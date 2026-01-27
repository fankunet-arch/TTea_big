/**
 * Toptea HQ - KDS 打印模板管理 JS
 * Version: 1.0.1
 * Date: 2026-01-27
 *
 * [AUDIT FIX 2026-01-27] Naming Convention Documentation:
 * - JavaScript variables use camelCase (e.g., templateCode, paperWidth) per JS conventions
 * - API payloads use snake_case keys (e.g., template_code, paper_width) to match backend/DB
 * - Example: const templateCode = ... -> data.template_code = templateCode
 */

const API_BASE = 'api/cpsys_api_gateway.php';
let editModal = null;

document.addEventListener('DOMContentLoaded', function() {
    editModal = new bootstrap.Modal(document.getElementById('editModal'));

    loadTemplates();

    document.getElementById('btnAddTemplate').addEventListener('click', () => openEditModal());
    document.getElementById('btnSaveTemplate').addEventListener('click', saveTemplate);
});

/**
 * 加载模板列表
 */
async function loadTemplates() {
    const tbody = document.getElementById('templatesTableBody');
    tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">加载中...</td></tr>';

    try {
        const response = await fetch(`${API_BASE}?res=print_templates&act=get`);
        const result = await response.json();

        if (result.status === 'success') {
            renderTemplates(result.data || []);
        } else {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">加载失败</td></tr>';
        }
    } catch (error) {
        console.error('Load templates error:', error);
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">加载失败</td></tr>';
    }
}

/**
 * 渲染模板列表
 */
function renderTemplates(templates) {
    const tbody = document.getElementById('templatesTableBody');

    if (!templates || templates.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">暂无模板</td></tr>';
        return;
    }

    tbody.innerHTML = '';
    templates.forEach(t => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><code>${t.template_code}</code></td>
            <td>${t.template_name}</td>
            <td><span class="badge bg-secondary">${t.template_type}</span></td>
            <td>${t.paper_width}x${t.paper_height}mm</td>
            <td>${t.is_active == 1 ? '<span class="badge bg-success">启用</span>' : '<span class="badge bg-secondary">禁用</span>'}</td>
            <td>${t.updated_at || '-'}</td>
            <td>
                <button class="btn btn-sm btn-outline-primary me-1" onclick="openEditModal(${t.id})">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick="deleteTemplate(${t.id})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

/**
 * 打开编辑模态框
 */
async function openEditModal(id = null) {
    document.getElementById('templateForm').reset();
    document.getElementById('templateId').value = '';
    document.getElementById('templateContent').value = '';

    if (id) {
        document.getElementById('modalTitle').textContent = '编辑模板';

        try {
            const response = await fetch(`${API_BASE}?res=print_templates&act=get&id=${id}`);
            const result = await response.json();

            if (result.status === 'success' && result.data) {
                const t = result.data;
                document.getElementById('templateId').value = t.id;
                document.getElementById('templateCode').value = t.template_code;
                document.getElementById('templateName').value = t.template_name;
                document.getElementById('templateType').value = t.template_type;
                document.getElementById('paperWidth').value = t.paper_width;
                document.getElementById('paperHeight').value = t.paper_height;
                document.getElementById('templateContent').value = JSON.stringify(t.template_content, null, 2);
                document.getElementById('description').value = t.description || '';
                document.getElementById('isActive').checked = t.is_active == 1;
            }
        } catch (error) {
            console.error('Load template error:', error);
            alert('加载模板失败');
            return;
        }
    } else {
        document.getElementById('modalTitle').textContent = '新建模板';
        // 默认模板内容
        document.getElementById('templateContent').value = JSON.stringify({
            commands: [
                { type: 'text', x: 10, y: 10, font: 2, content: '{{material_name}}' },
                { type: 'divider', x: 0, y: 35, width: 300 },
                { type: 'kv', x: 10, y: 45, font: 1, label: '开封:', value: '{{opened_at_time}}' },
                { type: 'kv', x: 10, y: 70, font: 1, label: '过期:', value: '{{expires_at_time}}' },
                { type: 'text', x: 10, y: 95, font: 2, content: '剩余: {{time_left}}' },
                { type: 'kv', x: 10, y: 120, font: 1, label: '操作员:', value: '{{handler_name}}' }
            ],
            copies: 1
        }, null, 2);
    }

    editModal.show();
}

/**
 * 保存模板
 */
async function saveTemplate() {
    const id = document.getElementById('templateId').value;
    const templateCode = document.getElementById('templateCode').value.trim();
    const templateName = document.getElementById('templateName').value.trim();

    if (!templateCode || !templateName) {
        alert('模板代码和名称不能为空');
        return;
    }

    let templateContent;
    try {
        templateContent = JSON.parse(document.getElementById('templateContent').value);
    } catch (e) {
        alert('模板内容JSON格式错误');
        return;
    }

    const data = {
        id: id || null,
        template_code: templateCode,
        template_name: templateName,
        template_type: document.getElementById('templateType').value,
        paper_width: parseInt(document.getElementById('paperWidth').value) || 40,
        paper_height: parseInt(document.getElementById('paperHeight').value) || 30,
        template_content: templateContent,
        description: document.getElementById('description').value.trim(),
        is_active: document.getElementById('isActive').checked ? 1 : 0
    };

    try {
        const response = await fetch(`${API_BASE}?res=print_templates&act=save`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ data })
        });

        const result = await response.json();

        if (result.status === 'success') {
            alert(result.message || '保存成功');
            editModal.hide();
            loadTemplates();
        } else {
            alert('保存失败: ' + result.message);
        }
    } catch (error) {
        console.error('Save template error:', error);
        alert('保存请求失败');
    }
}

/**
 * 删除模板
 */
async function deleteTemplate(id) {
    if (!confirm('确定要删除这个模板吗？')) return;

    try {
        const response = await fetch(`${API_BASE}?res=print_templates&act=delete&id=${id}`, {
            method: 'POST'
        });

        const result = await response.json();

        if (result.status === 'success') {
            alert('删除成功');
            loadTemplates();
        } else {
            alert('删除失败: ' + result.message);
        }
    } catch (error) {
        console.error('Delete template error:', error);
        alert('删除请求失败');
    }
}
