-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- 主机： mhdlmskvtmwsnt5z.mysql.db
-- 生成日期： 2026-01-27 12:18:15
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

-- --------------------------------------------------------

--
-- 表的结构 `kds_product_sweetness_options`
--

DROP TABLE IF EXISTS `kds_product_sweetness_options`;
CREATE TABLE `kds_product_sweetness_options` (
  `product_id` int UNSIGNED NOT NULL,
  `sweetness_option_id` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品与甜度选项的关联表';

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
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `cpsys_users`
--
ALTER TABLE `cpsys_users`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `expsys_store_stock`
--
ALTER TABLE `expsys_store_stock`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_cups`
--
ALTER TABLE `kds_cups`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_global_adjustment_rules`
--
ALTER TABLE `kds_global_adjustment_rules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_ice_options`
--
ALTER TABLE `kds_ice_options`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_ice_option_translations`
--
ALTER TABLE `kds_ice_option_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_materials`
--
ALTER TABLE `kds_materials`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_material_expiries`
--
ALTER TABLE `kds_material_expiries`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_material_translations`
--
ALTER TABLE `kds_material_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_print_templates`
--
ALTER TABLE `kds_print_templates`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_products`
--
ALTER TABLE `kds_products`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_product_statuses`
--
ALTER TABLE `kds_product_statuses`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_product_translations`
--
ALTER TABLE `kds_product_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_recipe_adjustments`
--
ALTER TABLE `kds_recipe_adjustments`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_sop_query_rules`
--
ALTER TABLE `kds_sop_query_rules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_stores`
--
ALTER TABLE `kds_stores`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_sweetness_options`
--
ALTER TABLE `kds_sweetness_options`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_sweetness_option_translations`
--
ALTER TABLE `kds_sweetness_option_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_units`
--
ALTER TABLE `kds_units`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_unit_translations`
--
ALTER TABLE `kds_unit_translations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `kds_users`
--
ALTER TABLE `kds_users`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `store_inspection_tasks`
--
ALTER TABLE `store_inspection_tasks`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `store_inspection_templates`
--
ALTER TABLE `store_inspection_templates`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

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
