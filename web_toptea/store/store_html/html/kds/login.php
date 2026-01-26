<?php
@session_start();
if (isset($_SESSION['kds_logged_in']) && $_SESSION['kds_logged_in'] === true) {
    header('Location: index.php');
    exit;
}
// [REFACTOR 2026-01-26] 视图迁移到 kds_backend/views
require_once realpath(__DIR__ . '/../../kds_backend/views/login_view.php');