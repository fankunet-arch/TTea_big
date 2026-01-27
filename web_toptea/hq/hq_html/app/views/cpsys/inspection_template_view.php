<div class="d-flex justify-content-between align-items-center mb-3">
    <div>
        <span class="text-white-50">管理门店检查项目，设置周期和门店范围</span>
    </div>
    <button class="btn btn-primary" id="create-btn" data-bs-toggle="offcanvas" data-bs-target="#data-drawer">
        <i class="bi bi-plus-circle me-2"></i>新增检查项目
    </button>
</div>

<div class="card">
    <div class="card-header">检查项目列表</div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle" id="template-table">
                <thead>
                    <tr>
                        <th>检查名称</th>
                        <th>代码</th>
                        <th>检查周期</th>
                        <th>截止日</th>
                        <th>门店范围</th>
                        <th>状态</th>
                        <th class="text-end">操作</th>
                    </tr>
                </thead>
                <tbody id="template-tbody">
                    <tr><td colspan="7" class="text-center">加载中...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 编辑抽屉 -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="data-drawer" aria-labelledby="drawer-label" style="width: 600px;">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="drawer-label">创建/编辑检查项目</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <form id="data-form">
            <input type="hidden" id="data-id" name="id">

            <h6 class="text-white-50">基础信息</h6>
            <div class="mb-3">
                <label for="template_code" class="form-label">检查代码 <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="template_code" name="template_code" required
                       pattern="[A-Z0-9_]+" title="只能包含大写字母、数字和下划线">
                <div class="form-text">唯一标识，如 FIRE_EQUIPMENT</div>
            </div>
            <div class="mb-3">
                <label for="template_name" class="form-label">检查名称 <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="template_name" name="template_name" required>
            </div>
            <div class="mb-3">
                <label for="description" class="form-label">检查说明</label>
                <textarea class="form-control" id="description" name="description" rows="4" placeholder="详细的检查要求和步骤..."></textarea>
            </div>
            <div class="mb-3">
                <label for="photo_hint" class="form-label">照片提示</label>
                <input type="text" class="form-control" id="photo_hint" name="photo_hint" placeholder="如：请拍摄所有灭火器，每个一张">
            </div>

            <hr>
            <h6 class="text-white-50">检查周期</h6>
            <div class="mb-3">
                <label class="form-label">周期类型 <span class="text-danger">*</span></label>
                <div class="btn-group w-100" role="group">
                    <input type="radio" class="btn-check" name="frequency_type" id="freq_weekly" value="weekly">
                    <label class="btn btn-outline-primary" for="freq_weekly">每周</label>

                    <input type="radio" class="btn-check" name="frequency_type" id="freq_monthly" value="monthly" checked>
                    <label class="btn btn-outline-primary" for="freq_monthly">每月</label>

                    <input type="radio" class="btn-check" name="frequency_type" id="freq_yearly" value="yearly">
                    <label class="btn btn-outline-primary" for="freq_yearly">每年</label>
                </div>
            </div>

            <!-- 周度截止设置 -->
            <div class="mb-3 freq-option" id="weekly-options" style="display: none;">
                <label for="due_weekday" class="form-label">每周几截止</label>
                <select class="form-select" id="due_weekday" name="due_weekday">
                    <option value="1">周一</option>
                    <option value="2">周二</option>
                    <option value="3">周三</option>
                    <option value="4">周四</option>
                    <option value="5" selected>周五</option>
                    <option value="6">周六</option>
                    <option value="7">周日</option>
                </select>
            </div>

            <!-- 月度截止设置 -->
            <div class="mb-3 freq-option" id="monthly-options">
                <label for="due_day" class="form-label">每月第几天截止</label>
                <input type="number" class="form-control" id="due_day" name="due_day" min="1" max="31" value="25">
            </div>

            <!-- 年度截止设置 -->
            <div class="mb-3 freq-option" id="yearly-options" style="display: none;">
                <div class="row">
                    <div class="col-6">
                        <label for="due_month" class="form-label">第几月</label>
                        <select class="form-select" id="due_month" name="due_month">
                            <?php for ($m = 1; $m <= 12; $m++): ?>
                            <option value="<?php echo $m; ?>" <?php echo $m === 12 ? 'selected' : ''; ?>><?php echo $m; ?>月</option>
                            <?php endfor; ?>
                        </select>
                    </div>
                    <div class="col-6">
                        <label for="due_day_yearly" class="form-label">第几天</label>
                        <input type="number" class="form-control" id="due_day_yearly" name="due_day_yearly" min="1" max="31" value="15">
                    </div>
                </div>
            </div>

            <hr>
            <h6 class="text-white-50">适用门店</h6>
            <div class="mb-3">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="apply_to_all" name="apply_to_all" checked>
                    <label class="form-check-label" for="apply_to_all">全部门店</label>
                </div>
            </div>
            <div class="mb-3" id="store-selection" style="display: none;">
                <label class="form-label">选择门店</label>
                <div id="store-checkboxes" class="border rounded p-2" style="max-height: 200px; overflow-y: auto;">
                    <?php foreach ($stores as $store): ?>
                    <div class="form-check">
                        <input class="form-check-input store-cb" type="checkbox" value="<?php echo $store['id']; ?>" id="store_<?php echo $store['id']; ?>">
                        <label class="form-check-label" for="store_<?php echo $store['id']; ?>">
                            <?php echo htmlspecialchars($store['store_code'] . ' - ' . $store['store_name']); ?>
                        </label>
                    </div>
                    <?php endforeach; ?>
                </div>
            </div>

            <hr>
            <div class="form-check form-switch mb-4">
                <input class="form-check-input" type="checkbox" id="is_active" name="is_active" checked>
                <label class="form-check-label" for="is_active">启用此检查项目</label>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="offcanvas">取消</button>
                <button type="submit" class="btn btn-primary">保存</button>
            </div>
        </form>
    </div>
</div>
