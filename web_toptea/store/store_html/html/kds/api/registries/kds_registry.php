<?php
/**
 * Toptea Store - KDS 统一 API 注册表
 * 迁移所有 store/html/kds/api/ 的逻辑
 * Version: 1.0.0 (Pre-Phase 3 Migration)
 * Date: 2025-11-08
 *
 * [A2 UTC SYNC]: Modified handle_kds_expiry_record to use utc_now().
 *
 * [GEMINI SUPER-ENGINEER FIX (Error 2)]
 * 1. KDS 布局 (main.php) 需要加载打印模板。为遵循“禁止跨平台调用”的规则，KDS API 必须能自己提供模板。
 * 2. 从 pos_registry.php 复制了 handle_print_get_templates 函数。
 * 3. 修改了此函数，使其使用 KDS 的会话变量 ($_SESSION['kds_store_id'])。
 * 4. 添加了新的 'print' 资源到注册表。
 */

// 1. 加载所有 KDS 业务逻辑函数 (来自 kds_repo.php)
require_once realpath(__DIR__ . '/../../../../kds_backend/helpers/kds_helper.php');

// 2. 定义门店端角色常量 (必须与 kds_api_core.php 一致)
if (!defined('ROLE_STORE_MANAGER')) {
    define('ROLE_STORE_MANAGER', 'manager');
}
if (!defined('ROLE_STORE_USER')) {
    define('ROLE_STORE_USER', 'staff');
}

/* -------------------------------------------------------------------------- */
/* Handlers: KDS打印模板 (效期标签)
/* [2026-01-26 后台重构] 使用新的 kds_print_templates 表         */
/* -------------------------------------------------------------------------- */
function handle_print_get_templates(PDO $pdo, array $config, array $input_data): void {
    // [2026-01-27 FIX] 修正SQL查询以匹配实际表结构
    // kds_print_templates 表使用 template_code 作为模板标识，
    // paper_width/paper_height 作为尺寸，没有 store_id 字段
    $stmt = $pdo->prepare(
        "SELECT template_code, template_content, paper_width, paper_height
         FROM kds_print_templates
         WHERE is_active = 1"
    );
    $stmt->execute();
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $templates = [];
    foreach ($results as $row) {
        $code = $row['template_code'];
        if (!isset($templates[$code])) {
            $templates[$code] = [
                'content' => json_decode($row['template_content'], true),
                'size' => $row['paper_width'] . 'x' . $row['paper_height']
            ];
        }
    }
    json_ok($templates, 'Templates loaded.');
}


/* -------------------------------------------------------------------------- */
/* Handlers: 迁移自 /kds/api/sop_handler.php*/
/* -------------------------------------------------------------------------- */
function handle_kds_sop_get(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    // store_id 检查已在 kds_api_core.php 中完成
    
    $raw = $_GET['code'] ?? '';
    
    // 依赖: KdsSopParser (来自 kds_repo.php)
    $parser = new KdsSopParser($pdo, $store_id);
    $seg = $parser->parse($raw);

    if (!$seg || $seg['p'] === '') json_error('编码不合法或未匹配任何解析规则', 400);

    // 依赖: get_product (来自 kds_repo.php)
    $prod = get_product($pdo, $seg['p']);
    if (!$prod || $prod['deleted_at'] !== null || (int)$prod['is_active'] !== 1) {
        json_error('找不到该产品或未上架 (P-Code: ' . htmlspecialchars($seg['p']) . ')', 404);
    }
    $pid = (int)$prod['id'];

    // 依赖: get_product_info_bilingual (来自 kds_repo.php)
    $prod_info = array_merge(
        ['product_id' => $pid, 'product_code' => $prod['product_code']],
        get_product_info_bilingual($pdo, $pid, (int)$prod['status_id'])
    );
    
    if ($seg['ord'] !== null) {
        $prod_info['order_uuid'] = $seg['ord'];
    }

    // (P-Code ONLY) 仅查询基础信息
    if ($seg['a'] === null && $seg['m'] === null && $seg['t'] === null) {
        json_ok([
            'type' => 'base_info',
            'product' => $prod_info,
            'recipe' => get_base_recipe_bilingual($pdo, $pid), // 依赖 (来自 kds_repo.php)
            'options' => get_available_options($pdo, $pid) // 依赖 (来自 kds_repo.php)
        ]);
    }

    // (P-A-M-T) 动态计算配方

    // 依赖: id_by_code (来自 kds_repo.php)
    $cup_id = id_by_code($pdo, 'kds_cups', 'cup_code', $seg['a']);
    if ($seg['a'] !== null && $cup_id === null) json_error('杯型编码 (A-code) 无效: ' . htmlspecialchars($seg['a']), 404);
    
    $ice_id = id_by_code($pdo, 'kds_ice_options', 'ice_code', $seg['m']);
    if ($seg['m'] !== null && $ice_id === null) json_error('冰量编码 (M-code) 无效: ' . htmlspecialchars($seg['m']), 404);

    $sweet_id = id_by_code($pdo, 'kds_sweetness_options', 'sweetness_code', $seg['t']);
    if ($seg['t'] !== null && $sweet_id === null) json_error('甜度编码 (T-code) 无效: ' . htmlspecialchars($seg['t']), 404);

    try {
        // 依赖: check_gating (来自 kds_repo.php)
        check_gating($pdo, $pid, $cup_id, $ice_id, $sweet_id);
    } catch (Exception $e) {
        json_error($e->getMessage(), 403, ['code' => $e->getCode()]);
    }

    // 依赖: get_base_recipe (来自 kds_repo.php)
    $recipe_map = get_base_recipe($pdo, $pid);
    if (empty($recipe_map)) json_error('产品 (P-Code: ' . htmlspecialchars($seg['p']) . ') 缺少基础配方 (L1)，无法计算。', 404);

    // 依赖: apply_global_rules (来自 kds_repo.php)
    $recipe_map = apply_global_rules($pdo, $recipe_map, $cup_id, $ice_id, $sweet_id);
    // 依赖: apply_overrides (来自 kds_repo.php)
    $recipe_map = apply_overrides($pdo, $pid, $recipe_map, $cup_id, $ice_id, $sweet_id);

    $final_recipe = [];
    foreach ($recipe_map as $item) {
        if ($item['quantity'] <= 0) continue; 
        // 依赖: m_details, u_name, norm_cat (来自 kds_repo.php)
        $m_details = m_details($pdo, (int)$item['material_id']);
        $u_names = u_name($pdo, (int)$item['unit_id']);
        $final_recipe[] = [
            'material_zh'   => $m_details['zh'],
            'material_es'   => $m_details['es'],
            'image_url'     => $m_details['image_url'],
            'unit_zh'       => $u_names['zh'],
            'unit_es'       => $u_names['es'],
            'quantity'      => (float)$item['quantity'],
            'step_category' => norm_cat((string)$item['step_category'])
        ];
    }
    
    // 依赖: get_cup_names_bilingual, etc. (来自 kds_repo.php)
    $names = array_merge(
        get_cup_names_bilingual($pdo, $cup_id),
        get_ice_names_bilingual($pdo, $ice_id),
        get_sweet_names_bilingual($pdo, $sweet_id)
    );
    $prod_info = array_merge($prod_info, $names);

    json_ok([
        'type' => 'adjusted_recipe',
        'product' => $prod_info,
        'recipe' => $final_recipe
    ]);
}

/* -------------------------------------------------------------------------- */
/* Handlers: 迁移自 /kds/api/record_expiry_item.php*/
/* -------------------------------------------------------------------------- */
function handle_kds_expiry_record(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)$_SESSION['kds_store_id'];
    $user_id = (int)$_SESSION['kds_user_id'];
    $operator_name = $_SESSION['kds_display_name'] ?? 'KDS User';
    
    $material_id = (int)($input_data['material_id'] ?? 0);
    if ($material_id <= 0) json_error('无效的物料ID。', 400);

    // 依赖: getMaterialById (来自 kds_repo.php)
    $material = getMaterialById($pdo, $material_id);
    if (!$material || empty($material['expiry_rule_type'])) {
        json_error('找不到该物料或该物料未设置效期规则。', 404);
    }

    // [A2 UTC SYNC] 依赖 datetime_helper.php
    $tz = new DateTimeZone(APP_DEFAULT_TIMEZONE);
    $opened_at_utc = utc_now();
    $opened_at_local_dt = (clone $opened_at_utc)->setTimezone($tz); // 转换为本地时间以便计算
    $expires_at_local_dt = clone $opened_at_local_dt;
    // [A2 UTC SYNC] END
    
    $time_left_text = 'N/A';

    switch ($material['expiry_rule_type']) {
        case 'HOURS':
            $duration = (int)$material['expiry_duration'];
            $expires_at_local_dt->add(new DateInterval('PT' . $duration . 'H'));
            $time_left_text = $duration . '小时';
            break;
        case 'DAYS':
            $duration = (int)$material['expiry_duration'];
            $expires_at_local_dt->add(new DateInterval('P' . $duration . 'D'));
            $time_left_text = $duration . '天';
            break;
        case 'END_OF_DAY':
            $expires_at_local_dt->setTime(23, 59, 59);
            $time_left_text = '至当日结束';
            break;
    }

    // [A2 UTC SYNC] 将计算后的本地过期时间转回 UTC 存入数据库
    $expires_at_utc = (clone $expires_at_local_dt)->setTimezone(new DateTimeZone('UTC'));

    $pdo->beginTransaction();
    $stmt_expiry = $pdo->prepare(
        "INSERT INTO kds_material_expiries (material_id, store_id, opened_at, expires_at, status) VALUES (?, ?, ?, ?, 'ACTIVE')"
    );
    $stmt_expiry->execute([
        $material_id, $store_id,
        $opened_at_utc->format('Y-m-d H:i:s'), // 存 UTC
        $expires_at_utc->format('Y-m-d H:i:s')  // 存 UTC
    ]);
    $pdo->commit();

    // [A2 UTC SYNC] 打印数据使用本地时间
    $print_data = [
        'material_name' => $material['name_zh'] ?? 'N/A',
        'material_name_es' => $material['name_es'] ?? ($material['name_zh'] ?? 'N/A'),
        'opened_at_time' => $opened_at_local_dt->format('Y-m-d H:i'),
        'expires_at_time' => $expires_at_local_dt->format('Y-m-d H:i'),
        'time_left' => $time_left_text,
        'operator_name' => $operator_name
    ];

    json_ok('效期记录已生成。', ['print_data' => $print_data]);
}

/* -------------------------------------------------------------------------- */
/* Handlers: 迁移自 /kds/api/get_preppable_materials.php*/
/* -------------------------------------------------------------------------- */
function handle_kds_get_preppable(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)$_SESSION['kds_store_id'];
    $sql = "
        SELECT 
            m.id, m.material_type,
            mt.material_name AS name_zh,
            mt_es.material_name AS name_es
        FROM kds_materials m
        LEFT JOIN kds_material_translations mt ON m.id = mt.material_id AND mt.language_code = 'zh-CN'
        LEFT JOIN kds_material_translations mt_es ON m.id = mt_es.material_id AND mt_es.language_code = 'es-ES'
        WHERE m.deleted_at IS NULL
          AND m.expiry_rule_type IS NOT NULL
        ORDER BY m.material_code ASC
    ";
    
    $stmt = $pdo->query($sql);
    if ($stmt === false) json_error("SQL query failed to execute.", 500);
    
    $all_materials = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $response_data = ['packaged_goods' => [], 'in_store_preps' => []];

    foreach ($all_materials as $material) {
        if ($material['material_type'] === 'PRODUCT' || $material['material_type'] === 'RAW') {
            $response_data['packaged_goods'][] = $material;
        } 
        elseif ($material['material_type'] === 'SEMI_FINISHED') {
            $response_data['in_store_preps'][] = $material;
        }
    }
    json_ok($response_data);
}

/* -------------------------------------------------------------------------- */
/* Handlers: 迁移自 /kds/api/get_kds_expiry_items.php*/
/* -------------------------------------------------------------------------- */
function handle_kds_get_expiry_items(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)$_SESSION['kds_store_id'];
    // [A2 UTC SYNC] opened_at 和 expires_at 已经是 UTC，无需转换
    $sql = "
        SELECT 
            e.id, e.batch_code, e.opened_at, e.expires_at,
            mt_zh.material_name AS name_zh,
            mt_es.material_name AS name_es
        FROM kds_material_expiries e
        JOIN kds_material_translations mt_zh ON e.material_id = mt_zh.material_id AND mt_zh.language_code = 'zh-CN'
        JOIN kds_material_translations mt_es ON e.material_id = mt_es.material_id AND mt_es.language_code = 'es-ES'
        WHERE e.store_id = ? AND e.status = 'ACTIVE'
        ORDER BY e.expires_at ASC
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$store_id]);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
    json_ok($items);
}

/* -------------------------------------------------------------------------- */
/* Handlers: 迁移自 /kds/api/update_expiry_status.php*/
/* -------------------------------------------------------------------------- */
function handle_kds_update_expiry_status(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)$_SESSION['kds_store_id'];
    $handler_id = (int)$_SESSION['kds_user_id'];
    
    $item_id = (int)($input_data['item_id'] ?? 0);
    $new_status = (string)($input_data['status'] ?? '');

    if ($item_id <= 0 || !in_array($new_status, ['USED', 'DISCARDED'])) {
        json_error('无效的项目ID或状态。', 400);
    }

    // [A2 UTC SYNC] 使用 handled_at = utc_now()
    $now_utc_str = utc_now()->format('Y-m-d H:i:s');

    $pdo->beginTransaction();
    $stmt = $pdo->prepare(
        "UPDATE kds_material_expiries SET status = ?, handler_id = ?, handled_at = ? WHERE id = ? AND store_id = ? AND status = 'ACTIVE'"
    );
    $stmt->execute([$new_status, $handler_id, $now_utc_str, $item_id, $store_id]); // [A2 UTC SYNC]

    if ($stmt->rowCount() > 0) {
        $pdo->commit();
        json_ok(null, '状态更新成功。');
    } else {
        $pdo->rollBack();
        json_error('未找到项目、项目已被更新或不属于本店。', 404);
    }
}


/* -------------------------------------------------------------------------- */
/* Handlers: 库存入库码 (2026-01-26 后台重构)                                */
/* -------------------------------------------------------------------------- */

/**
 * 解析入库码
 */
function handle_kds_parse_import_code(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    if ($store_id === 0) json_error('无法确定门店ID。', 401);

    $import_code = trim($input_data['import_code'] ?? '');
    if (empty($import_code)) json_error('入库码不能为空', 400);

    // 1. Base64解码
    $decoded = base64_decode($import_code, true);
    if ($decoded === false) json_error('入库码格式错误：无法解码', 400);

    // 2. JSON解析
    $payload = json_decode($decoded, true);
    if (json_last_error() !== JSON_ERROR_NONE) json_error('入库码格式错误：JSON无效', 400);

    // 3. 验证必要字段
    $required = ['v', 'store', 'ref', 'date', 'items', 'checksum'];
    foreach ($required as $field) {
        if (!isset($payload[$field])) json_error("入库码格式错误：缺少字段 {$field}", 400);
    }

    // 4. 验证校验码
    $checksum_data = $payload;
    unset($checksum_data['checksum']);
    $expected_checksum = substr(hash('sha256', json_encode($checksum_data)), 0, 8);
    if ($payload['checksum'] !== $expected_checksum) json_error('入库码校验失败：数据可能被篡改', 400);

    // 5. 验证门店
    $store_code = $payload['store'];
    $stmt = $pdo->prepare("SELECT id, store_code, store_name FROM kds_stores WHERE id = ? AND deleted_at IS NULL");
    $stmt->execute([$store_id]);
    $store = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$store || $store['store_code'] !== $store_code) {
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

        $stmt = $pdo->prepare("
            SELECT m.id, m.material_code, m.base_unit_id,
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

    if (!empty($errors)) json_error(implode("\n", $errors), 400);

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
function handle_kds_execute_import(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    $user_id = (int)($_SESSION['kds_user_id'] ?? 0);

    $data_store_id = (int)($input_data['store_id'] ?? 0);
    $mrs_reference = $input_data['mrs_reference'] ?? '';
    $shipment_date = $input_data['shipment_date'] ?? '';
    $items = $input_data['items'] ?? [];
    $code_hash = $input_data['code_hash'] ?? '';
    $raw_code = $input_data['raw_code'] ?? '';

    if ($store_id !== $data_store_id) json_error('门店不匹配', 400);
    if (empty($items) || empty($code_hash)) json_error('参数不完整', 400);

    // 再次检查是否已导入
    $stmt = $pdo->prepare("SELECT id FROM stock_import_logs WHERE import_code_hash = ?");
    $stmt->execute([$code_hash]);
    if ($stmt->fetch()) json_error('此入库码已导入过', 400);

    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare("
            INSERT INTO stock_import_logs
            (store_id, import_code_hash, mrs_reference, shipment_date, items_count, raw_code, imported_by, import_source)
            VALUES (?, ?, ?, ?, ?, ?, ?, 'KDS')
        ");
        $stmt->execute([$store_id, $code_hash, $mrs_reference, $shipment_date, count($items), $raw_code, $user_id ?: null]);
        $log_id = $pdo->lastInsertId();

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
            $stmt_detail->execute([
                $log_id,
                $item['material_id'],
                $item['quantity'],
                $item['unit_id'],
                $item['batch_code'] ?? null,
                $item['shelf_life_date'] ?? null,
            ]);

            $stmt_stock->execute([$store_id, $item['material_id'], $item['quantity']]);
        }

        $pdo->commit();
        json_ok(['import_log_id' => $log_id], '入库成功！共入库 ' . count($items) . ' 种物料');

    } catch (Exception $e) {
        $pdo->rollBack();
        json_error('入库失败: ' . $e->getMessage(), 500);
    }
}

/**
 * 获取最近入库记录
 */
function handle_kds_recent_imports(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    $limit = min((int)($_GET['limit'] ?? 10), 50);

    $stmt = $pdo->prepare("
        SELECT id, mrs_reference, shipment_date, items_count, imported_at
        FROM stock_import_logs
        WHERE store_id = ?
        ORDER BY imported_at DESC
        LIMIT ?
    ");
    $stmt->execute([$store_id, $limit]);
    json_ok($stmt->fetchAll(PDO::FETCH_ASSOC), '最近入库记录');
}


/* -------------------------------------------------------------------------- */
/* Handlers: 门店检查系统 (2026-01-27)                                        */
/* -------------------------------------------------------------------------- */

/**
 * 获取门店检查任务
 */
function handle_kds_get_inspection_tasks(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    $user_role = $_SESSION['kds_role'] ?? '';

    // 只有店长可以查看检查任务
    if ($user_role !== 'manager') {
        json_error('只有店长可以查看检查任务', 403);
    }

    $period = $_GET['period'] ?? 'current';

    // 确保当期任务已生成
    if ($period === 'current') {
        ensureCurrentTasksExist($pdo, $store_id);
    }

    $now = new DateTime();

    if ($period === 'current') {
        // 获取当期任务（包括所有周期类型的当前周期）
        $sql = "
            SELECT
                t.id, t.template_id, t.period_key, t.period_start, t.period_end, t.status,
                t.completed_at, t.completed_by, t.notes,
                tpl.template_name, tpl.description as template_description, tpl.frequency_type, tpl.photo_hint,
                ku.display_name as completed_by_name,
                (SELECT COUNT(*) FROM store_inspection_photos WHERE task_id = t.id) as photo_count
            FROM store_inspection_tasks t
            JOIN store_inspection_templates tpl ON tpl.id = t.template_id
            LEFT JOIN kds_users ku ON ku.id = t.completed_by
            WHERE t.store_id = ?
              AND t.period_end >= ?
            ORDER BY t.status ASC, t.period_end ASC
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$store_id, $now->format('Y-m-d')]);
    } else {
        // 获取历史任务
        $sql = "
            SELECT
                t.id, t.template_id, t.period_key, t.period_start, t.period_end, t.status,
                t.completed_at, t.completed_by, t.notes,
                tpl.template_name, tpl.description as template_description, tpl.frequency_type, tpl.photo_hint,
                ku.display_name as completed_by_name,
                (SELECT COUNT(*) FROM store_inspection_photos WHERE task_id = t.id) as photo_count
            FROM store_inspection_tasks t
            JOIN store_inspection_templates tpl ON tpl.id = t.template_id
            LEFT JOIN kds_users ku ON ku.id = t.completed_by
            WHERE t.store_id = ?
              AND t.status IN ('completed', 'pending_review')
            ORDER BY t.completed_at DESC
            LIMIT 50
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$store_id]);
    }

    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // 计算汇总
    $summary = ['total' => count($tasks), 'completed' => 0, 'pending' => 0, 'pending_review' => 0];
    foreach ($tasks as $task) {
        if ($task['status'] === 'completed') {
            $summary['completed']++;
        } elseif ($task['status'] === 'pending_review') {
            $summary['pending_review']++;
        } else {
            $summary['pending']++;
        }
    }

    json_ok(['tasks' => $tasks, 'summary' => $summary], '检查任务列表');
}

/**
 * 确保当期任务已生成
 */
function ensureCurrentTasksExist(PDO $pdo, int $store_id): void {
    $now = new DateTime();

    // 获取该门店适用的活跃模板
    $sql = "
        SELECT tpl.*
        FROM store_inspection_templates tpl
        WHERE tpl.is_active = 1
          AND (tpl.apply_to_all = 1
               OR EXISTS (SELECT 1 FROM store_inspection_template_stores ts WHERE ts.template_id = tpl.id AND ts.store_id = ?))
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$store_id]);
    $templates = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($templates as $tpl) {
        $freq = $tpl['frequency_type'];

        // 计算周期
        switch ($freq) {
            case 'weekly':
                $period_key = $now->format('Y-\\WW');
                $period_start = (clone $now)->modify('monday this week')->format('Y-m-d');
                $due_weekday = (int)$tpl['due_weekday'];
                $period_end_dt = (clone $now)->modify('monday this week');
                $period_end_dt->modify('+' . ($due_weekday - 1) . ' days');
                $period_end = $period_end_dt->format('Y-m-d');
                break;
            case 'yearly':
                $period_key = $now->format('Y');
                $period_start = $now->format('Y') . '-01-01';
                $due_month = (int)$tpl['due_month'];
                $due_day = min((int)$tpl['due_day'], 28);
                $period_end = $now->format('Y') . '-' . str_pad($due_month, 2, '0', STR_PAD_LEFT) . '-' . str_pad($due_day, 2, '0', STR_PAD_LEFT);
                break;
            default: // monthly
                $period_key = $now->format('Y-m');
                $period_start = $now->format('Y-m') . '-01';
                $due_day = (int)$tpl['due_day'];
                $last_day = (int)$now->format('t');
                $due_day = min($due_day, $last_day);
                $period_end = $now->format('Y-m') . '-' . str_pad($due_day, 2, '0', STR_PAD_LEFT);
        }

        // 检查是否已存在
        $stmt = $pdo->prepare("SELECT id FROM store_inspection_tasks WHERE store_id = ? AND template_id = ? AND period_key = ?");
        $stmt->execute([$store_id, $tpl['id'], $period_key]);

        if (!$stmt->fetch()) {
            // 创建任务
            $stmt = $pdo->prepare("INSERT INTO store_inspection_tasks (store_id, template_id, period_key, period_start, period_end) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$store_id, $tpl['id'], $period_key, $period_start, $period_end]);
        }
    }
}

/**
 * 获取任务详情
 */
function handle_kds_inspection_task_detail(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    $task_id = (int)($_GET['id'] ?? 0);

    if ($task_id <= 0) {
        json_error('缺少任务ID', 400);
    }

    $stmt = $pdo->prepare("
        SELECT
            t.*,
            tpl.template_name, tpl.description as template_description, tpl.photo_hint,
            ku.display_name as completed_by_name
        FROM store_inspection_tasks t
        JOIN store_inspection_templates tpl ON tpl.id = t.template_id
        LEFT JOIN kds_users ku ON ku.id = t.completed_by
        WHERE t.id = ? AND t.store_id = ?
    ");
    $stmt->execute([$task_id, $store_id]);
    $task = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$task) {
        json_error('任务不存在', 404);
    }

    // 获取照片
    $stmt = $pdo->prepare("
        SELECT p.*, ku.display_name as uploaded_by_name
        FROM store_inspection_photos p
        LEFT JOIN kds_users ku ON ku.id = p.uploaded_by
        WHERE p.task_id = ?
        ORDER BY p.uploaded_at
    ");
    $stmt->execute([$task_id]);
    $task['photos'] = $stmt->fetchAll(PDO::FETCH_ASSOC);

    json_ok($task, '任务详情');
}

/**
 * 上传检查照片
 */
function handle_kds_upload_inspection_photo(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    $user_id = (int)($_SESSION['kds_user_id'] ?? 0);
    $task_id = (int)($_POST['task_id'] ?? 0);

    if ($task_id <= 0) {
        json_error('缺少任务ID', 400);
    }

    // 验证任务归属
    $stmt = $pdo->prepare("SELECT id, status FROM store_inspection_tasks WHERE id = ? AND store_id = ?");
    $stmt->execute([$task_id, $store_id]);
    $task = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$task) {
        json_error('任务不存在', 404);
    }

    if ($task['status'] === 'completed' || $task['status'] === 'pending_review') {
        json_error('任务已提交，无法上传照片', 400);
    }

    // 检查文件上传
    if (!isset($_FILES['photo']) || $_FILES['photo']['error'] !== UPLOAD_ERR_OK) {
        json_error('照片上传失败', 400);
    }

    $file = $_FILES['photo'];

    // 验证文件类型
    $allowedTypes = ['image/jpeg', 'image/png', 'image/webp'];
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mimeType = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);

    if (!in_array($mimeType, $allowedTypes)) {
        json_error('只允许上传 JPEG、PNG 或 WEBP 格式的图片', 400);
    }

    // 文件大小限制 (2MB)
    if ($file['size'] > 2 * 1024 * 1024) {
        json_error('照片大小不能超过 2MB', 400);
    }

    // 创建存储目录
    $year = date('Y');
    $month = date('m');
    $uploadDir = realpath(__DIR__ . '/../../../..') . "/store_images/inspections/{$store_id}/{$year}/{$month}";

    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }

    // 生成文件名
    $fileHash = hash_file('sha256', $file['tmp_name']);
    $fileName = "task_{$task_id}_" . time() . "_" . substr($fileHash, 0, 8) . ".jpg";
    $filePath = "{$store_id}/{$year}/{$month}/{$fileName}";
    $fullPath = $uploadDir . '/' . $fileName;

    // 移动文件
    if (!move_uploaded_file($file['tmp_name'], $fullPath)) {
        json_error('保存照片失败', 500);
    }

    // 提取 EXIF 信息
    $takenAt = null;
    $deviceMake = null;
    $deviceModel = null;
    $latitude = null;
    $longitude = null;

    if (function_exists('exif_read_data') && $mimeType === 'image/jpeg') {
        $exif = @exif_read_data($fullPath);
        if ($exif) {
            if (isset($exif['DateTimeOriginal'])) {
                $takenAt = date('Y-m-d H:i:s', strtotime($exif['DateTimeOriginal']));
            }
            $deviceMake = $exif['Make'] ?? null;
            $deviceModel = $exif['Model'] ?? null;

            // GPS 信息
            if (isset($exif['GPSLatitude']) && isset($exif['GPSLongitude'])) {
                $latitude = gpsToDecimal($exif['GPSLatitude'], $exif['GPSLatitudeRef'] ?? 'N');
                $longitude = gpsToDecimal($exif['GPSLongitude'], $exif['GPSLongitudeRef'] ?? 'E');
            }
        }
    }

    // 解析验证标记
    $validationFlags = json_decode($_POST['validation_flags'] ?? '{}', true) ?: [];

    // 检查 EXIF
    if (!$takenAt) {
        $validationFlags['no_exif'] = true;
    }

    // 保存到数据库
    $stmt = $pdo->prepare("
        INSERT INTO store_inspection_photos
        (task_id, photo_path, file_size, file_hash, taken_at, device_make, device_model, latitude, longitude, uploaded_by, upload_ip, validation_flags)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");
    $stmt->execute([
        $task_id,
        $filePath,
        filesize($fullPath),
        $fileHash,
        $takenAt,
        $deviceMake,
        $deviceModel,
        $latitude,
        $longitude,
        $user_id,
        $_SERVER['REMOTE_ADDR'] ?? null,
        json_encode($validationFlags)
    ]);

    json_ok(['photo_id' => $pdo->lastInsertId(), 'path' => $filePath], '照片上传成功');
}

/**
 * GPS 坐标转换
 */
function gpsToDecimal($coord, $ref) {
    $degrees = count($coord) > 0 ? gpsToNumeric($coord[0]) : 0;
    $minutes = count($coord) > 1 ? gpsToNumeric($coord[1]) : 0;
    $seconds = count($coord) > 2 ? gpsToNumeric($coord[2]) : 0;

    $decimal = $degrees + ($minutes / 60) + ($seconds / 3600);

    if ($ref === 'S' || $ref === 'W') {
        $decimal *= -1;
    }

    return $decimal;
}

function gpsToNumeric($value) {
    if (is_string($value) && strpos($value, '/') !== false) {
        $parts = explode('/', $value);
        if (count($parts) == 2 && $parts[1] != 0) {
            return $parts[0] / $parts[1];
        }
    }
    return (float)$value;
}

/**
 * 完成检查任务
 */
function handle_kds_complete_inspection_task(PDO $pdo, array $config, array $input_data): void {
    $store_id = (int)($_SESSION['kds_store_id'] ?? 0);
    $user_id = (int)($_SESSION['kds_user_id'] ?? 0);

    $task_id = (int)($input_data['task_id'] ?? 0);
    $notes = trim($input_data['notes'] ?? '');

    if ($task_id <= 0) {
        json_error('缺少任务ID', 400);
    }

    // 验证任务归属
    $stmt = $pdo->prepare("SELECT id, status FROM store_inspection_tasks WHERE id = ? AND store_id = ?");
    $stmt->execute([$task_id, $store_id]);
    $task = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$task) {
        json_error('任务不存在', 404);
    }

    if ($task['status'] === 'completed') {
        json_error('任务已通过审核', 400);
    }
    if ($task['status'] === 'pending_review') {
        json_error('任务已提交，等待总部审核', 400);
    }

    // 检查是否有照片
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM store_inspection_photos WHERE task_id = ?");
    $stmt->execute([$task_id]);
    $photoCount = (int)$stmt->fetchColumn();

    if ($photoCount === 0) {
        json_error('请至少上传一张照片', 400);
    }

    // 提交审核（不再直接标记完成）
    $stmt = $pdo->prepare("
        UPDATE store_inspection_tasks
        SET status = 'pending_review', completed_at = NOW(), completed_by = ?, notes = ?
        WHERE id = ?
    ");
    $stmt->execute([$user_id, $notes ?: null, $task_id]);

    json_ok(null, '检查已提交，等待总部审核');
}


/* -------------------------------------------------------------------------- */
/* 注册表*/
/* -------------------------------------------------------------------------- */
return [
    
    // [GEMINI FIX 2] 新增 'print' 资源
    'print' => [
        'auth_role' => ROLE_STORE_USER,
        'custom_actions' => [
            'get_templates' => 'handle_print_get_templates',
        ],
    ],
    
    // KDS: SOP
    'sop' => [
        'auth_role' => ROLE_STORE_USER, // KDS 角色
        'custom_actions' => [
            'get' => 'handle_kds_sop_get', // 迁移自 kds/api/sop_handler.php
        ],
    ],
    
    // KDS: Expiry
    'expiry' => [
        'auth_role' => ROLE_STORE_USER, // KDS 角色
        'custom_actions' => [
            'record' => 'handle_kds_expiry_record',       // 迁移自 kds/api/record_expiry_item.php
            'get_items' => 'handle_kds_get_expiry_items', // 迁移自 kds/api/get_kds_expiry_items.php
            'update_status' => 'handle_kds_update_expiry_status',// 迁移自 kds/api/update_expiry_status.php
        ],
    ],
    
    // KDS: Prep
    'prep' => [
        'auth_role' => ROLE_STORE_USER, // KDS 角色
        'custom_actions' => [
            'get_materials' => 'handle_kds_get_preppable', // 迁移自 kds/api/get_preppable_materials.php
        ],
    ],

    // KDS: Stock Import (2026-01-26 后台重构)
    'stock' => [
        'auth_role' => ROLE_STORE_USER,
        'custom_actions' => [
            'parse_import_code' => 'handle_kds_parse_import_code',
            'execute_import' => 'handle_kds_execute_import',
            'recent_imports' => 'handle_kds_recent_imports',
        ],
    ],

    // KDS: Inspection (2026-01-27 门店检查系统)
    'inspection' => [
        'auth_role' => ROLE_STORE_MANAGER, // 只有店长可用
        'custom_actions' => [
            'get_tasks' => 'handle_kds_get_inspection_tasks',
            'task_detail' => 'handle_kds_inspection_task_detail',
            'upload_photo' => 'handle_kds_upload_inspection_photo',
            'complete_task' => 'handle_kds_complete_inspection_task',
        ],
    ],
];