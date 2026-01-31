-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- 主机： mhdlmskvtmwsnt5z.mysql.db
-- 生成日期： 2026-01-31 02:41:00
-- 服务器版本： 8.4.7-7
-- PHP 版本： 8.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `mhdlmskvtmwsnt5z`
--
CREATE DATABASE IF NOT EXISTS `mhdlmskvtmwsnt5z` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `mhdlmskvtmwsnt5z`;

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
(1, 'toptea_admin', '$2y$10$8t9wfcsnMJPGSiIYnhBwTO4d8AQm4d6aCgeoD.DBcPYEMCypjA3Am', 'admin@toptea.es', 'TopTea Admin', 1, 1, '2026-01-31 00:12:47.000000', '2025-10-22 21:43:58.000000', '2026-01-31 00:12:47.953936', NULL),
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
-- 表的结构 `kds_print_templates`
--

DROP TABLE IF EXISTS `kds_print_templates`;
CREATE TABLE `kds_print_templates` (
  `id` int UNSIGNED NOT NULL,
  `template_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板代码 (e.g., EXPIRY_LABEL)',
  `template_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `template_type` enum('TSPL','ESC_POS') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TSPL' COMMENT '打印机语言类型',
  `paper_width` int UNSIGNED NOT NULL DEFAULT '40' COMMENT '纸张宽度(mm)',
  `paper_height` int UNSIGNED NOT NULL DEFAULT '30' COMMENT '纸张高度(mm)',
  `template_content` json NOT NULL COMMENT '模板内容（JSON格式的打印指令）',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '模板说明',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS打印模板表';

--
-- 转存表中的数据 `kds_print_templates`
--

INSERT INTO `kds_print_templates` (`id`, `template_code`, `template_name`, `template_type`, `paper_width`, `paper_height`, `template_content`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'EXPIRY_LABEL', '效期标签', 'TSPL', 40, 30, '{\"copies\": 1, \"commands\": [{\"x\": 10, \"y\": 10, \"font\": 2, \"type\": \"text\", \"content\": \"{{material_name}}\"}, {\"x\": 0, \"y\": 35, \"type\": \"divider\", \"width\": 300}, {\"x\": 10, \"y\": 45, \"font\": 1, \"type\": \"kv\", \"label\": \"开封:\", \"value\": \"{{opened_at_time}}\"}, {\"x\": 10, \"y\": 70, \"font\": 1, \"type\": \"kv\", \"label\": \"过期:\", \"value\": \"{{expires_at_time}}\"}, {\"x\": 10, \"y\": 95, \"font\": 2, \"type\": \"text\", \"content\": \"剩余: {{time_left}}\"}, {\"x\": 10, \"y\": 120, \"font\": 1, \"type\": \"kv\", \"label\": \"操作员:\", \"value\": \"{{handler_name}}\"}]}', '物料开封后打印的效期追踪标签', 1, '2026-01-27 01:09:49.989797', '2026-01-27 01:09:49.989797');

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
  `tax_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '门店税号 (NIF/CIF)，用于票据合规',
  `store_city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所在城市',
  `store_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '详细地址',
  `store_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `store_cif` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'CIF/税号',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)),
  `updated_at` datetime(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6),
  `deleted_at` datetime(6) DEFAULT NULL,
  `pr_kds_type` enum('NONE','WIFI','BLUETOOTH','USB') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NONE' COMMENT '角色3: KDS厨房/效期打印机',
  `pr_kds_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色3: IP地址',
  `pr_kds_port` int DEFAULT NULL COMMENT '角色3: 端口',
  `pr_kds_mac` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色3: 蓝牙MAC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS - 门店表';

--
-- 转存表中的数据 `kds_stores`
--

INSERT INTO `kds_stores` (`id`, `store_code`, `store_name`, `tax_id`, `store_city`, `store_address`, `store_phone`, `store_cif`, `is_active`, `created_at`, `updated_at`, `deleted_at`, `pr_kds_type`, `pr_kds_ip`, `pr_kds_port`, `pr_kds_mac`) VALUES
(1, 'A1001', 'TopTea 演示门店', 'B12345678', 'MADRID', NULL, NULL, NULL, 1, '2025-10-24 00:00:09.000000', '2025-11-11 00:32:14.000000', NULL, 'NONE', NULL, NULL, NULL);

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
(1, 1, 'kds_user', '$2y$10$CJ5eP.Tsdb30A8IhlinTkedNL6aQpYkVBMKGOL7InBusP/vW.0NdG', 'KDS Staff3', 'manager', 1, '2026-01-31 00:54:52.000000', '2025-10-24 00:00:09.000000', '2026-01-31 00:54:52.815879', NULL),
(2, 1, '11', '4fc82b26aecb47d2868c4efbe3581732a3e7cbcc6c2efb32062c08170a05eeb8', '22', 'staff', 1, NULL, '2025-11-05 20:40:52.000000', '2025-11-05 20:40:58.000000', '2025-11-05 20:40:58.000000');

-- --------------------------------------------------------

--
-- 表的结构 `stock_import_details`
--

DROP TABLE IF EXISTS `stock_import_details`;
CREATE TABLE `stock_import_details` (
  `id` int UNSIGNED NOT NULL,
  `import_log_id` int UNSIGNED NOT NULL COMMENT '入库日志ID',
  `material_id` int UNSIGNED NOT NULL COMMENT '物料ID',
  `quantity` decimal(12,3) NOT NULL COMMENT '入库数量（基础单位）',
  `unit_id` int UNSIGNED NOT NULL COMMENT '原始单位ID（用于显示）',
  `batch_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '批次号',
  `shelf_life_date` date DEFAULT NULL COMMENT '未开封保质期'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库明细表';

-- --------------------------------------------------------

--
-- 表的结构 `stock_import_logs`
--

DROP TABLE IF EXISTS `stock_import_logs`;
CREATE TABLE `stock_import_logs` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL COMMENT '门店ID',
  `import_code_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SHA256(原始入库码)，防重复导入',
  `mrs_reference` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'MRS出货单号',
  `shipment_date` date NOT NULL COMMENT '出货日期',
  `items_count` int UNSIGNED NOT NULL COMMENT '物料种类数',
  `raw_code` text COLLATE utf8mb4_unicode_ci COMMENT '原始入库码（Base64）',
  `imported_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `imported_by` int UNSIGNED DEFAULT NULL COMMENT '操作人(kds_users.id)',
  `import_source` enum('KDS','HQ') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '导入来源'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库日志表';

-- --------------------------------------------------------

--
-- 表的结构 `store_inspection_photos`
--

DROP TABLE IF EXISTS `store_inspection_photos`;
CREATE TABLE `store_inspection_photos` (
  `id` int UNSIGNED NOT NULL,
  `task_id` int UNSIGNED NOT NULL COMMENT '任务ID',
  `photo_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '照片存储路径',
  `file_size` int UNSIGNED DEFAULT NULL COMMENT '文件大小(字节)',
  `file_hash` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SHA256 哈希值(防篡改)',
  `taken_at` datetime DEFAULT NULL COMMENT '拍摄时间',
  `device_make` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '设备厂商',
  `device_model` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '设备型号',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT '经度',
  `uploaded_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `uploaded_by` int UNSIGNED DEFAULT NULL COMMENT '上传者 (kds_users.id)',
  `upload_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上传者IP',
  `photo_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '照片说明',
  `validation_flags` json DEFAULT NULL COMMENT '校验结果 (no_exif, old_photo等)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查照片表';

--
-- 转存表中的数据 `store_inspection_photos`
--

INSERT INTO `store_inspection_photos` (`id`, `task_id`, `photo_path`, `file_size`, `file_hash`, `taken_at`, `device_make`, `device_model`, `latitude`, `longitude`, `uploaded_at`, `uploaded_by`, `upload_ip`, `photo_note`, `validation_flags`) VALUES
(2, 3, '1/2026/01/task_3_1769725233_9b34e48f.jpg', 68851, '9b34e48f40e0105aae3dc46f6b431d5df7cbaf85eae8ce0d1671f979a2f8e74c', NULL, NULL, NULL, NULL, NULL, '2026-01-29 22:20:33.481654', 1, '79.117.222.242', NULL, '{\"no_exif\": true}'),
(3, 3, '1/2026/01/task_3_1769727390_ff8d95fc.jpg', 145688, 'ff8d95fcbd03adac3eac8e55b9f8594419660c03e4ffe64e0ae010c3b27abb9a', NULL, NULL, NULL, NULL, NULL, '2026-01-29 22:56:30.442812', 1, '79.117.222.242', NULL, '{\"no_exif\": true}'),
(4, 3, '1/2026/01/task_3_1769728407_3062cce1.jpg', 133368, '3062cce1a9258c61ea5ac369f07db7a819550d0885850435b40bb423dee43085', NULL, NULL, NULL, NULL, NULL, '2026-01-29 23:13:27.169582', 1, '79.117.222.242', NULL, '{\"no_exif\": true}'),
(5, 3, '1/2026/01/task_3_1769735158_81a5fd2a.jpg', 81573, '81a5fd2a3013b63d40ee95848b629a1c3bffaca471002280ce7f7c72201da423', NULL, NULL, NULL, NULL, NULL, '2026-01-30 01:05:58.947622', 1, '79.117.222.242', NULL, '{\"no_exif\": true}'),
(6, 4, '1/2026/01/task_4_1769820939_bf64f79e.jpg', 90223, 'bf64f79ef374a5a19ab182ce3570a60c339d90eb657128dce2d05304fcf9c208', NULL, NULL, NULL, NULL, NULL, '2026-01-31 00:55:39.492341', 1, '79.117.222.242', NULL, '{\"no_exif\": true}');

-- --------------------------------------------------------

--
-- 表的结构 `store_inspection_tasks`
--

DROP TABLE IF EXISTS `store_inspection_tasks`;
CREATE TABLE `store_inspection_tasks` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL COMMENT '门店ID',
  `template_id` int UNSIGNED NOT NULL COMMENT '模板ID',
  `period_key` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '周期标识: 2026-01(月), 2026-W04(周), 2026(年)',
  `period_start` date NOT NULL COMMENT '周期开始日期',
  `period_end` date NOT NULL COMMENT '周期截止日期',
  `status` enum('pending','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '任务状态',
  `completed_at` datetime DEFAULT NULL COMMENT '完成时间',
  `completed_by` int UNSIGNED DEFAULT NULL COMMENT '完成人 (kds_users.id)',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT '店长备注',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查任务表';

--
-- 转存表中的数据 `store_inspection_tasks`
--

INSERT INTO `store_inspection_tasks` (`id`, `store_id`, `template_id`, `period_key`, `period_start`, `period_end`, `status`, `completed_at`, `completed_by`, `notes`, `created_at`) VALUES
(1, 1, 1, '2026-01', '2026-01-01', '2026-01-25', 'pending', NULL, NULL, NULL, '2026-01-27 15:52:34.823698'),
(2, 1, 2, '2026-01', '2026-01-01', '2026-01-25', 'pending', NULL, NULL, NULL, '2026-01-27 15:52:34.826402'),
(3, 1, 3, '2026-W05', '2026-01-26', '2026-01-30', '', '2026-01-30 01:05:58', 1, NULL, '2026-01-27 15:52:34.828135'),
(4, 1, 4, '2026-W05', '2026-01-26', '2026-02-01', '', '2026-01-31 00:55:39', 1, NULL, '2026-01-31 00:54:20.360116');

-- --------------------------------------------------------

--
-- 表的结构 `store_inspection_templates`
--

DROP TABLE IF EXISTS `store_inspection_templates`;
CREATE TABLE `store_inspection_templates` (
  `id` int UNSIGNED NOT NULL,
  `template_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板代码 (唯一)',
  `template_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '检查名称，如"消防设备检查"',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '检查说明/要求',
  `frequency_type` enum('weekly','monthly','yearly') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'monthly' COMMENT '检查周期类型',
  `due_day` int UNSIGNED DEFAULT '25' COMMENT '月度/年度: 每月/年第几天截止 (1-31)',
  `due_weekday` int UNSIGNED DEFAULT '5' COMMENT '周度: 周几截止 (1=周一, 7=周日)',
  `due_month` int UNSIGNED DEFAULT '12' COMMENT '年度: 第几月截止 (1-12)',
  `photo_hint` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '照片拍摄提示，如"请拍摄所有灭火器"',
  `apply_to_all` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=全部门店, 0=指定门店',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查模板表';

--
-- 转存表中的数据 `store_inspection_templates`
--

INSERT INTO `store_inspection_templates` (`id`, `template_code`, `template_name`, `description`, `frequency_type`, `due_day`, `due_weekday`, `due_month`, `photo_hint`, `apply_to_all`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'FIRE_EQUIPMENT', '消防设备检查', '1. 检查所有灭火器是否在有效期内\n2. 检查灭火器压力是否正常\n3. 检查消防通道是否畅通\n4. 检查应急出口标识是否完好', 'monthly', 25, 5, 12, '请拍摄所有灭火器，每个灭火器一张照片', 1, 1, '2026-01-27 12:18:02.144161', '2026-01-27 12:18:02.144161'),
(2, 'EMERGENCY_LIGHT', '应急灯检查', '1. 检查应急照明灯是否正常工作\n2. 检查安全出口指示灯是否亮\n3. 测试断电后应急灯是否自动启动', 'monthly', 25, 5, 12, '请拍摄每个应急灯的工作状态', 1, 1, '2026-01-27 12:18:02.144161', '2026-01-27 12:18:02.144161'),
(3, 'FOOD_HYGIENE', '食品卫生检查', '1. 检查冰箱温度是否在标准范围内\n2. 检查食材是否在保质期内\n3. 检查工作台和设备清洁情况', 'weekly', 5, 5, 12, '请拍摄冰箱温度计、食材标签、工作台照片', 1, 1, '2026-01-27 12:18:02.144161', '2026-01-27 12:18:02.144161'),
(4, 'TEST_001', '测试检查', '', 'weekly', 25, 7, 12, '', 1, 1, '2026-01-31 00:54:09.745116', '2026-01-31 00:54:09.745116');

-- --------------------------------------------------------

--
-- 表的结构 `store_inspection_template_stores`
--

DROP TABLE IF EXISTS `store_inspection_template_stores`;
CREATE TABLE `store_inspection_template_stores` (
  `id` int UNSIGNED NOT NULL,
  `template_id` int UNSIGNED NOT NULL COMMENT '模板ID',
  `store_id` int UNSIGNED NOT NULL COMMENT '门店ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查模板-门店关联表';

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
-- 表的索引 `kds_print_templates`
--
ALTER TABLE `kds_print_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_template_code` (`template_code`);

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
  ADD UNIQUE KEY `store_code` (`store_code`);

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
-- 表的索引 `stock_import_details`
--
ALTER TABLE `stock_import_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_import_log` (`import_log_id`),
  ADD KEY `idx_material` (`material_id`);

--
-- 表的索引 `stock_import_logs`
--
ALTER TABLE `stock_import_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_hash` (`import_code_hash`),
  ADD KEY `idx_store_date` (`store_id`,`shipment_date`),
  ADD KEY `idx_mrs_ref` (`mrs_reference`);

--
-- 表的索引 `store_inspection_photos`
--
ALTER TABLE `store_inspection_photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_task` (`task_id`),
  ADD KEY `idx_uploaded_at` (`uploaded_at`);

--
-- 表的索引 `store_inspection_tasks`
--
ALTER TABLE `store_inspection_tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_store_template_period` (`store_id`,`template_id`,`period_key`),
  ADD KEY `idx_store_status` (`store_id`,`status`),
  ADD KEY `idx_period_key` (`period_key`),
  ADD KEY `idx_period_end` (`period_end`),
  ADD KEY `fk_inspection_task_template` (`template_id`);

--
-- 表的索引 `store_inspection_templates`
--
ALTER TABLE `store_inspection_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_template_code` (`template_code`),
  ADD KEY `idx_frequency_active` (`frequency_type`,`is_active`);

--
-- 表的索引 `store_inspection_template_stores`
--
ALTER TABLE `store_inspection_template_stores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_template_store` (`template_id`,`store_id`),
  ADD KEY `idx_store` (`store_id`);

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
-- 使用表AUTO_INCREMENT `kds_print_templates`
--
ALTER TABLE `kds_print_templates`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
-- 使用表AUTO_INCREMENT `stock_import_details`
--
ALTER TABLE `stock_import_details`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `stock_import_logs`
--
ALTER TABLE `stock_import_logs`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `store_inspection_photos`
--
ALTER TABLE `store_inspection_photos`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用表AUTO_INCREMENT `store_inspection_tasks`
--
ALTER TABLE `store_inspection_tasks`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `store_inspection_templates`
--
ALTER TABLE `store_inspection_templates`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `store_inspection_template_stores`
--
ALTER TABLE `store_inspection_template_stores`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

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
-- 限制表 `stock_import_details`
--
ALTER TABLE `stock_import_details`
  ADD CONSTRAINT `fk_import_detail_log` FOREIGN KEY (`import_log_id`) REFERENCES `stock_import_logs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_import_detail_material` FOREIGN KEY (`material_id`) REFERENCES `kds_materials` (`id`) ON DELETE RESTRICT;

--
-- 限制表 `stock_import_logs`
--
ALTER TABLE `stock_import_logs`
  ADD CONSTRAINT `fk_import_log_store` FOREIGN KEY (`store_id`) REFERENCES `kds_stores` (`id`) ON DELETE CASCADE;

--
-- 限制表 `store_inspection_photos`
--
ALTER TABLE `store_inspection_photos`
  ADD CONSTRAINT `fk_inspection_photo_task` FOREIGN KEY (`task_id`) REFERENCES `store_inspection_tasks` (`id`) ON DELETE CASCADE;

--
-- 限制表 `store_inspection_tasks`
--
ALTER TABLE `store_inspection_tasks`
  ADD CONSTRAINT `fk_inspection_task_store` FOREIGN KEY (`store_id`) REFERENCES `kds_stores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_inspection_task_template` FOREIGN KEY (`template_id`) REFERENCES `store_inspection_templates` (`id`) ON DELETE CASCADE;

--
-- 限制表 `store_inspection_template_stores`
--
ALTER TABLE `store_inspection_template_stores`
  ADD CONSTRAINT `fk_inspection_template_stores_store` FOREIGN KEY (`store_id`) REFERENCES `kds_stores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_inspection_template_stores_template` FOREIGN KEY (`template_id`) REFERENCES `store_inspection_templates` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
