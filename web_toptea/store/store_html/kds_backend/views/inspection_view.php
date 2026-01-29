<header class="prep-header">
    <h1 class="prep-title">
        <i class="bi bi-clipboard-check me-2"></i>
        <span data-i18n-key="inspection_title">检查清单</span>
    </h1>
    <a href="index.php" class="btn-back">
        <i class="bi bi-arrow-left"></i>
        <span data-i18n-key="btn_back_kds">返回KDS</span>
    </a>
</header>

<main class="inspection-container">
    <!-- 进度概览 -->
    <div class="inspection-summary" id="inspection-summary">
        <div class="summary-text">
            <span data-i18n-key="inspection_progress">本期进度</span>:
            <strong id="progress-completed">0</strong> / <strong id="progress-total">0</strong>
        </div>
        <div class="progress" style="height: 20px; flex: 1; max-width: 200px;">
            <div class="progress-bar bg-success" id="progress-bar" role="progressbar" style="width: 0%"></div>
        </div>
    </div>

    <!-- 周期切换 -->
    <div class="inspection-tabs">
        <button class="inspection-tab active" data-period="current">
            <i class="bi bi-calendar-check me-1"></i>
            <span data-i18n-key="period_current">当期任务</span>
        </button>
        <button class="inspection-tab" data-period="history">
            <i class="bi bi-clock-history me-1"></i>
            <span data-i18n-key="period_history">历史记录</span>
        </button>
    </div>

    <!-- 任务列表 -->
    <div class="inspection-list" id="inspection-list">
        <div class="loading-spinner">
            <div class="spinner-border text-primary" role="status"></div>
            <span data-i18n-key="loading">加载中...</span>
        </div>
    </div>
</main>

<!-- 任务详情 Modal -->
<div class="modal fade" id="taskModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="taskModalTitle">检查详情</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="taskModalBody">
                <!-- 动态填充 -->
            </div>
            <div class="modal-footer" id="taskModalFooter">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 照片上传 Modal -->
<div class="modal fade" id="photoUploadModal" tabindex="-1" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">上传检查照片</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="upload-task-id">

                <div class="photo-requirements mb-3">
                    <div class="alert alert-info mb-0">
                        <i class="bi bi-info-circle me-2"></i>
                        <strong>拍照要求:</strong>
                        <ul class="mb-0 mt-2">
                            <li>请现场拍摄，不要使用以前的照片</li>
                            <li>确保内容清晰可读（如标签、日期等）</li>
                            <li>照片将记录拍摄时间和位置用于备查</li>
                        </ul>
                    </div>
                </div>

                <div class="photo-hint mb-3" id="photo-hint-text" style="display: none;">
                    <div class="alert alert-secondary mb-0">
                        <i class="bi bi-lightbulb me-2"></i>
                        <span id="photo-hint-content"></span>
                    </div>
                </div>

                <!-- 照片上传区域 -->
                <!--
                    WebView 关键兼容方案：
                    使用 <label for="inputId"> 替代 <button> + JS .click()。
                    原因：Android WebView 中，JS 调用 input.click() 经常被静默拦截，
                    但 <label> 的原生 HTML 关联行为（点击 label = 点击 input）不受此限制。
                    这是跨所有 WebView 实现最可靠的触发 file input 的方式。
                -->
                <div class="photo-upload-area">
                    <div class="upload-buttons d-flex gap-2 mb-3">
                        <label for="camera-input" class="btn btn-primary flex-fill mb-0" id="btn-camera" role="button">
                            <i class="bi bi-camera-fill me-2"></i>拍照
                        </label>
                        <label for="photo-input" class="btn btn-outline-primary flex-fill mb-0" id="btn-gallery" role="button">
                            <i class="bi bi-image me-2"></i>相册
                        </label>
                    </div>
                    <input type="file" id="camera-input" accept="image/*" capture="environment"
                           style="position:absolute;left:-9999px;top:-9999px;opacity:0;width:1px;height:1px;pointer-events:none;">
                    <input type="file" id="photo-input" accept="image/*" multiple
                           style="position:absolute;left:-9999px;top:-9999px;opacity:0;width:1px;height:1px;pointer-events:none;">
                </div>

                <!-- 已选照片预览 -->
                <div class="selected-photos mt-3" id="selected-photos">
                    <div class="text-muted text-center py-3" id="no-photos-hint">
                        <i class="bi bi-images" style="font-size: 2rem;"></i>
                        <p class="mb-0">点击上方按钮添加照片</p>
                    </div>
                    <div class="photo-preview-grid" id="photo-preview-grid"></div>
                </div>

                <!-- 备注 -->
                <div class="mt-3">
                    <label class="form-label">备注 (可选)</label>
                    <textarea class="form-control" id="task-notes" rows="2" placeholder="添加检查备注..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-success" id="btn-submit-inspection" disabled>
                    <i class="bi bi-check-circle me-2"></i>提交完成
                </button>
            </div>
        </div>
    </div>
</div>

<style>
.inspection-container {
    padding: 1rem;
    max-width: 800px;
    margin: 0 auto;
}

.inspection-summary {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    background: rgba(255,255,255,0.1);
    border-radius: 8px;
    margin-bottom: 1rem;
}

.summary-text {
    font-size: 1.1rem;
}

.inspection-tabs {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1rem;
}

.inspection-tab {
    flex: 1;
    padding: 0.75rem;
    border: none;
    background: rgba(255,255,255,0.1);
    color: #ccc;
    border-radius: 8px;
    font-size: 1rem;
    cursor: pointer;
    transition: all 0.2s;
}

.inspection-tab.active {
    background: var(--bs-primary);
    color: white;
}

.inspection-list {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.inspection-item {
    background: rgba(255,255,255,0.05);
    border-radius: 8px;
    padding: 1rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    cursor: pointer;
    transition: all 0.2s;
    border: 1px solid transparent;
}

.inspection-item:hover {
    background: rgba(255,255,255,0.1);
}

.inspection-item.completed {
    border-color: var(--bs-success);
}

.inspection-item.pending {
    border-color: var(--bs-warning);
}

.inspection-item.overdue {
    border-color: var(--bs-danger);
}

.item-status {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    flex-shrink: 0;
}

.item-status.completed {
    background: var(--bs-success);
    color: white;
}

.item-status.pending {
    background: var(--bs-warning);
    color: #000;
}

.item-status.pending-review {
    background: var(--bs-info);
    color: white;
}

.inspection-item.pending-review {
    border-color: var(--bs-info);
}

.item-status.overdue {
    background: var(--bs-danger);
    color: white;
}

.item-content {
    flex: 1;
}

.item-title {
    font-weight: 600;
    margin-bottom: 0.25rem;
}

.item-subtitle {
    font-size: 0.85rem;
    color: #999;
}

.item-arrow {
    color: #666;
    font-size: 1.2rem;
}

.loading-spinner {
    text-align: center;
    padding: 3rem;
    color: #999;
}

.loading-spinner .spinner-border {
    margin-bottom: 1rem;
}

.photo-preview-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.5rem;
}

.photo-preview-item {
    position: relative;
    aspect-ratio: 1;
    border-radius: 8px;
    overflow: hidden;
}

.photo-preview-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.photo-preview-item .remove-photo {
    position: absolute;
    top: 4px;
    right: 4px;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    background: rgba(0,0,0,0.7);
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

.photo-preview-item .photo-warning {
    position: absolute;
    bottom: 4px;
    left: 4px;
    padding: 2px 6px;
    background: rgba(255, 193, 7, 0.9);
    color: #000;
    font-size: 0.7rem;
    border-radius: 4px;
}
</style>
