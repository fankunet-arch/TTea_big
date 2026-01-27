<?php
/**
 * Toptea Store - KDS
 * Inspection Page Entry Point (Secured - Manager Only)
 * Version: 1.0
 * Date: 2026-01-27
 */

// 防缓存
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");
header("Expires: 0");

// KDS 认证
require_once realpath(__DIR__ . '/../../kds_backend/core/kds_auth_core.php');
header('Content-Type: text/html; charset=utf-8');
require_once realpath(__DIR__ . '/../../kds_backend/core/config.php');

// 检查是否是店长角色
if (!isset($_SESSION['kds_role']) || $_SESSION['kds_role'] !== 'manager') {
    header('Location: index.php');
    exit;
}

$page_title = '检查清单 - KDS';
$content_view = KDS_VIEWS_PATH . '/inspection_view.php';
$page_js = 'kds_inspection.js';

if (!file_exists($content_view)) {
    die("Critical Error: View file not found at path: " . htmlspecialchars($content_view));
}

include KDS_VIEWS_PATH . '/layouts/main.php';
