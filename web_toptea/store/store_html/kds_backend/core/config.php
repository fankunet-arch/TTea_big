<?php
/**
 * Toptea KDS - Core Configuration File
 * Engineer: Gemini | Date: 2025-10-24
 * Revision: 4.0 (Architecture Refactor - Unified to kds_backend)
 *
 * [KDS ARCHITECTURE REFACTOR 2026-01-25]
 * 此文件从 kds/core/config.php 迁移到 kds_backend/core/config.php
 * 统一KDS后端目录结构，与POS架构保持一致
 */

// --- [SECURITY FIX V2.0] ---
ini_set('display_errors', '0'); // Turn off displaying errors in production
ini_set('display_startup_errors', '0');
ini_set('log_errors', '1'); // Enable logging errors
ini_set('error_log', __DIR__ . '/php_errors_kds.log'); // Log errors to this file
// --- [END FIX] ---

error_reporting(E_ALL);
mb_internal_encoding('UTF-8');

// --- Database Configuration (Unified with POS/HQ) ---
// [AUDIT FIX 2026-01-25] 统一使用 POS 数据库配置
$db_host = 'mhdlmskv3gjbpqv3.mysql.db';
$db_name = 'mhdlmskv3gjbpqv3';
$db_user = 'mhdlmskv3gjbpqv3';
$db_pass = 'zqVdVfAWYYaa4gTAuHWX7CngpRDqR';
$db_char = 'utf8mb4';

// --- Application Settings ---
define('KDS_BASE_URL', '/kds/'); // Relative base URL for the KDS app

// --- Directory Paths (Updated for kds_backend) ---
define('KDS_BACKEND_PATH', dirname(__DIR__));          // kds_backend/
define('KDS_CORE_PATH', KDS_BACKEND_PATH . '/core');   // kds_backend/core/
define('KDS_HELPERS_PATH', KDS_BACKEND_PATH . '/helpers'); // kds_backend/helpers/

// --- View Paths (视图仍在 kds/app/views 目录) ---
// 视图层保留在原位置，符合前后端分离原则
define('KDS_VIEWS_PATH', dirname(KDS_BACKEND_PATH) . '/kds/app/views'); // kds/app/views/
define('KDS_APP_PATH', dirname(KDS_BACKEND_PATH) . '/kds/app');         // 兼容旧代码

// --- Application Default Timezone (for datetime calculations) ---
if (!defined('APP_DEFAULT_TIMEZONE')) {
    define('APP_DEFAULT_TIMEZONE', 'Europe/Madrid');
}

// --- Database Connection (PDO) ---
$dsn = "mysql:host=$db_host;dbname=$db_name;charset=$db_char";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $db_user, $db_pass, $options);

    // [A1 UTC SYNC] Set connection timezone to UTC
    $pdo->exec("SET time_zone='+00:00'");

} catch (\PDOException $e) {
    error_log("KDS Database connection failed: " . $e->getMessage());
    // For KDS, we must die cleanly in a way the frontend can parse
    header('Content-Type: application/json; charset=utf-8');
    http_response_code(503); // Service Unavailable
    echo json_encode([
        'status' => 'error',
        'message' => 'DB Connection Error (KDS)',
        'data' => null
    ]);
    exit;
}
