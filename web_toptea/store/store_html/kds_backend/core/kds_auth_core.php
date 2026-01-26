<?php
/**
 * Toptea Store - KDS
 * Core Authentication & Session Check for KDS Pages
 * Engineer: Gemini | Date: 2025-10-23
 * Revision: 2.0 (Architecture Refactor - Moved to kds_backend)
 *
 * [KDS ARCHITECTURE REFACTOR 2026-01-25]
 * 此文件从 kds/core/kds_auth_core.php 迁移到 kds_backend/core/kds_auth_core.php
 *
 * 用途: 用于 KDS 前端页面 (index.php, prep.php, expiry.php 等) 的会话验证。
 * API 验证由 kds_api_core.php 负责。
 */

@session_start();

if (!isset($_SESSION['kds_logged_in']) || $_SESSION['kds_logged_in'] !== true) {
    session_destroy();
    header('Location: login.php');
    exit;
}
