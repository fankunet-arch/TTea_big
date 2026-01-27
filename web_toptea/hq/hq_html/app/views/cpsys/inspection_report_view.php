<div class="d-flex justify-content-between align-items-center mb-3">
    <div>
        <span class="text-white-50">查看各门店检查完成情况</span>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-primary" id="btn-generate-tasks">
            <i class="bi bi-plus-circle me-1"></i>生成当期任务
        </button>
    </div>
</div>

<!-- 筛选器 -->
<div class="card mb-4">
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label">检查周期</label>
                <select class="form-select" id="filter-frequency">
                    <option value="monthly" selected>月度检查</option>
                    <option value="weekly">周度检查</option>
                    <option value="yearly">年度检查</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">周期</label>
                <input type="month" class="form-control" id="filter-period-month">
                <input type="week" class="form-control" id="filter-period-week" style="display: none;">
                <input type="number" class="form-control" id="filter-period-year" style="display: none;" min="2020" max="2100">
            </div>
            <div class="col-md-3">
                <label class="form-label">门店</label>
                <select class="form-select" id="filter-store">
                    <option value="">全部门店</option>
                    <?php foreach ($stores as $store): ?>
                    <option value="<?php echo $store['id']; ?>">
                        <?php echo htmlspecialchars($store['store_code'] . ' - ' . $store['store_name']); ?>
                    </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="col-md-3">
                <button class="btn btn-primary w-100" id="btn-search">
                    <i class="bi bi-search me-1"></i>查询
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 统计卡片 -->
<div class="row mb-4" id="summary-cards">
    <div class="col-md-3">
        <div class="card text-bg-primary">
            <div class="card-body">
                <h6 class="card-title">总任务数</h6>
                <h2 class="mb-0" id="stat-total">0</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-bg-success">
            <div class="card-body">
                <h6 class="card-title">已完成</h6>
                <h2 class="mb-0" id="stat-completed">0</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-bg-warning">
            <div class="card-body">
                <h6 class="card-title">待完成</h6>
                <h2 class="mb-0" id="stat-pending">0</h2>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-bg-info">
            <div class="card-body">
                <h6 class="card-title">完成率</h6>
                <h2 class="mb-0"><span id="stat-rate">0</span>%</h2>
            </div>
        </div>
    </div>
</div>

<!-- 任务列表 -->
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span>检查任务列表</span>
        <span class="badge text-bg-secondary" id="period-display"></span>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle" id="task-table">
                <thead>
                    <tr>
                        <th>门店</th>
                        <th>检查项目</th>
                        <th>截止日期</th>
                        <th>状态</th>
                        <th>完成时间</th>
                        <th>完成人</th>
                        <th>照片</th>
                        <th class="text-end">操作</th>
                    </tr>
                </thead>
                <tbody id="task-tbody">
                    <tr><td colspan="8" class="text-center">请选择周期后点击查询</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 任务详情 Modal -->
<div class="modal fade" id="task-detail-modal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">检查详情</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="task-detail-body">
                加载中...
            </div>
        </div>
    </div>
</div>
