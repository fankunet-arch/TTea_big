/**
 * Toptea KDS - Inspection Checklist
 * Version: 1.1
 * Date: 2026-01-28
 *
 * WebView兼容修复:
 * - 摄像头: 优先使用 getUserMedia API 直接调用摄像头（绕过 file input）
 *           仅在 getUserMedia 不可用时回退到 <input capture>
 * - 相册:   file input 使用 off-screen 定位（而非 display:none）
 *           添加超时检测，若 WebView 未响应 file input 则提示用户
 */

const API_BASE = 'api/kds_api_gateway.php';
let currentTasks = [];
let selectedPhotos = [];
let currentTaskId = null;

// --- 相机状态 ---
let cameraStream = null;
let cameraFacingMode = 'environment'; // 'environment' = 后置, 'user' = 前置

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

    // 拍照按钮 - 优先 getUserMedia，回退 file input
    $('#btn-camera').on('click', function() {
        openCamera();
    });

    // 相册按钮 - 带 WebView 超时检测
    $('#btn-gallery').on('click', function() {
        openGallery();
    });

    // 相机输入 (回退方案)
    $('#camera-input').on('change', function(e) {
        handlePhotoSelect(e.target.files);
        this.value = '';
    });

    // 相册输入
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

    // --- 取景器控制 ---
    $('#btn-camera-shutter').on('click', captureFromViewfinder);
    $('#btn-camera-close').on('click', closeCamera);
    $('#btn-camera-switch').on('click', switchCamera);

    // 取景器 modal 关闭时确保释放摄像头
    $('#cameraViewfinderModal').on('hidden.bs.modal', function() {
        stopCameraStream();
    });
}

// =============================================
// 相机功能 - getUserMedia 优先
// =============================================

/**
 * 打开相机。
 * 策略：先尝试 getUserMedia（WebView 通常支持），不行再回退 file input。
 */
async function openCamera() {
    // 检测 getUserMedia 支持
    if (navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function') {
        try {
            await startCameraStream();
            return; // 成功打开取景器
        } catch (err) {
            console.warn('getUserMedia 失败，回退到 file input:', err.name, err.message);
        }
    }

    // 回退：触发 file input (带 capture)
    triggerFileInput('camera-input');
}

/**
 * 启动摄像头流并显示取景器 modal
 */
async function startCameraStream() {
    // 先停止之前可能存在的流
    stopCameraStream();

    const constraints = {
        video: {
            facingMode: cameraFacingMode,
            width: { ideal: 1920 },
            height: { ideal: 1440 }
        },
        audio: false
    };

    cameraStream = await navigator.mediaDevices.getUserMedia(constraints);

    const video = document.getElementById('camera-viewfinder');
    video.srcObject = cameraStream;

    // 确保视频开始播放
    await video.play().catch(function() { /* 自动播放策略，忽略 */ });

    // 显示取景器 modal
    var viewfinderModal = new bootstrap.Modal(document.getElementById('cameraViewfinderModal'), {
        backdrop: 'static',
        keyboard: false
    });
    viewfinderModal.show();
}

/**
 * 从取景器截图
 */
function captureFromViewfinder() {
    var video = document.getElementById('camera-viewfinder');
    var canvas = document.getElementById('camera-snapshot-canvas');

    if (!video.videoWidth || !video.videoHeight) {
        console.error('视频尚未就绪');
        return;
    }

    // 使用视频实际分辨率
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;

    var ctx = canvas.getContext('2d');
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    // 转为 Blob
    canvas.toBlob(function(blob) {
        if (!blob) return;

        // 生成预览
        var previewUrl = canvas.toDataURL('image/jpeg', 0.8);

        // 检测分辨率
        var validationFlags = {};
        if (canvas.width < 800 || canvas.height < 600) {
            validationFlags.resolution_low = true;
        }

        selectedPhotos.push({
            blob: blob,
            preview: previewUrl,
            name: 'camera_' + Date.now() + '.jpg',
            validationFlags: validationFlags
        });

        renderPhotoPreview();

        // 关闭取景器
        closeCamera();
    }, 'image/jpeg', 0.75);
}

/**
 * 切换前后摄像头
 */
async function switchCamera() {
    cameraFacingMode = (cameraFacingMode === 'environment') ? 'user' : 'environment';
    try {
        await startCameraStream();
    } catch (err) {
        console.error('切换摄像头失败:', err);
        // 切回原来的
        cameraFacingMode = (cameraFacingMode === 'environment') ? 'user' : 'environment';
    }
}

/**
 * 关闭取景器
 */
function closeCamera() {
    var modalEl = document.getElementById('cameraViewfinderModal');
    var modal = bootstrap.Modal.getInstance(modalEl);
    if (modal) {
        modal.hide();
    }
    stopCameraStream();
}

/**
 * 停止摄像头流
 */
function stopCameraStream() {
    if (cameraStream) {
        cameraStream.getTracks().forEach(function(track) {
            track.stop();
        });
        cameraStream = null;
    }
    var video = document.getElementById('camera-viewfinder');
    if (video) {
        video.srcObject = null;
    }
}

// =============================================
// 相册功能 - WebView 兼容
// =============================================

/**
 * 打开相册选择。
 * 使用超时检测：如果点击 file input 后一段时间没有 change 事件，
 * 说明 WebView 可能不支持，提示用户。
 */
function openGallery() {
    triggerFileInput('photo-input');
}

/**
 * 触发隐藏的 file input，兼容 WebView。
 * 多重策略：
 * 1. 直接 .click()
 * 2. 若失败，尝试临时将元素移到可见区域再 click
 * 3. 超时检测
 */
function triggerFileInput(inputId) {
    var input = document.getElementById(inputId);
    if (!input) return;

    // 重置值以确保同一文件也能触发 change
    input.value = '';

    // 标记是否已触发 (通过 focus/change 事件判断)
    var triggered = false;

    var onChangeOnce = function() {
        triggered = true;
        input.removeEventListener('change', onChangeOnce);
    };
    input.addEventListener('change', onChangeOnce);

    // 策略1: 直接 click
    input.click();

    // 超时检测 - 若 3 秒内没有反应，可能 WebView 不支持
    setTimeout(function() {
        input.removeEventListener('change', onChangeOnce);

        if (triggered) return; // 已经触发了，没问题

        // 检查页面是否失去焦点（file chooser 打开时页面会失去焦点）
        if (document.hasFocus()) {
            // 页面仍有焦点 = file chooser 没打开
            // 尝试策略2: 临时移到可见位置再 click
            var origStyle = input.getAttribute('style');
            input.style.cssText = 'position:fixed;top:50%;left:50%;opacity:0.01;width:1px;height:1px;z-index:99999;';

            setTimeout(function() {
                input.click();
                // 恢复原始样式
                setTimeout(function() {
                    input.setAttribute('style', origStyle || '');
                }, 500);

                // 二次超时检测
                setTimeout(function() {
                    if (!triggered && document.hasFocus()) {
                        // 确实不支持，提示用户
                        showFileInputFallbackMessage(inputId === 'camera-input');
                    }
                }, 3000);
            }, 100);
        }
        // 如果页面没有焦点，说明 file chooser 已打开，一切正常
    }, 3000);
}

/**
 * 当 file input 无法工作时显示提示
 */
function showFileInputFallbackMessage(isCamera) {
    if (isCamera) {
        // 相机 file input 也不行，说明设备根本不支持
        var msg = '无法打开相机。请检查：\n1. 已授予相机权限\n2. 尝试在系统浏览器中打开此页面';
        if (window.showKdsAlert) {
            showKdsAlert(msg, true);
        } else {
            alert(msg);
        }
    } else {
        var msg = '无法打开相册。请检查：\n1. 已授予存储/相册权限\n2. 尝试在系统浏览器中打开此页面';
        if (window.showKdsAlert) {
            showKdsAlert(msg, true);
        } else {
            alert(msg);
        }
    }
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
        reader.onload = async function(e) {
            const img = new Image();
            img.onload = function() {
                // 检测照片质量
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
