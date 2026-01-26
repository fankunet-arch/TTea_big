<?php
/**
 * Toptea HQ - KDS 打印模板管理页面
 * Version: 1.0
 * Date: 2026-01-26
 */
?>
<div class="container-fluid">
    <div class="row mb-4">
        <div class="col">
            <h4>KDS 打印模板管理</h4>
            <p class="text-muted">配置效期标签等 KDS 打印模板</p>
        </div>
        <div class="col-auto">
            <button type="button" class="btn btn-primary" id="btnAddTemplate">
                <i class="bi bi-plus-lg me-2"></i>新建模板
            </button>
        </div>
    </div>

    <!-- 模板列表 -->
    <div class="card">
        <div class="card-body">
            <table class="table table-hover" id="templatesTable">
                <thead>
                    <tr>
                        <th>模板代码</th>
                        <th>模板名称</th>
                        <th>类型</th>
                        <th>纸张尺寸</th>
                        <th>状态</th>
                        <th>更新时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="templatesTableBody">
                    <tr>
                        <td colspan="7" class="text-center text-muted">加载中...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 编辑模态框 -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">编辑模板</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="templateForm">
                    <input type="hidden" id="templateId">

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="templateCode" class="form-label">模板代码 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="templateCode" placeholder="如: EXPIRY_LABEL" required>
                            <div class="form-text">唯一标识符，用于程序调用</div>
                        </div>
                        <div class="col-md-6">
                            <label for="templateName" class="form-label">模板名称 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="templateName" placeholder="如: 效期标签" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="templateType" class="form-label">打印机类型</label>
                            <select class="form-select" id="templateType">
                                <option value="TSPL">TSPL (标签打印机)</option>
                                <option value="ESC_POS">ESC/POS (小票打印机)</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="paperWidth" class="form-label">纸张宽度 (mm)</label>
                            <input type="number" class="form-control" id="paperWidth" value="40">
                        </div>
                        <div class="col-md-4">
                            <label for="paperHeight" class="form-label">纸张高度 (mm)</label>
                            <input type="number" class="form-control" id="paperHeight" value="30">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="templateContent" class="form-label">模板内容 (JSON)</label>
                        <textarea class="form-control font-monospace" id="templateContent" rows="12" placeholder='{"commands": [...], "copies": 1}'></textarea>
                        <div class="form-text">
                            支持的变量: <code>{{material_name}}</code>, <code>{{opened_at_time}}</code>, <code>{{expires_at_time}}</code>, <code>{{time_left}}</code>, <code>{{handler_name}}</code>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">说明</label>
                        <textarea class="form-control" id="description" rows="2"></textarea>
                    </div>

                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="isActive" checked>
                        <label class="form-check-label" for="isActive">启用</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="btnSaveTemplate">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 预览模态框 -->
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">模板预览</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="border p-3 bg-white text-dark" id="previewContent" style="font-family: monospace; min-height: 200px;">
                </div>
            </div>
        </div>
    </div>
</div>
