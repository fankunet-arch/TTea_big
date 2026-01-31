-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- 主机： mhdlmskv6dpwwe9h.mysql.db
-- 生成日期： 2026-01-31 02:26:39
-- 服务器版本： 8.4.6-6
-- PHP 版本： 8.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `mhdlmskv6dpwwe9h`
--
CREATE DATABASE IF NOT EXISTS `mhdlmskv6dpwwe9h` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `mhdlmskv6dpwwe9h`;

-- --------------------------------------------------------

--
-- 表的结构 `cpsys_roles`
--

DROP TABLE IF EXISTS `cpsys_roles`;
CREATE TABLE `cpsys_roles` (
  `id` int UNSIGNED NOT NULL,
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称 (e.g., Super Admin)',
  `role_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '角色描述',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台系统角色表';

--
-- 转存表中的数据 `cpsys_roles`
--

INSERT INTO `cpsys_roles` (`id`, `role_name`, `role_description`, `created_at`) VALUES
(1, 'Super Admin', '超级管理员，拥有所有权限', '2025-10-22 21:43:58.000000'),
(2, 'Product Manager', '产品经理，管理配方和菜单', '2025-10-22 21:43:58.000000'),
(3, 'Store Manager', '门店经理，查看报表', '2025-10-22 21:43:58.000000');

-- --------------------------------------------------------

--
-- 表的结构 `cpsys_users`
--

DROP TABLE IF EXISTS `cpsys_users`;
CREATE TABLE `cpsys_users` (
  `id` int UNSIGNED NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显示名称',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '账户是否激活',
  `role_id` int UNSIGNED NOT NULL COMMENT '外键, 关联 cpsys_roles 表',
  `last_login_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台系统用户表';

--
-- 转存表中的数据 `cpsys_users`
--

INSERT INTO `cpsys_users` (`id`, `username`, `password_hash`, `email`, `display_name`, `is_active`, `role_id`, `last_login_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'toptea_admin', '$2y$10$8t9wfcsnMJPGSiIYnhBwTO4d8AQm4d6aCgeoD.DBcPYEMCypjA3Am', 'admin@toptea.es', 'TopTea Admin', 1, 1, '2026-01-26 17:42:01.000000', '2025-10-22 21:43:58.000000', '2026-01-26 17:42:01.367989', NULL),
(2, 'product_manager', '$2y$12$QCWWF6o6oSV391KYzbcNpu4XxAGQiBF69UjhDng7e2ynU.31kl/QK', 'admin@toptea.es', '产品经理 A2', 1, 2, '2025-11-10 21:40:59.000000', '2025-10-23 14:51:19.000000', '2026-01-26 15:54:37.960252', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `expsys_store_stock`
--

DROP TABLE IF EXISTS `expsys_store_stock`;
CREATE TABLE `expsys_store_stock` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL,
  `material_id` int UNSIGNED NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT '0.00',
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT 'UTC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `expsys_warehouse_stock`
--

DROP TABLE IF EXISTS `expsys_warehouse_stock`;
CREATE TABLE `expsys_warehouse_stock` (
  `id` int UNSIGNED NOT NULL,
  `material_id` int UNSIGNED NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT '0.00',
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT 'UTC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `kds_cups`
--

DROP TABLE IF EXISTS `kds_cups`;
CREATE TABLE `kds_cups` (
  `id` int UNSIGNED NOT NULL,
  `cup_code` smallint UNSIGNED NOT NULL COMMENT '杯型自定义编号 (1-2位)',
  `cup_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '杯型名称 (e.g., 中杯)',
  `volume_ml` int DEFAULT NULL COMMENT '杯型容量(毫升)',
  `sop_description_zh` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sop_description_es` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 杯型管理';

--
-- 转存表中的数据 `kds_cups`
--

INSERT INTO `kds_cups` (`id`, `cup_code`, `cup_name`, `volume_ml`, `sop_description_zh`, `sop_description_es`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '大杯', 700, '700cc 大杯', 'Vaso Grande 700cc', '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(2, 2, '中杯', 500, '500cc 中杯', 'Vaso Mediano 500cc', '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `kds_global_adjustment_rules`
--

DROP TABLE IF EXISTS `kds_global_adjustment_rules`;
CREATE TABLE `kds_global_adjustment_rules` (
  `id` int UNSIGNED NOT NULL,
  `rule_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则名称, e.g., "标准糖量公式"',
  `priority` int NOT NULL DEFAULT '100' COMMENT '执行优先级，数字越小越先执行',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `cond_cup_id` int UNSIGNED DEFAULT NULL COMMENT '条件: 杯型ID (NULL为全部)',
  `cond_ice_id` int UNSIGNED DEFAULT NULL COMMENT '条件: 冰量ID (NULL为全部)',
  `cond_sweet_id` int UNSIGNED DEFAULT NULL COMMENT '条件: 甜度ID (NULL为全部)',
  `cond_material_id` int UNSIGNED DEFAULT NULL COMMENT '条件: 针对哪个基础物料 (NULL为全部)',
  `cond_base_gt` decimal(10,2) DEFAULT NULL COMMENT '条件: L1基础用量大于此值',
  `cond_base_lte` decimal(10,2) DEFAULT NULL COMMENT '条件: L1基础用量小于等于此值',
  `action_type` enum('SET_VALUE','ADD_MATERIAL','CONDITIONAL_OFFSET','MULTIPLY_BASE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '动作: SET=设为定值, ADD=添加物料, OFFSET=偏移量, MULTIPLY=乘基础值',
  `action_material_id` int UNSIGNED NOT NULL COMMENT '动作: 目标物料ID (e.g., 果糖, 冰)',
  `action_value` decimal(10,2) NOT NULL COMMENT '动作: 值 (e.g., 50.00, 1.25, -10.00)',
  `action_unit_id` int UNSIGNED DEFAULT NULL COMMENT '动作: ADD_MATERIAL 时的新单位ID',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RMS V2.2 - 全局动态调整规则 (L2)';

--
-- 转存表中的数据 `kds_global_adjustment_rules`
--

INSERT INTO `kds_global_adjustment_rules` (`id`, `rule_name`, `priority`, `is_active`, `cond_cup_id`, `cond_ice_id`, `cond_sweet_id`, `cond_material_id`, `cond_base_gt`, `cond_base_lte`, `action_type`, `action_material_id`, `action_value`, `action_unit_id`, `created_at`, `updated_at`) VALUES
(1, '七分糖 (>60g)', 10, 1, NULL, NULL, 2, 1, 60.00, NULL, 'CONDITIONAL_OFFSET', 1, -10.00, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000'),
(2, '七分糖 (<=60g)', 11, 1, NULL, NULL, 2, 1, NULL, 60.00, 'CONDITIONAL_OFFSET', 1, -5.00, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000'),
(3, '五分糖 (>60g)', 12, 1, NULL, NULL, 3, 1, 60.00, NULL, 'CONDITIONAL_OFFSET', 1, -15.00, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000'),
(4, '五分糖 (<=60g)', 13, 1, NULL, NULL, 3, 1, NULL, 60.00, 'CONDITIONAL_OFFSET', 1, -10.00, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000'),
(5, '三分糖 (>60g)', 14, 1, NULL, NULL, 4, 1, 60.00, NULL, 'CONDITIONAL_OFFSET', 1, -20.00, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000'),
(6, '三分糖 (<=60g)', 15, 1, NULL, NULL, 4, 1, NULL, 60.00, 'CONDITIONAL_OFFSET', 1, -15.00, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000'),
(7, '不另外加糖 (所有)', 20, 1, NULL, NULL, 5, 1, NULL, NULL, 'SET_VALUE', 1, 0.00, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:40:15.000000');

-- --------------------------------------------------------

--
-- 表的结构 `kds_ice_options`
--

DROP TABLE IF EXISTS `kds_ice_options`;
CREATE TABLE `kds_ice_options` (
  `id` int UNSIGNED NOT NULL,
  `ice_code` smallint UNSIGNED NOT NULL COMMENT '冰量自定义编号 (1-2位)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 冰量选项管理';

--
-- 转存表中的数据 `kds_ice_options`
--

INSERT INTO `kds_ice_options` (`id`, `ice_code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(2, 2, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(3, 3, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(4, 4, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `kds_ice_option_translations`
--

DROP TABLE IF EXISTS `kds_ice_option_translations`;
CREATE TABLE `kds_ice_option_translations` (
  `id` int UNSIGNED NOT NULL,
  `ice_option_id` int UNSIGNED NOT NULL,
  `language_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '语言代码 (zh-CN, es-ES)',
  `ice_option_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '该语言下的选项名称',
  `sop_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 冰量选项翻译表';

--
-- 转存表中的数据 `kds_ice_option_translations`
--

INSERT INTO `kds_ice_option_translations` (`id`, `ice_option_id`, `language_code`, `ice_option_name`, `sop_description`) VALUES
(1, 1, 'zh-CN', '正常冰', '正常冰'),
(2, 1, 'es-ES', 'Hielo Normal', 'Hielo Normal'),
(3, 2, 'zh-CN', '少冰', '少冰'),
(4, 2, 'es-ES', 'Menos Hielo', 'Menos Hielo'),
(5, 3, 'zh-CN', '去冰', '去冰'),
(6, 3, 'es-ES', 'Sin Hielo', 'Sin Hielo'),
(7, 4, 'zh-CN', '温热', '温热'),
(8, 4, 'es-ES', 'Caliente', 'Caliente');

-- --------------------------------------------------------

--
-- 表的结构 `kds_materials`
--

DROP TABLE IF EXISTS `kds_materials`;
CREATE TABLE `kds_materials` (
  `id` int UNSIGNED NOT NULL,
  `material_code` smallint UNSIGNED NOT NULL COMMENT '物料自定义编号 (1-2位)',
  `material_type` enum('RAW','SEMI_FINISHED','PRODUCT','CONSUMABLE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SEMI_FINISHED',
  `base_unit_id` int UNSIGNED NOT NULL,
  `medium_unit_id` int UNSIGNED DEFAULT NULL,
  `medium_conversion_rate` decimal(10,2) DEFAULT NULL COMMENT '1 中级单位 = X 基础单位',
  `large_unit_id` int UNSIGNED DEFAULT NULL,
  `large_conversion_rate` decimal(10,2) DEFAULT NULL COMMENT '1 大单位 = X 中级单位',
  `expiry_rule_type` enum('HOURS','DAYS','END_OF_DAY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiry_duration` int DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '物料图片URL',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 物料字典主表';

--
-- 转存表中的数据 `kds_materials`
--

INSERT INTO `kds_materials` (`id`, `material_code`, `material_type`, `base_unit_id`, `medium_unit_id`, `medium_conversion_rate`, `large_unit_id`, `large_conversion_rate`, `expiry_rule_type`, `expiry_duration`, `image_url`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'PRODUCT', 1, 8, 25000.00, NULL, NULL, NULL, 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-05 20:30:46.000000', NULL),
(2, 2, 'SEMI_FINISHED', 2, NULL, NULL, NULL, NULL, NULL, 0, 'agua.jpg', '2025-11-02 19:39:32.000000', '2025-11-07 01:37:08.000000', NULL),
(3, 3, 'PRODUCT', 1, NULL, NULL, NULL, NULL, NULL, 0, 'hielo.jpg', '2025-11-02 19:39:32.000000', '2025-11-07 01:34:38.000000', NULL),
(4, 4, 'RAW', 1, 8, 15000.00, NULL, NULL, 'DAYS', 7, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:12:22.000000', NULL),
(5, 5, 'RAW', 1, 8, 10000.00, NULL, NULL, 'DAYS', 7, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:12:54.000000', NULL),
(6, 6, 'RAW', 1, 8, 3000.00, NULL, NULL, 'DAYS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:48:08.000000', NULL),
(7, 7, 'PRODUCT', 2, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(8, 8, 'PRODUCT', 2, NULL, NULL, NULL, NULL, 'DAYS', 2, 'leche.jpg', '2025-11-02 19:39:32.000000', '2025-11-07 01:31:19.000000', NULL),
(9, 9, 'PRODUCT', 2, 8, 12000.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:40:24.000000', NULL),
(10, 10, 'RAW', 1, NULL, NULL, NULL, NULL, 'DAYS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(11, 11, 'PRODUCT', 2, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(12, 12, 'SEMI_FINISHED', 2, NULL, NULL, NULL, NULL, 'HOURS', 5, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(13, 13, 'SEMI_FINISHED', 2, NULL, NULL, NULL, NULL, 'HOURS', 5, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(14, 14, 'SEMI_FINISHED', 2, NULL, NULL, NULL, NULL, 'HOURS', 6, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(15, 15, 'SEMI_FINISHED', 2, NULL, NULL, NULL, NULL, NULL, 0, 'agua.jpg', '2025-11-02 19:39:32.000000', '2025-11-07 01:37:22.000000', NULL),
(16, 16, 'SEMI_FINISHED', 1, NULL, NULL, NULL, NULL, 'DAYS', 2, 'brulee.jpg', '2025-11-02 19:39:32.000000', '2025-11-07 00:48:31.000000', NULL),
(17, 17, 'SEMI_FINISHED', 1, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(18, 18, 'SEMI_FINISHED', 1, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(19, 19, 'SEMI_FINISHED', 1, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(20, 20, 'PRODUCT', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(21, 21, 'PRODUCT', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(22, 22, 'RAW', 1, 8, 18000.00, NULL, NULL, '', 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:49:19.000000', NULL),
(23, 23, 'RAW', 1, 8, 20000.00, NULL, NULL, '', 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:49:00.000000', NULL),
(24, 24, 'RAW', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(25, 25, 'RAW', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(26, 26, 'PRODUCT', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(27, 27, 'PRODUCT', 1, 8, 6000.00, NULL, NULL, '', 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:43:28.000000', NULL),
(28, 28, 'RAW', 1, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(29, 29, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:46:57.000000', NULL),
(30, 30, 'PRODUCT', 1, 8, 12000.00, NULL, NULL, 'DAYS', 3, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:44:33.000000', NULL),
(31, 31, 'PRODUCT', 2, 8, 12000.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:41:50.000000', NULL),
(32, 32, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:49:57.000000', NULL),
(33, 33, 'PRODUCT', 1, 8, 12000.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:42:19.000000', NULL),
(34, 34, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:50:26.000000', NULL),
(35, 35, 'PRODUCT', 2, 8, 12000.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:42:04.000000', NULL),
(36, 36, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:41:07.000000', NULL),
(37, 37, 'PRODUCT', 1, 8, 12000.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:41:31.000000', NULL),
(38, 38, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:42:35.000000', NULL),
(39, 39, 'PRODUCT', 1, 8, 7800.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:42:57.000000', NULL),
(40, 40, 'SEMI_FINISHED', 1, NULL, NULL, NULL, NULL, 'HOURS', 6, 'boba.jpg', '2025-11-02 19:39:32.000000', '2025-11-07 00:14:50.000000', NULL),
(41, 41, 'SEMI_FINISHED', 1, NULL, NULL, NULL, NULL, 'HOURS', 8, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(42, 42, 'SEMI_FINISHED', 2, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(43, 43, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 6, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:50:57.000000', NULL),
(44, 44, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 6, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:55:56.000000', NULL),
(45, 45, 'PRODUCT', 1, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(46, 46, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:55:43.000000', NULL),
(47, 47, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 6, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:51:23.000000', NULL),
(48, 48, 'PRODUCT', 2, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(49, 49, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:51:10.000000', NULL),
(50, 50, 'PRODUCT', 2, 8, 12000.00, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:40:49.000000', NULL),
(51, 51, 'PRODUCT', 1, 8, 10200.00, NULL, NULL, 'HOURS', 8, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 19:48:41.000000', NULL),
(52, 52, 'SEMI_FINISHED', 1, 0, 0.00, NULL, NULL, 'HOURS', 4, NULL, '2025-11-02 19:39:32.000000', '2025-11-04 18:51:40.000000', NULL),
(53, 53, 'PRODUCT', 2, NULL, NULL, NULL, NULL, 'DAYS', 2, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(54, 54, 'SEMI_FINISHED', 1, NULL, NULL, NULL, NULL, 'DAYS', 1, NULL, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(55, 55, 'RAW', 1, 8, 12000.00, NULL, NULL, 'HOURS', 6, NULL, '2025-11-04 19:47:36.000000', '2025-11-04 19:47:36.000000', NULL),
(56, 56, 'CONSUMABLE', 9, 8, 500.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:12:49.000000', '2025-11-04 20:12:49.000000', NULL),
(57, 57, 'CONSUMABLE', 9, 8, 1000.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:13:13.000000', '2025-11-04 20:13:13.000000', NULL),
(58, 58, 'CONSUMABLE', 9, 8, 2000.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:13:44.000000', '2025-11-04 20:13:44.000000', NULL),
(59, 59, 'CONSUMABLE', 9, 8, 2000.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:14:08.000000', '2025-11-04 20:14:08.000000', NULL),
(60, 60, 'CONSUMABLE', 9, 8, 500.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:14:32.000000', '2025-11-04 20:14:51.000000', NULL),
(61, 61, 'CONSUMABLE', 9, 8, 1000.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:17:12.000000', '2025-11-04 20:17:12.000000', NULL),
(62, 62, 'CONSUMABLE', 9, 8, 2000.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:17:53.000000', '2025-11-04 20:17:53.000000', NULL),
(63, 63, 'CONSUMABLE', 9, 8, 1000.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:18:15.000000', '2025-11-04 20:18:15.000000', NULL),
(64, 64, 'CONSUMABLE', 9, 0, 0.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:19:12.000000', '2025-11-04 20:19:39.000000', NULL),
(65, 65, 'CONSUMABLE', 9, 0, 0.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:19:29.000000', '2025-11-04 20:19:29.000000', NULL),
(66, 66, 'CONSUMABLE', 9, 8, 1000.00, NULL, NULL, '', 0, NULL, '2025-11-04 20:20:04.000000', '2025-11-04 20:20:04.000000', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `kds_material_expiries`
--

DROP TABLE IF EXISTS `kds_material_expiries`;
CREATE TABLE `kds_material_expiries` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL,
  `material_id` int UNSIGNED NOT NULL,
  `batch_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `opened_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `status` enum('ACTIVE','USED','DISCARDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `handler_id` int UNSIGNED DEFAULT NULL,
  `handled_at` datetime(6) DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `kds_material_translations`
--

DROP TABLE IF EXISTS `kds_material_translations`;
CREATE TABLE `kds_material_translations` (
  `id` int UNSIGNED NOT NULL,
  `material_id` int UNSIGNED NOT NULL,
  `language_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '语言代码 (zh-CN, es-ES)',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '物料名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 物料翻译表';

--
-- 转存表中的数据 `kds_material_translations`
--

INSERT INTO `kds_material_translations` (`id`, `material_id`, `language_code`, `material_name`) VALUES
(1, 1, 'zh-CN', '蔗糖'),
(2, 1, 'es-ES', 'Azúcar de caña'),
(3, 2, 'zh-CN', '直饮水'),
(4, 2, 'es-ES', 'Agua potable'),
(5, 3, 'zh-CN', '冰块'),
(6, 3, 'es-ES', 'Hielo'),
(7, 4, 'zh-CN', '茉莉绿茶叶'),
(8, 4, 'es-ES', 'Hojas de Té Verde Jazmín'),
(9, 5, 'zh-CN', '2号滇红红茶叶'),
(10, 5, 'es-ES', 'Hojas de Té Negro Dianhong N2'),
(11, 6, 'zh-CN', '抹茶粉'),
(12, 6, 'es-ES', 'Matcha en polvo'),
(13, 7, 'zh-CN', '炼乳'),
(14, 7, 'es-ES', 'Leche condensada'),
(15, 8, 'zh-CN', '纯牛奶'),
(16, 8, 'es-ES', 'Leche Entera'),
(17, 9, 'zh-CN', '基底乳'),
(18, 9, 'es-ES', 'Base Láctea'),
(19, 10, 'zh-CN', '布蕾粉'),
(20, 10, 'es-ES', 'Polvo de Crème Brûlée'),
(21, 11, 'zh-CN', '淡奶油'),
(22, 11, 'es-ES', 'Nata para montar'),
(23, 12, 'zh-CN', '茉莉绿茶'),
(24, 12, 'es-ES', 'Té Verde Jazmín (Preparado)'),
(25, 13, 'zh-CN', '2号滇红红茶'),
(26, 13, 'es-ES', 'Té Negro Dianhong N2 (Preparado)'),
(27, 14, 'zh-CN', '抹茶液'),
(28, 14, 'es-ES', 'Matcha Líquido (para topping)'),
(29, 15, 'zh-CN', '冰水'),
(30, 15, 'es-ES', 'Agua Helada'),
(31, 16, 'zh-CN', '布蕾蛋糕酱'),
(32, 16, 'es-ES', 'Salsa de Tarta Brûlée'),
(33, 17, 'zh-CN', '咸奶酪奶盖'),
(34, 17, 'es-ES', 'Mousse de Queso Salado'),
(35, 18, 'zh-CN', '芝士奶盖'),
(36, 18, 'es-ES', 'Mousse de Queso'),
(37, 19, 'zh-CN', '开心果芝士奶盖'),
(38, 19, 'es-ES', 'Mousse de Queso y Pistacho'),
(39, 20, 'zh-CN', '马斯卡彭奶酪'),
(40, 20, 'es-ES', 'Queso Mascarpone'),
(41, 21, 'zh-CN', '海盐'),
(42, 21, 'es-ES', 'Sal marina'),
(43, 22, 'zh-CN', '珍珠 (生)'),
(44, 22, 'es-ES', 'Perlas de Tapioca (Cruda)'),
(45, 23, 'zh-CN', '黑糖粉'),
(46, 23, 'es-ES', 'Azúcar moreno en polvo'),
(47, 24, 'zh-CN', '血糯米 (生)'),
(48, 24, 'es-ES', 'Arroz glutinoso negro (Crudo)'),
(49, 25, 'zh-CN', '白砂糖'),
(50, 25, 'es-ES', 'Azúcar blanco'),
(51, 26, 'zh-CN', '芝士'),
(52, 26, 'es-ES', 'Queso Crema'),
(53, 27, 'zh-CN', '开心果酱'),
(54, 27, 'es-ES', 'Pasta de Pistacho'),
(55, 28, 'zh-CN', '红糖粉'),
(56, 28, 'es-ES', 'Polvo de Azúcar Morena (Topping)'),
(57, 29, 'zh-CN', '桃子果肉'),
(58, 29, 'es-ES', 'Pulpa de Melocotón'),
(59, 30, 'zh-CN', '脆波波'),
(60, 30, 'es-ES', 'Boba Crispy'),
(61, 31, 'zh-CN', '蜜桃汁'),
(62, 31, 'es-ES', 'Zumo de Melocotón'),
(63, 32, 'zh-CN', '芒果果粒'),
(64, 32, 'es-ES', 'Trozos de Mango'),
(65, 33, 'zh-CN', '芒果酱'),
(66, 33, 'es-ES', 'Salsa de Mango'),
(67, 34, 'zh-CN', '葡萄果肉'),
(68, 34, 'es-ES', 'Pulpa de Uva'),
(69, 35, 'zh-CN', '葡萄汁'),
(70, 35, 'es-ES', 'Zumo de Uva'),
(71, 36, 'zh-CN', '草莓果肉'),
(72, 36, 'es-ES', 'Pulpa de Fresa'),
(73, 37, 'zh-CN', '草莓酱'),
(74, 37, 'es-ES', 'Salsa de Fresa'),
(75, 38, 'zh-CN', '桑葚果肉'),
(76, 38, 'es-ES', 'Pulpa de Mora'),
(77, 39, 'zh-CN', '桑葚酱'),
(78, 39, 'es-ES', 'Salsa de Mora'),
(79, 40, 'zh-CN', '黑糖珍珠'),
(80, 40, 'es-ES', 'Perlas de Azúcar Moreno'),
(81, 41, 'zh-CN', '血糯米'),
(82, 41, 'es-ES', 'Arroz glutinoso cocido'),
(83, 42, 'zh-CN', '抹茶汁'),
(84, 42, 'es-ES', 'Zumo de Matcha'),
(85, 43, 'zh-CN', '百香果'),
(86, 43, 'es-ES', 'Maracuyá fresca'),
(87, 44, 'zh-CN', '黄柠檬'),
(88, 44, 'es-ES', 'Limón Amarillo'),
(89, 45, 'zh-CN', '百香果酱'),
(90, 45, 'es-ES', 'Salsa de Maracuyá'),
(91, 46, 'zh-CN', '橙肉'),
(92, 46, 'es-ES', 'Pulpa de Naranja'),
(93, 47, 'zh-CN', '橙片'),
(94, 47, 'es-ES', 'Rodaja de Naranja'),
(95, 48, 'zh-CN', '橙汁'),
(96, 48, 'es-ES', 'Zumo de Naranja'),
(97, 49, 'zh-CN', '西瓜'),
(98, 49, 'es-ES', 'Sandía'),
(99, 50, 'zh-CN', '椰奶'),
(100, 50, 'es-ES', 'Leche de Coco'),
(101, 51, 'zh-CN', '西柚肉'),
(102, 51, 'es-ES', 'Pulpa de Pomelo'),
(103, 52, 'zh-CN', '牛油果肉'),
(104, 52, 'es-ES', 'Pulpa de Aguacate'),
(105, 53, 'zh-CN', '椰青水'),
(106, 53, 'es-ES', 'Agua de Coco'),
(107, 54, 'zh-CN', '大红豆'),
(108, 54, 'es-ES', 'Judía Roja Grande'),
(109, 55, 'zh-CN', '小西米'),
(110, 55, 'es-ES', 'Sagú'),
(111, 56, 'zh-CN', '90-700注塑细磨砂杯'),
(112, 56, 'es-ES', 'Vaso inyectado de PP esmerilado fino (90-700ml)'),
(113, 57, 'zh-CN', '90注塑磨砂防漏盖-白色'),
(114, 57, 'es-ES', 'Tapa inyectada de PP esmerilada antiderrame (90mm) - Blanca'),
(115, 58, 'zh-CN', 'PLA12*230粗吸管'),
(116, 58, 'es-ES', 'Pajita gruesa de PLA (12x230mm)'),
(117, 59, 'zh-CN', 'PLA6*230细吸管'),
(118, 59, 'es-ES', 'Pajita fina de PLA (6x230mm)'),
(119, 60, 'zh-CN', '90-160Z双层中空杯纸杯'),
(120, 60, 'es-ES', 'Vaso de papel de doble capa hueca (90-160Z)'),
(121, 61, 'zh-CN', '90卡扣盖-白色(热饮盖)'),
(122, 61, 'es-ES', 'Tapa de cierre a presión (90mm) - Blanca (para bebidas calientes)'),
(123, 62, 'zh-CN', '单杯塑料袋(背心袋)'),
(124, 62, 'es-ES', 'Bolsa de plástico individual (tipo camiseta)'),
(125, 63, 'zh-CN', '双杯塑料袋(背心袋)'),
(126, 63, 'es-ES', 'Bolsa de plástico doble (tipo camiseta)'),
(127, 64, 'zh-CN', '单杯无纺布袋'),
(128, 64, 'es-ES', 'Bolsa de tela no tejida individual'),
(129, 65, 'zh-CN', '双杯无纺布袋'),
(130, 65, 'es-ES', 'Bolsa de tela no tejida doble'),
(131, 66, 'zh-CN', '白色 瓦楞双层杯套'),
(132, 66, 'es-ES', 'Funda de cartón corrugado de doble capa - Blanca');

-- --------------------------------------------------------

--
-- 表的结构 `kds_products`
--

DROP TABLE IF EXISTS `kds_products`;
CREATE TABLE `kds_products` (
  `id` int UNSIGNED NOT NULL,
  `product_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产品唯一编码 (P-Code)',
  `status_id` int UNSIGNED NOT NULL,
  `category_id` int UNSIGNED DEFAULT NULL,
  `product_qr_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '预留给二维码数据',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否上架',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL,
  `is_deleted_flag` int UNSIGNED NOT NULL DEFAULT '0' COMMENT '用于软删除唯一约束的辅助列'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 产品主表';

--
-- 转存表中的数据 `kds_products`
--

INSERT INTO `kds_products` (`id`, `product_code`, `status_id`, `category_id`, `product_qr_code`, `is_active`, `created_at`, `updated_at`, `deleted_at`, `is_deleted_flag`) VALUES
(1, 'A1', 1, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(2, 'A2', 1, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(3, 'A3', 3, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(4, 'A4', 1, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(5, 'B5', 1, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(6, 'B6', 1, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(7, 'C7', 1, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(8, 'D8', 3, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(9, 'D9', 3, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(10, 'D10', 3, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(11, 'D11', 3, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(12, 'D12', 3, NULL, NULL, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL, 0),
(13, 'E13', 1, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(14, 'E14', 1, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(15, 'E15', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(16, 'E16', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(17, 'E17', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(18, 'E18', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(19, 'E19', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(20, 'E20', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(21, 'F21', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(22, 'F22', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(23, 'F23', 3, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(24, 'G24', 1, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(25, 'G25', 1, NULL, NULL, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL, 0),
(26, 'G26', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(27, 'H27', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(28, 'H28', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(29, 'H29', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(30, 'H30', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(31, 'H31', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(32, 'I32', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(33, 'I33', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(34, 'I34', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0),
(35, 'I35', 1, NULL, NULL, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL, 0);

--
-- 触发器 `kds_products`
--
DROP TRIGGER IF EXISTS `before_product_soft_delete`;
DELIMITER $$
CREATE TRIGGER `before_product_soft_delete` BEFORE UPDATE ON `kds_products` FOR EACH ROW BEGIN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        SET NEW.is_deleted_flag = OLD.id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_adjustments`
--

DROP TABLE IF EXISTS `kds_product_adjustments`;
CREATE TABLE `kds_product_adjustments` (
  `id` int UNSIGNED NOT NULL,
  `product_id` int UNSIGNED NOT NULL COMMENT '关联的产品ID',
  `option_type` enum('sweetness','ice') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项类型 (甜度或冰度)',
  `option_id` int UNSIGNED NOT NULL COMMENT '关联的选项ID (来自 kds_sweetness_options 或 kds_ice_options)',
  `material_id` int UNSIGNED NOT NULL COMMENT '需要调整用量的物料ID (如糖浆, 冰块)',
  `quantity` decimal(10,2) NOT NULL COMMENT '该选项下的物料用量',
  `unit_id` int UNSIGNED NOT NULL COMMENT '用量的单位ID',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 产品动态用量调整表';

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_categories`
--

DROP TABLE IF EXISTS `kds_product_categories`;
CREATE TABLE `kds_product_categories` (
  `id` int UNSIGNED NOT NULL,
  `parent_id` int UNSIGNED DEFAULT NULL COMMENT '父分类ID, NULL表示顶级分类',
  `sort_order` int DEFAULT '0' COMMENT '排序字段',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 产品分类主表';

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_category_translations`
--

DROP TABLE IF EXISTS `kds_product_category_translations`;
CREATE TABLE `kds_product_category_translations` (
  `id` int UNSIGNED NOT NULL,
  `category_id` int UNSIGNED NOT NULL,
  `language_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '语言代码 (zh-CN, es-ES)',
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 产品分类翻译表';

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_ice_options`
--

DROP TABLE IF EXISTS `kds_product_ice_options`;
CREATE TABLE `kds_product_ice_options` (
  `product_id` int UNSIGNED NOT NULL,
  `ice_option_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品与冰量选项的关联表';

--
-- 转存表中的数据 `kds_product_ice_options`
--

INSERT INTO `kds_product_ice_options` (`product_id`, `ice_option_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(1, 2),
(2, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(13, 2),
(14, 2),
(24, 2),
(25, 2),
(26, 2),
(27, 2),
(28, 2),
(29, 2),
(30, 2),
(31, 2),
(32, 2),
(33, 2),
(34, 2),
(35, 2),
(1, 3),
(2, 3),
(4, 3),
(5, 3),
(6, 3),
(7, 3),
(13, 3),
(14, 3),
(24, 3),
(25, 3),
(26, 3),
(27, 3),
(28, 3),
(29, 3),
(30, 3),
(31, 3),
(32, 3),
(33, 3),
(34, 3),
(35, 3),
(1, 4),
(2, 4),
(4, 4),
(5, 4),
(6, 4),
(7, 4),
(24, 4),
(25, 4),
(27, 4),
(28, 4),
(29, 4),
(31, 4),
(32, 4),
(33, 4),
(34, 4),
(35, 4);

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_recipes`
--

DROP TABLE IF EXISTS `kds_product_recipes`;
CREATE TABLE `kds_product_recipes` (
  `id` int UNSIGNED NOT NULL,
  `product_id` int UNSIGNED NOT NULL,
  `material_id` int UNSIGNED NOT NULL,
  `unit_id` int UNSIGNED NOT NULL,
  `quantity` decimal(10,2) NOT NULL COMMENT '数量',
  `step_category` enum('base','mixing','topping') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '步骤分类: 底料, 调杯, 顶料',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '同一分类内的排序',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 产品结构化制作步骤';

--
-- 转存表中的数据 `kds_product_recipes`
--

INSERT INTO `kds_product_recipes` (`id`, `product_id`, `material_id`, `unit_id`, `quantity`, `step_category`, `sort_order`, `created_at`, `updated_at`) VALUES
(18, 3, 40, 1, 80.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(19, 3, 16, 1, 30.00, 'base', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(20, 3, 42, 2, 80.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(21, 3, 11, 1, 40.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(22, 3, 1, 1, 40.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(23, 3, 3, 1, 250.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(24, 3, 16, 1, 30.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(25, 3, 28, 1, 2.00, 'topping', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(26, 4, 40, 1, 80.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(27, 4, 16, 1, 40.00, 'base', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(28, 4, 13, 2, 200.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(29, 4, 8, 2, 100.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(30, 4, 9, 2, 40.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(31, 4, 1, 1, 30.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(32, 4, 3, 1, 200.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(33, 5, 8, 2, 100.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(34, 5, 1, 1, 30.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(35, 5, 3, 1, 200.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(36, 5, 12, 2, 250.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(37, 5, 17, 1, 70.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(38, 6, 8, 2, 180.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(39, 6, 9, 2, 30.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(40, 6, 1, 1, 30.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(41, 6, 3, 1, 200.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(42, 6, 42, 2, 60.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(43, 6, 17, 1, 70.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(44, 7, 41, 1, 80.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(45, 7, 13, 2, 250.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(46, 7, 8, 2, 80.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(47, 7, 9, 2, 40.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(48, 7, 1, 1, 30.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(49, 7, 3, 1, 200.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(50, 8, 29, 1, 30.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(51, 8, 30, 1, 30.00, 'base', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(52, 8, 31, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(53, 8, 29, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(54, 8, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(55, 8, 1, 1, 45.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(56, 8, 3, 1, 210.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(57, 8, 18, 1, 60.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(58, 9, 32, 1, 40.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(59, 9, 30, 1, 30.00, 'base', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(60, 9, 33, 1, 15.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(61, 9, 32, 1, 80.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(62, 9, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(63, 9, 1, 1, 45.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(64, 9, 3, 1, 210.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(65, 9, 18, 1, 60.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(66, 10, 34, 1, 40.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(67, 10, 30, 1, 30.00, 'base', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(68, 10, 35, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(69, 10, 34, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(70, 10, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(71, 10, 1, 1, 40.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(72, 10, 3, 1, 210.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(73, 10, 18, 1, 60.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(74, 11, 36, 1, 40.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(75, 11, 30, 1, 30.00, 'base', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(76, 11, 37, 1, 15.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(77, 11, 36, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(78, 11, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(79, 11, 1, 1, 45.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(80, 11, 3, 1, 210.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(81, 11, 18, 1, 60.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(82, 12, 38, 1, 20.00, 'base', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(83, 12, 30, 1, 30.00, 'base', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(84, 12, 39, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(85, 12, 38, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(86, 12, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(87, 12, 1, 1, 50.00, 'mixing', 40, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(88, 12, 3, 1, 230.00, 'mixing', 50, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(89, 12, 18, 1, 60.00, 'topping', 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(105, 15, 30, 1, 50.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(106, 15, 49, 1, 150.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(107, 15, 50, 1, 90.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(108, 15, 12, 2, 80.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(109, 15, 1, 1, 45.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(110, 15, 3, 1, 250.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(111, 16, 51, 1, 10.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(112, 16, 30, 1, 20.00, 'base', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(113, 16, 32, 1, 30.00, 'base', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(114, 16, 33, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(115, 16, 32, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(116, 16, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(117, 16, 1, 1, 40.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(118, 16, 3, 1, 250.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(119, 17, 30, 1, 30.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(120, 17, 34, 1, 40.00, 'base', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(121, 17, 35, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(122, 17, 34, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(123, 17, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(124, 17, 1, 1, 40.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(125, 17, 3, 1, 250.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(126, 18, 38, 1, 20.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(127, 18, 30, 1, 30.00, 'base', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(128, 18, 39, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(129, 18, 38, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(130, 18, 36, 1, 30.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(131, 18, 12, 2, 100.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(132, 18, 1, 1, 50.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(133, 18, 3, 1, 250.00, 'mixing', 60, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(134, 19, 30, 1, 30.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(135, 19, 32, 1, 30.00, 'base', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(136, 19, 50, 2, 70.00, 'base', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(137, 19, 33, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(138, 19, 32, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(139, 19, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(140, 19, 1, 1, 40.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(141, 19, 3, 1, 250.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(142, 20, 30, 1, 30.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(143, 20, 29, 1, 40.00, 'base', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(144, 20, 31, 1, 20.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(145, 20, 29, 1, 60.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(146, 20, 12, 2, 100.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(147, 20, 1, 1, 45.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(148, 20, 3, 1, 250.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(149, 21, 52, 1, 15.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(150, 21, 52, 1, 80.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(151, 21, 36, 1, 50.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(152, 21, 8, 2, 180.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(153, 21, 1, 1, 40.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(154, 21, 3, 1, 220.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(155, 22, 52, 1, 15.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(156, 22, 52, 1, 80.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(157, 22, 8, 2, 200.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(158, 22, 1, 1, 45.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(159, 22, 3, 1, 200.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(160, 23, 32, 1, 40.00, 'base', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(161, 23, 50, 2, 50.00, 'base', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(162, 23, 52, 1, 70.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(163, 23, 8, 2, 130.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(164, 23, 50, 2, 70.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(165, 23, 1, 1, 40.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(166, 23, 3, 1, 200.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(167, 24, 12, 2, 220.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(168, 24, 8, 2, 50.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(169, 24, 9, 2, 60.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(170, 24, 1, 1, 40.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(171, 24, 3, 1, 150.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(172, 25, 12, 2, 200.00, 'mixing', 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(173, 25, 31, 1, 12.00, 'mixing', 20, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(174, 25, 8, 2, 50.00, 'mixing', 30, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(175, 25, 9, 2, 50.00, 'mixing', 40, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(176, 25, 1, 1, 25.00, 'mixing', 50, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(177, 25, 3, 1, 150.00, 'mixing', 60, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(178, 26, 36, 1, 60.00, 'base', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(179, 26, 37, 1, 10.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(180, 26, 8, 2, 50.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(181, 26, 9, 2, 60.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(182, 26, 1, 1, 35.00, 'mixing', 40, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(183, 26, 2, 2, 100.00, 'mixing', 50, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(184, 26, 3, 1, 150.00, 'mixing', 60, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(185, 27, 12, 2, 300.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(186, 27, 1, 1, 35.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(187, 27, 3, 1, 200.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(188, 27, 18, 1, 70.00, 'topping', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(189, 28, 13, 2, 300.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(190, 28, 1, 1, 35.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(191, 28, 3, 1, 200.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(192, 28, 18, 1, 70.00, 'topping', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(193, 29, 42, 2, 45.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(194, 29, 1, 1, 25.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(195, 29, 9, 2, 40.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(196, 29, 8, 2, 100.00, 'mixing', 40, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(197, 29, 2, 2, 100.00, 'mixing', 50, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(198, 29, 3, 1, 200.00, 'mixing', 60, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(199, 29, 18, 1, 50.00, 'topping', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(200, 30, 53, 2, 300.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(201, 30, 1, 1, 10.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(202, 30, 3, 1, 200.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(203, 30, 19, 1, 70.00, 'topping', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(204, 31, 12, 2, 300.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(205, 31, 1, 1, 35.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(206, 31, 3, 1, 200.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(207, 31, 19, 1, 70.00, 'topping', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(208, 32, 40, 1, 100.00, 'base', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(209, 32, 13, 2, 200.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(210, 32, 8, 2, 100.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(211, 32, 9, 2, 40.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(212, 32, 1, 1, 30.00, 'mixing', 40, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(213, 32, 3, 1, 200.00, 'mixing', 50, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(214, 33, 30, 1, 50.00, 'base', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(215, 33, 40, 1, 60.00, 'base', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(216, 33, 12, 2, 230.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(217, 33, 8, 2, 100.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(218, 33, 9, 2, 40.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(219, 33, 1, 1, 35.00, 'mixing', 40, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(220, 33, 3, 1, 200.00, 'mixing', 50, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(221, 34, 50, 2, 150.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(222, 34, 8, 2, 80.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(223, 34, 1, 1, 35.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(224, 34, 2, 2, 100.00, 'mixing', 40, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(225, 34, 3, 1, 200.00, 'mixing', 50, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(226, 34, 42, 2, 70.00, 'mixing', 60, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(227, 35, 9, 2, 60.00, 'mixing', 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(228, 35, 8, 2, 130.00, 'mixing', 20, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(229, 35, 1, 1, 40.00, 'mixing', 30, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(230, 35, 2, 2, 140.00, 'mixing', 40, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(231, 35, 3, 1, 200.00, 'mixing', 50, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(232, 35, 42, 2, 75.00, 'mixing', 60, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(242, 13, 43, 1, 30.00, 'base', 1, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(243, 13, 33, 1, 10.00, 'mixing', 2, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(244, 13, 32, 1, 50.00, 'base', 3, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(245, 13, 45, 1, 10.00, 'mixing', 4, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(246, 13, 44, 1, 15.00, 'base', 5, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(247, 13, 12, 2, 180.00, 'mixing', 6, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(248, 13, 15, 2, 100.00, 'mixing', 7, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(249, 13, 1, 1, 60.00, 'mixing', 8, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(250, 13, 3, 1, 255.00, 'mixing', 9, '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(251, 14, 46, 1, 40.00, 'base', 1, '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(252, 14, 48, 1, 15.00, 'mixing', 2, '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(253, 14, 47, 1, 80.00, 'base', 3, '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(254, 14, 12, 2, 180.00, 'mixing', 4, '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(255, 14, 1, 1, 40.00, 'mixing', 5, '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(256, 14, 3, 1, 295.00, 'mixing', 6, '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(363, 2, 40, 1, 80.00, 'base', 1, '2025-11-13 22:12:54.119705', '2025-11-13 22:12:54.119705'),
(364, 2, 8, 2, 200.00, 'mixing', 2, '2025-11-13 22:12:54.119946', '2025-11-13 22:12:54.119946'),
(365, 2, 16, 1, 30.00, 'topping', 3, '2025-11-13 22:12:54.120181', '2025-11-13 22:12:54.120181'),
(366, 2, 16, 1, 30.00, 'base', 4, '2025-11-13 22:12:54.120385', '2025-11-13 22:12:54.120385'),
(367, 2, 1, 1, 30.00, 'mixing', 5, '2025-11-13 22:12:54.120596', '2025-11-13 22:12:54.120596'),
(368, 2, 28, 1, 2.00, 'topping', 6, '2025-11-13 22:12:54.120855', '2025-11-13 22:12:54.120855'),
(369, 2, 3, 1, 200.00, 'mixing', 7, '2025-11-13 22:12:54.121081', '2025-11-13 22:12:54.121081'),
(370, 2, 42, 2, 80.00, 'mixing', 8, '2025-11-13 22:12:54.121306', '2025-11-13 22:12:54.121306'),
(389, 1, 40, 1, 80.00, 'base', 1, '2026-01-02 22:18:21.090951', '2026-01-02 22:18:21.090951'),
(390, 1, 13, 2, 200.00, 'mixing', 2, '2026-01-02 22:18:21.091208', '2026-01-02 22:18:21.091208'),
(391, 1, 16, 1, 30.00, 'topping', 3, '2026-01-02 22:18:21.091436', '2026-01-02 22:18:21.091436'),
(392, 1, 16, 1, 30.00, 'base', 4, '2026-01-02 22:18:21.091665', '2026-01-02 22:18:21.091665'),
(393, 1, 8, 2, 70.00, 'mixing', 5, '2026-01-02 22:18:21.091889', '2026-01-02 22:18:21.091889'),
(394, 1, 28, 1, 2.00, 'topping', 6, '2026-01-02 22:18:21.092115', '2026-01-02 22:18:21.092115'),
(395, 1, 9, 2, 40.00, 'mixing', 7, '2026-01-02 22:18:21.092344', '2026-01-02 22:18:21.092344'),
(396, 1, 1, 1, 30.00, 'mixing', 8, '2026-01-02 22:18:21.092568', '2026-01-02 22:18:21.092568'),
(397, 1, 3, 1, 200.00, 'mixing', 9, '2026-01-02 22:18:21.092797', '2026-01-02 22:18:21.092797');

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_statuses`
--

DROP TABLE IF EXISTS `kds_product_statuses`;
CREATE TABLE `kds_product_statuses` (
  `id` int UNSIGNED NOT NULL,
  `status_code` smallint UNSIGNED NOT NULL COMMENT '产品状态自定义编号 (1-2位)',
  `status_name_zh` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态名称 (中)',
  `status_name_es` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态名称 (西)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 产品状态管理';

--
-- 转存表中的数据 `kds_product_statuses`
--

INSERT INTO `kds_product_statuses` (`id`, `status_code`, `status_name_zh`, `status_name_es`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '正常销售', 'En Venta', '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(2, 2, '估清', 'Agotado', '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(3, 3, '冰沙', 'Smoothie', '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_sweetness_options`
--

DROP TABLE IF EXISTS `kds_product_sweetness_options`;
CREATE TABLE `kds_product_sweetness_options` (
  `product_id` int UNSIGNED NOT NULL,
  `sweetness_option_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品与甜度选项的关联表';

--
-- 转存表中的数据 `kds_product_sweetness_options`
--

INSERT INTO `kds_product_sweetness_options` (`product_id`, `sweetness_option_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 2),
(22, 2),
(23, 2),
(24, 2),
(25, 2),
(26, 2),
(27, 2),
(28, 2),
(29, 2),
(30, 2),
(31, 2),
(32, 2),
(33, 2),
(34, 2),
(35, 2),
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(5, 3),
(6, 3),
(7, 3),
(8, 3),
(9, 3),
(10, 3),
(11, 3),
(12, 3),
(13, 3),
(14, 3),
(15, 3),
(16, 3),
(17, 3),
(18, 3),
(19, 3),
(20, 3),
(21, 3),
(22, 3),
(23, 3),
(24, 3),
(25, 3),
(26, 3),
(27, 3),
(28, 3),
(29, 3),
(30, 3),
(31, 3),
(32, 3),
(33, 3),
(34, 3),
(35, 3),
(1, 4),
(2, 4),
(4, 4),
(5, 4),
(6, 4),
(7, 4),
(13, 4),
(14, 4),
(24, 4),
(25, 4),
(26, 4),
(27, 4),
(28, 4),
(29, 4),
(30, 4),
(31, 4),
(32, 4),
(33, 4),
(34, 4),
(35, 4),
(1, 5),
(2, 5),
(4, 5),
(5, 5),
(6, 5),
(7, 5),
(13, 5),
(14, 5),
(24, 5),
(25, 5),
(26, 5),
(27, 5),
(28, 5),
(29, 5),
(30, 5),
(31, 5),
(32, 5),
(33, 5),
(34, 5),
(35, 5);

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_translations`
--

DROP TABLE IF EXISTS `kds_product_translations`;
CREATE TABLE `kds_product_translations` (
  `id` int UNSIGNED NOT NULL,
  `product_id` int UNSIGNED NOT NULL,
  `language_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '语言代码 (zh-CN, es-ES)',
  `product_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 产品翻译表';

--
-- 转存表中的数据 `kds_product_translations`
--

INSERT INTO `kds_product_translations` (`id`, `product_id`, `language_code`, `product_name`) VALUES
(1, 1, 'zh-CN', '烤布蕾黑糖啵啵奶茶'),
(2, 1, 'es-ES', 'Té con Leche Boba Brown Sugar y Brûlée'),
(3, 2, 'zh-CN', '烤布蕾黑糖啵啵抹茶'),
(4, 2, 'es-ES', 'Matcha Boba Brown Sugar y Brûlée'),
(5, 3, 'zh-CN', '布蕾黑糖啵啵抹茶冰'),
(6, 3, 'es-ES', 'Smoothie Matcha Boba Brown Sugar y Brûlée'),
(7, 4, 'zh-CN', '布蕾蛋糕黑糖珍珠奶茶'),
(8, 4, 'es-ES', 'Té con Leche Perlas Brown Sugar y Tarta Brûlée'),
(9, 5, 'zh-CN', '咸奶酪茉莉鲜奶茶'),
(10, 5, 'es-ES', 'Té Verde Jazmín con Leche Fresca y Mousse Salada'),
(11, 6, 'zh-CN', '咸奶酪抹茶鲜奶茶'),
(12, 6, 'es-ES', 'Té Matcha con Leche Fresca y Mousse Salada'),
(13, 7, 'zh-CN', '血糯米奶茶'),
(14, 7, 'es-ES', 'Té con Leche y Arroz Glutinoso Negro'),
(15, 8, 'zh-CN', '芝芝桃桃'),
(16, 8, 'es-ES', 'Smoothie de Melocotón con Mousse de Queso'),
(17, 9, 'zh-CN', '芝芝芒芒'),
(18, 9, 'es-ES', 'Smoothie de Mango con Mousse de Queso'),
(19, 10, 'zh-CN', '芝芝葡萄'),
(20, 10, 'es-ES', 'Smoothie de Uva con Mousse de Queso'),
(21, 11, 'zh-CN', '芝芝草莓'),
(22, 11, 'es-ES', 'Smoothie de Fresa con Mousse de Queso'),
(23, 12, 'zh-CN', '芝芝桑葚'),
(24, 12, 'es-ES', 'Smoothie de Mora con Mousse de Queso'),
(25, 13, 'zh-CN', '百香芒芒'),
(26, 13, 'es-ES', 'Maracuyá y Mango'),
(27, 14, 'zh-CN', '暴打鲜橙'),
(28, 14, 'es-ES', 'Naranja Fresca Prensada'),
(29, 15, 'zh-CN', '西瓜椰椰 (沙冰)'),
(30, 15, 'es-ES', 'Smoothie de Sandía y Coco'),
(31, 16, 'zh-CN', '杨枝甘露 (沙冰)'),
(32, 16, 'es-ES', 'Smoothie Mango Pomelo Sago'),
(33, 17, 'zh-CN', '多肉葡萄 (沙冰)'),
(34, 17, 'es-ES', 'Smoothie de Uva con Pulpa'),
(35, 18, 'zh-CN', '桑葚草莓 (沙冰)'),
(36, 18, 'es-ES', 'Smoothie de Mora y Fresa'),
(37, 19, 'zh-CN', '生辉芒芒 (沙冰)'),
(38, 19, 'es-ES', 'Smoothie de Mango Brillante'),
(39, 20, 'zh-CN', '多肉蜜桃 (沙冰)'),
(40, 20, 'es-ES', 'Smoothie de Melocotón con Pulpa'),
(41, 21, 'zh-CN', '牛油果套套'),
(42, 21, 'es-ES', 'Batido de Aguacate y Fresa'),
(43, 22, 'zh-CN', '牛油果鲜奶昔'),
(44, 22, 'es-ES', 'Batido de Aguacate y Leche'),
(45, 23, 'zh-CN', '牛油果甘露'),
(46, 23, 'es-ES', 'Batido de Aguacate y Mango (Estilo \'Mango Sago\')'),
(47, 24, 'zh-CN', '茉莉轻乳茶'),
(48, 24, 'es-ES', 'Té con Leche Ligero de Jazmín'),
(49, 25, 'zh-CN', '白桃轻乳茶'),
(50, 25, 'es-ES', 'Té con Leche Ligero de Melocotón Blanco'),
(51, 26, 'zh-CN', '草莓轻乳'),
(52, 26, 'es-ES', 'Té con Leche Ligero de Fresa'),
(53, 27, 'zh-CN', '芝芝茉莉'),
(54, 27, 'es-ES', 'Té de Jazmín con Mousse de Queso'),
(55, 28, 'zh-CN', '芝芝红茶'),
(56, 28, 'es-ES', 'Té Negro con Mousse de Queso'),
(57, 29, 'zh-CN', '芝芝抹茶'),
(58, 29, 'es-ES', 'Matcha con Mousse de Queso'),
(59, 30, 'zh-CN', '开心果芝芝'),
(60, 30, 'es-ES', 'Agua de Coco con Mousse de Pistacho'),
(61, 31, 'zh-CN', '开心果芝芝茉莉'),
(62, 31, 'es-ES', 'Té de Jazmín con Mousse de Pistacho'),
(63, 32, 'zh-CN', '黑糖珍珠奶茶'),
(64, 32, 'es-ES', 'Té con Leche y Perlas Brown Sugar'),
(65, 33, 'zh-CN', '双蛋波波奶茶'),
(66, 33, 'es-ES', 'Té con Leche y Doble Boba'),
(67, 34, 'zh-CN', '抹茶椰椰'),
(68, 34, 'es-ES', 'Matcha Coco'),
(69, 35, 'zh-CN', '抹茶轻乳茶'),
(70, 35, 'es-ES', 'Té Matcha con Leche Ligero');

-- --------------------------------------------------------

--
-- 表的结构 `kds_recipe_adjustments`
--

DROP TABLE IF EXISTS `kds_recipe_adjustments`;
CREATE TABLE `kds_recipe_adjustments` (
  `id` int UNSIGNED NOT NULL,
  `product_id` int UNSIGNED NOT NULL COMMENT '关联 kds_products.id',
  `material_id` int UNSIGNED NOT NULL COMMENT '要调整的物料ID',
  `cup_id` int UNSIGNED DEFAULT NULL COMMENT '条件: 杯型ID',
  `sweetness_option_id` int UNSIGNED DEFAULT NULL COMMENT '条件: 甜度选项ID',
  `ice_option_id` int UNSIGNED DEFAULT NULL COMMENT '条件: 冰量选项ID',
  `quantity` decimal(10,2) NOT NULL COMMENT '结果: 该条件下物料的最终用量',
  `unit_id` int UNSIGNED NOT NULL COMMENT '用量的单位ID',
  `step_category` enum('base','mixing','topping') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '结果: 覆盖步骤分类',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 配方动态调整规则表';

--
-- 转存表中的数据 `kds_recipe_adjustments`
--

INSERT INTO `kds_recipe_adjustments` (`id`, `product_id`, `material_id`, `cup_id`, `sweetness_option_id`, `ice_option_id`, `quantity`, `unit_id`, `step_category`, `created_at`, `updated_at`) VALUES
(33, 4, 13, NULL, NULL, 2, 250.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(34, 4, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(35, 4, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(36, 4, 13, NULL, NULL, 3, 280.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(37, 4, 8, NULL, NULL, 3, 120.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(38, 4, 9, NULL, NULL, 3, 45.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(39, 4, 1, NULL, NULL, 3, 35.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(40, 4, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(41, 4, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(42, 4, 8, NULL, NULL, 4, 150.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(43, 4, 9, NULL, NULL, 4, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(44, 4, 13, NULL, NULL, 4, 200.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(45, 4, 1, NULL, NULL, 4, 30.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(46, 4, 2, NULL, NULL, 4, 120.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(47, 4, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(48, 5, 12, NULL, NULL, 2, 260.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(49, 5, 1, NULL, NULL, 2, 35.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(50, 5, 8, NULL, NULL, 2, 110.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(51, 5, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(52, 5, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(53, 5, 12, NULL, NULL, 3, 280.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(54, 5, 1, NULL, NULL, 3, 40.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(55, 5, 8, NULL, NULL, 3, 120.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(56, 5, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(57, 5, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(58, 5, 12, NULL, NULL, 4, 280.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(59, 5, 1, NULL, NULL, 4, 40.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(60, 5, 8, NULL, NULL, 4, 150.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(61, 5, 2, NULL, NULL, 4, 30.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(62, 5, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(63, 6, 8, NULL, NULL, 2, 200.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(64, 6, 1, NULL, NULL, 2, 35.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(65, 6, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(66, 6, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(67, 6, 8, NULL, NULL, 3, 250.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(68, 6, 9, NULL, NULL, 3, 40.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(69, 6, 1, NULL, NULL, 3, 40.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(70, 6, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(71, 6, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(72, 6, 42, NULL, NULL, 4, 65.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(73, 6, 8, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(74, 6, 9, NULL, NULL, 4, 40.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(75, 6, 2, NULL, NULL, 4, 30.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(76, 6, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(77, 7, 13, NULL, NULL, 2, 280.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(78, 7, 8, NULL, NULL, 2, 100.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(79, 7, 9, NULL, NULL, 2, 45.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(80, 7, 1, NULL, NULL, 2, 35.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(81, 7, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(82, 7, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(83, 7, 13, NULL, NULL, 3, 300.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(84, 7, 8, NULL, NULL, 3, 110.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(85, 7, 9, NULL, NULL, 3, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(86, 7, 1, NULL, NULL, 3, 40.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(87, 7, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(88, 7, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(89, 7, 8, NULL, NULL, 4, 110.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(90, 7, 9, NULL, NULL, 4, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(91, 7, 1, NULL, NULL, 4, 35.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(92, 7, 13, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(93, 7, 2, NULL, NULL, 4, 50.00, 2, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(94, 7, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000'),
(95, 24, 12, NULL, NULL, 2, 230.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(96, 24, 8, NULL, NULL, 2, 55.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(97, 24, 9, NULL, NULL, 2, 65.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(98, 24, 1, NULL, NULL, 2, 45.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(99, 24, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(100, 24, 3, NULL, NULL, 2, 100.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(101, 24, 12, NULL, NULL, 3, 250.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(102, 24, 8, NULL, NULL, 3, 60.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(103, 24, 9, NULL, NULL, 3, 70.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(104, 24, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(105, 24, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(106, 24, 12, NULL, NULL, 4, 200.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(107, 24, 8, NULL, NULL, 4, 60.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(108, 24, 9, NULL, NULL, 4, 60.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(109, 24, 1, NULL, NULL, 4, 30.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(110, 24, 2, NULL, NULL, 4, 100.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(111, 24, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(112, 25, 12, NULL, NULL, 2, 220.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(113, 25, 8, NULL, NULL, 2, 55.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(114, 25, 9, NULL, NULL, 2, 55.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(115, 25, 1, NULL, NULL, 2, 30.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(116, 25, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(117, 25, 3, NULL, NULL, 2, 100.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(118, 25, 12, NULL, NULL, 3, 250.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(119, 25, 31, NULL, NULL, 3, 15.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(120, 25, 8, NULL, NULL, 3, 60.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(121, 25, 9, NULL, NULL, 3, 60.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(122, 25, 1, NULL, NULL, 3, 35.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(123, 25, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(124, 25, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(125, 25, 8, NULL, NULL, 4, 55.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(126, 25, 9, NULL, NULL, 4, 55.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(127, 25, 1, NULL, NULL, 4, 30.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(128, 25, 2, NULL, NULL, 4, 50.00, 2, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(129, 25, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000'),
(130, 26, 8, NULL, NULL, 2, 55.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(131, 26, 9, NULL, NULL, 2, 65.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(132, 26, 1, NULL, NULL, 2, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(133, 26, 2, NULL, NULL, 2, 150.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(134, 26, 3, NULL, NULL, 2, 100.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(135, 26, 37, NULL, NULL, 3, 15.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(136, 26, 36, NULL, NULL, 3, 70.00, 1, 'base', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(137, 26, 8, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(138, 26, 9, NULL, NULL, 3, 70.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(139, 26, 1, NULL, NULL, 3, 45.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(140, 26, 2, NULL, NULL, 3, 180.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(141, 26, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(142, 27, 1, NULL, NULL, 2, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(143, 27, 2, NULL, NULL, 2, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(144, 27, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(145, 27, 12, NULL, NULL, 3, 350.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(146, 27, 1, NULL, NULL, 3, 45.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(147, 27, 2, NULL, NULL, 3, 100.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(148, 27, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(149, 27, 1, NULL, NULL, 4, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(150, 27, 2, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(151, 27, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(152, 28, 1, NULL, NULL, 2, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(153, 28, 2, NULL, NULL, 2, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(154, 28, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(155, 28, 13, NULL, NULL, 3, 350.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(156, 28, 1, NULL, NULL, 3, 45.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(157, 28, 2, NULL, NULL, 3, 100.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(158, 28, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(159, 28, 1, NULL, NULL, 4, 30.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(160, 28, 2, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(161, 28, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(162, 29, 42, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(163, 29, 1, NULL, NULL, 2, 30.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(164, 29, 8, NULL, NULL, 2, 120.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(165, 29, 2, NULL, NULL, 2, 150.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(166, 29, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(167, 29, 42, NULL, NULL, 3, 55.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(168, 29, 1, NULL, NULL, 3, 35.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(169, 29, 9, NULL, NULL, 3, 50.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(170, 29, 8, NULL, NULL, 3, 150.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(171, 29, 2, NULL, NULL, 3, 200.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(172, 29, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(173, 29, 18, NULL, NULL, 3, 60.00, 1, 'topping', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(174, 29, 42, NULL, NULL, 4, 55.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(175, 29, 9, NULL, NULL, 4, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(176, 29, 8, NULL, NULL, 4, 150.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(177, 29, 2, NULL, NULL, 4, 300.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(178, 29, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(179, 30, 1, NULL, NULL, 2, 15.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(180, 30, 2, NULL, NULL, 2, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(181, 30, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(182, 30, 53, NULL, NULL, 3, 350.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(183, 30, 1, NULL, NULL, 3, 20.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(184, 30, 2, NULL, NULL, 3, 100.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(185, 30, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(186, 31, 1, NULL, NULL, 2, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(187, 31, 2, NULL, NULL, 2, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(188, 31, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(189, 31, 12, NULL, NULL, 3, 350.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(190, 31, 1, NULL, NULL, 3, 45.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(191, 31, 2, NULL, NULL, 3, 100.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(192, 31, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(193, 31, 1, NULL, NULL, 4, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(194, 31, 2, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(195, 31, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(196, 32, 13, NULL, NULL, 2, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(197, 32, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(198, 32, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(199, 32, 13, NULL, NULL, 3, 280.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(200, 32, 8, NULL, NULL, 3, 120.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(201, 32, 9, NULL, NULL, 3, 45.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(202, 32, 1, NULL, NULL, 3, 35.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(203, 32, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(204, 32, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(205, 32, 8, NULL, NULL, 4, 150.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(206, 32, 9, NULL, NULL, 4, 50.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(207, 32, 2, NULL, NULL, 4, 120.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(208, 32, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(209, 33, 12, NULL, NULL, 2, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(210, 33, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(211, 33, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(212, 33, 12, NULL, NULL, 3, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(213, 33, 8, NULL, NULL, 3, 120.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(214, 33, 9, NULL, NULL, 3, 45.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(215, 33, 1, NULL, NULL, 3, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(216, 33, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(217, 33, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(218, 33, 12, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(219, 33, 8, NULL, NULL, 4, 120.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(220, 33, 9, NULL, NULL, 4, 50.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(221, 33, 1, NULL, NULL, 4, 25.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(222, 33, 2, NULL, NULL, 4, 100.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(223, 33, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(224, 34, 42, NULL, NULL, 2, 75.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(225, 34, 50, NULL, NULL, 2, 160.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(226, 34, 8, NULL, NULL, 2, 100.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(227, 34, 2, NULL, NULL, 2, 130.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(228, 34, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(229, 34, 42, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(230, 34, 50, NULL, NULL, 3, 170.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(231, 34, 1, NULL, NULL, 3, 40.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(232, 34, 8, NULL, NULL, 3, 100.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(233, 34, 2, NULL, NULL, 3, 150.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(234, 34, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(235, 34, 42, NULL, NULL, 4, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(236, 34, 50, NULL, NULL, 4, 200.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(237, 34, 2, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(238, 34, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(239, 35, 42, NULL, NULL, 2, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(240, 35, 9, NULL, NULL, 2, 70.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(241, 35, 2, NULL, NULL, 2, 180.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(242, 35, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(243, 35, 42, NULL, NULL, 3, 90.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(244, 35, 1, NULL, NULL, 3, 45.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(245, 35, 9, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(246, 35, 8, NULL, NULL, 3, 160.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(247, 35, 2, NULL, NULL, 3, 250.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(248, 35, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(249, 35, 42, NULL, NULL, 4, 90.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(250, 35, 9, NULL, NULL, 4, 80.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(251, 35, 8, NULL, NULL, 4, 160.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(252, 35, 2, NULL, NULL, 4, 300.00, 2, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(253, 35, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000'),
(281, 13, 3, NULL, NULL, 2, 205.00, 1, 'mixing', '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(282, 13, 15, NULL, NULL, 2, 180.00, 2, 'mixing', '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(283, 13, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(284, 13, 12, NULL, NULL, 3, 230.00, 2, 'mixing', '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(285, 13, 15, NULL, NULL, 3, 200.00, 2, 'mixing', '2025-11-03 12:14:00.000000', '2025-11-03 12:14:00.000000'),
(286, 14, 3, NULL, NULL, 2, 245.00, 1, 'mixing', '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(287, 14, 2, NULL, NULL, 2, 80.00, 2, 'mixing', '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(288, 14, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(289, 14, 12, NULL, NULL, 3, 230.00, 2, 'mixing', '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(290, 14, 2, NULL, NULL, 3, 100.00, 2, 'mixing', '2025-11-03 12:14:12.000000', '2025-11-03 12:14:12.000000'),
(491, 2, 8, NULL, NULL, 2, 210.00, 2, 'mixing', '2025-11-13 22:12:54.123641', '2025-11-13 22:12:54.123641'),
(492, 2, 1, NULL, NULL, 2, 35.00, 1, 'mixing', '2025-11-13 22:12:54.123901', '2025-11-13 22:12:54.123901'),
(493, 2, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2025-11-13 22:12:54.124123', '2025-11-13 22:12:54.124123'),
(494, 2, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2025-11-13 22:12:54.124344', '2025-11-13 22:12:54.124344'),
(495, 2, 42, NULL, NULL, 2, 80.00, 2, 'mixing', '2025-11-13 22:12:54.124583', '2025-11-13 22:12:54.124583'),
(496, 2, 8, NULL, NULL, 3, 230.00, 2, 'mixing', '2025-11-13 22:12:54.124815', '2025-11-13 22:12:54.124815'),
(497, 2, 1, NULL, NULL, 3, 40.00, 1, 'mixing', '2025-11-13 22:12:54.125044', '2025-11-13 22:12:54.125044'),
(498, 2, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-13 22:12:54.125284', '2025-11-13 22:12:54.125284'),
(499, 2, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2025-11-13 22:12:54.125504', '2025-11-13 22:12:54.125504'),
(500, 2, 42, NULL, NULL, 3, 80.00, 2, 'mixing', '2025-11-13 22:12:54.125748', '2025-11-13 22:12:54.125748'),
(501, 2, 8, NULL, NULL, 4, 250.00, 2, 'mixing', '2025-11-13 22:12:54.125960', '2025-11-13 22:12:54.125960'),
(502, 2, 1, NULL, NULL, 4, 30.00, 1, 'mixing', '2025-11-13 22:12:54.126175', '2025-11-13 22:12:54.126175'),
(503, 2, 2, NULL, NULL, 4, 50.00, 2, 'mixing', '2025-11-13 22:12:54.126412', '2025-11-13 22:12:54.126412'),
(504, 2, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2025-11-13 22:12:54.126626', '2025-11-13 22:12:54.126626'),
(505, 2, 42, NULL, NULL, 4, 85.00, 2, 'mixing', '2025-11-13 22:12:54.126818', '2025-11-13 22:12:54.126818'),
(540, 1, 13, NULL, NULL, 2, 220.00, 2, 'mixing', '2026-01-02 22:18:21.094954', '2026-01-02 22:18:21.094954'),
(541, 1, 8, NULL, NULL, 2, 80.00, 2, 'mixing', '2026-01-02 22:18:21.095225', '2026-01-02 22:18:21.095225'),
(542, 1, 1, NULL, NULL, 2, 35.00, 1, 'mixing', '2026-01-02 22:18:21.095466', '2026-01-02 22:18:21.095466'),
(543, 1, 2, NULL, NULL, 2, 50.00, 2, 'mixing', '2026-01-02 22:18:21.095709', '2026-01-02 22:18:21.095709'),
(544, 1, 3, NULL, NULL, 2, 150.00, 1, 'mixing', '2026-01-02 22:18:21.095946', '2026-01-02 22:18:21.095946'),
(545, 1, 13, NULL, NULL, 3, 250.00, 2, 'mixing', '2026-01-02 22:18:21.096189', '2026-01-02 22:18:21.096189'),
(546, 1, 8, NULL, NULL, 3, 100.00, 2, 'mixing', '2026-01-02 22:18:21.096444', '2026-01-02 22:18:21.096444'),
(547, 1, 9, NULL, NULL, 3, 45.00, 2, 'mixing', '2026-01-02 22:18:21.096681', '2026-01-02 22:18:21.096681'),
(548, 1, 1, NULL, NULL, 3, 40.00, 1, 'mixing', '2026-01-02 22:18:21.096920', '2026-01-02 22:18:21.096920'),
(549, 1, 2, NULL, NULL, 3, 80.00, 2, 'mixing', '2026-01-02 22:18:21.097151', '2026-01-02 22:18:21.097151'),
(550, 1, 3, NULL, NULL, 3, 0.00, 1, 'mixing', '2026-01-02 22:18:21.097397', '2026-01-02 22:18:21.097397'),
(551, 1, 13, NULL, NULL, 4, 250.00, 2, 'mixing', '2026-01-02 22:18:21.097636', '2026-01-02 22:18:21.097636'),
(552, 1, 8, NULL, NULL, 4, 100.00, 2, 'mixing', '2026-01-02 22:18:21.097871', '2026-01-02 22:18:21.097871'),
(553, 1, 9, NULL, NULL, 4, 50.00, 2, 'mixing', '2026-01-02 22:18:21.098148', '2026-01-02 22:18:21.098148'),
(554, 1, 1, NULL, NULL, 4, 35.00, 1, 'mixing', '2026-01-02 22:18:21.098388', '2026-01-02 22:18:21.098388'),
(555, 1, 2, NULL, NULL, 4, 50.00, 2, 'mixing', '2026-01-02 22:18:21.098639', '2026-01-02 22:18:21.098639'),
(556, 1, 3, NULL, NULL, 4, 0.00, 1, 'mixing', '2026-01-02 22:18:21.098878', '2026-01-02 22:18:21.098878');

-- --------------------------------------------------------

--
-- 表的结构 `kds_sop_query_rules`
--

DROP TABLE IF EXISTS `kds_sop_query_rules`;
CREATE TABLE `kds_sop_query_rules` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED DEFAULT NULL COMMENT '适用的门店ID, NULL = 全局规则',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则名称 (e.g., KDS内部码, 门店A二维码)',
  `priority` int NOT NULL DEFAULT '100' COMMENT '解析优先级, 数字越小越先尝试',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `extractor_type` enum('DELIMITER','KEY_VALUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DELIMITER' COMMENT '解析器类型',
  `config_json` json NOT NULL COMMENT '解析器配置',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS SOP 查询码解析规则表 (V5.0)';

--
-- 转存表中的数据 `kds_sop_query_rules`
--

INSERT INTO `kds_sop_query_rules` (`id`, `store_id`, `rule_name`, `priority`, `is_active`, `extractor_type`, `config_json`, `created_at`, `updated_at`) VALUES
(1, NULL, 'KDS 内部标准格式 (P-A-M-T)', 999, 1, '', '{\"mapping\": {\"a\": \"A\", \"m\": \"M\", \"p\": \"P\", \"t\": \"T\", \"ord\": \"ORD\"}, \"template\": \"{P}-{M}-{A}-{T}\"}', '2025-11-05 11:54:41.000000', '2025-11-07 00:22:24.000000');

-- --------------------------------------------------------

--
-- 表的结构 `kds_stores`
--

DROP TABLE IF EXISTS `kds_stores`;
CREATE TABLE `kds_stores` (
  `id` int UNSIGNED NOT NULL,
  `store_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '门店码 (e.g., A1001)',
  `store_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '门店名称',
  `invoice_prefix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '票号前缀 (e.g., S1)',
  `tax_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '门店税号 (NIF/CIF)，用于票据合规',
  `default_vat_rate` decimal(5,2) NOT NULL DEFAULT '10.00' COMMENT '门店默认增值税率(%)',
  `store_city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所在城市',
  `store_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '详细地址',
  `store_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `store_cif` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'CIF/税号',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL,
  `billing_system` enum('TICKETBAI','VERIFACTU','NONE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'NONE' COMMENT '该门店使用的票据合规系统',
  `eod_cutoff_hour` int NOT NULL DEFAULT '3',
  `pr_receipt_type` enum('NONE','WIFI','BLUETOOTH','USB') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NONE' COMMENT '角色1: 小票打印机类型',
  `pr_receipt_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色1: IP地址',
  `pr_receipt_port` int DEFAULT NULL COMMENT '角色1: 端口',
  `pr_receipt_mac` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色1: 蓝牙MAC',
  `pr_sticker_type` enum('NONE','WIFI','BLUETOOTH','USB') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NONE' COMMENT '角色2: 杯贴打印机类型',
  `pr_sticker_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色2: IP地址',
  `pr_sticker_port` int DEFAULT NULL COMMENT '角色2: 端口',
  `pr_sticker_mac` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色2: 蓝牙MAC',
  `pr_kds_type` enum('NONE','WIFI','BLUETOOTH','USB') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NONE' COMMENT '角色3: KDS厨房/效期打印机',
  `pr_kds_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色3: IP地址',
  `pr_kds_port` int DEFAULT NULL COMMENT '角色3: 端口',
  `pr_kds_mac` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色3: 蓝牙MAC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 门店表';

--
-- 转存表中的数据 `kds_stores`
--

INSERT INTO `kds_stores` (`id`, `store_code`, `store_name`, `invoice_prefix`, `tax_id`, `default_vat_rate`, `store_city`, `store_address`, `store_phone`, `store_cif`, `is_active`, `created_at`, `updated_at`, `deleted_at`, `billing_system`, `eod_cutoff_hour`, `pr_receipt_type`, `pr_receipt_ip`, `pr_receipt_port`, `pr_receipt_mac`, `pr_sticker_type`, `pr_sticker_ip`, `pr_sticker_port`, `pr_sticker_mac`, `pr_kds_type`, `pr_kds_ip`, `pr_kds_port`, `pr_kds_mac`) VALUES
(1, 'A1001', 'TopTea 演示门店', 'A1', 'B12345678', 10.00, 'MADRID', NULL, NULL, NULL, 1, '2025-10-24 00:00:09.000000', '2025-11-11 00:32:14.000000', NULL, 'NONE', 1, 'NONE', NULL, NULL, NULL, 'NONE', NULL, NULL, NULL, 'NONE', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `kds_sweetness_options`
--

DROP TABLE IF EXISTS `kds_sweetness_options`;
CREATE TABLE `kds_sweetness_options` (
  `id` int UNSIGNED NOT NULL,
  `sweetness_code` smallint UNSIGNED NOT NULL COMMENT '甜度自定义编号 (1-2位)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 甜度选项管理';

--
-- 转存表中的数据 `kds_sweetness_options`
--

INSERT INTO `kds_sweetness_options` (`id`, `sweetness_code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(2, 2, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(3, 3, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(4, 4, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(5, 5, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `kds_sweetness_option_translations`
--

DROP TABLE IF EXISTS `kds_sweetness_option_translations`;
CREATE TABLE `kds_sweetness_option_translations` (
  `id` int UNSIGNED NOT NULL,
  `sweetness_option_id` int UNSIGNED NOT NULL,
  `language_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sweetness_option_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sop_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 甜度选项翻译表';

--
-- 转存表中的数据 `kds_sweetness_option_translations`
--

INSERT INTO `kds_sweetness_option_translations` (`id`, `sweetness_option_id`, `language_code`, `sweetness_option_name`, `sop_description`) VALUES
(1, 1, 'zh-CN', '正常糖', '正常糖'),
(2, 1, 'es-ES', 'Azúcar Normal', 'Azúcar Normal'),
(3, 2, 'zh-CN', '七分糖', '七分糖'),
(4, 2, 'es-ES', '70% Azúcar', '70% Azúcar'),
(5, 3, 'zh-CN', '五分糖', '五分糖'),
(6, 3, 'es-ES', '50% Azúcar', '50% Azúcar'),
(7, 4, 'zh-CN', '三分糖', '三分糖'),
(8, 4, 'es-ES', '30% Azúcar', '30% Azúcar'),
(9, 5, 'zh-CN', '不另外加糖', '不另外加糖'),
(10, 5, 'es-ES', 'Sin Azúcar Añadido', 'Sin Azúcar Añadido');

-- --------------------------------------------------------

--
-- 表的结构 `kds_units`
--

DROP TABLE IF EXISTS `kds_units`;
CREATE TABLE `kds_units` (
  `id` int UNSIGNED NOT NULL,
  `unit_code` smallint UNSIGNED NOT NULL COMMENT '单位自定义编号 (1-2位)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 单位字典主表';

--
-- 转存表中的数据 `kds_units`
--

INSERT INTO `kds_units` (`id`, `unit_code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(2, 2, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(3, 3, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(4, 4, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(5, 5, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(6, 6, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(7, 7, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(8, 8, '2025-11-04 19:11:31.000000', '2025-11-04 19:11:31.000000', NULL),
(9, 9, '2025-11-04 20:12:05.000000', '2025-11-04 20:12:05.000000', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `kds_unit_translations`
--

DROP TABLE IF EXISTS `kds_unit_translations`;
CREATE TABLE `kds_unit_translations` (
  `id` int UNSIGNED NOT NULL,
  `unit_id` int UNSIGNED NOT NULL,
  `language_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '语言代码 (zh-CN, es-ES)',
  `unit_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '单位名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 单位翻译表';

--
-- 转存表中的数据 `kds_unit_translations`
--

INSERT INTO `kds_unit_translations` (`id`, `unit_id`, `language_code`, `unit_name`) VALUES
(1, 1, 'zh-CN', 'g'),
(2, 1, 'es-ES', 'g'),
(3, 2, 'zh-CN', 'ml'),
(4, 2, 'es-ES', 'ml'),
(5, 3, 'zh-CN', 'L'),
(6, 3, 'es-ES', 'L'),
(7, 4, 'zh-CN', 'kg'),
(8, 4, 'es-ES', 'kg'),
(9, 5, 'zh-CN', '块'),
(10, 5, 'es-ES', 'cubo'),
(11, 6, 'zh-CN', '片'),
(12, 6, 'es-ES', 'pieza'),
(13, 7, 'zh-CN', '份'),
(14, 7, 'es-ES', 'porción'),
(15, 8, 'zh-CN', '箱'),
(16, 8, 'es-ES', 'Caja'),
(17, 9, 'zh-CN', '个'),
(18, 9, 'es-ES', 'Pieza');

-- --------------------------------------------------------

--
-- 表的结构 `kds_users`
--

DROP TABLE IF EXISTS `kds_users`;
CREATE TABLE `kds_users` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL COMMENT '关联的门店ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显示名称',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'staff' COMMENT '角色 (e.g., staff, manager)',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_login_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 用户表';

--
-- 转存表中的数据 `kds_users`
--

INSERT INTO `kds_users` (`id`, `store_id`, `username`, `password_hash`, `display_name`, `role`, `is_active`, `last_login_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'kds_user', '$2y$12$sHNAsvmOswKuq4m6PB.SZO6jGLjFT2EAq2C5iG31Ghwcyu3uAc9S2', 'KDS Staff3', 'staff', 1, '2025-11-22 12:57:12.000000', '2025-10-24 00:00:09.000000', '2026-01-26 15:54:37.556086', NULL),
(2, 1, '11', '4fc82b26aecb47d2868c4efbe3581732a3e7cbcc6c2efb32062c08170a05eeb8', '22', 'staff', 1, NULL, '2025-11-05 20:40:52.000000', '2025-11-05 20:40:58.000000', '2025-11-05 20:40:58.000000');

-- --------------------------------------------------------

--
-- 表的结构 `member_passes`
--

DROP TABLE IF EXISTS `member_passes`;
CREATE TABLE `member_passes` (
  `member_pass_id` int UNSIGNED NOT NULL COMMENT '会员持卡ID',
  `member_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pos_members.id',
  `pass_plan_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pass_plans.pass_plan_id',
  `topup_order_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 topup_orders.topup_order_id (来源订单)',
  `total_uses` int UNSIGNED NOT NULL COMMENT '总次数 (快照)',
  `remaining_uses` int UNSIGNED NOT NULL COMMENT '剩余次数',
  `purchase_amount` decimal(10,2) NOT NULL COMMENT '购卡支付金额 (分摊基准)',
  `unit_allocated_base` decimal(10,2) NOT NULL COMMENT '单位分摊基准价 [cite: 97]',
  `status` enum('active','suspended','revoked','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '卡状态 [cite: 35]',
  `store_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 kds_stores.id (激活门店)',
  `device_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '激活设备ID',
  `activated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `expires_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: 会员持卡表';

--
-- 转存表中的数据 `member_passes`
--

INSERT INTO `member_passes` (`member_pass_id`, `member_id`, `pass_plan_id`, `topup_order_id`, `total_uses`, `remaining_uses`, `purchase_amount`, `unit_allocated_base`, `status`, `store_id`, `device_id`, `activated_at`, `expires_at`) VALUES
(1, 1, 1, 7, 50, 47, 300.00, 6.00, 'active', 1, NULL, '2025-11-19 10:54:50.000000', '2026-05-21 02:00:19.000000'),
(4, 7, 1, 8, 10, 10, 60.00, 6.00, 'suspended', 1, '0', '2025-11-22 13:18:55.000000', '2026-05-21 13:18:55.000000');

-- --------------------------------------------------------

--
-- 表的结构 `pass_daily_usage`
--

DROP TABLE IF EXISTS `pass_daily_usage`;
CREATE TABLE `pass_daily_usage` (
  `id` int UNSIGNED NOT NULL,
  `member_pass_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 member_passes.member_pass_id',
  `usage_date` date NOT NULL COMMENT '使用日期 (按Madrid时区计算的日期, 存储为UTC日期) [cite: 40]',
  `uses_count` int UNSIGNED NOT NULL DEFAULT '0' COMMENT '当日已用次数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: 次卡每日用量统计 (防超限)';

--
-- 转存表中的数据 `pass_daily_usage`
--

INSERT INTO `pass_daily_usage` (`id`, `member_pass_id`, `usage_date`, `uses_count`) VALUES
(1, 1, '2025-11-19', 2),
(3, 1, '2025-11-20', 1);

-- --------------------------------------------------------

--
-- 表的结构 `pass_plans`
--

DROP TABLE IF EXISTS `pass_plans`;
CREATE TABLE `pass_plans` (
  `pass_plan_id` int UNSIGNED NOT NULL COMMENT '次卡方案ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '方案名称 (e.g., 10次奶茶卡)',
  `name_zh` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '中文名称',
  `name_es` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '西班牙语名称',
  `total_uses` int UNSIGNED NOT NULL COMMENT '总可用次数',
  `validity_days` int UNSIGNED NOT NULL COMMENT '有效期(天数)',
  `max_uses_per_order` int UNSIGNED NOT NULL DEFAULT '1' COMMENT '单笔订单最大核销次数 [cite: 31]',
  `max_uses_per_day` int UNSIGNED NOT NULL DEFAULT '0' COMMENT '单日最大核销次数 (0=不限) [cite: 31]',
  `allocation_strategy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'last_adjust' COMMENT '分摊策略 (默认: 尾差法) [cite: 31, 97]',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否激活 (可售)',
  `auto_activate` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=需后台审核, 1=购买后自动激活',
  `sale_sku` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'FK, 关联 kds_products.product_code (售卖SKU)',
  `sale_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '售价(欧元)',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '备注说明',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: 次卡方案定义表';

--
-- 转存表中的数据 `pass_plans`
--

INSERT INTO `pass_plans` (`pass_plan_id`, `name`, `name_zh`, `name_es`, `total_uses`, `validity_days`, `max_uses_per_order`, `max_uses_per_day`, `allocation_strategy`, `is_active`, `auto_activate`, `sale_sku`, `sale_price`, `notes`, `created_at`, `updated_at`) VALUES
(1, '10次奶茶卡', '10次奶茶卡', '10次奶茶卡', 10, 180, 1, 0, 'last_adjust', 1, 0, 'PASS10', 60.00, NULL, '2025-11-16 17:31:47.166457', '2025-11-21 13:22:52.719044');

-- --------------------------------------------------------

--
-- 表的结构 `pass_redemptions`
--

DROP TABLE IF EXISTS `pass_redemptions`;
CREATE TABLE `pass_redemptions` (
  `redemption_id` int UNSIGNED NOT NULL COMMENT '核销明细ID (每杯)',
  `batch_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pass_redemption_batches.batch_id',
  `member_pass_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 member_passes.member_pass_id',
  `order_id` int UNSIGNED DEFAULT NULL COMMENT 'FK, 关联 pos_invoices.id (TP税票ID, 0元核销时为NULL)',
  `order_item_id` int UNSIGNED DEFAULT NULL COMMENT 'FK, 关联 pos_invoice_items.id (对应单品, 0元核销时为NULL)',
  `sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商品SKU (快照)',
  `invoice_series` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '税票系列 (TP) [cite: 38]',
  `invoice_number` bigint UNSIGNED NOT NULL COMMENT '税票编号 [cite: 38]',
  `covered_amount` decimal(10,2) NOT NULL COMMENT '卡支付分摊金额 (税基1) [cite: 38, 66]',
  `extra_charge` decimal(10,2) NOT NULL COMMENT '额外付费 (加料/差价) (税基2) [cite: 38, 66]',
  `redeemed_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `store_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 kds_stores.id (核销门店)',
  `device_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '核销设备ID',
  `cashier_user_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 kds_users.id (核销员工)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: 次卡核销明细表 (每杯)';

--
-- 转存表中的数据 `pass_redemptions`
--

INSERT INTO `pass_redemptions` (`redemption_id`, `batch_id`, `member_pass_id`, `order_id`, `order_item_id`, `sku_id`, `invoice_series`, `invoice_number`, `covered_amount`, `extra_charge`, `redeemed_at`, `store_id`, `device_id`, `cashier_user_id`) VALUES
(1, 1, 1, NULL, NULL, 'G26', 'A1-VRY25', 4, 9.90, 0.00, '2025-11-20 01:54:05.000000', 1, '', 1),
(2, 2, 1, NULL, NULL, 'C7', 'A1-VRY25', 5, 9.90, 0.00, '2025-11-20 17:43:32.000000', 1, '', 1),
(3, 3, 1, NULL, NULL, 'H30', 'A1-VRY25', 6, 9.90, 0.00, '2025-11-21 15:00:48.000000', 1, '', 1);

-- --------------------------------------------------------

--
-- 表的结构 `pass_redemption_batches`
--

DROP TABLE IF EXISTS `pass_redemption_batches`;
CREATE TABLE `pass_redemption_batches` (
  `batch_id` int UNSIGNED NOT NULL COMMENT '核销批次ID (对应一单)',
  `member_pass_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 member_passes.member_pass_id',
  `order_id` int UNSIGNED DEFAULT NULL COMMENT 'FK, 关联 pos_invoices.id (TP税票ID, 0元核销时为NULL)',
  `redeemed_uses` int UNSIGNED NOT NULL COMMENT '本批次核销的总次数',
  `extra_charge_total` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '本批次核销的加价总额',
  `store_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 kds_stores.id (核销门店)',
  `cashier_user_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 kds_users.id (核销员工)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `idempotency_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: 次卡核销批次表 (每单)';

--
-- 转存表中的数据 `pass_redemption_batches`
--

INSERT INTO `pass_redemption_batches` (`batch_id`, `member_pass_id`, `order_id`, `redeemed_uses`, `extra_charge_total`, `store_id`, `cashier_user_id`, `created_at`, `idempotency_key`) VALUES
(1, 1, NULL, 1, 0.00, 1, 1, '2025-11-20 01:54:05.000000', '2676ded5-6d75-4b91-b807-12c5bac0b50b'),
(2, 1, NULL, 1, 0.00, 1, 1, '2025-11-20 17:43:32.000000', '4b6572c6-a712-4b8e-b6c3-c2d082ff10ea'),
(3, 1, NULL, 1, 0.00, 1, 1, '2025-11-21 15:00:48.000000', '76ed025e-dae8-4f02-a35c-c7c38d258cfb');

-- --------------------------------------------------------

--
-- 表的结构 `pos_addons`
--

DROP TABLE IF EXISTS `pos_addons`;
CREATE TABLE `pos_addons` (
  `id` int UNSIGNED NOT NULL,
  `addon_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一键 (e.g., boba)',
  `name_zh` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '中文名称',
  `name_es` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '西语名称',
  `price_eur` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `material_id` int UNSIGNED DEFAULT NULL COMMENT '关联 kds_materials.id (用于库存)',
  `sort_order` int NOT NULL DEFAULT '99',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='POS 可选小料（加料）表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_addon_tag_map`
--

DROP TABLE IF EXISTS `pos_addon_tag_map`;
CREATE TABLE `pos_addon_tag_map` (
  `addon_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pos_addons.id',
  `tag_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pos_tags.tag_id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: POS 加料与标签映射表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_categories`
--

DROP TABLE IF EXISTS `pos_categories`;
CREATE TABLE `pos_categories` (
  `id` int NOT NULL,
  `category_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name_zh` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name_es` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT '99',
  `card_bundle` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1=是次卡售卖分类(POS隐藏)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 转存表中的数据 `pos_categories`
--

INSERT INTO `pos_categories` (`id`, `category_code`, `name_zh`, `name_es`, `sort_order`, `card_bundle`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'A_BUREE', 'A. 布蕾黑糖系列', 'A. Serie Brûlée Brown Sugar', 10, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(2, 'B_CHEESE', 'B. 咸奶酪鲜奶茶', 'B. Té con Leche y Mousse Salada', 20, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(3, 'C_WINTER', 'C. 其他冬季热饮', 'C. Otras Bebidas Calientes', 30, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(4, 'D_FRUIT_CHEESE', 'D. 水果 & 芝士茶(冰沙)', 'D. Smoothie de Fruta y Queso', 40, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(5, 'E_FRUIT_TEA', 'E. 水果茶 & 冰沙', 'E. Té de Frutas y Smoothies', 50, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(6, 'F_AVOCADO', 'F. 牛油果系列', 'F. Serie Aguacate', 60, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(7, 'G_LIGHT_MILK', 'G. 轻乳茶系列', 'G. Serie Té con Leche Ligero', 70, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(8, 'H_ORIGIN_CHEESE', 'H. 原叶 & 芝士茶', 'H. Té Puro y Té con Mousse', 80, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(9, 'I_MILK_TEA', 'I. 手作奶茶系列', 'I. Serie Té con Leche Artesanal', 90, 0, '2025-11-02 19:39:32.000000', '2025-11-02 19:39:32.000000', NULL),
(11, 'TESTXXX', '测试', 'test', 99, 0, '2025-11-11 01:28:02.000000', '2025-11-11 21:13:53.153848', '2025-11-11 21:13:53.000000'),
(12, 'P_multi_pass', '优惠卡', 'Multi Pass', 99, 0, '2025-11-16 13:14:46.580881', '2025-11-16 14:44:45.550939', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `pos_coupons`
--

DROP TABLE IF EXISTS `pos_coupons`;
CREATE TABLE `pos_coupons` (
  `id` int UNSIGNED NOT NULL,
  `promotion_id` int UNSIGNED NOT NULL COMMENT '外键, 关联 pos_promotions.id',
  `coupon_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '优惠码 (大小写不敏感)',
  `coupon_usage_limit` int UNSIGNED NOT NULL DEFAULT '1' COMMENT '每个码可使用的总次数',
  `coupon_usage_count` int UNSIGNED NOT NULL DEFAULT '0' COMMENT '当前已使用次数',
  `coupon_is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS优惠券码表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_daily_tracking`
--

DROP TABLE IF EXISTS `pos_daily_tracking`;
CREATE TABLE `pos_daily_tracking` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL,
  `last_daily_reset_business_date` date DEFAULT NULL COMMENT '最后执行“每日重置”的营业日期',
  `sold_out_state_snapshot` json DEFAULT NULL COMMENT '交接班时存储的估清状态快照',
  `snapshot_taken_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS 门店每日状态追踪表';

--
-- 转存表中的数据 `pos_daily_tracking`
--

INSERT INTO `pos_daily_tracking` (`id`, `store_id`, `last_daily_reset_business_date`, `sold_out_state_snapshot`, `snapshot_taken_at`) VALUES
(1, 1, '2025-11-22', NULL, '2025-11-22 13:25:58.000000');

-- --------------------------------------------------------

--
-- 表的结构 `pos_eod_records`
--

DROP TABLE IF EXISTS `pos_eod_records`;
CREATE TABLE `pos_eod_records` (
  `id` bigint UNSIGNED NOT NULL,
  `shift_id` bigint UNSIGNED NOT NULL,
  `store_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `started_at` datetime(6) NOT NULL,
  `ended_at` datetime(6) NOT NULL,
  `starting_float` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_sales` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_in` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_out` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_refunds` decimal(10,2) NOT NULL DEFAULT '0.00',
  `expected_cash` decimal(10,2) NOT NULL DEFAULT '0.00',
  `counted_cash` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_diff` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `pos_eod_records`
--

INSERT INTO `pos_eod_records` (`id`, `shift_id`, `store_id`, `user_id`, `started_at`, `ended_at`, `starting_float`, `cash_sales`, `cash_in`, `cash_out`, `cash_refunds`, `expected_cash`, `counted_cash`, `cash_diff`, `created_at`) VALUES
(1, 1, 1, 1, '2025-11-02 19:26:12.000000', '2025-11-04 01:57:07.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-04 02:57:07.000000'),
(2, 2, 1, 1, '2025-11-04 01:57:07.000000', '2025-11-04 01:57:07.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 1.00, 0.00, '2025-11-04 02:57:07.000000'),
(3, 3, 1, 1, '2025-11-04 01:57:07.000000', '2025-11-05 20:24:51.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 1.00, 0.00, '2025-11-05 21:24:51.000000'),
(4, 4, 1, 1, '2025-11-05 20:24:51.000000', '2025-11-05 20:24:51.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 1.00, 0.00, '2025-11-05 21:24:51.000000'),
(5, 5, 1, 1, '2025-11-05 20:24:51.000000', '2025-11-06 15:53:38.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 1.00, 0.00, '2025-11-06 16:53:38.000000'),
(6, 6, 1, 1, '2025-11-06 15:53:38.000000', '2025-11-06 15:53:38.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-06 16:53:38.000000'),
(7, 7, 1, 1, '2025-11-06 15:53:38.000000', '2025-11-07 00:18:28.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-07 01:18:28.000000'),
(8, 8, 1, 1, '2025-11-07 00:18:28.000000', '2025-11-07 00:18:28.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-07 01:18:28.000000'),
(9, 9, 1, 1, '2025-11-07 00:18:28.000000', '2025-11-08 00:31:33.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-08 01:31:33.000000'),
(10, 10, 1, 1, '2025-11-08 00:31:33.000000', '2025-11-08 00:31:33.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, 0.00, '2025-11-08 01:31:33.000000'),
(11, 11, 1, 1, '2025-11-08 00:31:33.000000', '2025-11-10 02:23:41.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, 0.00, '2025-11-10 03:23:41.000000'),
(12, 12, 1, 1, '2025-11-10 02:23:41.000000', '2025-11-10 02:23:41.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-10 03:23:41.000000'),
(13, 13, 1, 1, '2025-11-10 02:23:41.000000', '2025-11-17 02:18:47.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-17 02:18:47.598816'),
(14, 14, 1, 1, '2025-11-17 02:18:47.000000', '2025-11-17 02:18:47.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-17 02:18:47.604662'),
(15, 15, 1, 1, '2025-11-17 02:18:47.000000', '2025-11-17 23:53:41.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-17 23:53:41.594560'),
(16, 16, 1, 1, '2025-11-17 23:53:41.000000', '2025-11-17 23:53:41.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-17 23:53:41.601732'),
(17, 17, 1, 1, '2025-11-17 23:53:41.000000', '2025-11-18 01:47:36.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-18 01:47:36.709378'),
(18, 18, 1, 1, '2025-11-18 01:47:36.000000', '2025-11-18 01:47:36.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-18 01:47:36.715749'),
(19, 19, 1, 1, '2025-11-18 01:47:36.000000', '2025-11-18 23:00:20.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-18 23:00:20.494457'),
(20, 20, 1, 1, '2025-11-18 23:00:20.000000', '2025-11-18 23:00:20.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:00:20.503819'),
(21, 21, 1, 1, '2025-11-18 23:00:20.000000', '2025-11-18 23:00:27.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:00:27.068412'),
(22, 22, 1, 1, '2025-11-18 23:00:27.000000', '2025-11-18 23:00:27.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:00:27.074925'),
(23, 23, 1, 1, '2025-11-18 23:00:27.000000', '2025-11-18 23:01:57.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:01:57.626703'),
(24, 24, 1, 1, '2025-11-18 23:01:57.000000', '2025-11-18 23:01:57.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:01:57.632923'),
(25, 25, 1, 1, '2025-11-18 23:01:57.000000', '2025-11-18 23:02:27.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:02:27.107017'),
(26, 26, 1, 1, '2025-11-18 23:02:27.000000', '2025-11-18 23:02:27.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:02:27.112837'),
(27, 27, 1, 1, '2025-11-18 23:02:27.000000', '2025-11-18 23:02:41.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:02:41.789582'),
(28, 28, 1, 1, '2025-11-18 23:02:41.000000', '2025-11-18 23:02:41.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:02:41.825527'),
(29, 29, 1, 1, '2025-11-18 23:02:41.000000', '2025-11-18 23:37:26.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:37:26.542270'),
(30, 30, 1, 1, '2025-11-18 23:37:26.000000', '2025-11-18 23:37:26.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:37:26.550254'),
(31, 31, 1, 1, '2025-11-18 23:37:26.000000', '2025-11-18 23:55:51.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:55:51.763492'),
(32, 32, 1, 1, '2025-11-18 23:55:51.000000', '2025-11-18 23:55:51.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-18 23:55:51.772901'),
(33, 33, 1, 1, '2025-11-18 23:55:51.000000', '2025-11-19 00:40:29.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-19 00:40:29.464982'),
(34, 34, 1, 1, '2025-11-19 00:40:29.000000', '2025-11-19 00:40:29.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-19 00:40:29.473774'),
(35, 35, 1, 1, '2025-11-19 00:40:29.000000', '2025-11-19 23:59:28.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-19 23:59:28.070985'),
(36, 36, 1, 1, '2025-11-19 23:59:28.000000', '2025-11-19 23:59:28.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-19 23:59:28.080060'),
(37, 37, 1, 1, '2025-11-19 23:59:28.000000', '2025-11-19 23:59:35.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-19 23:59:35.585506'),
(38, 38, 1, 1, '2025-11-19 23:59:35.000000', '2025-11-19 23:59:35.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-19 23:59:35.591052'),
(39, 39, 1, 1, '2025-11-19 23:59:35.000000', '2025-11-20 00:31:28.000000', 1.00, 0.00, 0.00, 0.00, 0.00, 1.00, 0.00, -1.00, '2025-11-20 00:31:28.219328'),
(40, 40, 1, 1, '2025-11-20 00:31:28.000000', '2025-11-20 00:31:28.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-20 00:31:28.229238'),
(41, 41, 1, 1, '2025-11-20 00:31:28.000000', '2025-11-21 01:24:02.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-21 01:24:02.949982'),
(42, 42, 1, 1, '2025-11-21 01:24:02.000000', '2025-11-21 01:24:02.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-21 01:24:02.958599'),
(43, 43, 1, 1, '2025-11-21 01:24:02.000000', '2025-11-22 01:59:54.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-22 01:59:54.829215'),
(44, 44, 1, 1, '2025-11-22 01:59:54.000000', '2025-11-22 01:59:54.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-22 01:59:54.843798'),
(45, 45, 1, 1, '2025-11-22 01:59:54.000000', '2025-11-22 13:25:58.000000', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-11-22 13:25:58.499511');

-- --------------------------------------------------------

--
-- 表的结构 `pos_eod_reports`
--

DROP TABLE IF EXISTS `pos_eod_reports`;
CREATE TABLE `pos_eod_reports` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL,
  `user_id` int UNSIGNED NOT NULL COMMENT '执行日结的用户ID (cpsys_users or kds_users)',
  `report_date` date NOT NULL COMMENT '报告所属日期',
  `executed_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `transactions_count` int NOT NULL DEFAULT '0',
  `system_gross_sales` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '系统计算-总销售额',
  `system_discounts` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '系统计算-总折扣',
  `system_net_sales` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '系统计算-净销售额',
  `system_tax` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '系统计算-总税额',
  `system_cash` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '系统计算-现金收款',
  `system_card` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '系统计算-刷卡收款',
  `system_platform` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '系统计算-平台收款',
  `counted_cash` decimal(10,2) NOT NULL COMMENT '清点的现金金额',
  `cash_discrepancy` decimal(10,2) NOT NULL COMMENT '现金差异 (counted - system)',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='POS每日日结报告存档表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_held_orders`
--

DROP TABLE IF EXISTS `pos_held_orders`;
CREATE TABLE `pos_held_orders` (
  `id` int NOT NULL,
  `store_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `cart_data` json NOT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用于存储POS端挂起的订单';

-- --------------------------------------------------------

--
-- 表的结构 `pos_invoices`
--

DROP TABLE IF EXISTS `pos_invoices`;
CREATE TABLE `pos_invoices` (
  `id` int UNSIGNED NOT NULL,
  `invoice_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内部全局唯一ID (UUID)',
  `store_id` int UNSIGNED NOT NULL COMMENT '外键, 关联 kds_stores.id',
  `user_id` int UNSIGNED NOT NULL COMMENT '外键, 关联 kds_users.id (收银员)',
  `shift_id` int UNSIGNED DEFAULT NULL,
  `issuer_nif` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(合规/快照) 开票方税号',
  `series` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(合规) 票据系列号',
  `number` bigint UNSIGNED NOT NULL COMMENT '(合规) 票据连续编号',
  `issued_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `invoice_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'F2' COMMENT '(合规) 票据类型, F2=简化发票, R5=简化更正票据等',
  `taxable_base` decimal(10,2) NOT NULL COMMENT '税前基数',
  `vat_amount` decimal(10,2) NOT NULL COMMENT '增值税总额',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '促销折扣总额',
  `final_total` decimal(10,2) NOT NULL COMMENT '最终含税总额',
  `status` enum('ISSUED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ISSUED' COMMENT '状态: ISSUED=已开具, CANCELLED=已作废',
  `cancellation_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '作废原因 (用于RF-anulación)',
  `correction_type` enum('S','I') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '(合规) 更正类型, S=替换, I=差额',
  `references_invoice_id` int UNSIGNED DEFAULT NULL COMMENT '外键, 指向被作废或被更正的原始票据ID',
  `compliance_system` enum('TICKETBAI','VERIFACTU') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '此票据遵循的合规系统',
  `compliance_data` json NOT NULL COMMENT '存储合规系统所需的所有凭证数据 (哈希, 签名, QR等)',
  `payment_summary` json DEFAULT NULL COMMENT '支付方式快照 (JSON)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS统一票据主表 (多系统合规-最终版)';

--
-- 触发器 `pos_invoices`
--
DROP TRIGGER IF EXISTS `before_invoice_insert`;
DELIMITER $$
CREATE TRIGGER `before_invoice_insert` BEFORE INSERT ON `pos_invoices` FOR EACH ROW BEGIN
    DECLARE store_billing_system VARCHAR(20);

    -- 从 kds_stores 表中获取对应门店的开票策略
    SELECT billing_system INTO store_billing_system
    FROM kds_stores
    WHERE id = NEW.store_id;

    -- 如果策略为 'NONE'，则拒绝插入并报错
    IF store_billing_system = 'NONE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invoicing is disabled for this store (DB Trigger). Cannot insert into pos_invoices.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `pos_invoice_counters`
--

DROP TABLE IF EXISTS `pos_invoice_counters`;
CREATE TABLE `pos_invoice_counters` (
  `id` int UNSIGNED NOT NULL,
  `invoice_prefix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '门店票号前缀 (e.g., S1)',
  `series` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '完整系列号 (e.g., S1Y25)',
  `compliance_system` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '合规系统 (TICKETBAI, VERIFACTU, NONE)',
  `current_number` bigint UNSIGNED NOT NULL DEFAULT '0' COMMENT '当前已用的最大号码',
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS 票号原子计数器';

-- --------------------------------------------------------

--
-- 表的结构 `pos_invoice_items`
--

DROP TABLE IF EXISTS `pos_invoice_items`;
CREATE TABLE `pos_invoice_items` (
  `id` int UNSIGNED NOT NULL,
  `invoice_id` int UNSIGNED NOT NULL COMMENT '外键, 关联 pos_invoices.id',
  `menu_item_id` int UNSIGNED DEFAULT NULL COMMENT '关联 pos_menu_items.id',
  `variant_id` int UNSIGNED DEFAULT NULL COMMENT '关联 pos_item_variants.id',
  `item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(快照) 商品名称',
  `variant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(快照) 规格名称',
  `item_name_zh` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name_es` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `variant_name_zh` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `variant_name_es` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price` decimal(10,2) NOT NULL COMMENT '(快照) 成交含税单价',
  `unit_taxable_base` decimal(10,2) NOT NULL COMMENT '(合规/快照) 税前单价',
  `vat_rate` decimal(5,2) NOT NULL COMMENT '(合规/快照) 增值税率',
  `vat_amount` decimal(10,2) NOT NULL COMMENT '(合规/快照) 此行项目总增值税额',
  `customizations` json DEFAULT NULL COMMENT '(快照) 个性化选项 (JSON)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS票据项目详情表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_item_variants`
--

DROP TABLE IF EXISTS `pos_item_variants`;
CREATE TABLE `pos_item_variants` (
  `id` int UNSIGNED NOT NULL,
  `menu_item_id` int UNSIGNED NOT NULL COMMENT '外键，关联 pos_menu_items.id',
  `cup_id` int UNSIGNED DEFAULT NULL COMMENT '关联 kds_cups.id',
  `variant_name_zh` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格名 (中文), 如: 中杯',
  `variant_name_es` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格名 (西语), 如: Mediano',
  `price_eur` decimal(10,2) NOT NULL COMMENT '该规格的最终售价',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为默认规格, 1=是, 0=否',
  `sort_order` int NOT NULL DEFAULT '99' COMMENT '规格的排序，越小越靠前',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS商品规格、价格与配方关联表';

--
-- 转存表中的数据 `pos_item_variants`
--

INSERT INTO `pos_item_variants` (`id`, `menu_item_id`, `cup_id`, `variant_name_zh`, `variant_name_es`, `price_eur`, `is_default`, `sort_order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-04 21:11:32.000000', NULL),
(2, 2, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(3, 3, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(4, 4, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(5, 5, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(6, 6, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(7, 7, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(8, 8, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(9, 9, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(10, 10, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(11, 11, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(12, 12, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(13, 13, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(14, 14, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(15, 15, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(16, 16, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(17, 17, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(18, 18, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(19, 19, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(20, 20, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(21, 21, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(22, 22, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(23, 23, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(24, 24, 2, '中杯', 'Mediano', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(25, 25, 2, '中杯', 'Mediano', 9.90, 1, 10, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(26, 26, 2, '中杯', 'Mediano', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(27, 27, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(28, 28, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(29, 29, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(30, 30, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(31, 31, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(32, 32, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(33, 33, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(34, 34, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(35, 35, 1, '大杯', 'Grande', 9.90, 1, 10, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(36, 37, NULL, '次卡', 'Pase', 60.00, 1, 1, '2025-11-16 17:31:47.169822', '2025-11-16 17:31:47.169822', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `pos_members`
--

DROP TABLE IF EXISTS `pos_members`;
CREATE TABLE `pos_members` (
  `id` int UNSIGNED NOT NULL,
  `member_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会员全局唯一ID',
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号 (主要查找依据)',
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名字',
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓氏',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `birthdate` date DEFAULT NULL COMMENT '会员生日',
  `points_balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '当前积分余额',
  `member_level_id` int UNSIGNED DEFAULT NULL COMMENT '外键, 关联 pos_member_levels.id',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '会员状态 (1=激活, 0=禁用)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='POS会员信息表';

--
-- 转存表中的数据 `pos_members`
--

INSERT INTO `pos_members` (`id`, `member_uuid`, `phone_number`, `first_name`, `last_name`, `email`, `birthdate`, `points_balance`, `member_level_id`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '056b3e7cd904d54617434e9a08ad72a1', '123456', NULL, NULL, NULL, NULL, 0.00, NULL, 1, '2025-11-16 20:04:58.811913', '2025-11-16 20:04:58.811913', NULL),
(7, 'bbc4a714-c961-4a6a-9284-e8c264f21ca9', '12345', NULL, NULL, NULL, NULL, 0.00, 1, 1, '2025-11-22 02:53:08.000000', '2025-11-22 02:53:08.000000', NULL),
(8, 'edd79cc6-0dbb-4836-b278-0e1841c9afe4', '1234567', NULL, NULL, NULL, NULL, 0.00, 1, 1, '2025-11-22 12:57:47.000000', '2025-11-22 12:57:47.000000', NULL),
(10, '4a0b4b0a-dd5a-4072-a456-f871d01f8c9a', '12345678', NULL, NULL, NULL, '2023-01-12', 0.00, 1, 1, '2025-11-22 12:58:44.000000', '2025-11-22 12:58:44.000000', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `pos_member_issued_coupons`
--

DROP TABLE IF EXISTS `pos_member_issued_coupons`;
CREATE TABLE `pos_member_issued_coupons` (
  `id` int UNSIGNED NOT NULL,
  `member_id` int UNSIGNED NOT NULL COMMENT '外键, 关联 pos_members.id',
  `promotion_id` int UNSIGNED NOT NULL COMMENT '外键, 关联 pos_promotions.id (优惠活动定义)',
  `coupon_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '可选的唯一码 (若有)',
  `issued_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `expires_at` datetime(6) DEFAULT NULL,
  `status` enum('ACTIVE','USED','EXPIRED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '券状态',
  `used_at` datetime(6) DEFAULT NULL,
  `used_invoice_id` int UNSIGNED DEFAULT NULL COMMENT '外键, 关联 pos_invoices.id (在哪个订单使用)',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源 (e.g., BIRTHDAY, LEVEL_UP, MANUAL)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='POS会员已发放优惠券实例表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_member_levels`
--

DROP TABLE IF EXISTS `pos_member_levels`;
CREATE TABLE `pos_member_levels` (
  `id` int UNSIGNED NOT NULL,
  `level_name_zh` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '等级名称 (中文)',
  `level_name_es` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '等级名称 (西文)',
  `points_threshold` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '达到此等级所需最低积分 (或累计消费)',
  `sort_order` int NOT NULL DEFAULT '10' COMMENT '等级排序 (数字越小越高)',
  `level_up_promo_id` int UNSIGNED DEFAULT NULL COMMENT '外键, 关联 pos_promotions.id (升级时赠送的活动)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='POS会员等级定义表';

--
-- 转存表中的数据 `pos_member_levels`
--

INSERT INTO `pos_member_levels` (`id`, `level_name_zh`, `level_name_es`, `points_threshold`, `sort_order`, `level_up_promo_id`, `created_at`, `updated_at`) VALUES
(1, '普通会员', 'Standard', 0.00, 10, NULL, '2025-11-22 02:52:27.165054', '2025-11-22 02:52:27.165054');

-- --------------------------------------------------------

--
-- 表的结构 `pos_member_points_log`
--

DROP TABLE IF EXISTS `pos_member_points_log`;
CREATE TABLE `pos_member_points_log` (
  `id` int UNSIGNED NOT NULL,
  `member_id` int UNSIGNED NOT NULL COMMENT '关联 pos_members.id',
  `invoice_id` int UNSIGNED DEFAULT NULL COMMENT '关联 pos_invoices.id (产生或消耗积分的订单)',
  `points_change` decimal(10,2) NOT NULL COMMENT '积分变动 (+表示获得, -表示消耗)',
  `reason_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变动原因代码 (e.g., PURCHASE, REDEEM_DISCOUNT, MANUAL_ADJUST, BIRTHDAY)',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注 (例如: 兑换XX商品, 管理员调整)',
  `executed_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `user_id` int UNSIGNED DEFAULT NULL COMMENT '操作人ID (关联 cpsys_users.id 或 kds_users.id)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='POS会员积分流水记录表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_menu_items`
--

DROP TABLE IF EXISTS `pos_menu_items`;
CREATE TABLE `pos_menu_items` (
  `id` int UNSIGNED NOT NULL,
  `pos_category_id` int UNSIGNED NOT NULL COMMENT '外键，关联 pos_categories.id',
  `product_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联 kds_products 的 P-Code',
  `name_zh` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品销售名 (中文)',
  `name_es` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品销售名 (西语)',
  `description_zh` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '商品描述 (中文)',
  `description_es` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '商品描述 (西语)',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商品图片URL',
  `sort_order` int NOT NULL DEFAULT '99' COMMENT '在分类中的排序，越小越靠前',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在POS上架, 1=是, 0=否',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS销售商品主表';

--
-- 转存表中的数据 `pos_menu_items`
--

INSERT INTO `pos_menu_items` (`id`, `pos_category_id`, `product_code`, `name_zh`, `name_es`, `description_zh`, `description_es`, `image_url`, `sort_order`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'A1', '烤布蕾黑糖啵啵奶茶', 'Té con Leche Boba Brown Sugar y Brûlée', NULL, NULL, NULL, 101, 1, '2025-11-02 19:40:01.000000', '2026-01-02 22:19:56.111083', NULL),
(2, 1, 'A2', '烤布蕾黑糖啵啵抹茶', 'Matcha Boba Brown Sugar y Brûlée', NULL, NULL, NULL, 102, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(3, 1, 'A3', '布蕾黑糖啵啵抹茶冰', 'Smoothie Matcha Boba Brown Sugar y Brûlée', NULL, NULL, NULL, 103, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(4, 1, 'A4', '布蕾蛋糕黑糖珍珠奶茶', 'Té con Leche Perlas Brown Sugar y Tarta Brûlée', NULL, NULL, NULL, 104, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(5, 2, 'B5', '咸奶酪茉莉鲜奶茶', 'Té Verde Jazmín con Leche Fresca y Mousse Salada', NULL, NULL, NULL, 201, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(6, 2, 'B6', '咸奶酪抹茶鲜奶茶', 'Té Matcha con Leche Fresca y Mousse Salada', NULL, NULL, NULL, 202, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(7, 3, 'C7', '血糯米奶茶', 'Té con Leche y Arroz Glutinoso Negro', NULL, NULL, NULL, 301, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(8, 4, 'D8', '芝芝桃桃', 'Smoothie de Melocotón con Mousse de Queso', NULL, NULL, NULL, 401, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(9, 4, 'D9', '芝芝芒芒', 'Smoothie de Mango con Mousse de Queso', NULL, NULL, NULL, 402, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(10, 4, 'D10', '芝芝葡萄', 'Smoothie de Uva con Mousse de Queso', NULL, NULL, NULL, 403, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(11, 4, 'D11', '芝芝草莓', 'Smoothie de Fresa con Mousse de Queso', NULL, NULL, NULL, 404, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(12, 4, 'D12', '芝芝桑葚', 'Smoothie de Mora con Mousse de Queso', NULL, NULL, NULL, 405, 1, '2025-11-02 19:40:01.000000', '2025-11-02 19:40:01.000000', NULL),
(13, 5, 'E13', '百香芒芒', 'Maracuyá y Mango', NULL, NULL, NULL, 501, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(14, 5, 'E14', '暴打鲜橙', 'Naranja Fresca Prensada', NULL, NULL, NULL, 502, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(15, 5, 'E15', '西瓜椰椰 (沙冰)', 'Smoothie de Sandía y Coco', NULL, NULL, NULL, 503, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(16, 5, 'E16', '杨枝甘露 (沙冰)', 'Smoothie Mango Pomelo Sago', NULL, NULL, NULL, 504, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(17, 5, 'E17', '多肉葡萄 (沙冰)', 'Smoothie de Uva con Pulpa', NULL, NULL, NULL, 505, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(18, 5, 'E18', '桑葚草莓 (沙冰)', 'Smoothie de Mora y Fresa', NULL, NULL, NULL, 506, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(19, 5, 'E19', '生辉芒芒 (沙冰)', 'Smoothie de Mango Brillante', NULL, NULL, NULL, 507, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(20, 5, 'E20', '多肉蜜桃 (沙冰)', 'Smoothie de Melocotón con Pulpa', NULL, NULL, NULL, 508, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(21, 6, 'F21', '牛油果套套', 'Batido de Aguacate y Fresa', NULL, NULL, NULL, 601, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(22, 6, 'F22', '牛油果鲜奶昔', 'Batido de Aguacate y Leche', NULL, NULL, NULL, 602, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(23, 6, 'F23', '牛油果甘露', 'Batido de Aguacate y Mango (Estilo \'Mango Sago\')', NULL, NULL, NULL, 603, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(24, 7, 'G24', '茉莉轻乳茶', 'Té con Leche Ligero de Jazmín', NULL, NULL, NULL, 701, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(25, 7, 'G25', '白桃轻乳茶', 'Té con Leche Ligero de Melocotón Blanco', NULL, NULL, NULL, 702, 1, '2025-11-02 19:40:09.000000', '2025-11-02 19:40:09.000000', NULL),
(26, 7, 'G26', '草莓轻乳', 'Té con Leche Ligero de Fresa', NULL, NULL, NULL, 703, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(27, 8, 'H27', '芝芝茉莉', 'Té de Jazmín con Mousse de Queso', NULL, NULL, NULL, 801, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(28, 8, 'H28', '芝芝红茶', 'Té Negro con Mousse de Queso', NULL, NULL, NULL, 802, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(29, 8, 'H29', '芝芝抹茶', 'Matcha con Mousse de Queso', NULL, NULL, NULL, 803, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(30, 8, 'H30', '开心果芝芝', 'Agua de Coco con Mousse de Pistacho', NULL, NULL, NULL, 804, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(31, 8, 'H31', '开心果芝芝茉莉', 'Té de Jazmín con Mousse de Pistacho', NULL, NULL, NULL, 805, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(32, 9, 'I32', '黑糖珍珠奶茶', 'Té con Leche y Perlas Brown Sugar', NULL, NULL, NULL, 901, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(33, 9, 'I33', '双蛋波波奶茶', 'Té con Leche y Doble Boba', NULL, NULL, NULL, 902, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(34, 9, 'I34', '抹茶椰椰', 'Matcha Coco', NULL, NULL, NULL, 903, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(35, 9, 'I35', '抹茶轻乳茶', 'Té Matcha con Leche Ligero', NULL, NULL, NULL, 904, 1, '2025-11-02 19:40:15.000000', '2025-11-02 19:40:15.000000', NULL),
(37, 12, 'PASS10', '10次奶茶卡', 'Tarjeta de 10', NULL, NULL, NULL, 999, 1, '2025-11-16 17:31:47.167929', '2025-11-21 14:59:25.087644', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `pos_point_redemption_rules`
--

DROP TABLE IF EXISTS `pos_point_redemption_rules`;
CREATE TABLE `pos_point_redemption_rules` (
  `id` int NOT NULL,
  `rule_name_zh` varchar(100) NOT NULL,
  `rule_name_es` varchar(100) NOT NULL,
  `points_required` int UNSIGNED NOT NULL DEFAULT '0',
  `reward_type` enum('DISCOUNT_AMOUNT','SPECIFIC_PROMOTION') NOT NULL DEFAULT 'DISCOUNT_AMOUNT',
  `reward_value_decimal` decimal(10,2) DEFAULT NULL COMMENT 'Discount amount if reward_type is DISCOUNT_AMOUNT',
  `reward_promo_id` int UNSIGNED DEFAULT NULL COMMENT 'pos_promotions.id if reward_type is SPECIFIC_PROMOTION',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `pos_print_templates`
--

DROP TABLE IF EXISTS `pos_print_templates`;
CREATE TABLE `pos_print_templates` (
  `id` int NOT NULL,
  `store_id` int UNSIGNED DEFAULT NULL COMMENT '所属门店ID, NULL表示全局通用',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称 (e.g., Z-Out Report, Customer Receipt)',
  `template_type` enum('EOD_REPORT','RECEIPT','KITCHEN_ORDER','SHIFT_REPORT','CUP_STICKER','EXPIRY_LABEL','PASS_REDEMPTION_SLIP') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板类型',
  `template_content` json NOT NULL COMMENT '模板布局和内容的JSON定义',
  `physical_size` varchar(20) DEFAULT NULL COMMENT '物理尺寸 (e.g., 50x30, 80mm)',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='POS打印模板配置表';

--
-- 转存表中的数据 `pos_print_templates`
--

INSERT INTO `pos_print_templates` (`id`, `store_id`, `template_name`, `template_type`, `template_content`, `physical_size`, `is_active`, `created_at`, `updated_at`) VALUES
(1, NULL, '默认效期模板', 'EXPIRY_LABEL', '[{\"size\": \"normal\", \"type\": \"text\", \"align\": \"left\", \"value\": \"{material_name}\"}, {\"size\": \"normal\", \"type\": \"text\", \"align\": \"left\", \"value\": \"{material_name_es}\"}, {\"key\": \"Ini:\", \"type\": \"kv\", \"value\": \"{opened_at_time}\", \"bold_value\": false}, {\"key\": \"Ópt.:\", \"type\": \"kv\", \"value\": \"{expires_at_time}\", \"bold_value\": true}]', '50x30', 1, '2025-11-03 13:35:04.000000', '2025-11-03 13:52:24.000000');

-- --------------------------------------------------------

--
-- 表的结构 `pos_product_availability`
--

DROP TABLE IF EXISTS `pos_product_availability`;
CREATE TABLE `pos_product_availability` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL COMMENT '关联 kds_stores.id',
  `menu_item_id` int UNSIGNED NOT NULL COMMENT '关联 pos_menu_items.id',
  `is_sold_out` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否估清 (1=估清, 0=可售)',
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS 门店商品估清状态表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_product_tag_map`
--

DROP TABLE IF EXISTS `pos_product_tag_map`;
CREATE TABLE `pos_product_tag_map` (
  `product_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pos_menu_items.id',
  `tag_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pos_tags.tag_id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: POS 商品与标签映射表';

--
-- 转存表中的数据 `pos_product_tag_map`
--

INSERT INTO `pos_product_tag_map` (`product_id`, `tag_id`) VALUES
(37, 1),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 2),
(21, 2),
(22, 2),
(23, 2),
(24, 2),
(25, 2),
(26, 2),
(27, 2),
(28, 2),
(29, 2),
(30, 2),
(31, 2),
(32, 2),
(33, 2),
(34, 2),
(35, 2);

-- --------------------------------------------------------

--
-- 表的结构 `pos_promotions`
--

DROP TABLE IF EXISTS `pos_promotions`;
CREATE TABLE `pos_promotions` (
  `id` int UNSIGNED NOT NULL,
  `promo_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则名称, e.g., 珍珠奶茶买一送一',
  `promo_priority` int NOT NULL DEFAULT '10' COMMENT '优先级, 数字越小越高',
  `promo_exclusive` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否排他, 1=是 (若应用此规则,则不再计算其他规则)',
  `promo_trigger_type` enum('AUTO_APPLY','COUPON_CODE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发类型: AUTO_APPLY=自动应用, COUPON_CODE=需优惠码',
  `promo_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promo_conditions` json NOT NULL COMMENT '触发条件 (JSON)',
  `promo_actions` json NOT NULL COMMENT '执行动作 (JSON)',
  `promo_start_date` datetime(6) DEFAULT NULL,
  `promo_end_date` datetime(6) DEFAULT NULL,
  `promo_is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS促销规则表';

-- --------------------------------------------------------

--
-- 表的结构 `pos_settings`
--

DROP TABLE IF EXISTS `pos_settings`;
CREATE TABLE `pos_settings` (
  `setting_key` varchar(50) NOT NULL,
  `setting_value` text NOT NULL,
  `description` text,
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `pos_settings`
--

INSERT INTO `pos_settings` (`setting_key`, `setting_value`, `description`, `updated_at`) VALUES
('global_free_addon_limit', '0', 'Global limit for free addons per item (0=unlimited)', '2025-11-13 23:16:41.767924'),
('points_euros_per_point', '1.00', '每消费 1 欧元可获得 1 积分', '2025-11-02 19:39:32.000000'),
('sif_declaracion_responsable', 'DECLARACIÓN RESPONSABLE DEL SISTEMA INFORMÁTICO DE FACTURACIÓN\n\na) Nombre del sistema: TOPTEA POS/KDS\nb) Código identificador del SIF: SIF-TOPTEA-2025-V2\nc) Versión: v2.5.0\nd) Componentes HW/SW y funcionalidades principales:\n   - HW: Terminales TPV Android, Impresoras térmicas.\n   - SW: Módulo POS.\n   - Funcionalidades: Gestión de pedidos, cobros, emisión de facturas simplificadas (SIF), gestión de cocina (KDS), gestión de recetas (RMS) y configuración centralizada (CPSYS).\ne) Modalidad de uso: [X] Dual (VERIFACTU y no verificable, según configuración de tienda)\nf) Ámbito de uso: [X] Varios OT; [X] Multitienda/Multiterminal\ng) Tipos de firma aplicados a RF y registro de eventos: Firma electrónica (Simulada para desarrollo)\nh) Productor (nombre/razón social): [TU NOMBRE DE EMPRESA AQUÍ]\ni) NIF/otro TIN y país: [TU NIF/CIF AQUÍ] (ESPAÑA)\nj) Domicilio y datos de contacto del productor: [TU DIRECCIÓN COMPLETA AQUÍ], email: [TU EMAIL DE SOPORTE AQUÍ]\nk) Manifestación de conformidad: El productor certifica, bajo su responsabilidad, que este SIF cumple el art. 29.2.j) de la Ley 58/2003, el RD 1007/2023 y la Orden HAC/1177/2024 (y demás normas de desarrollo).\nl) Lugar y fecha: Bilbao, España / 03 / 11 / 2025', 'Declaración Responsable (SIF Compliance Statement)', '2025-11-04 01:04:09.000000');

-- --------------------------------------------------------

--
-- 表的结构 `pos_shifts`
--

DROP TABLE IF EXISTS `pos_shifts`;
CREATE TABLE `pos_shifts` (
  `id` int UNSIGNED NOT NULL,
  `shift_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '班次全局唯一ID',
  `store_id` int UNSIGNED NOT NULL COMMENT '所属门店ID',
  `user_id` int UNSIGNED NOT NULL COMMENT '当班收银员ID',
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `status` enum('ACTIVE','ENDED','FORCE_CLOSED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '班次状态: ACTIVE=进行中, ENDED=已结束, FORCE_CLOSED=被强制关闭',
  `starting_float` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '初始备用金',
  `counted_cash` decimal(10,2) DEFAULT NULL COMMENT '交班时清点的现金金额',
  `expected_cash` decimal(10,2) DEFAULT NULL COMMENT '系统计算的应有现金',
  `cash_variance` decimal(10,2) DEFAULT NULL COMMENT '现金差异 (清点 - 系统)',
  `payment_summary` json DEFAULT NULL COMMENT '此班次内各支付方式的汇总',
  `admin_reviewed` tinyint(1) NOT NULL DEFAULT '0',
  `sales_summary` json DEFAULT NULL COMMENT '此班次内的销售总览 (总销售, 折扣等)',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='POS交接班记录表';

--
-- 转存表中的数据 `pos_shifts`
--

INSERT INTO `pos_shifts` (`id`, `shift_uuid`, `store_id`, `user_id`, `start_time`, `end_time`, `status`, `starting_float`, `counted_cash`, `expected_cash`, `cash_variance`, `payment_summary`, `admin_reviewed`, `sales_summary`, `created_at`, `updated_at`) VALUES
(1, '2251a18fa62ccfdf3e3554a3c912810c', 1, 1, '2025-11-02 19:26:12.000000', '2025-11-04 01:57:07.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff2\"}', 1, NULL, '2025-11-02 20:26:12.000000', '2025-11-04 12:26:54.000000'),
(2, '27dc8398d71dfb044d44748a15a20c58', 1, 1, '2025-11-04 01:57:07.000000', '2025-11-04 01:57:07.000000', 'FORCE_CLOSED', 1.00, 1.00, 1.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff2\"}', 1, NULL, '2025-11-04 02:57:07.000000', '2025-11-10 03:38:06.000000'),
(3, '81e255b5bb8ad73b5625efabb5aa198e', 1, 1, '2025-11-04 01:57:07.000000', '2025-11-05 20:24:51.000000', 'FORCE_CLOSED', 1.00, 1.00, 1.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 1, NULL, '2025-11-04 02:57:07.000000', '2025-11-10 03:38:00.000000'),
(4, 'a5588ed56233cb42b39503b50e4dba10', 1, 1, '2025-11-05 20:24:51.000000', '2025-11-05 20:24:51.000000', 'FORCE_CLOSED', 1.00, 1.00, 1.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 1, NULL, '2025-11-05 21:24:51.000000', '2025-11-12 17:59:25.000000'),
(5, 'dfb0749c656b03953bb0be6ba41e31a9', 1, 1, '2025-11-05 20:24:51.000000', '2025-11-06 15:53:38.000000', 'FORCE_CLOSED', 1.00, 1.00, 1.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 1, NULL, '2025-11-05 21:24:51.000000', '2025-11-10 21:39:42.000000'),
(6, 'e4224d88e95536790156b2c0d2b77c92', 1, 1, '2025-11-06 15:53:38.000000', '2025-11-06 15:53:38.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 1, NULL, '2025-11-06 16:53:38.000000', '2025-11-17 18:36:50.000000'),
(7, 'b007cfd331b273eb23c138e17c16bfa2', 1, 1, '2025-11-06 15:53:38.000000', '2025-11-07 00:18:28.000000', 'FORCE_CLOSED', 0.00, NULL, 0.00, NULL, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-06 16:53:38.000000', '2025-11-07 01:18:28.000000'),
(8, 'fcfac9b312646039d1a84e99d0c84fba', 1, 1, '2025-11-07 00:18:28.000000', '2025-11-07 00:18:28.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 1, NULL, '2025-11-07 01:18:28.000000', '2026-01-02 22:20:08.000000'),
(9, 'd2355af6c52afc5d777fa8f7f0eeaf5f', 1, 1, '2025-11-07 00:18:28.000000', '2025-11-08 00:31:33.000000', 'FORCE_CLOSED', 0.00, NULL, 0.00, NULL, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-07 01:18:28.000000', '2025-11-08 01:31:33.000000'),
(10, '437518217b13d31a6e0b2bd36396bb4f', 1, 1, '2025-11-08 00:31:33.000000', '2025-11-08 00:31:33.000000', 'FORCE_CLOSED', 1.00, NULL, 1.00, NULL, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-08 01:31:33.000000', '2025-11-08 01:31:33.000000'),
(11, '379b9de5e8664390760621735869d216', 1, 1, '2025-11-08 00:31:33.000000', '2025-11-10 02:23:41.000000', 'FORCE_CLOSED', 1.00, NULL, 1.00, NULL, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-08 01:31:33.000000', '2025-11-10 03:23:41.000000'),
(12, 'a7f2d54c099bd5897c0e38f0b403d08d', 1, 1, '2025-11-10 02:23:41.000000', '2025-11-10 02:23:41.000000', 'FORCE_CLOSED', 0.00, NULL, 0.00, NULL, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-10 03:23:41.000000', '2025-11-10 03:23:41.000000'),
(13, '3e017875a3ce8663a1b0c9b4aae84b98', 1, 1, '2025-11-10 02:23:41.000000', '2025-11-17 02:18:47.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-10 03:23:41.000000', '2025-11-17 02:18:47.596681'),
(14, 'b3a84a7d645bed73d8349a37bd0b0ce3', 1, 1, '2025-11-17 02:18:47.000000', '2025-11-17 02:18:47.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-17 02:18:47.599239', '2025-11-17 02:18:47.603266'),
(15, '4470be37bdf086e8a9b700c3cc59661d', 1, 1, '2025-11-17 02:18:47.000000', '2025-11-17 23:53:41.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-17 02:18:47.605034', '2025-11-17 23:53:41.592805'),
(16, '7bab8764f9adf16021b658c32f8b23d5', 1, 1, '2025-11-17 23:53:41.000000', '2025-11-17 23:53:41.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-17 23:53:41.595589', '2025-11-17 23:53:41.600241'),
(17, '46cea01bfd6fb0dc5f05cecff20c47e6', 1, 1, '2025-11-17 23:53:41.000000', '2025-11-18 01:47:36.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-17 23:53:41.602149', '2025-11-18 01:47:36.706413'),
(18, '0f7a1b0381c9771e3446af2c2a49ac9e', 1, 1, '2025-11-18 01:47:36.000000', '2025-11-18 01:47:36.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 01:47:36.710657', '2025-11-18 01:47:36.714451'),
(19, '5142f1f8d3923657b91428cd254bec74', 1, 1, '2025-11-18 01:47:36.000000', '2025-11-18 23:00:20.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 01:47:36.716112', '2025-11-18 23:00:20.490546'),
(20, 'a36e1e2dc810ac296b85d32d2db7b76d', 1, 1, '2025-11-18 23:00:20.000000', '2025-11-18 23:00:20.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:00:20.495633', '2025-11-18 23:00:20.501335'),
(21, 'e1c9492cb5229f86ae24e5e97df9c3e0', 1, 1, '2025-11-18 23:00:20.000000', '2025-11-18 23:00:27.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:00:20.504532', '2025-11-18 23:00:27.065830'),
(22, 'd61b773d035df5d927d207c302404755', 1, 1, '2025-11-18 23:00:27.000000', '2025-11-18 23:00:27.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:00:27.068984', '2025-11-18 23:00:27.073284'),
(23, '3683d9fe3304202ea2a58c0a98a04904', 1, 1, '2025-11-18 23:00:27.000000', '2025-11-18 23:01:57.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:00:27.075395', '2025-11-18 23:01:57.624990'),
(24, 'd98c71de50a085d1d4d0f252392a5cd1', 1, 1, '2025-11-18 23:01:57.000000', '2025-11-18 23:01:57.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:01:57.627089', '2025-11-18 23:01:57.631463'),
(25, 'ff16dfdf1b7294c91036bcb791832a87', 1, 1, '2025-11-18 23:01:57.000000', '2025-11-18 23:02:27.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:01:57.633311', '2025-11-18 23:02:27.104631'),
(26, 'e9ab83d59331de5011c5a68bb1a537c9', 1, 1, '2025-11-18 23:02:27.000000', '2025-11-18 23:02:27.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:02:27.107678', '2025-11-18 23:02:27.111444'),
(27, '08ecb493c6d914f8a3fdb68a1432f601', 1, 1, '2025-11-18 23:02:27.000000', '2025-11-18 23:02:41.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:02:27.113212', '2025-11-18 23:02:41.787849'),
(28, '1e643eaa93242e58477c4411cbc0fb1e', 1, 1, '2025-11-18 23:02:41.000000', '2025-11-18 23:02:41.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:02:41.790540', '2025-11-18 23:02:41.823260'),
(29, '104c36a61c206e0663ed870204d34048', 1, 1, '2025-11-18 23:02:41.000000', '2025-11-18 23:37:26.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:02:41.826089', '2025-11-18 23:37:26.539514'),
(30, 'ba3b47a70767b4ee32cc3b3b3f6a5e79', 1, 1, '2025-11-18 23:37:26.000000', '2025-11-18 23:37:26.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:37:26.542859', '2025-11-18 23:37:26.547996'),
(31, '1653bcf63c7bc8887821cd952a165b7e', 1, 1, '2025-11-18 23:37:26.000000', '2025-11-18 23:55:51.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:37:26.550845', '2025-11-18 23:55:51.761632'),
(32, 'b8ce252cd2eea41a586e819f6ffa3038', 1, 1, '2025-11-18 23:55:51.000000', '2025-11-18 23:55:51.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:55:51.763918', '2025-11-18 23:55:51.770612'),
(33, 'b1ef44e48177a53aa5b02d29bef5aae1', 1, 1, '2025-11-18 23:55:51.000000', '2025-11-19 00:40:29.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-18 23:55:51.773516', '2025-11-19 00:40:29.461915'),
(34, 'ea4eb674c34358378e0f60f5984f4c2e', 1, 1, '2025-11-19 00:40:29.000000', '2025-11-19 00:40:29.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-19 00:40:29.465622', '2025-11-19 00:40:29.471480'),
(35, '3baa9af081f240a95a2ac1afc0ffe92b', 1, 1, '2025-11-19 00:40:29.000000', '2025-11-19 23:59:28.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-19 00:40:29.474332', '2025-11-19 23:59:28.069257'),
(36, '1ad6ee0195e1a4e5e5eb0ddcffa348d6', 1, 1, '2025-11-19 23:59:28.000000', '2025-11-19 23:59:28.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-19 23:59:28.071858', '2025-11-19 23:59:28.077287'),
(37, '1dae84827d3567e6b3eb549a33ece0ac', 1, 1, '2025-11-19 23:59:28.000000', '2025-11-19 23:59:35.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-19 23:59:28.080624', '2025-11-19 23:59:35.584214'),
(38, 'b9ee78d63256d60f743c9a524d1273ac', 1, 1, '2025-11-19 23:59:35.000000', '2025-11-19 23:59:35.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-19 23:59:35.585880', '2025-11-19 23:59:35.589146'),
(39, '031264cc08403d7ef0edb4a46fc920b8', 1, 1, '2025-11-19 23:59:35.000000', '2025-11-20 00:31:28.000000', 'FORCE_CLOSED', 1.00, 0.00, 1.00, -1.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-19 23:59:35.591560', '2025-11-20 00:31:28.217389'),
(40, '0614475c5f5fccb1a2a6c09677b63ced', 1, 1, '2025-11-20 00:31:28.000000', '2025-11-20 00:31:28.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-20 00:31:28.219718', '2025-11-20 00:31:28.226830'),
(41, '76b0e1800e0ab182f84b8e73851a28c8', 1, 1, '2025-11-20 00:31:28.000000', '2025-11-21 01:24:02.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-20 00:31:28.229930', '2025-11-21 01:24:02.946420'),
(42, 'af19b2db0e78967eca4f09ab9703565b', 1, 1, '2025-11-21 01:24:02.000000', '2025-11-21 01:24:02.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"note\": \"Forcibly closed by KDS Staff3\"}', 0, NULL, '2025-11-21 01:24:02.950642', '2025-11-21 01:24:02.956075'),
(43, '06587ec0b1dd60d9928dd3e660223ffc', 1, 1, '2025-11-21 01:24:02.000000', '2025-11-22 01:59:54.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"card\": 0, \"cash\": 0, \"note\": \"Forcibly closed by KDS Staff3\", \"total\": 0, \"platform\": 0}', 0, NULL, '2025-11-21 01:24:02.959157', '2025-11-22 01:59:54.826151'),
(44, 'a27fec39eb9837812e289b749f176d48', 1, 1, '2025-11-22 01:59:54.000000', '2025-11-22 01:59:54.000000', 'FORCE_CLOSED', 0.00, 0.00, 0.00, 0.00, '{\"card\": 0, \"cash\": 0, \"note\": \"Forcibly closed by KDS Staff3\", \"total\": 0, \"platform\": 0}', 0, NULL, '2025-11-22 01:59:54.829837', '2025-11-22 01:59:54.841620'),
(45, '8d8b6d267a55c7126e3d094894f870f5', 1, 1, '2025-11-22 01:59:54.000000', '2025-11-22 13:25:58.000000', 'ENDED', 0.00, 0.00, 0.00, 0.00, '{\"card\": 0, \"cash\": 0, \"total\": 0, \"platform\": 0}', 0, NULL, '2025-11-22 01:59:54.844370', '2025-11-22 13:25:58.496593'),
(46, '960b79bbc4d5acc1b520dad298533805', 1, 1, '2025-11-22 13:26:07.000000', NULL, 'ACTIVE', 1.00, NULL, NULL, NULL, NULL, 0, NULL, '2025-11-22 13:26:07.715361', '2025-11-22 13:26:07.715361');

-- --------------------------------------------------------

--
-- 表的结构 `pos_tags`
--

DROP TABLE IF EXISTS `pos_tags`;
CREATE TABLE `pos_tags` (
  `tag_id` int UNSIGNED NOT NULL,
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签唯一码 (e.g., pass_eligible_beverage)',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签说明'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: POS 商品标签定义表';

--
-- 转存表中的数据 `pos_tags`
--

INSERT INTO `pos_tags` (`tag_id`, `tag_code`, `tag_name`) VALUES
(1, 'pass_product', '次卡商品(用于售卖)'),
(2, 'pass_eligible_beverage', '次卡可核销的基础饮品'),
(3, 'paid_addon', '次卡核销时需额外付费的加料'),
(4, 'free_addon', '次卡核销时可免费的加料'),
(5, 'card_bundle', '次卡组合（菜单隐藏）');

-- --------------------------------------------------------

--
-- 表的结构 `pos_vr_counters`
--

DROP TABLE IF EXISTS `pos_vr_counters`;
CREATE TABLE `pos_vr_counters` (
  `id` int UNSIGNED NOT NULL,
  `vr_prefix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '门店VR前缀 (e.g., S1-VR)',
  `series` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '完整系列号 (e.g., S1-VRY25)',
  `current_number` bigint UNSIGNED NOT NULL DEFAULT '0' COMMENT '当前已用的最大号码',
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: POS 售卡(VR)票号原子计数器';

--
-- 转存表中的数据 `pos_vr_counters`
--

INSERT INTO `pos_vr_counters` (`id`, `vr_prefix`, `series`, `current_number`, `updated_at`) VALUES
(1, 'A1-VR', 'A1-VRY25', 9, '2025-11-22 13:18:55.024750');

-- --------------------------------------------------------

--
-- 表的结构 `topup_orders`
--

DROP TABLE IF EXISTS `topup_orders`;
CREATE TABLE `topup_orders` (
  `topup_order_id` int UNSIGNED NOT NULL COMMENT '售卡订单ID',
  `pass_plan_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pass_plans.pass_plan_id',
  `member_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 pos_members.id (购买会员)',
  `quantity` int UNSIGNED NOT NULL DEFAULT '1' COMMENT '购买数量 (默认为1)',
  `amount_total` decimal(10,2) NOT NULL COMMENT '总支付金额 (合同负债)',
  `store_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 kds_stores.id (销售门店)',
  `device_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '销售设备ID',
  `sale_user_id` int UNSIGNED NOT NULL COMMENT 'FK, 关联 kds_users.id (销售员工)',
  `sale_time` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `voucher_series` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VR' COMMENT '非税凭证系列 (VR) [cite: 17, 33]',
  `voucher_number` bigint UNSIGNED NOT NULL COMMENT '非税凭证连续编号 [cite: 33]',
  `review_status` enum('pending','confirmed','rejected','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '审核状态 [cite: 33]',
  `reviewed_by_user_id` int UNSIGNED DEFAULT NULL COMMENT 'FK, 关联 cpsys_users.id (审核人)',
  `reviewed_at` datetime(6) DEFAULT NULL,
  `review_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '审核备注 [cite: 33]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='B1.1: 次卡售卡订单表 (VR非税)';

--
-- 转存表中的数据 `topup_orders`
--

INSERT INTO `topup_orders` (`topup_order_id`, `pass_plan_id`, `member_id`, `quantity`, `amount_total`, `store_id`, `device_id`, `sale_user_id`, `sale_time`, `voucher_series`, `voucher_number`, `review_status`, `reviewed_by_user_id`, `reviewed_at`, `review_note`) VALUES
(1, 1, 1, 1, 60.00, 1, '0', 1, '2025-11-19 10:54:50.000000', 'A1-VRY25', 1, 'pending', NULL, NULL, NULL),
(4, 1, 1, 1, 60.00, 1, '0', 1, '2025-11-19 12:55:53.000000', 'A1-VRY25', 2, 'pending', NULL, NULL, NULL),
(5, 1, 1, 1, 60.00, 1, '0', 1, '2025-11-19 17:06:02.000000', 'A1-VRY25', 3, 'pending', NULL, NULL, NULL),
(6, 1, 1, 1, 60.00, 1, '0', 1, '2025-11-21 15:03:00.000000', 'A1-VRY25', 7, 'pending', NULL, NULL, NULL),
(7, 1, 1, 1, 60.00, 1, '0', 1, '2025-11-22 02:00:19.000000', 'A1-VRY25', 8, 'pending', NULL, NULL, NULL),
(8, 1, 7, 1, 60.00, 1, '0', 1, '2025-11-22 13:18:55.000000', 'A1-VRY25', 9, 'pending', NULL, NULL, NULL);

--
-- 转储表的索引
--

--
-- 表的索引 `cpsys_roles`
--
ALTER TABLE `cpsys_roles`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cpsys_users`
--
ALTER TABLE `cpsys_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `idx_cpsys_users_email` (`email`);

--
-- 表的索引 `expsys_store_stock`
--
ALTER TABLE `expsys_store_stock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `store_material` (`store_id`,`material_id`);

--
-- 表的索引 `expsys_warehouse_stock`
--
ALTER TABLE `expsys_warehouse_stock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `material_id` (`material_id`);

--
-- 表的索引 `kds_cups`
--
ALTER TABLE `kds_cups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cup_code` (`cup_code`);

--
-- 表的索引 `kds_global_adjustment_rules`
--
ALTER TABLE `kds_global_adjustment_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_priority_active` (`priority`,`is_active`),
  ADD KEY `fk_global_cond_cup` (`cond_cup_id`),
  ADD KEY `fk_global_cond_ice` (`cond_ice_id`),
  ADD KEY `fk_global_cond_sweet` (`cond_sweet_id`),
  ADD KEY `fk_global_cond_material` (`cond_material_id`),
  ADD KEY `fk_global_action_material` (`action_material_id`),
  ADD KEY `fk_global_action_unit` (`action_unit_id`);

--
-- 表的索引 `kds_ice_options`
--
ALTER TABLE `kds_ice_options`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ice_code` (`ice_code`);

--
-- 表的索引 `kds_ice_option_translations`
--
ALTER TABLE `kds_ice_option_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_ice_option_language` (`ice_option_id`,`language_code`);

--
-- 表的索引 `kds_materials`
--
ALTER TABLE `kds_materials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `material_code` (`material_code`),
  ADD KEY `fk_material_large_unit` (`large_unit_id`);

--
-- 表的索引 `kds_material_expiries`
--
ALTER TABLE `kds_material_expiries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `material_id` (`material_id`),
  ADD KEY `store_id` (`store_id`),
  ADD KEY `status` (`status`),
  ADD KEY `expires_at` (`expires_at`);

--
-- 表的索引 `kds_material_translations`
--
ALTER TABLE `kds_material_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `material_language_unique` (`material_id`,`language_code`);

--
-- 表的索引 `kds_products`
--
ALTER TABLE `kds_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_product_code` (`product_code`,`is_deleted_flag`),
  ADD KEY `status_id` (`status_id`),
  ADD KEY `category_id` (`category_id`);

--
-- 表的索引 `kds_product_adjustments`
--
ALTER TABLE `kds_product_adjustments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_product_option` (`product_id`,`option_type`,`option_id`),
  ADD KEY `material_id` (`material_id`),
  ADD KEY `unit_id` (`unit_id`);

--
-- 表的索引 `kds_product_categories`
--
ALTER TABLE `kds_product_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- 表的索引 `kds_product_category_translations`
--
ALTER TABLE `kds_product_category_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_language_unique` (`category_id`,`language_code`);

--
-- 表的索引 `kds_product_ice_options`
--
ALTER TABLE `kds_product_ice_options`
  ADD PRIMARY KEY (`product_id`,`ice_option_id`),
  ADD KEY `ice_option_id` (`ice_option_id`);

--
-- 表的索引 `kds_product_recipes`
--
ALTER TABLE `kds_product_recipes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `material_id` (`material_id`),
  ADD KEY `unit_id` (`unit_id`);

--
-- 表的索引 `kds_product_statuses`
--
ALTER TABLE `kds_product_statuses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `status_code` (`status_code`);

--
-- 表的索引 `kds_product_sweetness_options`
--
ALTER TABLE `kds_product_sweetness_options`
  ADD PRIMARY KEY (`product_id`,`sweetness_option_id`),
  ADD KEY `sweetness_option_id` (`sweetness_option_id`);

--
-- 表的索引 `kds_product_translations`
--
ALTER TABLE `kds_product_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_language_unique` (`product_id`,`language_code`);

--
-- 表的索引 `kds_recipe_adjustments`
--
ALTER TABLE `kds_recipe_adjustments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_product_conditions` (`product_id`,`cup_id`,`sweetness_option_id`,`ice_option_id`),
  ADD KEY `fk_adj_material` (`material_id`),
  ADD KEY `fk_adj_cup` (`cup_id`),
  ADD KEY `fk_adj_sweetness` (`sweetness_option_id`),
  ADD KEY `fk_adj_ice` (`ice_option_id`),
  ADD KEY `fk_adj_unit` (`unit_id`);

--
-- 表的索引 `kds_sop_query_rules`
--
ALTER TABLE `kds_sop_query_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_store_priority` (`store_id`,`priority`,`is_active`);

--
-- 表的索引 `kds_stores`
--
ALTER TABLE `kds_stores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `store_code` (`store_code`),
  ADD UNIQUE KEY `uniq_invoice_prefix` (`invoice_prefix`);

--
-- 表的索引 `kds_sweetness_options`
--
ALTER TABLE `kds_sweetness_options`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sweetness_code` (`sweetness_code`);

--
-- 表的索引 `kds_sweetness_option_translations`
--
ALTER TABLE `kds_sweetness_option_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_sweetness_option_language` (`sweetness_option_id`,`language_code`);

--
-- 表的索引 `kds_units`
--
ALTER TABLE `kds_units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unit_code` (`unit_code`);

--
-- 表的索引 `kds_unit_translations`
--
ALTER TABLE `kds_unit_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unit_language_unique` (`unit_id`,`language_code`);

--
-- 表的索引 `kds_users`
--
ALTER TABLE `kds_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_store_username` (`store_id`,`username`,`deleted_at`);

--
-- 表的索引 `member_passes`
--
ALTER TABLE `member_passes`
  ADD PRIMARY KEY (`member_pass_id`),
  ADD UNIQUE KEY `uniq_member_plan` (`member_id`,`pass_plan_id`),
  ADD KEY `idx_member_id_status` (`member_id`,`status`),
  ADD KEY `idx_pass_plan_id` (`pass_plan_id`),
  ADD KEY `idx_topup_order_id` (`topup_order_id`);

--
-- 表的索引 `pass_daily_usage`
--
ALTER TABLE `pass_daily_usage`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_pass_date` (`member_pass_id`,`usage_date`);

--
-- 表的索引 `pass_plans`
--
ALTER TABLE `pass_plans`
  ADD PRIMARY KEY (`pass_plan_id`);

--
-- 表的索引 `pass_redemptions`
--
ALTER TABLE `pass_redemptions`
  ADD PRIMARY KEY (`redemption_id`),
  ADD KEY `idx_batch_id` (`batch_id`),
  ADD KEY `idx_member_pass_id` (`member_pass_id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `idx_order_item_id` (`order_item_id`);

--
-- 表的索引 `pass_redemption_batches`
--
ALTER TABLE `pass_redemption_batches`
  ADD PRIMARY KEY (`batch_id`),
  ADD UNIQUE KEY `idx_member_pass_idempotency` (`member_pass_id`,`idempotency_key`),
  ADD KEY `idx_member_pass_id` (`member_pass_id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `fk_batch_store` (`store_id`),
  ADD KEY `fk_batch_user` (`cashier_user_id`);

--
-- 表的索引 `pos_addons`
--
ALTER TABLE `pos_addons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_code_deleted` (`addon_code`,`deleted_at`),
  ADD KEY `idx_material_id` (`material_id`);

--
-- 表的索引 `pos_addon_tag_map`
--
ALTER TABLE `pos_addon_tag_map`
  ADD PRIMARY KEY (`addon_id`,`tag_id`),
  ADD KEY `fk_addon_map_tag` (`tag_id`);

--
-- 表的索引 `pos_categories`
--
ALTER TABLE `pos_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_code` (`category_code`);

--
-- 表的索引 `pos_coupons`
--
ALTER TABLE `pos_coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_coupon_code` (`coupon_code`),
  ADD KEY `idx_promotion_id` (`promotion_id`);

--
-- 表的索引 `pos_daily_tracking`
--
ALTER TABLE `pos_daily_tracking`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `store_id` (`store_id`);

--
-- 表的索引 `pos_eod_records`
--
ALTER TABLE `pos_eod_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_store_time` (`store_id`,`started_at`,`ended_at`);

--
-- 表的索引 `pos_eod_reports`
--
ALTER TABLE `pos_eod_reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `store_date_unique` (`store_id`,`report_date`);

--
-- 表的索引 `pos_held_orders`
--
ALTER TABLE `pos_held_orders`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `pos_invoices`
--
ALTER TABLE `pos_invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_issuer_series_number` (`issuer_nif`,`series`,`number`,`compliance_system`),
  ADD KEY `idx_store_id` (`store_id`),
  ADD KEY `idx_issued_at` (`issued_at`),
  ADD KEY `idx_references_invoice_id` (`references_invoice_id`),
  ADD KEY `fk_invoice_shift` (`shift_id`);

--
-- 表的索引 `pos_invoice_counters`
--
ALTER TABLE `pos_invoice_counters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_prefix_series_system` (`invoice_prefix`,`series`,`compliance_system`);

--
-- 表的索引 `pos_invoice_items`
--
ALTER TABLE `pos_invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invoice_id` (`invoice_id`),
  ADD KEY `idx_menu_item_id` (`menu_item_id`),
  ADD KEY `idx_variant_id` (`variant_id`);

--
-- 表的索引 `pos_item_variants`
--
ALTER TABLE `pos_item_variants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_menu_item_id` (`menu_item_id`),
  ADD KEY `fk_variant_cup` (`cup_id`);

--
-- 表的索引 `pos_members`
--
ALTER TABLE `pos_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `member_uuid_unique` (`member_uuid`),
  ADD UNIQUE KEY `phone_number_unique` (`phone_number`),
  ADD KEY `idx_phone_number` (`phone_number`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_birthdate` (`birthdate`),
  ADD KEY `idx_member_level_id` (`member_level_id`);

--
-- 表的索引 `pos_member_issued_coupons`
--
ALTER TABLE `pos_member_issued_coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `coupon_code_unique` (`coupon_code`),
  ADD KEY `idx_member_id_status_expires` (`member_id`,`status`,`expires_at`),
  ADD KEY `idx_promotion_id` (`promotion_id`),
  ADD KEY `idx_used_invoice_id` (`used_invoice_id`);

--
-- 表的索引 `pos_member_levels`
--
ALTER TABLE `pos_member_levels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_points_threshold` (`points_threshold`),
  ADD KEY `idx_sort_order` (`sort_order`);

--
-- 表的索引 `pos_member_points_log`
--
ALTER TABLE `pos_member_points_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_member_id` (`member_id`),
  ADD KEY `idx_invoice_id` (`invoice_id`);

--
-- 表的索引 `pos_menu_items`
--
ALTER TABLE `pos_menu_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pos_category_id` (`pos_category_id`),
  ADD KEY `idx_sort_order` (`sort_order`);

--
-- 表的索引 `pos_point_redemption_rules`
--
ALTER TABLE `pos_point_redemption_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_points_required` (`points_required`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `reward_promo_id` (`reward_promo_id`);

--
-- 表的索引 `pos_print_templates`
--
ALTER TABLE `pos_print_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_store_type` (`store_id`,`template_type`);

--
-- 表的索引 `pos_product_availability`
--
ALTER TABLE `pos_product_availability`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `store_item` (`store_id`,`menu_item_id`),
  ADD KEY `idx_store_id` (`store_id`),
  ADD KEY `idx_menu_item_id` (`menu_item_id`);

--
-- 表的索引 `pos_product_tag_map`
--
ALTER TABLE `pos_product_tag_map`
  ADD PRIMARY KEY (`product_id`,`tag_id`),
  ADD KEY `fk_tag_map_tag` (`tag_id`);

--
-- 表的索引 `pos_promotions`
--
ALTER TABLE `pos_promotions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `promo_code_unique` (`promo_code`),
  ADD KEY `idx_promo_active_dates` (`promo_is_active`,`promo_start_date`,`promo_end_date`);

--
-- 表的索引 `pos_settings`
--
ALTER TABLE `pos_settings`
  ADD PRIMARY KEY (`setting_key`);

--
-- 表的索引 `pos_shifts`
--
ALTER TABLE `pos_shifts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_store_user_status` (`store_id`,`user_id`,`status`),
  ADD KEY `idx_status_reviewed` (`status`,`admin_reviewed`);

--
-- 表的索引 `pos_tags`
--
ALTER TABLE `pos_tags`
  ADD PRIMARY KEY (`tag_id`),
  ADD UNIQUE KEY `uniq_tag_code` (`tag_code`);

--
-- 表的索引 `pos_vr_counters`
--
ALTER TABLE `pos_vr_counters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_prefix_series` (`vr_prefix`,`series`);

--
-- 表的索引 `topup_orders`
--
ALTER TABLE `topup_orders`
  ADD PRIMARY KEY (`topup_order_id`),
  ADD UNIQUE KEY `uniq_vr_series_number` (`voucher_series`,`voucher_number`),
  ADD KEY `idx_pass_plan_id` (`pass_plan_id`),
  ADD KEY `idx_member_id` (`member_id`),
  ADD KEY `idx_store_id` (`store_id`),
  ADD KEY `idx_sale_user_id` (`sale_user_id`),
  ADD KEY `idx_reviewed_by_user_id` (`reviewed_by_user_id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `cpsys_roles`
--
ALTER TABLE `cpsys_roles`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `cpsys_users`
--
ALTER TABLE `cpsys_users`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- 使用表AUTO_INCREMENT `expsys_store_stock`
--
ALTER TABLE `expsys_store_stock`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `expsys_warehouse_stock`
--
ALTER TABLE `expsys_warehouse_stock`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_cups`
--
ALTER TABLE `kds_cups`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `kds_global_adjustment_rules`
--
ALTER TABLE `kds_global_adjustment_rules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `kds_ice_options`
--
ALTER TABLE `kds_ice_options`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `kds_ice_option_translations`
--
ALTER TABLE `kds_ice_option_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- 使用表AUTO_INCREMENT `kds_materials`
--
ALTER TABLE `kds_materials`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- 使用表AUTO_INCREMENT `kds_material_expiries`
--
ALTER TABLE `kds_material_expiries`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_material_translations`
--
ALTER TABLE `kds_material_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- 使用表AUTO_INCREMENT `kds_products`
--
ALTER TABLE `kds_products`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- 使用表AUTO_INCREMENT `kds_product_adjustments`
--
ALTER TABLE `kds_product_adjustments`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_product_categories`
--
ALTER TABLE `kds_product_categories`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_product_category_translations`
--
ALTER TABLE `kds_product_category_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_product_recipes`
--
ALTER TABLE `kds_product_recipes`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=398;

--
-- 使用表AUTO_INCREMENT `kds_product_statuses`
--
ALTER TABLE `kds_product_statuses`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `kds_product_translations`
--
ALTER TABLE `kds_product_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- 使用表AUTO_INCREMENT `kds_recipe_adjustments`
--
ALTER TABLE `kds_recipe_adjustments`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=557;

--
-- 使用表AUTO_INCREMENT `kds_sop_query_rules`
--
ALTER TABLE `kds_sop_query_rules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `kds_stores`
--
ALTER TABLE `kds_stores`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `kds_sweetness_options`
--
ALTER TABLE `kds_sweetness_options`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `kds_sweetness_option_translations`
--
ALTER TABLE `kds_sweetness_option_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- 使用表AUTO_INCREMENT `kds_units`
--
ALTER TABLE `kds_units`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 使用表AUTO_INCREMENT `kds_unit_translations`
--
ALTER TABLE `kds_unit_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- 使用表AUTO_INCREMENT `kds_users`
--
ALTER TABLE `kds_users`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `member_passes`
--
ALTER TABLE `member_passes`
  MODIFY `member_pass_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '会员持卡ID', AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `pass_daily_usage`
--
ALTER TABLE `pass_daily_usage`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `pass_plans`
--
ALTER TABLE `pass_plans`
  MODIFY `pass_plan_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '次卡方案ID', AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `pass_redemptions`
--
ALTER TABLE `pass_redemptions`
  MODIFY `redemption_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '核销明细ID (每杯)', AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `pass_redemption_batches`
--
ALTER TABLE `pass_redemption_batches`
  MODIFY `batch_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '核销批次ID (对应一单)', AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `pos_addons`
--
ALTER TABLE `pos_addons`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_categories`
--
ALTER TABLE `pos_categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- 使用表AUTO_INCREMENT `pos_coupons`
--
ALTER TABLE `pos_coupons`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_daily_tracking`
--
ALTER TABLE `pos_daily_tracking`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- 使用表AUTO_INCREMENT `pos_eod_records`
--
ALTER TABLE `pos_eod_records`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- 使用表AUTO_INCREMENT `pos_eod_reports`
--
ALTER TABLE `pos_eod_reports`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_held_orders`
--
ALTER TABLE `pos_held_orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_invoices`
--
ALTER TABLE `pos_invoices`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_invoice_counters`
--
ALTER TABLE `pos_invoice_counters`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_invoice_items`
--
ALTER TABLE `pos_invoice_items`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_item_variants`
--
ALTER TABLE `pos_item_variants`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- 使用表AUTO_INCREMENT `pos_members`
--
ALTER TABLE `pos_members`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `pos_member_issued_coupons`
--
ALTER TABLE `pos_member_issued_coupons`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_member_levels`
--
ALTER TABLE `pos_member_levels`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `pos_member_points_log`
--
ALTER TABLE `pos_member_points_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_menu_items`
--
ALTER TABLE `pos_menu_items`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- 使用表AUTO_INCREMENT `pos_point_redemption_rules`
--
ALTER TABLE `pos_point_redemption_rules`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_print_templates`
--
ALTER TABLE `pos_print_templates`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `pos_product_availability`
--
ALTER TABLE `pos_product_availability`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- 使用表AUTO_INCREMENT `pos_promotions`
--
ALTER TABLE `pos_promotions`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `pos_shifts`
--
ALTER TABLE `pos_shifts`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- 使用表AUTO_INCREMENT `pos_tags`
--
ALTER TABLE `pos_tags`
  MODIFY `tag_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用表AUTO_INCREMENT `pos_vr_counters`
--
ALTER TABLE `pos_vr_counters`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- 使用表AUTO_INCREMENT `topup_orders`
--
ALTER TABLE `topup_orders`
  MODIFY `topup_order_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '售卡订单ID', AUTO_INCREMENT=9;

--
-- 限制导出的表
--

--
-- 限制表 `cpsys_users`
--
ALTER TABLE `cpsys_users`
  ADD CONSTRAINT `cpsys_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `cpsys_roles` (`id`) ON DELETE RESTRICT;

--
-- 限制表 `kds_global_adjustment_rules`
--
ALTER TABLE `kds_global_adjustment_rules`
  ADD CONSTRAINT `fk_global_action_material` FOREIGN KEY (`action_material_id`) REFERENCES `kds_materials` (`id`),
  ADD CONSTRAINT `fk_global_action_unit` FOREIGN KEY (`action_unit_id`) REFERENCES `kds_units` (`id`),
  ADD CONSTRAINT `fk_global_cond_cup` FOREIGN KEY (`cond_cup_id`) REFERENCES `kds_cups` (`id`),
  ADD CONSTRAINT `fk_global_cond_ice` FOREIGN KEY (`cond_ice_id`) REFERENCES `kds_ice_options` (`id`),
  ADD CONSTRAINT `fk_global_cond_material` FOREIGN KEY (`cond_material_id`) REFERENCES `kds_materials` (`id`),
  ADD CONSTRAINT `fk_global_cond_sweet` FOREIGN KEY (`cond_sweet_id`) REFERENCES `kds_sweetness_options` (`id`);

--
-- 限制表 `kds_ice_option_translations`
--
ALTER TABLE `kds_ice_option_translations`
  ADD CONSTRAINT `kds_ice_option_translations_ibfk_1` FOREIGN KEY (`ice_option_id`) REFERENCES `kds_ice_options` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_materials`
--
ALTER TABLE `kds_materials`
  ADD CONSTRAINT `fk_material_large_unit` FOREIGN KEY (`large_unit_id`) REFERENCES `kds_units` (`id`) ON DELETE SET NULL;

--
-- 限制表 `kds_material_translations`
--
ALTER TABLE `kds_material_translations`
  ADD CONSTRAINT `kds_material_translations_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `kds_materials` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_products`
--
ALTER TABLE `kds_products`
  ADD CONSTRAINT `kds_products_ibfk_2` FOREIGN KEY (`status_id`) REFERENCES `kds_product_statuses` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `kds_products_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `kds_product_categories` (`id`) ON DELETE SET NULL;

--
-- 限制表 `kds_product_adjustments`
--
ALTER TABLE `kds_product_adjustments`
  ADD CONSTRAINT `kds_product_adjustments_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `kds_products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kds_product_adjustments_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `kds_materials` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `kds_product_adjustments_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `kds_units` (`id`) ON DELETE RESTRICT;

--
-- 限制表 `kds_product_categories`
--
ALTER TABLE `kds_product_categories`
  ADD CONSTRAINT `kds_product_categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `kds_product_categories` (`id`) ON DELETE SET NULL;

--
-- 限制表 `kds_product_category_translations`
--
ALTER TABLE `kds_product_category_translations`
  ADD CONSTRAINT `kds_product_category_translations_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `kds_product_categories` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_product_ice_options`
--
ALTER TABLE `kds_product_ice_options`
  ADD CONSTRAINT `kds_product_ice_options_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `kds_products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kds_product_ice_options_ibfk_2` FOREIGN KEY (`ice_option_id`) REFERENCES `kds_ice_options` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_product_recipes`
--
ALTER TABLE `kds_product_recipes`
  ADD CONSTRAINT `kds_product_recipes_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `kds_products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kds_product_recipes_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `kds_materials` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `kds_product_recipes_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `kds_units` (`id`) ON DELETE RESTRICT;

--
-- 限制表 `kds_product_sweetness_options`
--
ALTER TABLE `kds_product_sweetness_options`
  ADD CONSTRAINT `kds_product_sweetness_options_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `kds_products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kds_product_sweetness_options_ibfk_2` FOREIGN KEY (`sweetness_option_id`) REFERENCES `kds_sweetness_options` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_product_translations`
--
ALTER TABLE `kds_product_translations`
  ADD CONSTRAINT `kds_product_translations_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `kds_products` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_recipe_adjustments`
--
ALTER TABLE `kds_recipe_adjustments`
  ADD CONSTRAINT `fk_adj_cup` FOREIGN KEY (`cup_id`) REFERENCES `kds_cups` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_adj_ice` FOREIGN KEY (`ice_option_id`) REFERENCES `kds_ice_options` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_adj_material` FOREIGN KEY (`material_id`) REFERENCES `kds_materials` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_adj_product` FOREIGN KEY (`product_id`) REFERENCES `kds_products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_adj_sweetness` FOREIGN KEY (`sweetness_option_id`) REFERENCES `kds_sweetness_options` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_adj_unit` FOREIGN KEY (`unit_id`) REFERENCES `kds_units` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_sweetness_option_translations`
--
ALTER TABLE `kds_sweetness_option_translations`
  ADD CONSTRAINT `kds_sweetness_option_translations_ibfk_1` FOREIGN KEY (`sweetness_option_id`) REFERENCES `kds_sweetness_options` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_unit_translations`
--
ALTER TABLE `kds_unit_translations`
  ADD CONSTRAINT `kds_unit_translations_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `kds_units` (`id`) ON DELETE CASCADE;

--
-- 限制表 `kds_users`
--
ALTER TABLE `kds_users`
  ADD CONSTRAINT `kds_users_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `kds_stores` (`id`) ON DELETE CASCADE;

--
-- 限制表 `member_passes`
--
ALTER TABLE `member_passes`
  ADD CONSTRAINT `fk_pass_member` FOREIGN KEY (`member_id`) REFERENCES `pos_members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pass_plan` FOREIGN KEY (`pass_plan_id`) REFERENCES `pass_plans` (`pass_plan_id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_pass_topup_order` FOREIGN KEY (`topup_order_id`) REFERENCES `topup_orders` (`topup_order_id`) ON DELETE CASCADE;

--
-- 限制表 `pass_daily_usage`
--
ALTER TABLE `pass_daily_usage`
  ADD CONSTRAINT `fk_usage_pass` FOREIGN KEY (`member_pass_id`) REFERENCES `member_passes` (`member_pass_id`) ON DELETE CASCADE;

--
-- 限制表 `pass_redemptions`
--
ALTER TABLE `pass_redemptions`
  ADD CONSTRAINT `fk_redemption_batch` FOREIGN KEY (`batch_id`) REFERENCES `pass_redemption_batches` (`batch_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_redemption_invoice` FOREIGN KEY (`order_id`) REFERENCES `pos_invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_redemption_invoice_item` FOREIGN KEY (`order_item_id`) REFERENCES `pos_invoice_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_redemption_pass` FOREIGN KEY (`member_pass_id`) REFERENCES `member_passes` (`member_pass_id`) ON DELETE RESTRICT;

--
-- 限制表 `pass_redemption_batches`
--
ALTER TABLE `pass_redemption_batches`
  ADD CONSTRAINT `fk_batch_invoice` FOREIGN KEY (`order_id`) REFERENCES `pos_invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_batch_pass` FOREIGN KEY (`member_pass_id`) REFERENCES `member_passes` (`member_pass_id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_batch_store` FOREIGN KEY (`store_id`) REFERENCES `kds_stores` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_batch_user` FOREIGN KEY (`cashier_user_id`) REFERENCES `kds_users` (`id`) ON DELETE RESTRICT;

--
-- 限制表 `pos_addon_tag_map`
--
ALTER TABLE `pos_addon_tag_map`
  ADD CONSTRAINT `fk_addon_map_addon` FOREIGN KEY (`addon_id`) REFERENCES `pos_addons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_addon_map_tag` FOREIGN KEY (`tag_id`) REFERENCES `pos_tags` (`tag_id`) ON DELETE CASCADE;

--
-- 限制表 `pos_invoices`
--
ALTER TABLE `pos_invoices`
  ADD CONSTRAINT `fk_invoice_shift` FOREIGN KEY (`shift_id`) REFERENCES `pos_shifts` (`id`) ON DELETE SET NULL;

--
-- 限制表 `pos_item_variants`
--
ALTER TABLE `pos_item_variants`
  ADD CONSTRAINT `fk_variant_cup` FOREIGN KEY (`cup_id`) REFERENCES `kds_cups` (`id`) ON DELETE SET NULL;

--
-- 限制表 `pos_members`
--
ALTER TABLE `pos_members`
  ADD CONSTRAINT `fk_member_level` FOREIGN KEY (`member_level_id`) REFERENCES `pos_member_levels` (`id`) ON DELETE SET NULL;

--
-- 限制表 `pos_member_issued_coupons`
--
ALTER TABLE `pos_member_issued_coupons`
  ADD CONSTRAINT `fk_issued_coupon_member` FOREIGN KEY (`member_id`) REFERENCES `pos_members` (`id`) ON DELETE CASCADE;

--
-- 限制表 `pos_member_points_log`
--
ALTER TABLE `pos_member_points_log`
  ADD CONSTRAINT `fk_member_points_member` FOREIGN KEY (`member_id`) REFERENCES `pos_members` (`id`) ON DELETE CASCADE;

--
-- 限制表 `pos_point_redemption_rules`
--
ALTER TABLE `pos_point_redemption_rules`
  ADD CONSTRAINT `pos_point_redemption_rules_ibfk_1` FOREIGN KEY (`reward_promo_id`) REFERENCES `pos_promotions` (`id`) ON DELETE SET NULL;

--
-- 限制表 `pos_product_tag_map`
--
ALTER TABLE `pos_product_tag_map`
  ADD CONSTRAINT `fk_tag_map_product` FOREIGN KEY (`product_id`) REFERENCES `pos_menu_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tag_map_tag` FOREIGN KEY (`tag_id`) REFERENCES `pos_tags` (`tag_id`) ON DELETE CASCADE;

--
-- 限制表 `topup_orders`
--
ALTER TABLE `topup_orders`
  ADD CONSTRAINT `fk_topup_member` FOREIGN KEY (`member_id`) REFERENCES `pos_members` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_topup_plan` FOREIGN KEY (`pass_plan_id`) REFERENCES `pass_plans` (`pass_plan_id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_topup_reviewer` FOREIGN KEY (`reviewed_by_user_id`) REFERENCES `cpsys_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_topup_store` FOREIGN KEY (`store_id`) REFERENCES `kds_stores` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_topup_user` FOREIGN KEY (`sale_user_id`) REFERENCES `kds_users` (`id`) ON DELETE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
