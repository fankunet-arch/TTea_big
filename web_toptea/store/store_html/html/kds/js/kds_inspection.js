/**
 * Toptea KDS - Inspection Checklist
 * Version: 1.2
 * Date: 2026-01-28
 *
 * WebView 兼容修复 (v1.2):
 * 核心问题：Android WebView APK 中 JS 的 input.click() 被静默拦截，
 *          且 getUserMedia 要求 HTTPS 安全上下文（APK WebView 通常是 HTTP）。
 *
 * 解决方案：
 * - 拍照/相册按钮改为 <label for="inputId">（HTML 层），
 *   利用浏览器原生 label-input 关联行为触发文件选择，无需任何 JS .click()。
 * - 完全移除 getUserMedia 相关代码（HTTP 下不可用）。
 * - 完全移除超时检测代码（在 WebView 中 document.hasFocus() 不可靠，会误报错误）。
 * - JS 端只负责监听 change 事件、处理/压缩照片、上传。
 */

const API_BASE = 'api/kds_api_gateway.php';
let currentTasks = [];
let selectedPhotos = [];
let currentTaskId = null;

$(document).ready(function() {
    loadTasks('current');
    initEventHandlers();
});

function initEventHandlers() {
    // 周期切换
    $('.inspection-tab').on('click', function() {
        $('.inspection-tab').removeClass('active');
        $(this).addClass('active');
        const period = $(this).data('period');
        loadTasks(period);
    });

    // 任务点击
    $(document).on('click', '.inspection-item', function() {
        const taskId = $(this).data('id');
        openTaskDetail(taskId);
    });

    // =============================================
    // 照片选择 —— 通过 <label for="..."> 原生触发
    // JS 端只需监听 change 事件，无需 .click()
    // =============================================

    // 相机输入 change
    $('#camera-input').on('change', function(e) {
        handlePhotoSelect(e.target.files);
        this.value = '';
    });

    // 相册输入 change
    $('#photo-input').on('change', function(e) {
        handlePhotoSelect(e.target.files);
        this.value = '';
    });

    // 删除照片
    $(document).on('click', '.remove-photo', function(e) {
        e.stopPropagation();
        const index = $(this).data('index');
        selectedPhotos.splice(index, 1);
        renderPhotoPreview();
    });

    // 提交检查
    $('#btn-submit-inspection').on('click', submitInspection);
}

// =============================================
// 任务加载与渲染
// =============================================

function loadTasks(period) {
    const $list = $('#inspection-list');
    $list.html(`
        <div class="loading-spinner">
            <div class="spinner-border text-primary" role="status"></div>
            <span>加载中...</span>
        </div>
    `);

    $.ajax({
        url: `${API_BASE}?res=inspection&act=get_tasks&period=${period}`,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                currentTasks = response.data.tasks || [];
                renderTasks(currentTasks);
                updateProgress(response.data.summary);
            } else {
                $list.html(`<div class="alert alert-danger">${response.message}</div>`);
            }
        },
        error: function() {
            $list.html('<div class="alert alert-danger">加载失败，请重试</div>');
        }
    });
}

function renderTasks(tasks) {
    const $list = $('#inspection-list');
    $list.empty();

    if (tasks.length === 0) {
        $list.html(`
            <div class="text-center py-5 text-muted">
                <i class="bi bi-check-circle" style="font-size: 3rem;"></i>
                <p class="mt-2">当前没有检查任务</p>
            </div>
        `);
        return;
    }

    tasks.forEach(task => {
        const isCompleted = task.status === 'completed';
        const statusClass = getStatusClass(task);
        const statusIcon = isCompleted ? 'bi-check-lg' : 'bi-hourglass-split';
        const subtitle = isCompleted
            ? `完成于 ${formatDate(task.completed_at)} · ${task.photo_count || 0}张照片`
            : `截止: ${task.period_end} · ${getFrequencyText(task.frequency_type)}`;

        $list.append(`
            <div class="inspection-item ${statusClass}" data-id="${task.id}">
                <div class="item-status ${statusClass}">
                    <i class="bi ${statusIcon}"></i>
                </div>
                <div class="item-content">
                    <div class="item-title">${escapeHtml(task.template_name)}</div>
                    <div class="item-subtitle">${subtitle}</div>
                </div>
                <div class="item-arrow">
                    <i class="bi bi-chevron-right"></i>
                </div>
            </div>
        `);
    });
}

function getStatusClass(task) {
    if (task.status === 'completed') return 'completed';

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const dueDate = new Date(task.period_end);

    if (dueDate < today) return 'overdue';
    return 'pending';
}

function getFrequencyText(type) {
    const texts = {
        'weekly': '每周检查',
        'monthly': '每月检查',
        'yearly': '每年检查'
    };
    return texts[type] || type;
}

function updateProgress(summary) {
    if (!summary) return;

    $('#progress-completed').text(summary.completed || 0);
    $('#progress-total').text(summary.total || 0);

    const rate = summary.total > 0 ? Math.round((summary.completed / summary.total) * 100) : 0;
    $('#progress-bar').css('width', rate + '%');
}

// =============================================
// 任务详情与上传
// =============================================

function openTaskDetail(taskId) {
    const task = currentTasks.find(t => t.id == taskId);
    if (!task) return;

    currentTaskId = taskId;

    if (task.status === 'completed') {
        showCompletedTaskDetail(task);
    } else {
        showPhotoUploadModal(task);
    }
}

function showCompletedTaskDetail(task) {
    $.ajax({
        url: `${API_BASE}?res=inspection&act=task_detail&id=${task.id}`,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                renderCompletedDetail(response.data);
                $('#taskModal').modal('show');
            }
        }
    });
}

function renderCompletedDetail(task) {
    let photosHtml = '';
    if (task.photos && task.photos.length > 0) {
        photosHtml = `
            <div class="photo-preview-grid mt-3">
                ${task.photos.map(photo => `
                    <div class="photo-preview-item">
                        <img src="../../store_images/inspections/${photo.photo_path}" alt="检查照片"
                             onclick="window.open(this.src)">
                    </div>
                `).join('')}
            </div>
        `;
    }

    $('#taskModalTitle').text(task.template_name);
    $('#taskModalBody').html(`
        <div class="mb-3">
            <span class="badge bg-success">已完成</span>
        </div>
        <p><strong>完成时间:</strong> ${formatDate(task.completed_at)}</p>
        <p><strong>完成人:</strong> ${escapeHtml(task.completed_by_name || '-')}</p>
        ${task.template_description ? `
        <div class="mb-3">
            <strong>检查要求:</strong>
            <div class="border rounded p-2 bg-light text-dark mt-1" style="white-space: pre-wrap;">${escapeHtml(task.template_description)}</div>
        </div>
        ` : ''}
        ${task.notes ? `<p><strong>备注:</strong> ${escapeHtml(task.notes)}</p>` : ''}
        ${photosHtml}
    `);
    $('#taskModalFooter').html('<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>');
}

function showPhotoUploadModal(task) {
    selectedPhotos = [];
    currentTaskId = task.id;

    $('#upload-task-id').val(task.id);
    $('#task-notes').val('');
    $('#photo-preview-grid').empty();
    $('#no-photos-hint').show();
    $('#btn-submit-inspection').prop('disabled', true);

    // 显示照片提示
    if (task.photo_hint) {
        $('#photo-hint-content').text(task.photo_hint);
        $('#photo-hint-text').show();
    } else {
        $('#photo-hint-text').hide();
    }

    $('#photoUploadModal .modal-title').text(task.template_name);
    $('#photoUploadModal').modal('show');
}

// =============================================
// 照片处理
// =============================================

async function handlePhotoSelect(files) {
    if (!files || files.length === 0) return;

    for (const file of files) {
        if (!file.type.startsWith('image/')) continue;

        try {
            const processed = await processPhoto(file);
            selectedPhotos.push(processed);
        } catch (error) {
            console.error('处理照片失败:', error);
        }
    }

    renderPhotoPreview();
}

async function processPhoto(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = function(e) {
            const img = new Image();
            img.onload = function() {
                const validationFlags = {};

                // 分辨率检查
                if (img.width < 800 || img.height < 600) {
                    validationFlags.resolution_low = true;
                }

                // 压缩照片
                const canvas = document.createElement('canvas');
                const maxWidth = 1920;
                const maxHeight = 1440;
                let width = img.width;
                let height = img.height;

                if (width > maxWidth || height > maxHeight) {
                    const ratio = Math.min(maxWidth / width, maxHeight / height);
                    width = Math.round(width * ratio);
                    height = Math.round(height * ratio);
                }

                canvas.width = width;
                canvas.height = height;
                const ctx = canvas.getContext('2d');
                ctx.drawImage(img, 0, 0, width, height);

                canvas.toBlob(function(blob) {
                    resolve({
                        blob: blob,
                        preview: canvas.toDataURL('image/jpeg', 0.8),
                        name: file.name,
                        validationFlags: validationFlags
                    });
                }, 'image/jpeg', 0.75);
            };
            img.onerror = reject;
            img.src = e.target.result;
        };
        reader.onerror = reject;
        reader.readAsDataURL(file);
    });
}

function renderPhotoPreview() {
    const $grid = $('#photo-preview-grid');
    $grid.empty();

    if (selectedPhotos.length === 0) {
        $('#no-photos-hint').show();
        $('#btn-submit-inspection').prop('disabled', true);
        return;
    }

    $('#no-photos-hint').hide();
    $('#btn-submit-inspection').prop('disabled', false);

    selectedPhotos.forEach((photo, index) => {
        let warningHtml = '';
        if (photo.validationFlags && photo.validationFlags.resolution_low) {
            warningHtml = '<span class="photo-warning">低分辨率</span>';
        }

        $grid.append(`
            <div class="photo-preview-item">
                <img src="${photo.preview}" alt="照片 ${index + 1}">
                <button class="remove-photo" data-index="${index}">
                    <i class="bi bi-x"></i>
                </button>
                ${warningHtml}
            </div>
        `);
    });
}

// =============================================
// 提交
// =============================================

async function submitInspection() {
    if (selectedPhotos.length === 0) {
        if (window.showKdsAlert) {
            showKdsAlert('请至少上传一张照片', true);
        } else {
            alert('请至少上传一张照片');
        }
        return;
    }

    const $btn = $('#btn-submit-inspection');
    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>提交中...');

    try {
        // 上传所有照片
        const photoResults = [];
        for (let i = 0; i < selectedPhotos.length; i++) {
            const photo = selectedPhotos[i];
            const formData = new FormData();
            formData.append('task_id', currentTaskId);
            formData.append('photo', photo.blob, `inspection_${Date.now()}_${i}.jpg`);
            formData.append('validation_flags', JSON.stringify(photo.validationFlags || {}));

            const result = await uploadPhoto(formData);
            if (result.status === 'success') {
                photoResults.push(result.data);
            }
        }

        // 完成任务
        const completeData = {
            task_id: currentTaskId,
            notes: $('#task-notes').val().trim()
        };

        const response = await $.ajax({
            url: `${API_BASE}?res=inspection&act=complete_task`,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(completeData),
            dataType: 'json'
        });

        if (response.status === 'success') {
            $('#photoUploadModal').modal('hide');
            if (window.showKdsAlert) {
                showKdsAlert('检查提交成功！', false);
            } else {
                alert('检查提交成功！');
            }
            loadTasks('current');
        } else {
            throw new Error(response.message);
        }
    } catch (error) {
        if (window.showKdsAlert) {
            showKdsAlert('提交失败: ' + error.message, true);
        } else {
            alert('提交失败: ' + error.message);
        }
    } finally {
        $btn.prop('disabled', false).html('<i class="bi bi-check-circle me-2"></i>提交完成');
    }
}

function uploadPhoto(formData) {
    return $.ajax({
        url: `${API_BASE}?res=inspection&act=upload_photo`,
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        dataType: 'json'
    });
}

// =============================================
// 工具函数
// =============================================

function formatDate(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    return date.toLocaleDateString('zh-CN', {
        month: 'numeric',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
