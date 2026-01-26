<?php
/**
 * Toptea HQ - CPSYS 主入口/控制器
 * Version: 2.0 (后台重构版)
 * Date: 2026-01-26
 *
 * [2026-01-26 后台重构]
 * - 移除所有 POS 相关路由 (菜单、会员、促销、票据、日结等)
 * - 移除总仓库存管理
 * - 保留: 配方管理(RMS)、门店库存、KDS出品、效期管理
 * - 新增: 入库码管理、KDS打印模板管理
 */

// --- 1. 核心引导 ---
require_once realpath(__DIR__ . '/../../core/auth_core.php');
require_once realpath(__DIR__ . '/../../core/config.php');
require_once realpath(__DIR__ . '/../../core/helpers.php');
require_once realpath(__DIR__ . '/../../app/helpers/auth_helper.php');
require_once realpath(__DIR__ . '/../../app/helpers/kds_helper.php');
require_once realpath(__DIR__ . '/../../app/helpers/datetime_helper.php');

// --- 2. 身份验证 ---
// auth_core.php 已自动执行检查

// --- 3. 数据库连接 ---
try {
    if (!isset($pdo) || !($pdo instanceof PDO)) {
         throw new Exception("PDO connection object (\$pdo) not found. Check core/config.php.");
    }
} catch (Exception $e) {
    error_log("Database Connection Error: " . $e->getMessage());
    die("数据库连接失败。请检查日志。");
}

// --- 4. 全局数据加载 ---
// (移除了 POS 班次复核计数)

// --- 5. 页面路由和控制器 ---
$page = $_GET['page'] ?? 'dashboard';
$data = [];
$page_title = 'Dashboard';
$js_files = [];
$view_path = '';

try {
    switch ($page) {

        // ============================================================
        // 核心
        // ============================================================
        case 'dashboard':
            check_role(ROLE_USER);
            $page_title = '仪表盘';
            // [2026-01-26] 简化仪表盘，移除 POS 相关 KPI
            $data['low_stock_alerts'] = getLowStockAlerts($pdo, 10);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/dashboard_view.php');
            break;

        case 'profile':
            check_role(ROLE_USER);
            $page_title = '个人资料';
            $js_files[] = 'profile.js';
            $data['current_user'] = getUserById($pdo, (int)$_SESSION['user_id']);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/profile_view.php');
            break;

        // ============================================================
        // RMS - 配方管理
        // ============================================================
        case 'material_management':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '物料管理';
            $js_files[] = 'material_management.js';
            $data['materials'] = getAllMaterials($pdo);
            $data['unit_options'] = getAllUnits($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/material_management_view.php');
            break;

        case 'cup_management':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '杯型管理';
            $js_files[] = 'cup_management.js';
            $data['cups'] = getAllCups($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/cup_management_view.php');
            break;

        case 'ice_option_management':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '冰量选项';
            $js_files[] = 'ice_option_management.js';
            $data['ice_options'] = getAllIceOptions($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/ice_option_management_view.php');
            break;

        case 'sweetness_option_management':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '甜度选项';
            $js_files[] = 'sweetness_option_management.js';
            $data['sweetness_options'] = getAllSweetnessOptions($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/sweetness_option_management_view.php');
            break;

        case 'product_status_management':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '产品状态';
            $js_files[] = 'product_status_management.js';
            $data['statuses'] = getAllStatuses($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/product_status_management_view.php');
            break;

        case 'unit_management':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '单位管理';
            $js_files[] = 'unit_management.js';
            $data['units'] = getAllUnits($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/unit_management_view.php');
            break;

        case 'rms_product_management':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '产品配方';
            $js_files[] = 'js/rms/rms_product_management.js';
            $data['base_products'] = getAllBaseProducts($pdo);
            $data['material_options'] = getAllMaterials($pdo);
            $data['unit_options'] = getAllUnits($pdo);
            $data['cup_options'] = getAllCups($pdo);
            $data['sweetness_options'] = getAllSweetnessOptions($pdo);
            $data['ice_options'] = getAllIceOptions($pdo);
            $data['status_options'] = getAllStatuses($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/rms/rms_product_management_view.php');
            break;

        case 'rms_global_rules':
            check_role(ROLE_PRODUCT_MANAGER);
            $page_title = '全局调整规则';
            $js_files[] = 'js/rms/rms_global_rules.js';
            $data['global_rules'] = getAllGlobalRules($pdo);
            $data['material_options'] = getAllMaterials($pdo);
            $data['unit_options'] = getAllUnits($pdo);
            $data['cup_options'] = getAllCups($pdo);
            $data['sweetness_options'] = getAllSweetnessOptions($pdo);
            $data['ice_options'] = getAllIceOptions($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/rms/rms_global_rules_view.php');
            break;

        // ============================================================
        // 门店管理
        // ============================================================
        case 'store_management':
            check_role(ROLE_ADMIN);
            $page_title = '门店管理';
            $js_files[] = 'store_management.js';
            $data['stores'] = getAllStores($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/store_management_view.php');
            break;

        case 'kds_user_management':
            check_role(ROLE_ADMIN);
            $store_id = (int)($_GET['store_id'] ?? 0);
            if ($store_id <= 0) {
                 header('Location: ?page=store_management'); exit;
            }
            $data['store_data'] = getStoreById($pdo, $store_id);
            if (!$data['store_data']) {
                 header('Location: ?page=store_management'); exit;
            }
            $page_title = '门店用户管理: ' . htmlspecialchars($data['store_data']['store_name']);
            $js_files[] = 'kds_user_management.js';
            $data['kds_users'] = getAllKdsUsersByStoreId($pdo, $store_id);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/kds_user_management_view.php');
            break;

        // ============================================================
        // 库存管理 (新增入库码功能)
        // ============================================================
        case 'store_stock_view':
            check_role(ROLE_ADMIN);
            $page_title = '门店库存';
            $js_files[] = 'store_stock.js';
            $data['stores'] = getAllStores($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/store_stock_view.php');
            break;

        case 'stock_import':
            check_role(ROLE_ADMIN);
            $page_title = '入库码管理';
            $js_files[] = 'stock_import.js';
            $data['stores'] = getAllStores($pdo);
            $data['materials'] = getAllMaterials($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/stock_import_view.php');
            break;

        case 'expiry_management':
            check_role(ROLE_ADMIN);
            $page_title = '效期管理';
            $data['expiry_items'] = getAllExpiryItems($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/expiry_management_view.php');
            break;

        // ============================================================
        // KDS / 出品系统
        // ============================================================
        case 'kds_sop_rules':
            check_role(ROLE_SUPER_ADMIN);
            $page_title = 'KDS SOP 解析规则';
            $js_files[] = 'kds_sop_rules.js';
            $data['stores'] = getAllStores($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/kds_sop_rules_view.php');
            break;

        case 'print_template_management':
            check_role(ROLE_SUPER_ADMIN);
            $page_title = 'KDS 打印模板';
            $js_files[] = 'print_template_management.js';
            // 数据由 JS 异步加载
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/print_template_management_view.php');
            break;

        // ============================================================
        // 系统管理
        // ============================================================
        case 'user_management':
            check_role(ROLE_SUPER_ADMIN);
            $page_title = 'HQ 账户管理';
            $js_files[] = 'user_management.js';
            $data['users'] = getAllUsers($pdo);
            $data['roles'] = getAllRoles($pdo);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/user_management_view.php');
            break;

        // ============================================================
        // 默认/回退
        // ============================================================
        default:
            $page = 'dashboard';
            check_role(ROLE_USER);
            $page_title = '仪表盘';
            $data['low_stock_alerts'] = getLowStockAlerts($pdo, 10);
            $view_path = realpath(__DIR__ . '/../../app/views/cpsys/dashboard_view.php');
            break;
    }

} catch (AuthException $e) {
    $page_title = '权限不足';
    $data['error_message'] = $e->getMessage();
    $view_path = realpath(__DIR__ . '/../../app/views/cpsys/access_denied_view.php');
} catch (Exception $e) {
    $page_title = '系统错误';
    $data['error_message'] = $e->getMessage();
    $data['error_trace'] = $e->getTraceAsString();
    $view_path = realpath(__DIR__ . '/../../app/views/cpsys/error_view.php');
    error_log("Unhandled Exception in index.php: " . $e->getMessage() . "\n" . $e->getTraceAsString());
}

// --- 5.9 兼容桥：让新版 $js_files 兼容旧版 main.php 的 $page_js ---
if ((!isset($page_js) || !$page_js) && isset($js_files) && is_array($js_files)) {
    foreach ($js_files as $src) {
        if (!is_string($src) || $src === '') continue;
        if (preg_match('#^https?://#i', $src)) continue;
        $src = preg_replace('#^/+?#', '', $src);
        $src = preg_replace('#^js/#', '', $src);
        $page_js = $src;
        break;
    }
}

// --- 6. 渲染布局 ---
extract($data);
include realpath(__DIR__ . '/../../app/views/cpsys/layouts/main.php');
