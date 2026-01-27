/**
 * Toptea HQ - 入库码管理 JS
 * Version: 1.0.1
 * Date: 2026-01-27
 *
 * [AUDIT FIX 2026-01-27] Naming Convention Documentation:
 * - JavaScript variables use camelCase (e.g., storeId, importCode) per JS conventions
 * - API payloads/parameters use snake_case (e.g., store_id, import_code) to match backend/DB
 * - All API calls in this file correctly map JS camelCase to snake_case API parameters
 * - Example: const storeId = ... -> url += `&store_id=${storeId}`
 */

const API_BASE = 'api/cpsys_api_gateway.php';
let currentParseResult = null;

document.addEventListener('DOMContentLoaded', function() {
    // 初始化
    loadImportLogs();

    // 绑定事件
    document.getElementById('btnParseCode').addEventListener('click', parseImportCode);
    document.getElementById('btnExecuteImport').addEventListener('click', executeImport);
    document.getElementById('btnCancelImport').addEventListener('click', cancelImport);
    document.getElementById('btnRefreshLogs').addEventListener('click', loadImportLogs);
    document.getElementById('filterStore').addEventListener('change', loadImportLogs);
});

/**
 * 解析入库码
 */
async function parseImportCode() {
    const importCode = document.getElementById('importCodeInput').value.trim();

    if (!importCode) {
        alert('请输入入库码');
        return;
    }

    try {
        const response = await fetch(`${API_BASE}?res=import_code&act=parse`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                data: {
                    import_code: importCode,
                    store_id: 0  // HQ 后台不限制门店
                }
            })
        });

        const result = await response.json();

        if (result.status === 'success') {
            currentParseResult = result.data;
            showPreview(result.data);
        } else {
            alert('解析失败: ' + result.message);
        }
    } catch (error) {
        console.error('Parse error:', error);
        alert('解析请求失败');
    }
}

/**
 * 显示入库预览
 */
function showPreview(data) {
    document.getElementById('previewStore').textContent = `${data.store_name} (${data.store_code})`;
    document.getElementById('previewRef').textContent = data.mrs_reference;
    document.getElementById('previewDate').textContent = data.shipment_date;
    document.getElementById('previewCount').textContent = data.items.length + ' 种';

    const tbody = document.getElementById('previewTableBody');
    tbody.innerHTML = '';

    data.items.forEach((item, index) => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${index + 1}</td>
            <td>${item.material_code}</td>
            <td>${item.material_name}</td>
            <td>${item.quantity}</td>
            <td>${item.unit_name}</td>
            <td>${item.batch_code || '-'}</td>
            <td>${item.shelf_life_date || '-'}</td>
        `;
        tbody.appendChild(tr);
    });

    document.getElementById('previewCard').style.display = 'block';
    document.getElementById('previewCard').scrollIntoView({ behavior: 'smooth' });
}

/**
 * 执行入库
 */
async function executeImport() {
    if (!currentParseResult) {
        alert('请先解析入库码');
        return;
    }

    if (!confirm(`确定要将 ${currentParseResult.items.length} 种物料入库到 ${currentParseResult.store_name} 吗？`)) {
        return;
    }

    try {
        const response = await fetch(`${API_BASE}?res=import_code&act=execute`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                data: {
                    store_id: currentParseResult.store_id,
                    mrs_reference: currentParseResult.mrs_reference,
                    shipment_date: currentParseResult.shipment_date,
                    items: currentParseResult.items,
                    code_hash: currentParseResult.code_hash,
                    raw_code: currentParseResult.raw_code,
                    import_source: 'HQ'
                }
            })
        });

        const result = await response.json();

        if (result.status === 'success') {
            alert(result.message);
            cancelImport();
            loadImportLogs();
            document.getElementById('importCodeInput').value = '';
        } else {
            alert('入库失败: ' + result.message);
        }
    } catch (error) {
        console.error('Execute error:', error);
        alert('入库请求失败');
    }
}

/**
 * 取消入库
 */
function cancelImport() {
    currentParseResult = null;
    document.getElementById('previewCard').style.display = 'none';
    document.getElementById('previewTableBody').innerHTML = '';
}

/**
 * 加载入库日志
 */
async function loadImportLogs() {
    const storeId = document.getElementById('filterStore').value;
    const tbody = document.getElementById('logsTableBody');
    tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">加载中...</td></tr>';

    try {
        let url = `${API_BASE}?res=import_logs&act=get`;
        if (storeId) {
            url += `&store_id=${storeId}`;
        }

        const response = await fetch(url);
        const result = await response.json();

        if (result.status === 'success') {
            renderLogs(result.data);
        } else {
            tbody.innerHTML = '<tr><td colspan="8" class="text-center text-danger">加载失败</td></tr>';
        }
    } catch (error) {
        console.error('Load logs error:', error);
        tbody.innerHTML = '<tr><td colspan="8" class="text-center text-danger">加载失败</td></tr>';
    }
}

/**
 * 渲染日志列表
 */
function renderLogs(logs) {
    const tbody = document.getElementById('logsTableBody');

    if (!logs || logs.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">暂无入库记录</td></tr>';
        return;
    }

    tbody.innerHTML = '';
    logs.forEach(log => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${log.id}</td>
            <td>${log.store_name} (${log.store_code})</td>
            <td>${log.mrs_reference}</td>
            <td>${log.shipment_date}</td>
            <td>${log.items_count} 种</td>
            <td>${log.imported_at}</td>
            <td><span class="badge ${log.import_source === 'HQ' ? 'bg-primary' : 'bg-success'}">${log.import_source}</span></td>
            <td>
                <button class="btn btn-sm btn-outline-info" onclick="viewLogDetail(${log.id})">
                    <i class="bi bi-eye"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

/**
 * 查看日志详情
 */
async function viewLogDetail(logId) {
    try {
        const response = await fetch(`${API_BASE}?res=import_logs&act=detail&id=${logId}`);
        const result = await response.json();

        if (result.status === 'success') {
            showDetailModal(result.data);
        } else {
            alert('获取详情失败: ' + result.message);
        }
    } catch (error) {
        console.error('Get detail error:', error);
        alert('获取详情失败');
    }
}

/**
 * 显示详情模态框
 */
function showDetailModal(data) {
    document.getElementById('detailStore').textContent = `${data.store_name} (${data.store_code})`;
    document.getElementById('detailRef').textContent = data.mrs_reference;
    document.getElementById('detailDate').textContent = data.shipment_date;
    document.getElementById('detailTime').textContent = data.imported_at;

    const tbody = document.getElementById('detailTableBody');
    tbody.innerHTML = '';

    (data.details || []).forEach(item => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${item.material_code}</td>
            <td>${item.material_name}</td>
            <td>${item.quantity}</td>
            <td>${item.unit_name}</td>
            <td>${item.batch_code || '-'}</td>
            <td>${item.shelf_life_date || '-'}</td>
        `;
        tbody.appendChild(tr);
    });

    new bootstrap.Modal(document.getElementById('detailModal')).show();
}
