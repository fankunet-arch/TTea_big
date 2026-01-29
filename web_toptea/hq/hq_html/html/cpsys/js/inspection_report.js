/**
 * Toptea HQ - Inspection Report
 * Version: 2.0
 * Date: 2026-01-29
 *
 * v2.0: 三态审核流程 (pending → pending_review → completed)
 *       - 待审核任务：可审核通过或退回
 *       - 已通过任务：仅查看
 *       - 照片软删除（文件移到 _rejected 目录，数据库记录删除）
 */

const API_BASE = 'api/cpsys_api_gateway.php';
let _currentDetailTaskId = null;

$(document).ready(function() {
    initFilters();
    initEventHandlers();
});

function initFilters() {
    const now = new Date();
    const yearMonth = now.toISOString().slice(0, 7);
    const weekNum = getWeekNumber(now);
    const year = now.getFullYear();

    $('#filter-period-month').val(yearMonth);
    $('#filter-period-week').val(`${year}-W${String(weekNum).padStart(2, '0')}`);
    $('#filter-period-year').val(year);
}

function initEventHandlers() {
    // 周期类型切换
    $('#filter-frequency').on('change', function() {
        const type = $(this).val();
        $('#filter-period-month, #filter-period-week, #filter-period-year').hide();
        if (type === 'weekly') {
            $('#filter-period-week').show();
        } else if (type === 'yearly') {
            $('#filter-period-year').show();
        } else {
            $('#filter-period-month').show();
        }
    });

    // 查询按钮
    $('#btn-search').on('click', loadReport);

    // 生成任务按钮
    $('#btn-generate-tasks').on('click', generateTasks);

    // 查看详情
    $(document).on('click', '.view-detail-btn', function() {
        const taskId = $(this).data('id');
        loadTaskDetail(taskId);
    });

    // 删除单张照片
    $(document).on('click', '.delete-photo-btn', function() {
        const photoId = $(this).data('photo-id');
        deletePhoto(photoId);
    });

    // 审核通过
    $(document).on('click', '#btn-approve-task', function() {
        const taskId = $(this).data('task-id');
        approveTask(taskId);
    });

    // 退回任务
    $(document).on('click', '#btn-reject-task', function() {
        const taskId = $(this).data('task-id');
        rejectTask(taskId);
    });
}

function getPeriodKey() {
    const type = $('#filter-frequency').val();
    if (type === 'weekly') {
        return $('#filter-period-week').val();
    } else if (type === 'yearly') {
        return $('#filter-period-year').val();
    } else {
        return $('#filter-period-month').val();
    }
}

function loadReport() {
    const frequencyType = $('#filter-frequency').val();
    const periodKey = getPeriodKey();
    const storeId = $('#filter-store').val();

    if (!periodKey) {
        alert('请选择周期');
        return;
    }

    const params = new URLSearchParams({
        res: 'inspection_report',
        act: 'get',
        frequency_type: frequencyType,
        period_key: periodKey
    });

    if (storeId) {
        params.append('store_id', storeId);
    }

    $.ajax({
        url: `${API_BASE}?${params.toString()}`,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                renderReport(response.data);
            } else {
                alert('查询失败: ' + response.message);
            }
        },
        error: function() {
            alert('网络错误，请重试');
        }
    });
}

function renderReport(data) {
    const summary = data.summary;
    $('#stat-total').text(summary.total);
    $('#stat-completed').text(summary.completed);
    $('#stat-pending-review').text(summary.pending_review);
    $('#stat-pending').text(summary.pending);
    $('#stat-rate').text(summary.completion_rate);
    $('#period-display').text(data.period_key);

    const tbody = $('#task-tbody');
    tbody.empty();

    if (data.tasks.length === 0) {
        tbody.html('<tr><td colspan="8" class="text-center">当前周期暂无检查任务</td></tr>');
        return;
    }

    data.tasks.forEach(task => {
        const statusBadge = getStatusBadge(task);
        const rowClass = getRowClass(task);

        const completedAt = task.completed_at
            ? formatDateTime(task.completed_at)
            : '-';

        const completedBy = task.completed_by_name || '-';
        const photoCount = task.photo_count || 0;

        tbody.append(`
            <tr class="${rowClass}">
                <td>
                    <strong>${escapeHtml(task.store_code)}</strong>
                    <br><small class="text-muted">${escapeHtml(task.store_name)}</small>
                </td>
                <td>${escapeHtml(task.template_name)}</td>
                <td>${task.period_end}</td>
                <td>${statusBadge}</td>
                <td>${completedAt}</td>
                <td>${escapeHtml(completedBy)}</td>
                <td>
                    ${photoCount > 0
                        ? `<span class="badge text-bg-info">${photoCount} 张</span>`
                        : '<span class="text-muted">-</span>'}
                </td>
                <td class="text-end">
                    <button class="btn btn-sm btn-outline-primary view-detail-btn" data-id="${task.id}" data-bs-toggle="modal" data-bs-target="#task-detail-modal">
                        查看详情
                    </button>
                </td>
            </tr>
        `);
    });
}

function getStatusBadge(task) {
    if (task.status === 'completed') {
        return '<span class="badge text-bg-success">已通过</span>';
    }
    if (task.status === 'pending_review') {
        return '<span class="badge text-bg-info">待审核</span>';
    }
    return getDueBadge(task.period_end);
}

function getRowClass(task) {
    if (task.status === 'completed') return '';
    if (task.status === 'pending_review') return 'table-info';
    return 'table-warning';
}

function getDueBadge(periodEnd) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const dueDate = new Date(periodEnd);
    const diffDays = Math.ceil((dueDate - today) / (1000 * 60 * 60 * 24));

    if (diffDays < 0) {
        return '<span class="badge text-bg-danger">已逾期</span>';
    } else if (diffDays <= 3) {
        return `<span class="badge text-bg-warning">剩 ${diffDays} 天</span>`;
    } else {
        return '<span class="badge text-bg-secondary">待完成</span>';
    }
}

// =============================================
// 任务详情
// =============================================

function loadTaskDetail(taskId) {
    _currentDetailTaskId = taskId;
    const body = $('#task-detail-body');
    body.html('<div class="text-center py-4"><div class="spinner-border"></div></div>');

    $.ajax({
        url: `${API_BASE}?res=inspection_report&act=task_detail&id=${taskId}`,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                renderTaskDetail(response.data);
            } else {
                body.html(`<div class="alert alert-danger">${response.message}</div>`);
            }
        },
        error: function() {
            body.html('<div class="alert alert-danger">加载失败</div>');
        }
    });
}

function renderTaskDetail(task) {
    const statusBadge = getDetailStatusBadge(task.status);

    // 照片区域（待审核和已通过任务带删除按钮）
    let photosHtml = '';
    if (task.photos && task.photos.length > 0) {
        const showDeleteBtn = (task.status === 'pending_review' || task.status === 'completed');
        photosHtml = `
            <h6 class="mt-4">检查照片 (${task.photos.length} 张)</h6>
            <div class="row g-2">
                ${task.photos.map(photo => `
                    <div class="col-md-4" id="photo-card-${photo.id}">
                        <div class="card">
                            <img src="../store/store_images/inspections/${photo.photo_path}" class="card-img-top" alt="检查照片"
                                 style="max-height: 200px; object-fit: cover; cursor: pointer;"
                                 onclick="window.open(this.src)">
                            <div class="card-body p-2">
                                <small class="text-muted">
                                    ${formatDateTime(photo.uploaded_at)}<br>
                                    ${photo.uploaded_by_name || '未知'}
                                    ${photo.device_model ? `<br>${escapeHtml(photo.device_model)}` : ''}
                                    ${renderValidationFlags(photo.validation_flags)}
                                </small>
                                ${showDeleteBtn ? `
                                <button class="btn btn-sm btn-outline-danger w-100 mt-2 delete-photo-btn"
                                        data-photo-id="${photo.id}">
                                    <i class="bi bi-trash me-1"></i>删除此照片
                                </button>
                                ` : ''}
                            </div>
                        </div>
                    </div>
                `).join('')}
            </div>
        `;
    } else {
        photosHtml = '<div class="alert alert-secondary mt-4">暂无照片</div>';
    }

    // 操作区域：待审核显示审核通过+退回，已通过显示退回
    let actionHtml = '';
    if (task.status === 'pending_review') {
        actionHtml = `
            <hr>
            <div class="d-flex align-items-end gap-2">
                <button class="btn btn-success" id="btn-approve-task" data-task-id="${task.id}">
                    <i class="bi bi-check-circle me-1"></i>审核通过
                </button>
                <div class="flex-grow-1">
                    <label class="form-label mb-1"><small>退回原因 (可选)</small></label>
                    <input type="text" class="form-control form-control-sm" id="reject-reason"
                           placeholder="如：照片模糊，请重新拍摄">
                </div>
                <button class="btn btn-danger" id="btn-reject-task" data-task-id="${task.id}">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>退回
                </button>
            </div>
        `;
    } else if (task.status === 'completed') {
        actionHtml = `
            <hr>
            <div class="d-flex align-items-end gap-2">
                <div class="flex-grow-1">
                    <label class="form-label mb-1"><small>退回原因 (可选)</small></label>
                    <input type="text" class="form-control form-control-sm" id="reject-reason"
                           placeholder="如：照片模糊，请重新拍摄">
                </div>
                <button class="btn btn-danger" id="btn-reject-task" data-task-id="${task.id}">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>退回
                </button>
            </div>
        `;
    }

    const showSubmitInfo = (task.status === 'completed' || task.status === 'pending_review');

    const html = `
        <div class="row mb-3">
            <div class="col-md-6">
                <strong>门店:</strong> ${escapeHtml(task.store_code)} - ${escapeHtml(task.store_name)}
            </div>
            <div class="col-md-6">
                <strong>状态:</strong> ${statusBadge}
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-md-6">
                <strong>检查项目:</strong> ${escapeHtml(task.template_name)}
            </div>
            <div class="col-md-6">
                <strong>截止日期:</strong> ${task.period_end}
            </div>
        </div>
        ${showSubmitInfo ? `
        <div class="row mb-3">
            <div class="col-md-6">
                <strong>提交时间:</strong> ${formatDateTime(task.completed_at)}
            </div>
            <div class="col-md-6">
                <strong>提交人:</strong> ${escapeHtml(task.completed_by_name || '-')}
            </div>
        </div>
        ` : ''}
        ${task.template_description ? `
        <div class="mb-3">
            <strong>检查要求:</strong>
            <div class="border rounded p-2 bg-light text-dark" style="white-space: pre-wrap;">${escapeHtml(task.template_description)}</div>
        </div>
        ` : ''}
        ${task.notes ? `
        <div class="mb-3">
            <strong>店长备注:</strong>
            <div class="border rounded p-2">${escapeHtml(task.notes)}</div>
        </div>
        ` : ''}
        ${photosHtml}
        ${actionHtml}
    `;

    $('#task-detail-body').html(html);
}

function getDetailStatusBadge(status) {
    if (status === 'completed') return '<span class="badge text-bg-success">已通过</span>';
    if (status === 'pending_review') return '<span class="badge text-bg-info">待审核</span>';
    return '<span class="badge text-bg-warning">待完成</span>';
}

function renderValidationFlags(flags) {
    if (!flags) return '';
    const warnings = [];
    if (flags.no_exif) warnings.push('无EXIF');
    if (flags.old_photo) warnings.push('旧照片');
    if (flags.resolution_low) warnings.push('低分辨率');
    if (flags.edited_software) warnings.push('可能编辑过');

    if (warnings.length === 0) return '';
    return `<br><span class="badge text-bg-warning">${warnings.join(', ')}</span>`;
}

// =============================================
// 审核通过
// =============================================

function approveTask(taskId) {
    if (!confirm('确定要通过此任务的审核吗？')) return;

    const $btn = $('#btn-approve-task');
    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-1"></span>处理中...');

    $.ajax({
        url: `${API_BASE}?res=inspection_report&act=approve_task`,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ data: { task_id: taskId } }),
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                alert('已通过审核');
                $('#task-detail-modal').modal('hide');
                loadReport();
            } else {
                alert('操作失败: ' + response.message);
                $btn.prop('disabled', false).html('<i class="bi bi-check-circle me-1"></i>审核通过');
            }
        },
        error: function() {
            alert('网络错误，请重试');
            $btn.prop('disabled', false).html('<i class="bi bi-check-circle me-1"></i>审核通过');
        }
    });
}

// =============================================
// 删除照片
// =============================================

function deletePhoto(photoId) {
    if (!confirm('确定要删除这张照片吗？\n\n照片文件将被移至备份目录，数据库记录将被删除。')) return;

    $.ajax({
        url: `${API_BASE}?res=inspection_report&act=delete_photo`,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ data: { photo_id: photoId } }),
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                // 从 DOM 移除照片卡片
                $(`#photo-card-${photoId}`).fadeOut(300, function() {
                    $(this).remove();
                    // 更新照片计数标题
                    const remaining = $('#task-detail-body .col-md-4').length;
                    $('#task-detail-body h6').first().text(`检查照片 (${remaining} 张)`);
                    if (remaining === 0) {
                        $('#task-detail-body .row.g-2').replaceWith('<div class="alert alert-secondary mt-4">暂无照片</div>');
                    }
                });
            } else {
                alert('删除失败: ' + response.message);
            }
        },
        error: function() {
            alert('网络错误，请重试');
        }
    });
}

// =============================================
// 退回任务
// =============================================

function rejectTask(taskId) {
    if (!confirm('确定要退回此任务吗？\n\n退回后该任务的所有照片将被移至备份目录，数据库记录将被清除，门店需重新完成检查。')) return;

    const reason = ($('#reject-reason').val() || '').trim();
    const $btn = $('#btn-reject-task');
    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-1"></span>处理中...');

    $.ajax({
        url: `${API_BASE}?res=inspection_report&act=reject_task`,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ data: { task_id: taskId, reason: reason } }),
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                alert(response.message);
                $('#task-detail-modal').modal('hide');
                loadReport();
            } else {
                alert('退回失败: ' + response.message);
                $btn.prop('disabled', false).html('<i class="bi bi-arrow-counterclockwise me-1"></i>退回');
            }
        },
        error: function() {
            alert('网络错误，请重试');
            $btn.prop('disabled', false).html('<i class="bi bi-arrow-counterclockwise me-1"></i>退回');
        }
    });
}

// =============================================
// 生成任务
// =============================================

function generateTasks() {
    const frequencyType = $('#filter-frequency').val();
    if (!confirm(`确定要生成当前的${frequencyType === 'monthly' ? '月度' : frequencyType === 'weekly' ? '周度' : '年度'}检查任务吗？`)) {
        return;
    }

    $.ajax({
        url: `${API_BASE}?res=inspection_report&act=generate_tasks`,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ data: { frequency_type: frequencyType } }),
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                alert(response.message);
                loadReport();
            } else {
                alert('生成失败: ' + response.message);
            }
        },
        error: function() {
            alert('网络错误，请重试');
        }
    });
}

// =============================================
// 工具函数
// =============================================

function getWeekNumber(date) {
    const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
    const dayNum = d.getUTCDay() || 7;
    d.setUTCDate(d.getUTCDate() + 4 - dayNum);
    const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    return Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
}

function formatDateTime(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
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
