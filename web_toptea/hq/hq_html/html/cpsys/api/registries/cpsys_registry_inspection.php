<?php
/**
 * Toptea HQ - CPSYS API 注册表 (Inspection Management)
 * 门店检查系统管理
 * Version: 1.0
 * Date: 2026-01-27
 */

require_once realpath(__DIR__ . '/../../../../app/helpers/auth_helper.php');

/* ============================================================
   检查模板 Handlers
   ============================================================ */

/**
 * 获取检查模板列表
 */
function handle_inspection_template_get(PDO $pdo, array $config, array $input_data): void {
    $id = isset($_GET['id']) ? (int)$_GET['id'] : null;

    if ($id) {
        // 获取单个模板详情
        $stmt = $pdo->prepare("
            SELECT t.*,
                   GROUP_CONCAT(ts.store_id) as store_ids
            FROM store_inspection_templates t
            LEFT JOIN store_inspection_template_stores ts ON ts.template_id = t.id
            WHERE t.id = ?
            GROUP BY t.id
        ");
        $stmt->execute([$id]);
        $template = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$template) {
            json_error('模板不存在', 404);
        }

        // 解析 store_ids
        $template['store_ids'] = $template['store_ids']
            ? array_map('intval', explode(',', $template['store_ids']))
            : [];

        json_ok($template, '模板详情');
    }

    // 获取所有模板列表
    $sql = "
        SELECT t.*,
               (SELECT COUNT(*) FROM store_inspection_template_stores WHERE template_id = t.id) as assigned_store_count
        FROM store_inspection_templates t
        ORDER BY t.frequency_type, t.template_name
    ";
    $stmt = $pdo->query($sql);
    json_ok($stmt->fetchAll(PDO::FETCH_ASSOC), '模板列表');
}

/**
 * 保存检查模板
 */
function handle_inspection_template_save(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);

    $id = !empty($data['id']) ? (int)$data['id'] : null;
    $template_code = trim($data['template_code'] ?? '');
    $template_name = trim($data['template_name'] ?? '');
    $description = trim($data['description'] ?? '');
    $frequency_type = $data['frequency_type'] ?? 'monthly';
    $due_day = (int)($data['due_day'] ?? 25);
    $due_weekday = (int)($data['due_weekday'] ?? 5);
    $due_month = (int)($data['due_month'] ?? 12);
    $photo_hint = trim($data['photo_hint'] ?? '');
    $apply_to_all = (int)($data['apply_to_all'] ?? 1);
    $is_active = (int)($data['is_active'] ?? 1);
    $store_ids = $data['store_ids'] ?? [];

    if (empty($template_code) || empty($template_name)) {
        json_error('模板代码和名称不能为空', 400);
    }

    if (!in_array($frequency_type, ['weekly', 'monthly', 'yearly'])) {
        json_error('无效的检查周期类型', 400);
    }

    $pdo->beginTransaction();
    try {
        if ($id) {
            // 更新
            $stmt = $pdo->prepare("
                UPDATE store_inspection_templates SET
                    template_code = ?,
                    template_name = ?,
                    description = ?,
                    frequency_type = ?,
                    due_day = ?,
                    due_weekday = ?,
                    due_month = ?,
                    photo_hint = ?,
                    apply_to_all = ?,
                    is_active = ?
                WHERE id = ?
            ");
            $stmt->execute([
                $template_code, $template_name, $description,
                $frequency_type, $due_day, $due_weekday, $due_month,
                $photo_hint, $apply_to_all, $is_active, $id
            ]);
        } else {
            // 新增
            $stmt = $pdo->prepare("
                INSERT INTO store_inspection_templates
                (template_code, template_name, description, frequency_type, due_day, due_weekday, due_month, photo_hint, apply_to_all, is_active)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            $stmt->execute([
                $template_code, $template_name, $description,
                $frequency_type, $due_day, $due_weekday, $due_month,
                $photo_hint, $apply_to_all, $is_active
            ]);
            $id = $pdo->lastInsertId();
        }

        // 更新门店关联
        $stmt = $pdo->prepare("DELETE FROM store_inspection_template_stores WHERE template_id = ?");
        $stmt->execute([$id]);

        if (!$apply_to_all && !empty($store_ids)) {
            $stmt = $pdo->prepare("INSERT INTO store_inspection_template_stores (template_id, store_id) VALUES (?, ?)");
            foreach ($store_ids as $store_id) {
                $stmt->execute([$id, (int)$store_id]);
            }
        }

        $pdo->commit();
        json_ok(['id' => $id], $id ? '模板更新成功' : '模板创建成功');
    } catch (Exception $e) {
        $pdo->rollBack();
        if (strpos($e->getMessage(), 'Duplicate entry') !== false) {
            json_error('模板代码已存在', 400);
        }
        json_error('保存失败: ' . $e->getMessage(), 500);
    }
}

/**
 * 删除检查模板
 */
function handle_inspection_template_delete(PDO $pdo, array $config, array $input_data): void {
    $id = (int)($_GET['id'] ?? $input_data['data']['id'] ?? 0);

    if ($id <= 0) {
        json_error('缺少模板ID', 400);
    }

    // 检查是否有关联任务
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM store_inspection_tasks WHERE template_id = ?");
    $stmt->execute([$id]);
    if ($stmt->fetchColumn() > 0) {
        json_error('该模板已有检查任务，无法删除。请先将其设为禁用。', 400);
    }

    $stmt = $pdo->prepare("DELETE FROM store_inspection_templates WHERE id = ?");
    $stmt->execute([$id]);

    if ($stmt->rowCount() > 0) {
        json_ok(null, '模板删除成功');
    } else {
        json_error('模板不存在', 404);
    }
}


/* ============================================================
   检查报表 Handlers
   ============================================================ */

/**
 * 获取检查报表数据
 */
function handle_inspection_report_get(PDO $pdo, array $config, array $input_data): void {
    $store_id = isset($_GET['store_id']) ? (int)$_GET['store_id'] : null;
    $period_key = $_GET['period_key'] ?? null;
    $frequency_type = $_GET['frequency_type'] ?? 'monthly';

    // 如果没有指定周期，使用当前周期
    if (!$period_key) {
        $now = new DateTime();
        switch ($frequency_type) {
            case 'weekly':
                $period_key = $now->format('Y-\\WW');
                break;
            case 'yearly':
                $period_key = $now->format('Y');
                break;
            default:
                $period_key = $now->format('Y-m');
        }
    }

    $where = ['t.period_key = ?'];
    $params = [$period_key];

    if ($store_id) {
        $where[] = 't.store_id = ?';
        $params[] = $store_id;
    }

    $whereClause = implode(' AND ', $where);

    $sql = "
        SELECT
            t.id,
            t.store_id,
            s.store_code,
            s.store_name,
            t.template_id,
            tpl.template_name,
            tpl.frequency_type,
            t.period_key,
            t.period_start,
            t.period_end,
            t.status,
            t.completed_at,
            t.completed_by,
            ku.display_name as completed_by_name,
            t.notes,
            (SELECT COUNT(*) FROM store_inspection_photos WHERE task_id = t.id) as photo_count
        FROM store_inspection_tasks t
        JOIN kds_stores s ON s.id = t.store_id
        JOIN store_inspection_templates tpl ON tpl.id = t.template_id
        LEFT JOIN kds_users ku ON ku.id = t.completed_by
        WHERE {$whereClause}
        ORDER BY s.store_code, tpl.template_name
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // 汇总统计
    $summary = [
        'total' => count($tasks),
        'completed' => 0,
        'pending' => 0,
        'completion_rate' => 0,
    ];

    foreach ($tasks as $task) {
        if ($task['status'] === 'completed') {
            $summary['completed']++;
        } else {
            $summary['pending']++;
        }
    }

    if ($summary['total'] > 0) {
        $summary['completion_rate'] = round(($summary['completed'] / $summary['total']) * 100, 1);
    }

    json_ok([
        'tasks' => $tasks,
        'summary' => $summary,
        'period_key' => $period_key,
    ], '检查报表');
}

/**
 * 获取任务详情（含照片）
 */
function handle_inspection_task_detail(PDO $pdo, array $config, array $input_data): void {
    $task_id = (int)($_GET['id'] ?? 0);

    if ($task_id <= 0) {
        json_error('缺少任务ID', 400);
    }

    // 获取任务信息
    $stmt = $pdo->prepare("
        SELECT
            t.*,
            s.store_code,
            s.store_name,
            tpl.template_name,
            tpl.description as template_description,
            tpl.photo_hint,
            ku.display_name as completed_by_name
        FROM store_inspection_tasks t
        JOIN kds_stores s ON s.id = t.store_id
        JOIN store_inspection_templates tpl ON tpl.id = t.template_id
        LEFT JOIN kds_users ku ON ku.id = t.completed_by
        WHERE t.id = ?
    ");
    $stmt->execute([$task_id]);
    $task = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$task) {
        json_error('任务不存在', 404);
    }

    // 获取照片
    $stmt = $pdo->prepare("
        SELECT
            p.*,
            ku.display_name as uploaded_by_name
        FROM store_inspection_photos p
        LEFT JOIN kds_users ku ON ku.id = p.uploaded_by
        WHERE p.task_id = ?
        ORDER BY p.uploaded_at
    ");
    $stmt->execute([$task_id]);
    $task['photos'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // 解析 validation_flags JSON
    foreach ($task['photos'] as &$photo) {
        if ($photo['validation_flags']) {
            $photo['validation_flags'] = json_decode($photo['validation_flags'], true);
        }
    }

    json_ok($task, '任务详情');
}

/**
 * 手动生成当期任务
 */
function handle_inspection_generate_tasks(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);
    $frequency_type = $data['frequency_type'] ?? 'monthly';

    $now = new DateTime();
    $generatedCount = generateInspectionTasks($pdo, $frequency_type, $now);

    json_ok(['generated' => $generatedCount], "已生成 {$generatedCount} 个检查任务");
}

/**
 * 生成检查任务的核心函数
 */
function generateInspectionTasks(PDO $pdo, string $frequency_type, DateTime $now): int {
    // 计算周期
    switch ($frequency_type) {
        case 'weekly':
            $period_key = $now->format('Y-\\WW');
            $period_start = (clone $now)->modify('monday this week')->format('Y-m-d');
            // 根据 due_weekday 计算截止日期
            break;
        case 'yearly':
            $period_key = $now->format('Y');
            $period_start = $now->format('Y') . '-01-01';
            break;
        default: // monthly
            $period_key = $now->format('Y-m');
            $period_start = $now->format('Y-m') . '-01';
    }

    // 获取所有活跃的该周期类型模板
    $stmt = $pdo->prepare("
        SELECT * FROM store_inspection_templates
        WHERE frequency_type = ? AND is_active = 1
    ");
    $stmt->execute([$frequency_type]);
    $templates = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // 获取所有活跃门店
    $stores = $pdo->query("SELECT id FROM kds_stores WHERE deleted_at IS NULL")->fetchAll(PDO::FETCH_COLUMN);

    $generatedCount = 0;

    foreach ($templates as $tpl) {
        // 计算该模板的截止日期
        switch ($frequency_type) {
            case 'weekly':
                $due_weekday = (int)$tpl['due_weekday'];
                $period_end_dt = (clone $now)->modify('monday this week');
                $period_end_dt->modify('+' . ($due_weekday - 1) . ' days');
                $period_end = $period_end_dt->format('Y-m-d');
                break;
            case 'yearly':
                $due_month = (int)$tpl['due_month'];
                $due_day = min((int)$tpl['due_day'], 28);
                $period_end = $now->format('Y') . '-' . str_pad($due_month, 2, '0', STR_PAD_LEFT) . '-' . str_pad($due_day, 2, '0', STR_PAD_LEFT);
                break;
            default: // monthly
                $due_day = (int)$tpl['due_day'];
                $last_day = (int)$now->format('t');
                $due_day = min($due_day, $last_day);
                $period_end = $now->format('Y-m') . '-' . str_pad($due_day, 2, '0', STR_PAD_LEFT);
        }

        // 确定适用门店
        if ($tpl['apply_to_all']) {
            $applicable_stores = $stores;
        } else {
            $stmt = $pdo->prepare("SELECT store_id FROM store_inspection_template_stores WHERE template_id = ?");
            $stmt->execute([$tpl['id']]);
            $applicable_stores = $stmt->fetchAll(PDO::FETCH_COLUMN);
        }

        // 为每个门店生成任务
        $stmt_check = $pdo->prepare("
            SELECT id FROM store_inspection_tasks
            WHERE store_id = ? AND template_id = ? AND period_key = ?
        ");
        $stmt_insert = $pdo->prepare("
            INSERT INTO store_inspection_tasks
            (store_id, template_id, period_key, period_start, period_end)
            VALUES (?, ?, ?, ?, ?)
        ");

        foreach ($applicable_stores as $store_id) {
            $stmt_check->execute([$store_id, $tpl['id'], $period_key]);
            if (!$stmt_check->fetch()) {
                $stmt_insert->execute([$store_id, $tpl['id'], $period_key, $period_start, $period_end]);
                $generatedCount++;
            }
        }
    }

    return $generatedCount;
}


/**
 * 删除检查照片（HQ管理员操作）
 */
function handle_inspection_delete_photo(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);
    $photo_id = (int)($data['photo_id'] ?? 0);

    if ($photo_id <= 0) {
        json_error('缺少照片ID', 400);
    }

    // 查找照片记录
    $stmt = $pdo->prepare("SELECT p.*, t.store_id FROM store_inspection_photos p JOIN store_inspection_tasks t ON t.id = p.task_id WHERE p.id = ?");
    $stmt->execute([$photo_id]);
    $photo = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$photo) {
        json_error('照片不存在', 404);
    }

    // 删除物理文件
    $storeRoot = realpath(__DIR__ . '/../../../../store/store_html');
    if ($storeRoot && !empty($photo['photo_path'])) {
        $filePath = $storeRoot . '/store_images/inspections/' . $photo['photo_path'];
        if (file_exists($filePath)) {
            unlink($filePath);
        }
    }

    // 删除数据库记录
    $stmt = $pdo->prepare("DELETE FROM store_inspection_photos WHERE id = ?");
    $stmt->execute([$photo_id]);

    json_ok(null, '照片已删除');
}

/**
 * 退回检查任务（已完成 → 待完成）
 */
function handle_inspection_reject_task(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);
    $task_id = (int)($data['task_id'] ?? 0);
    $reason = trim($data['reason'] ?? '');

    if ($task_id <= 0) {
        json_error('缺少任务ID', 400);
    }

    // 检查任务是否存在且已完成
    $stmt = $pdo->prepare("SELECT * FROM store_inspection_tasks WHERE id = ?");
    $stmt->execute([$task_id]);
    $task = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$task) {
        json_error('任务不存在', 404);
    }
    if ($task['status'] !== 'completed') {
        json_error('只能退回已完成的任务', 400);
    }

    $pdo->beginTransaction();
    try {
        // 获取该任务的照片路径，删除物理文件
        $stmt = $pdo->prepare("SELECT photo_path FROM store_inspection_photos WHERE task_id = ?");
        $stmt->execute([$task_id]);
        $photos = $stmt->fetchAll(PDO::FETCH_COLUMN);

        $storeRoot = realpath(__DIR__ . '/../../../../store/store_html');
        if ($storeRoot) {
            foreach ($photos as $photoPath) {
                if (!empty($photoPath)) {
                    $filePath = $storeRoot . '/store_images/inspections/' . $photoPath;
                    if (file_exists($filePath)) {
                        unlink($filePath);
                    }
                }
            }
        }

        // 删除该任务所有照片记录
        $stmt = $pdo->prepare("DELETE FROM store_inspection_photos WHERE task_id = ?");
        $stmt->execute([$task_id]);

        // 重置任务状态
        $notes = $reason ? "[退回] {$reason}" : null;
        $stmt = $pdo->prepare("
            UPDATE store_inspection_tasks
            SET status = 'pending',
                completed_at = NULL,
                completed_by = NULL,
                notes = ?
            WHERE id = ?
        ");
        $stmt->execute([$notes, $task_id]);

        $pdo->commit();
        json_ok(null, '任务已退回，门店需重新完成检查');
    } catch (Exception $e) {
        $pdo->rollBack();
        json_error('退回失败: ' . $e->getMessage(), 500);
    }
}


/* ============================================================
   注册表
   ============================================================ */

return [

    // 检查模板管理
    'inspection_templates' => [
        'table' => 'store_inspection_templates',
        'pk' => 'id',
        'auth_role' => ROLE_ADMIN,
        'custom_actions' => [
            'get' => 'handle_inspection_template_get',
            'save' => 'handle_inspection_template_save',
            'delete' => 'handle_inspection_template_delete',
        ],
    ],

    // 检查报表
    'inspection_report' => [
        'table' => 'store_inspection_tasks',
        'pk' => 'id',
        'auth_role' => ROLE_ADMIN,
        'custom_actions' => [
            'get' => 'handle_inspection_report_get',
            'task_detail' => 'handle_inspection_task_detail',
            'generate_tasks' => 'handle_inspection_generate_tasks',
            'delete_photo' => 'handle_inspection_delete_photo',
            'reject_task' => 'handle_inspection_reject_task',
        ],
    ],

];
