<?php
/**
 * Toptea Store - KDS 统一 API 网关
 * Version: 2.0.0
 * Date: 2026-01-25
 *
 * [KDS ARCHITECTURE REFACTOR 2026-01-25]
 * 重构为与 POS API 网关标准一致的结构：
 * - 添加 declare(strict_types=1)
 * - 使用 realpath() 进行路径解析
 * - 统一从 kds_backend/ 目录加载所有后端文件
 * - 移除兼容性 hack，使用现代 PHP 标准
 */

declare(strict_types=1);

// 1) 核心配置与依赖
require_once realpath(__DIR__ . '/../../../kds_backend/core/config.php');
require_once realpath(__DIR__ . '/../../../kds_backend/helpers/kds_json_helper.php');
require_once realpath(__DIR__ . '/../../../kds_backend/core/kds_api_core.php');

// 2) 注册表
$registry_main = require __DIR__ . '/registries/kds_registry.php';

// 3) 合并注册表 (KDS 目前只有主注册表，预留扩展接口)
$full_registry = $registry_main;

// 4) 运行 API 引擎
run_api($full_registry, $pdo);
