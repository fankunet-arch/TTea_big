<?php
/**
 * Toptea HQ - cpsys
 * Main Layout File
 * Version: 2.0 (后台重构版)
 * Date: 2026-01-26
 *
 * [2026-01-26 后台重构]
 * - 移除所有 POS 相关菜单
 * - 简化库存菜单（只保留门店库存、入库码、效期）
 * - 新增 KDS 打印模板管理
 */
$page_title = $page_title ?? 'TopTea HQ';
$page = $_GET['page'] ?? 'dashboard';

// 菜单组定义
$rmsPages = [
    'rms_product_management', 'rms_global_rules', 'material_management',
    'cup_management', 'ice_option_management', 'sweetness_option_management',
    'product_status_management', 'unit_management'
];

$stockPages = [
    'store_stock_view', 'stock_import', 'expiry_management'
];

$systemPages = [
    'user_management', 'store_management', 'kds_user_management',
    'print_template_management', 'kds_sop_rules'
];
?>
<!DOCTYPE html>
<html lang="zh-CN" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($page_title, ENT_QUOTES, 'UTF-8'); ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css?v=<?php echo time(); ?>">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
</head>
<body>
    <div class="d-flex">
        <nav class="sidebar min-vh-100 p-3">
            <div class="sidebar-header mb-4"><h4 class="text-white">TopTea HQ</h4></div>
            <ul class="nav flex-column">

                <!-- 仪表盘 -->
                <li class="nav-item">
                    <a class="nav-link <?php echo ($page === 'dashboard') ? 'active' : ''; ?>" href="index.php?page=dashboard">
                        <i class="bi bi-speedometer2 me-2"></i>仪表盘
                    </a>
                </li>

                <!-- 配方管理 (RMS) -->
                <li class="nav-item">
                    <a class="nav-link collapsed <?php echo (in_array($page, $rmsPages)) ? 'active' : ''; ?>" href="#" data-bs-toggle="collapse" data-bs-target="#rms-submenu" aria-expanded="<?php echo (in_array($page, $rmsPages)) ? 'true' : 'false'; ?>">
                        <i class="bi bi-cup-straw me-2"></i>配方管理
                    </a>
                    <div class="collapse <?php echo (in_array($page, $rmsPages)) ? 'show' : ''; ?>" id="rms-submenu">
                        <ul class="nav flex-column ps-4">
                            <?php if (check_role(ROLE_PRODUCT_MANAGER)): ?>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'rms_product_management') ? 'active' : ''; ?>" href="index.php?page=rms_product_management">产品配方</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'rms_global_rules') ? 'active' : ''; ?>" href="index.php?page=rms_global_rules">全局调整规则</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'material_management') ? 'active' : ''; ?>" href="index.php?page=material_management">物料管理</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'cup_management') ? 'active' : ''; ?>" href="index.php?page=cup_management">杯型管理</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'ice_option_management') ? 'active' : ''; ?>" href="index.php?page=ice_option_management">冰量选项</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'sweetness_option_management') ? 'active' : ''; ?>" href="index.php?page=sweetness_option_management">甜度选项</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'product_status_management') ? 'active' : ''; ?>" href="index.php?page=product_status_management">产品状态</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'unit_management') ? 'active' : ''; ?>" href="index.php?page=unit_management">单位管理</a>
                            </li>
                            <?php endif; ?>
                        </ul>
                    </div>
                </li>

                <!-- 库存管理 -->
                <li class="nav-item">
                    <a class="nav-link collapsed <?php echo (in_array($page, $stockPages)) ? 'active' : ''; ?>" href="#" data-bs-toggle="collapse" data-bs-target="#stock-submenu" aria-expanded="<?php echo (in_array($page, $stockPages)) ? 'true' : 'false'; ?>">
                        <i class="bi bi-box-seam me-2"></i>库存管理
                    </a>
                    <div class="collapse <?php echo (in_array($page, $stockPages)) ? 'show' : ''; ?>" id="stock-submenu">
                        <ul class="nav flex-column ps-4">
                            <?php if (check_role(ROLE_ADMIN)): ?>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'store_stock_view') ? 'active' : ''; ?>" href="index.php?page=store_stock_view">门店库存</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'stock_import') ? 'active' : ''; ?>" href="index.php?page=stock_import">入库码管理</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'expiry_management') ? 'active' : ''; ?>" href="index.php?page=expiry_management">效期管理</a>
                            </li>
                            <?php endif; ?>
                        </ul>
                    </div>
                </li>

                <!-- 系统设置 -->
                <?php if (check_role(ROLE_ADMIN)): ?>
                <li class="nav-item">
                    <a class="nav-link collapsed <?php echo (in_array($page, $systemPages)) ? 'active' : ''; ?>" href="#" data-bs-toggle="collapse" data-bs-target="#system-submenu" aria-expanded="<?php echo (in_array($page, $systemPages)) ? 'true' : 'false'; ?>">
                        <i class="bi bi-gear me-2"></i>系统设置
                    </a>
                    <div class="collapse <?php echo (in_array($page, $systemPages)) ? 'show' : ''; ?>" id="system-submenu">
                        <ul class="nav flex-column ps-4">
                            <?php if (check_role(ROLE_SUPER_ADMIN)): ?>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'user_management') ? 'active' : ''; ?>" href="index.php?page=user_management">HQ 账户管理</a>
                            </li>
                            <?php endif; ?>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'store_management' || $page === 'kds_user_management') ? 'active' : ''; ?>" href="index.php?page=store_management">门店管理</a>
                            </li>
                            <?php if (check_role(ROLE_SUPER_ADMIN)): ?>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'kds_sop_rules') ? 'active' : ''; ?>" href="index.php?page=kds_sop_rules">KDS SOP 规则</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <?php echo ($page === 'print_template_management') ? 'active' : ''; ?>" href="index.php?page=print_template_management">KDS 打印模板</a>
                            </li>
                            <?php endif; ?>
                        </ul>
                    </div>
                </li>
                <?php endif; ?>

            </ul>
        </nav>

        <div class="main-content flex-grow-1 p-4">
            <header class="d-flex justify-content-between align-items-center mb-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="index.php?page=dashboard">后台管理</a></li>
                        <li class="breadcrumb-item active" aria-current="page"><?php echo htmlspecialchars($page_title, ENT_QUOTES, 'UTF-8'); ?></li>
                    </ol>
                </nav>
                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle" type="button" id="userMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle me-2"></i> <?php echo htmlspecialchars($_SESSION['display_name'] ?? 'User'); ?>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenuButton">
                        <li><a class="dropdown-item" href="index.php?page=profile">个人资料</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="logout.php">退出登录</a></li>
                    </ul>
                </div>
            </header>
            <main>
                <?php
                    if (isset($data) && is_array($data)) {
                        extract($data);
                    }

                    if (isset($view_path) && file_exists($view_path)) {
                        include $view_path;
                    } else {
                        $error_msg = 'Error: Content view file not found';
                        if (isset($view_path)) {
                             $error_msg .= ' at path: ' . htmlspecialchars($view_path);
                        } else {
                             $error_msg .= ' (path variable is empty).';
                        }
                         echo '<div class="alert alert-danger">' . $error_msg . '</div>';
                    }
                ?>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>

    <?php if (isset($page_js) && $page_js): ?>
    <script src="js/<?php echo $page_js; ?>?ver=<?php echo time(); ?>"></script>
    <?php endif; ?>
</body>
</html>
