<?php
/**
 * Toptea KDS - 入库码录入页面
 * Version: 1.0
 * Date: 2026-01-26
 */
?>
<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-box-arrow-in-down me-2"></i>物料入库</h5>
                </div>
                <div class="card-body">
                    <!-- 入库码输入 -->
                    <div class="mb-4">
                        <label for="importCodeInput" class="form-label fw-bold">入库码</label>
                        <textarea class="form-control" id="importCodeInput" rows="3"
                                  placeholder="请粘贴或扫描MRS系统生成的入库码..."></textarea>
                        <div class="form-text">入库码由MRS系统在出货时生成，包含物料清单信息</div>
                    </div>

                    <button type="button" class="btn btn-primary btn-lg w-100 mb-4" id="btnParseCode">
                        <i class="bi bi-search me-2"></i>解析入库码
                    </button>

                    <!-- 预览区域 -->
                    <div id="previewArea" style="display: none;">
                        <hr>
                        <h6 class="text-warning"><i class="bi bi-exclamation-triangle me-2"></i>入库预览</h6>

                        <div class="row mb-3">
                            <div class="col-6">
                                <small class="text-muted">MRS单号</small>
                                <div class="fw-bold" id="previewRef">-</div>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">出货日期</small>
                                <div class="fw-bold" id="previewDate">-</div>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-sm table-bordered">
                                <thead class="table-secondary">
                                    <tr>
                                        <th>物料</th>
                                        <th>数量</th>
                                        <th>批次</th>
                                        <th>保质期</th>
                                    </tr>
                                </thead>
                                <tbody id="previewTableBody">
                                </tbody>
                            </table>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-success btn-lg" id="btnConfirmImport">
                                <i class="bi bi-check-circle me-2"></i>确认入库
                            </button>
                            <button type="button" class="btn btn-outline-secondary" id="btnCancelImport">
                                取消
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 最近入库记录 -->
            <div class="card mt-4">
                <div class="card-header">
                    <i class="bi bi-clock-history me-2"></i>最近入库记录
                </div>
                <div class="card-body p-0">
                    <div class="list-group list-group-flush" id="recentImportsList">
                        <div class="list-group-item text-center text-muted">加载中...</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
const API_URL = 'api/kds_api_gateway.php';
let currentParseResult = null;

document.getElementById('btnParseCode').addEventListener('click', parseCode);
document.getElementById('btnConfirmImport').addEventListener('click', confirmImport);
document.getElementById('btnCancelImport').addEventListener('click', cancelImport);

// 页面加载时获取最近记录
loadRecentImports();

async function parseCode() {
    const code = document.getElementById('importCodeInput').value.trim();
    if (!code) {
        showKdsAlert('请输入入库码', true);
        return;
    }

    try {
        const response = await fetch(`${API_URL}?res=stock&act=parse_import_code`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ import_code: code })
        });

        const result = await response.json();

        if (result.status === 'success') {
            currentParseResult = result.data;
            showPreview(result.data);
        } else {
            showKdsAlert(result.message || '解析失败', true);
        }
    } catch (error) {
        console.error('Parse error:', error);
        showKdsAlert('解析请求失败', true);
    }
}

function showPreview(data) {
    document.getElementById('previewRef').textContent = data.mrs_reference;
    document.getElementById('previewDate').textContent = data.shipment_date;

    const tbody = document.getElementById('previewTableBody');
    tbody.innerHTML = '';

    data.items.forEach(item => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${item.material_name}</td>
            <td>${item.quantity} ${item.unit_name}</td>
            <td>${item.batch_code || '-'}</td>
            <td>${item.shelf_life_date || '-'}</td>
        `;
        tbody.appendChild(tr);
    });

    document.getElementById('previewArea').style.display = 'block';
}

async function confirmImport() {
    if (!currentParseResult) return;

    if (!confirm(`确定入库 ${currentParseResult.items.length} 种物料吗？`)) {
        return;
    }

    try {
        const response = await fetch(`${API_URL}?res=stock&act=execute_import`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                store_id: currentParseResult.store_id,
                mrs_reference: currentParseResult.mrs_reference,
                shipment_date: currentParseResult.shipment_date,
                items: currentParseResult.items,
                code_hash: currentParseResult.code_hash,
                raw_code: currentParseResult.raw_code,
                import_source: 'KDS'
            })
        });

        const result = await response.json();

        if (result.status === 'success') {
            showKdsAlert('入库成功！', false);
            cancelImport();
            document.getElementById('importCodeInput').value = '';
            loadRecentImports();
        } else {
            showKdsAlert(result.message || '入库失败', true);
        }
    } catch (error) {
        console.error('Import error:', error);
        showKdsAlert('入库请求失败', true);
    }
}

function cancelImport() {
    currentParseResult = null;
    document.getElementById('previewArea').style.display = 'none';
}

async function loadRecentImports() {
    try {
        const response = await fetch(`${API_URL}?res=stock&act=recent_imports&limit=5`);
        const result = await response.json();

        const list = document.getElementById('recentImportsList');

        if (result.status === 'success' && result.data && result.data.length > 0) {
            list.innerHTML = '';
            result.data.forEach(log => {
                const item = document.createElement('div');
                item.className = 'list-group-item d-flex justify-content-between align-items-center';
                item.innerHTML = `
                    <div>
                        <div class="fw-bold">${log.mrs_reference}</div>
                        <small class="text-muted">${log.shipment_date} | ${log.items_count} 种物料</small>
                    </div>
                    <small class="text-muted">${log.imported_at}</small>
                `;
                list.appendChild(item);
            });
        } else {
            list.innerHTML = '<div class="list-group-item text-center text-muted">暂无入库记录</div>';
        }
    } catch (error) {
        console.error('Load recent imports error:', error);
    }
}
</script>
