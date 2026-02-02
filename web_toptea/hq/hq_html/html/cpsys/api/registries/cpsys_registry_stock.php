<?php
/**
 * Toptea HQ - CPSYS API 注册表 (Stock Management)
 * 门店库存管理、入库码功能
 * Version: 1.0
 * Date: 2026-01-26
 */

require_once realpath(__DIR__ . '/../../../../app/helpers/kds_helper.php');
require_once realpath(__DIR__ . '/../../../../app/helpers/auth_helper.php');

/* ============================================================
   门店库存 Handlers
   ============================================================ */

/**
 * 获取门店库存列表
 */
function handle_store_stock_get(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_GET['store_id'] ?? 0);

    if ($store_id <= 0) {
        // 获取所有门店库存汇总
        $sql = "SELECT
                    ss.store_id,
                    s.store_code,
                    s.store_name,
                    COUNT(DISTINCT ss.material_id) as material_count,
                    MAX(ss.last_updated_at) as last_update
                FROM expsys_store_stock ss
                JOIN kds_stores s ON s.id = ss.store_id AND s.deleted_at IS NULL
                GROUP BY ss.store_id
                ORDER BY s.store_code";
        $stmt = $pdo->query($sql);
        json_ok($stmt->fetchAll(PDO::FETCH_ASSOC), '门店库存汇总');
    } else {
        // 获取指定门店的库存明细
        $sql = "SELECT
                    ss.material_id,
                    m.material_code,
                    COALESCE(mt.material_name, CONCAT('M', m.material_code)) as material_name,
                    ss.quantity,
                    u.unit_code as base_unit_code,
                    COALESCE(ut.unit_name, u.unit_code) as base_unit_name,
                    ss.last_updated_at
                FROM expsys_store_stock ss
                JOIN kds_materials m ON m.id = ss.material_id AND m.deleted_at IS NULL
                LEFT JOIN kds_material_translations mt ON mt.material_id = m.id AND mt.language_code = 'zh-CN'
                LEFT JOIN kds_units u ON u.id = m.base_unit_id
                LEFT JOIN kds_unit_translations ut ON ut.unit_id = u.id AND ut.language_code = 'zh-CN'
                WHERE ss.store_id = :store_id
                ORDER BY m.material_code";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':store_id' => $store_id]);
        json_ok($stmt->fetchAll(PDO::FETCH_ASSOC), '门店库存明细');
    }
}

/**
 * 手动调整门店库存
 */
function handle_store_stock_adjust(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);

    $store_id = (int)($data['store_id'] ?? 0);
    $material_id = (int)($data['material_id'] ?? 0);
    $adjust_quantity = (float)($data['quantity'] ?? 0);
    $reason = trim($data['reason'] ?? '');

    if ($store_id <= 0 || $material_id <= 0) {
        json_error('门店ID和物料ID不能为空', 400);
    }

    $pdo->beginTransaction();
    try {
        // 更新库存
        $sql = "INSERT INTO expsys_store_stock (store_id, material_id, quantity)
                VALUES (:store_id, :material_id, :quantity)
                ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':store_id' => $store_id,
            ':material_id' => $material_id,
            ':quantity' => $adjust_quantity
        ]);

        $pdo->commit();
        json_ok(null, '库存调整成功');
    } catch (Exception $e) {
        $pdo->rollBack();
        json_error('库存调整失败: ' . $e->getMessage(), 500);
    }
}


/* ============================================================
   入库码 Handlers
   ============================================================ */

/**
 * 获取入库日志列表
 */
function handle_import_log_get(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_GET['store_id'] ?? 0);
    $limit = min((int)($_GET['limit'] ?? 50), 200);
    $offset = (int)($_GET['offset'] ?? 0);

    $where = '';
    $params = [];

    if ($store_id > 0) {
        $where = 'WHERE il.store_id = :store_id';
        $params[':store_id'] = $store_id;
    }

    $sql = "SELECT
                il.id,
                il.store_id,
                s.store_code,
                s.store_name,
                il.mrs_reference,
                il.shipment_date,
                il.items_count,
                il.imported_at,
                il.import_source,
                ku.display_name as imported_by_name
            FROM stock_import_logs il
            JOIN kds_stores s ON s.id = il.store_id
            LEFT JOIN kds_users ku ON ku.id = il.imported_by
            {$where}
            ORDER BY il.imported_at DESC
            LIMIT {$limit} OFFSET {$offset}";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    json_ok($stmt->fetchAll(PDO::FETCH_ASSOC), '入库日志列表');
}

/**
 * 获取入库日志详情
 */
function handle_import_log_detail(PDO $pdo, array $config, array $input_data): void {
    $log_id = (int)($_GET['id'] ?? 0);

    if ($log_id <= 0) {
        json_error('缺少入库日志ID', 400);
    }

    // 获取日志主信息
    $sql = "SELECT
                il.*,
                s.store_code,
                s.store_name
            FROM stock_import_logs il
            JOIN kds_stores s ON s.id = il.store_id
            WHERE il.id = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([':id' => $log_id]);
    $log = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$log) {
        json_error('入库日志不存在', 404);
    }

    // 获取明细
    $sql = "SELECT
                d.id,
                d.material_id,
                m.material_code,
                COALESCE(mt.material_name, CONCAT('M', m.material_code)) as material_name,
                d.quantity,
                d.unit_id,
                COALESCE(ut.unit_name, u.unit_code) as unit_name,
                d.batch_code,
                d.shelf_life_date
            FROM stock_import_details d
            JOIN kds_materials m ON m.id = d.material_id
            LEFT JOIN kds_material_translations mt ON mt.material_id = m.id AND mt.language_code = 'zh-CN'
            LEFT JOIN kds_units u ON u.id = d.unit_id
            LEFT JOIN kds_unit_translations ut ON ut.unit_id = u.id AND ut.language_code = 'zh-CN'
            WHERE d.import_log_id = :log_id
            ORDER BY d.id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([':log_id' => $log_id]);
    $log['details'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

    json_ok($log, '入库日志详情');
}

/**
 * 解析入库码（预览）
 */
function handle_import_code_parse(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);
    $import_code = trim($data['import_code'] ?? '');
    $current_store_id = (int)($data['store_id'] ?? 0);

    if (empty($import_code)) {
        json_error('入库码不能为空', 400);
    }

    // 1. Base64解码
    $decoded = base64_decode($import_code, true);
    if ($decoded === false) {
        json_error('入库码格式错误：无法解码', 400);
    }

    // 2. JSON解析
    $payload = json_decode($decoded, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        json_error('入库码格式错误：JSON无效', 400);
    }

    // 3. 验证必要字段
    $required = ['v', 'store', 'ref', 'date', 'items', 'checksum'];
    foreach ($required as $field) {
        if (!isset($payload[$field])) {
            json_error("入库码格式错误：缺少字段 {$field}", 400);
        }
    }

    // 4. 验证校验码
    $checksum_data = $payload;
    unset($checksum_data['checksum']);
    $expected_checksum = substr(hash('sha256', json_encode($checksum_data)), 0, 8);
    if ($payload['checksum'] !== $expected_checksum) {
        json_error('入库码校验失败：数据可能被篡改', 400);
    }

    // 5. 验证门店
    $store_code = $payload['store'];
    $stmt = $pdo->prepare("SELECT id, store_code, store_name FROM kds_stores WHERE store_code = ? AND deleted_at IS NULL");
    $stmt->execute([$store_code]);
    $store = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$store) {
        json_error("入库码错误：门店代码 {$store_code} 不存在", 400);
    }

    if ($current_store_id > 0 && $store['id'] != $current_store_id) {
        json_error("入库码错误：此入库码是给门店 {$store_code} 的，与当前门店不匹配", 400);
    }

    // 6. 检查是否已导入
    $code_hash = hash('sha256', $import_code);
    $stmt = $pdo->prepare("SELECT id, imported_at FROM stock_import_logs WHERE import_code_hash = ?");
    $stmt->execute([$code_hash]);
    $existing = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($existing) {
        json_error("此入库码已于 {$existing['imported_at']} 导入过，不能重复使用", 400);
    }

    // 7. 解析物料明细
    $items = [];
    $errors = [];

    foreach ($payload['items'] as $idx => $item) {
        $material_code = $item['code'] ?? '';

        // 查询物料
        $stmt = $pdo->prepare("
            SELECT m.id, m.material_code, m.base_unit_id, m.is_active,
                   COALESCE(mt.material_name, CONCAT('M', m.material_code)) as material_name
            FROM kds_materials m
            LEFT JOIN kds_material_translations mt ON mt.material_id = m.id AND mt.language_code = 'zh-CN'
            WHERE m.material_code = ? AND m.deleted_at IS NULL
        ");
        $stmt->execute([$material_code]);
        $material = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$material) {
            $errors[] = "第" . ($idx + 1) . "项：物料代码 {$material_code} 不存在";
            continue;
        }

        // 验证物料是否上架 (is_active)
        if (isset($material['is_active']) && $material['is_active'] == 0) {
            $errors[] = "第" . ($idx + 1) . "项：物料 {$material_code} ({$material['material_name']}) 已下架，禁止入库";
            continue;
        }

        // 查询单位
        $unit_code = $item['unit'] ?? '';
        $stmt = $pdo->prepare("
            SELECT u.id, u.unit_code, COALESCE(ut.unit_name, u.unit_code) as unit_name
            FROM kds_units u
            LEFT JOIN kds_unit_translations ut ON ut.unit_id = u.id AND ut.language_code = 'zh-CN'
            WHERE u.unit_code = ? AND u.deleted_at IS NULL
        ");
        $stmt->execute([$unit_code]);
        $unit = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$unit) {
            $errors[] = "第" . ($idx + 1) . "项：单位代码 {$unit_code} 不存在";
            continue;
        }

        $items[] = [
            'material_id' => $material['id'],
            'material_code' => $material['material_code'],
            'material_name' => $material['material_name'],
            'quantity' => (float)$item['qty'],
            'unit_id' => $unit['id'],
            'unit_code' => $unit['unit_code'],
            'unit_name' => $unit['unit_name'],
            'batch_code' => $item['batch'] ?? null,
            'shelf_life_date' => $item['shelf'] ?? null,
        ];
    }

    if (!empty($errors)) {
        json_error(implode("\n", $errors), 400);
    }

    // 返回解析结果
    json_ok([
        'store_id' => $store['id'],
        'store_code' => $store['store_code'],
        'store_name' => $store['store_name'],
        'mrs_reference' => $payload['ref'],
        'shipment_date' => $payload['date'],
        'items' => $items,
        'code_hash' => $code_hash,
        'raw_code' => $import_code,
    ], '入库码解析成功');
}

/**
 * 执行入库
 */
function handle_import_code_execute(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);

    $store_id = (int)($data['store_id'] ?? 0);
    $mrs_reference = $data['mrs_reference'] ?? '';
    $shipment_date = $data['shipment_date'] ?? '';
    $items = $data['items'] ?? [];
    $code_hash = $data['code_hash'] ?? '';
    $raw_code = $data['raw_code'] ?? '';
    $operator_id = (int)($data['operator_id'] ?? 0);
    $import_source = $data['import_source'] ?? 'HQ';

    if ($store_id <= 0 || empty($items) || empty($code_hash)) {
        json_error('参数不完整', 400);
    }

    // 再次检查是否已导入
    $stmt = $pdo->prepare("SELECT id FROM stock_import_logs WHERE import_code_hash = ?");
    $stmt->execute([$code_hash]);
    if ($stmt->fetch()) {
        json_error('此入库码已导入过，不能重复使用', 400);
    }

    $pdo->beginTransaction();
    try {
        // 1. 插入入库日志
        $stmt = $pdo->prepare("
            INSERT INTO stock_import_logs
            (store_id, import_code_hash, mrs_reference, shipment_date, items_count, raw_code, imported_by, import_source)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([
            $store_id, $code_hash, $mrs_reference, $shipment_date,
            count($items), $raw_code, $operator_id ?: null, $import_source
        ]);
        $log_id = $pdo->lastInsertId();

        // 2. 插入入库明细 & 更新库存
        $stmt_detail = $pdo->prepare("
            INSERT INTO stock_import_details
            (import_log_id, material_id, quantity, unit_id, batch_code, shelf_life_date)
            VALUES (?, ?, ?, ?, ?, ?)
        ");

        $stmt_stock = $pdo->prepare("
            INSERT INTO expsys_store_stock (store_id, material_id, quantity)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)
        ");

        foreach ($items as $item) {
            // 入库明细
            $stmt_detail->execute([
                $log_id,
                $item['material_id'],
                $item['quantity'],
                $item['unit_id'],
                $item['batch_code'] ?? null,
                $item['shelf_life_date'] ?? null,
            ]);

            // 更新库存
            $stmt_stock->execute([
                $store_id,
                $item['material_id'],
                $item['quantity'],
            ]);
        }

        $pdo->commit();
        json_ok(['import_log_id' => $log_id], '入库成功！共入库 ' . count($items) . ' 种物料');

    } catch (Exception $e) {
        $pdo->rollBack();
        json_error('入库失败: ' . $e->getMessage(), 500);
    }
}


/* ============================================================
   打印模板 Handlers
   ============================================================ */

/**
 * 获取打印模板
 */
function handle_print_template_get(PDO $pdo, array $config, array $input_data): void {
    $id = $_GET['id'] ?? null;
    $code = $_GET['code'] ?? null;

    if ($id) {
        $stmt = $pdo->prepare("SELECT * FROM kds_print_templates WHERE id = ?");
        $stmt->execute([(int)$id]);
    } elseif ($code) {
        $stmt = $pdo->prepare("SELECT * FROM kds_print_templates WHERE template_code = ?");
        $stmt->execute([$code]);
    } else {
        // 获取所有模板列表
        $stmt = $pdo->query("SELECT id, template_code, template_name, template_type, paper_width, paper_height, is_active, updated_at FROM kds_print_templates ORDER BY template_code");
        json_ok($stmt->fetchAll(PDO::FETCH_ASSOC), '打印模板列表');
        return;
    }

    $template = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$template) {
        json_error('模板不存在', 404);
    }

    // 解码JSON字段
    if (isset($template['template_content'])) {
        $template['template_content'] = json_decode($template['template_content'], true);
    }

    json_ok($template, '打印模板详情');
}

/**
 * 保存打印模板
 */
function handle_print_template_save(PDO $pdo, array $config, array $input_data): void {
    $data = $input_data['data'] ?? json_error('缺少 data', 400);

    $id = !empty($data['id']) ? (int)$data['id'] : null;
    $template_code = trim($data['template_code'] ?? '');
    $template_name = trim($data['template_name'] ?? '');
    $template_type = $data['template_type'] ?? 'TSPL';
    $paper_width = (int)($data['paper_width'] ?? 40);
    $paper_height = (int)($data['paper_height'] ?? 30);
    $template_content = $data['template_content'] ?? [];
    $description = trim($data['description'] ?? '');
    $is_active = (int)($data['is_active'] ?? 1);

    if (empty($template_code) || empty($template_name)) {
        json_error('模板代码和名称不能为空', 400);
    }

    // 编码JSON
    $content_json = json_encode($template_content, JSON_UNESCAPED_UNICODE);

    if ($id) {
        // 更新
        $stmt = $pdo->prepare("
            UPDATE kds_print_templates SET
                template_code = ?,
                template_name = ?,
                template_type = ?,
                paper_width = ?,
                paper_height = ?,
                template_content = ?,
                description = ?,
                is_active = ?
            WHERE id = ?
        ");
        $stmt->execute([$template_code, $template_name, $template_type, $paper_width, $paper_height, $content_json, $description, $is_active, $id]);
        json_ok(['id' => $id], '模板更新成功');
    } else {
        // 新增
        $stmt = $pdo->prepare("
            INSERT INTO kds_print_templates
            (template_code, template_name, template_type, paper_width, paper_height, template_content, description, is_active)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([$template_code, $template_name, $template_type, $paper_width, $paper_height, $content_json, $description, $is_active]);
        json_ok(['id' => $pdo->lastInsertId()], '模板创建成功');
    }
}

/**
 * 删除打印模板
 */
function handle_print_template_delete(PDO $pdo, array $config, array $input_data): void {
    $id = (int)($_GET['id'] ?? $input_data['data']['id'] ?? 0);

    if ($id <= 0) {
        json_error('缺少模板ID', 400);
    }

    $stmt = $pdo->prepare("DELETE FROM kds_print_templates WHERE id = ?");
    $stmt->execute([$id]);

    if ($stmt->rowCount() > 0) {
        json_ok(null, '模板删除成功');
    } else {
        json_error('模板不存在', 404);
    }
}


/* ============================================================
   注册表
   ============================================================ */

return [

    // 门店库存
    'store_stock' => [
        'table' => 'expsys_store_stock',
        'pk' => null, // 复合主键
        'auth_role' => ROLE_ADMIN,
        'custom_actions' => [
            'get' => 'handle_store_stock_get',
            'adjust' => 'handle_store_stock_adjust',
        ],
    ],

    // 入库日志
    'import_logs' => [
        'table' => 'stock_import_logs',
        'pk' => 'id',
        'auth_role' => ROLE_ADMIN,
        'custom_actions' => [
            'get' => 'handle_import_log_get',
            'detail' => 'handle_import_log_detail',
        ],
    ],

    // 入库码
    'import_code' => [
        'table' => 'stock_import_logs', // 占位
        'auth_role' => ROLE_ADMIN,
        'custom_actions' => [
            'parse' => 'handle_import_code_parse',
            'execute' => 'handle_import_code_execute',
        ],
    ],

    // 打印模板
    'print_templates' => [
        'table' => 'kds_print_templates',
        'pk' => 'id',
        'auth_role' => ROLE_SUPER_ADMIN,
        'custom_actions' => [
            'get' => 'handle_print_template_get',
            'save' => 'handle_print_template_save',
            'delete' => 'handle_print_template_delete',
        ],
    ],

];
