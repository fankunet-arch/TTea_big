/**
 * Toptea HQ - Inspection Report
 * Version: 1.0
 * Date: 2026-01-27
 */

const API_BASE = 'api/cpsys_api_gateway.php';

$(document).ready(function() {
    initFilters();
    initEventHandlers();
});

function initFilters() {
    // 设置默认日期为当前月份
    const now = new Date();
    const yearMonth = now.toISOString().slice(0, 7); // YYYY-MM
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
}

function getPeriodKey() {
    const type = $('#filter-frequency').val();
    if (type === 'weekly') {
        return $('#filter-period-week').val(); // YYYY-Www
    } else if (type === 'yearly') {
        return $('#filter-period-year').val(); // YYYY
    } else {
        return $('#filter-period-month').val(); // YYYY-MM
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
    // 更新统计卡片
    const summary = data.summary;
    $('#stat-total').text(summary.total);
    $('#stat-completed').text(summary.completed);
    $('#stat-pending').text(summary.pending);
    $('#stat-rate').text(summary.completion_rate);
    $('#period-display').text(data.period_key);

    // 渲染任务列表
    const tbody = $('#task-tbody');
    tbody.empty();

    if (data.tasks.length === 0) {
        tbody.html('<tr><td colspan="8" class="text-center">当前周期暂无检查任务</td></tr>');
        return;
    }

    data.tasks.forEach(task => {
        const isCompleted = task.status === 'completed';
        const statusBadge = isCompleted
            ? '<span class="badge text-bg-success">已完成</span>'
            : getDueBadge(task.period_end);

        const completedAt = task.completed_at
            ? formatDateTime(task.completed_at)
            : '-';

        const completedBy = task.completed_by_name || '-';
        const photoCount = task.photo_count || 0;

        tbody.append(`
            <tr class="${isCompleted ? '' : 'table-warning'}">
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

function loadTaskDetail(taskId) {
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
    const isCompleted = task.status === 'completed';
    const statusBadge = isCompleted
        ? '<span class="badge text-bg-success">已完成</span>'
        : '<span class="badge text-bg-warning">待完成</span>';

    let photosHtml = '';
    if (task.photos && task.photos.length > 0) {
        photosHtml = `
            <h6 class="mt-4">检查照片 (${task.photos.length} 张)</h6>
            <div class="row g-2">
                ${task.photos.map(photo => `
                    <div class="col-md-4">
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
                            </div>
                        </div>
                    </div>
                `).join('')}
            </div>
        `;
    } else {
        photosHtml = '<div class="alert alert-secondary mt-4">暂无照片</div>';
    }

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
        ${isCompleted ? `
        <div class="row mb-3">
            <div class="col-md-6">
                <strong>完成时间:</strong> ${formatDateTime(task.completed_at)}
            </div>
            <div class="col-md-6">
                <strong>完成人:</strong> ${escapeHtml(task.completed_by_name || '-')}
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
    `;

    $('#task-detail-body').html(html);
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
