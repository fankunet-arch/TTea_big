/**
 * Toptea HQ - Inspection Template Management
 * Version: 1.0.1
 * Date: 2026-01-27
 *
 * [AUDIT FIX 2026-01-27] Naming Convention Documentation:
 * - JavaScript variables use camelCase (e.g., storeId, templateCode) per JS conventions
 * - API payloads use snake_case keys (e.g., store_ids, template_code) to match backend/DB
 * - Example: storeIds.push() -> data.store_ids = storeIds
 */

const API_BASE = 'api/cpsys_api_gateway.php';

$(document).ready(function() {
    loadTemplates();
    initEventHandlers();
});

function initEventHandlers() {
    // 周期类型切换
    $('input[name="frequency_type"]').on('change', function() {
        const type = $(this).val();
        $('.freq-option').hide();
        $(`#${type}-options`).show();
    });

    // 全部门店切换
    $('#apply_to_all').on('change', function() {
        $('#store-selection').toggle(!this.checked);
    });

    // 创建按钮
    $('#create-btn').on('click', function() {
        resetForm();
        $('#drawer-label').text('新增检查项目');
    });

    // 表单提交
    $('#data-form').on('submit', function(e) {
        e.preventDefault();
        saveTemplate();
    });

    // 编辑按钮
    $(document).on('click', '.edit-btn', function() {
        const id = $(this).data('id');
        loadTemplateDetail(id);
    });

    // 删除按钮
    $(document).on('click', '.delete-btn', function() {
        const id = $(this).data('id');
        const name = $(this).data('name');
        if (confirm(`确定要删除检查项目「${name}」吗？`)) {
            deleteTemplate(id);
        }
    });
}

function loadTemplates() {
    $.ajax({
        url: `${API_BASE}?res=inspection_templates&act=get`,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                renderTemplateTable(response.data);
            } else {
                alert('加载失败: ' + response.message);
            }
        },
        error: function() {
            alert('网络错误，请刷新重试');
        }
    });
}

function renderTemplateTable(templates) {
    const tbody = $('#template-tbody');
    tbody.empty();

    if (templates.length === 0) {
        tbody.html('<tr><td colspan="7" class="text-center">暂无检查项目</td></tr>');
        return;
    }

    templates.forEach(tpl => {
        const freqText = {
            'weekly': '每周',
            'monthly': '每月',
            'yearly': '每年'
        }[tpl.frequency_type] || tpl.frequency_type;

        let dueText = '';
        if (tpl.frequency_type === 'weekly') {
            const weekdays = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
            dueText = weekdays[tpl.due_weekday] || '';
        } else if (tpl.frequency_type === 'yearly') {
            dueText = `${tpl.due_month}月${tpl.due_day}日`;
        } else {
            dueText = `每月${tpl.due_day}日`;
        }

        const storeText = tpl.apply_to_all == 1
            ? '<span class="badge text-bg-info">全部门店</span>'
            : `<span class="badge text-bg-secondary">${tpl.assigned_store_count || 0} 个门店</span>`;

        const statusBadge = tpl.is_active == 1
            ? '<span class="badge text-bg-success">启用</span>'
            : '<span class="badge text-bg-secondary">禁用</span>';

        tbody.append(`
            <tr>
                <td><strong>${escapeHtml(tpl.template_name)}</strong></td>
                <td><code>${escapeHtml(tpl.template_code)}</code></td>
                <td><span class="badge text-bg-primary">${freqText}</span></td>
                <td>${dueText}</td>
                <td>${storeText}</td>
                <td>${statusBadge}</td>
                <td class="text-end">
                    <button class="btn btn-sm btn-outline-primary edit-btn" data-id="${tpl.id}" data-bs-toggle="offcanvas" data-bs-target="#data-drawer">编辑</button>
                    <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${tpl.id}" data-name="${escapeHtml(tpl.template_name)}">删除</button>
                </td>
            </tr>
        `);
    });
}

function loadTemplateDetail(id) {
    $.ajax({
        url: `${API_BASE}?res=inspection_templates&act=get&id=${id}`,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                populateForm(response.data);
                $('#drawer-label').text('编辑检查项目');
            } else {
                alert('加载详情失败: ' + response.message);
            }
        }
    });
}

function populateForm(data) {
    resetForm();

    $('#data-id').val(data.id);
    $('#template_code').val(data.template_code);
    $('#template_name').val(data.template_name);
    $('#description').val(data.description || '');
    $('#photo_hint').val(data.photo_hint || '');

    // 周期类型
    $(`input[name="frequency_type"][value="${data.frequency_type}"]`).prop('checked', true).trigger('change');

    // 截止日设置
    $('#due_weekday').val(data.due_weekday);
    $('#due_day').val(data.due_day);
    $('#due_month').val(data.due_month);
    $('#due_day_yearly').val(data.due_day);

    // 门店范围
    const applyToAll = data.apply_to_all == 1;
    $('#apply_to_all').prop('checked', applyToAll).trigger('change');

    if (!applyToAll && data.store_ids && data.store_ids.length > 0) {
        data.store_ids.forEach(storeId => {
            $(`#store_${storeId}`).prop('checked', true);
        });
    }

    // 状态
    $('#is_active').prop('checked', data.is_active == 1);
}

function resetForm() {
    $('#data-form')[0].reset();
    $('#data-id').val('');
    $('.store-cb').prop('checked', false);
    $('#freq_monthly').prop('checked', true).trigger('change');
    $('#apply_to_all').prop('checked', true).trigger('change');
}

function saveTemplate() {
    const id = $('#data-id').val();
    const frequencyType = $('input[name="frequency_type"]:checked').val();

    // 根据周期类型获取 due_day
    let dueDay = $('#due_day').val();
    if (frequencyType === 'yearly') {
        dueDay = $('#due_day_yearly').val();
    }

    // 收集选中的门店
    const storeIds = [];
    if (!$('#apply_to_all').is(':checked')) {
        $('.store-cb:checked').each(function() {
            storeIds.push($(this).val());
        });
    }

    const data = {
        id: id || null,
        template_code: $('#template_code').val().toUpperCase(),
        template_name: $('#template_name').val(),
        description: $('#description').val(),
        photo_hint: $('#photo_hint').val(),
        frequency_type: frequencyType,
        due_day: parseInt(dueDay),
        due_weekday: parseInt($('#due_weekday').val()),
        due_month: parseInt($('#due_month').val()),
        apply_to_all: $('#apply_to_all').is(':checked') ? 1 : 0,
        store_ids: storeIds,
        is_active: $('#is_active').is(':checked') ? 1 : 0
    };

    $.ajax({
        url: `${API_BASE}?res=inspection_templates&act=save`,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ data: data }),
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                bootstrap.Offcanvas.getInstance(document.getElementById('data-drawer')).hide();
                loadTemplates();
                alert(response.message);
            } else {
                alert('保存失败: ' + response.message);
            }
        },
        error: function() {
            alert('网络错误，请重试');
        }
    });
}

function deleteTemplate(id) {
    $.ajax({
        url: `${API_BASE}?res=inspection_templates&act=delete&id=${id}`,
        type: 'POST',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                loadTemplates();
                alert(response.message);
            } else {
                alert('删除失败: ' + response.message);
            }
        }
    });
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
