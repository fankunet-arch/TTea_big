<?php
/**
 * Toptea HQ - 入库码管理页面
 * Version: 1.0
 * Date: 2026-01-26
 */
?>
<div class="container-fluid">
    <div class="row mb-4">
        <div class="col">
            <h4>入库码管理</h4>
            <p class="text-muted">通过入库码批量导入门店库存</p>
        </div>
    </div>

    <!-- 入库码录入区域 -->
    <div class="card mb-4">
        <div class="card-header">
            <i class="bi bi-qr-code me-2"></i>录入入库码
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                    <div class="mb-3">
                        <label for="importCodeInput" class="form-label">入库码 (Base64)</label>
                        <textarea class="form-control" id="importCodeInput" rows="4" placeholder="粘贴MRS系统生成的入库码..."></textarea>
                    </div>
                    <button type="button" class="btn btn-primary" id="btnParseCode">
                        <i class="bi bi-search me-2"></i>解析入库码
                    </button>
                </div>
                <div class="col-md-4">
                    <div class="alert alert-info">
                        <h6><i class="bi bi-info-circle me-2"></i>入库码格式说明</h6>
                        <small>
                            入库码由MRS系统生成，包含：<br>
                            - 门店代码<br>
                            - MRS单号<br>
                            - 出货日期<br>
                            - 物料清单（含数量、批次、保质期）
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 解析预览区域 (默认隐藏) -->
    <div class="card mb-4" id="previewCard" style="display: none;">
        <div class="card-header bg-warning text-dark">
            <i class="bi bi-eye me-2"></i>入库预览
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-3">
                    <strong>门店：</strong><span id="previewStore">-</span>
                </div>
                <div class="col-md-3">
                    <strong>MRS单号：</strong><span id="previewRef">-</span>
                </div>
                <div class="col-md-3">
                    <strong>出货日期：</strong><span id="previewDate">-</span>
                </div>
                <div class="col-md-3">
                    <strong>物料种类：</strong><span id="previewCount">-</span>
                </div>
            </div>

            <table class="table table-sm table-bordered" id="previewTable">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>物料代码</th>
                        <th>物料名称</th>
                        <th>数量</th>
                        <th>单位</th>
                        <th>批次号</th>
                        <th>保质期</th>
                    </tr>
                </thead>
                <tbody id="previewTableBody">
                </tbody>
            </table>

            <div class="d-flex gap-2">
                <button type="button" class="btn btn-success" id="btnExecuteImport">
                    <i class="bi bi-check-circle me-2"></i>确认入库
                </button>
                <button type="button" class="btn btn-secondary" id="btnCancelImport">
                    <i class="bi bi-x-circle me-2"></i>取消
                </button>
            </div>
        </div>
    </div>

    <!-- 入库日志列表 -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span><i class="bi bi-list-ul me-2"></i>入库日志</span>
            <div>
                <select class="form-select form-select-sm d-inline-block w-auto" id="filterStore">
                    <option value="">全部门店</option>
                    <?php foreach ($stores ?? [] as $store): ?>
                        <option value="<?php echo $store['id']; ?>"><?php echo htmlspecialchars($store['store_name']); ?></option>
                    <?php endforeach; ?>
                </select>
                <button type="button" class="btn btn-sm btn-outline-secondary" id="btnRefreshLogs">
                    <i class="bi bi-arrow-clockwise"></i>
                </button>
            </div>
        </div>
        <div class="card-body">
            <table class="table table-hover" id="logsTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>门店</th>
                        <th>MRS单号</th>
                        <th>出货日期</th>
                        <th>物料种类</th>
                        <th>导入时间</th>
                        <th>来源</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="logsTableBody">
                    <tr>
                        <td colspan="8" class="text-center text-muted">加载中...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 详情模态框 -->
<div class="modal fade" id="detailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">入库详情</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong>门店：</strong><span id="detailStore">-</span></p>
                        <p><strong>MRS单号：</strong><span id="detailRef">-</span></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>出货日期：</strong><span id="detailDate">-</span></p>
                        <p><strong>导入时间：</strong><span id="detailTime">-</span></p>
                    </div>
                </div>
                <table class="table table-sm table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>物料代码</th>
                            <th>物料名称</th>
                            <th>数量</th>
                            <th>单位</th>
                            <th>批次号</th>
                            <th>保质期</th>
                        </tr>
                    </thead>
                    <tbody id="detailTableBody">
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
