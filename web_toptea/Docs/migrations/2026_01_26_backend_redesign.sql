-- ============================================================================
-- Toptea 后台系统重构 - 数据库迁移脚本
-- Version: 1.0
-- Date: 2026-01-26
-- Description: 移除POS/总仓模块，保留配方管理+门店库存+KDS出品
-- ============================================================================

-- 使用事务确保原子性
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

-- ============================================================================
-- PART 1: 创建新表
-- ============================================================================

-- 1.1 门店库存表 (如果不存在则创建)
CREATE TABLE IF NOT EXISTS `expsys_store_stock` (
    `store_id` INT UNSIGNED NOT NULL COMMENT '门店ID',
    `material_id` INT UNSIGNED NOT NULL COMMENT '物料ID',
    `quantity` DECIMAL(12,3) NOT NULL DEFAULT 0 COMMENT '当前库存（基础单位）',
    `last_updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (`store_id`, `material_id`),
    INDEX `idx_material` (`material_id`),
    CONSTRAINT `fk_store_stock_store` FOREIGN KEY (`store_id`) REFERENCES `kds_stores`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_store_stock_material` FOREIGN KEY (`material_id`) REFERENCES `kds_materials`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='门店库存表';

-- 1.2 入库日志表
CREATE TABLE IF NOT EXISTS `stock_import_logs` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `store_id` INT UNSIGNED NOT NULL COMMENT '门店ID',
    `import_code_hash` VARCHAR(64) NOT NULL COMMENT 'SHA256(原始入库码)，防重复导入',
    `mrs_reference` VARCHAR(100) NOT NULL COMMENT 'MRS出货单号',
    `shipment_date` DATE NOT NULL COMMENT '出货日期',
    `items_count` INT UNSIGNED NOT NULL COMMENT '物料种类数',
    `raw_code` TEXT COMMENT '原始入库码（Base64）',
    `imported_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `imported_by` INT UNSIGNED DEFAULT NULL COMMENT '操作人(kds_users.id)',
    `import_source` ENUM('KDS', 'HQ') NOT NULL COMMENT '导入来源',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_hash` (`import_code_hash`),
    INDEX `idx_store_date` (`store_id`, `shipment_date`),
    INDEX `idx_mrs_ref` (`mrs_reference`),
    CONSTRAINT `fk_import_log_store` FOREIGN KEY (`store_id`) REFERENCES `kds_stores`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库日志表';

-- 1.3 入库明细表
CREATE TABLE IF NOT EXISTS `stock_import_details` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `import_log_id` INT UNSIGNED NOT NULL COMMENT '入库日志ID',
    `material_id` INT UNSIGNED NOT NULL COMMENT '物料ID',
    `quantity` DECIMAL(12,3) NOT NULL COMMENT '入库数量（基础单位）',
    `unit_id` INT UNSIGNED NOT NULL COMMENT '原始单位ID（用于显示）',
    `batch_code` VARCHAR(50) DEFAULT NULL COMMENT '批次号',
    `shelf_life_date` DATE DEFAULT NULL COMMENT '未开封保质期',
    PRIMARY KEY (`id`),
    INDEX `idx_import_log` (`import_log_id`),
    INDEX `idx_material` (`material_id`),
    CONSTRAINT `fk_import_detail_log` FOREIGN KEY (`import_log_id`) REFERENCES `stock_import_logs`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_import_detail_material` FOREIGN KEY (`material_id`) REFERENCES `kds_materials`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库明细表';

-- 1.4 KDS打印模板表
CREATE TABLE IF NOT EXISTS `kds_print_templates` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `template_code` VARCHAR(50) NOT NULL COMMENT '模板代码 (e.g., EXPIRY_LABEL)',
    `template_name` VARCHAR(100) NOT NULL COMMENT '模板名称',
    `template_type` ENUM('TSPL', 'ESC_POS') NOT NULL DEFAULT 'TSPL' COMMENT '打印机语言类型',
    `paper_width` INT UNSIGNED NOT NULL DEFAULT 40 COMMENT '纸张宽度(mm)',
    `paper_height` INT UNSIGNED NOT NULL DEFAULT 30 COMMENT '纸张高度(mm)',
    `template_content` JSON NOT NULL COMMENT '模板内容（JSON格式的打印指令）',
    `description` TEXT COMMENT '模板说明',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_template_code` (`template_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='KDS打印模板表';

-- 1.5 插入默认效期标签模板
INSERT INTO `kds_print_templates` (`template_code`, `template_name`, `template_type`, `paper_width`, `paper_height`, `template_content`, `description`) VALUES
('EXPIRY_LABEL', '效期标签', 'TSPL', 40, 30, JSON_OBJECT(
    'commands', JSON_ARRAY(
        JSON_OBJECT('type', 'text', 'x', 10, 'y', 10, 'font', 2, 'content', '{{material_name}}'),
        JSON_OBJECT('type', 'divider', 'x', 0, 'y', 35, 'width', 300),
        JSON_OBJECT('type', 'kv', 'x', 10, 'y', 45, 'font', 1, 'label', '开封:', 'value', '{{opened_at_time}}'),
        JSON_OBJECT('type', 'kv', 'x', 10, 'y', 70, 'font', 1, 'label', '过期:', 'value', '{{expires_at_time}}'),
        JSON_OBJECT('type', 'text', 'x', 10, 'y', 95, 'font', 2, 'content', '剩余: {{time_left}}'),
        JSON_OBJECT('type', 'kv', 'x', 10, 'y', 120, 'font', 1, 'label', '操作员:', 'value', '{{handler_name}}')
    ),
    'copies', 1
), '物料开封后打印的效期追踪标签')
ON DUPLICATE KEY UPDATE `updated_at` = CURRENT_TIMESTAMP(6);


-- ============================================================================
-- PART 2: 简化 kds_stores 表 (移除POS相关字段)
-- ============================================================================

-- 2.1 删除POS相关字段 (保留 pr_kds_* 用于效期打印)
-- 注意：MySQL 8.0.23+ 才支持 DROP COLUMN IF EXISTS，为兼容性使用存储过程
DELIMITER //
CREATE PROCEDURE drop_column_if_exists(
    IN tbl_name VARCHAR(64),
    IN col_name VARCHAR(64)
)
BEGIN
    DECLARE col_exists INT;
    SELECT COUNT(*) INTO col_exists
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = tbl_name
      AND COLUMN_NAME = col_name;

    IF col_exists > 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', tbl_name, '` DROP COLUMN `', col_name, '`');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

-- 执行字段删除
CALL drop_column_if_exists('kds_stores', 'invoice_prefix');
CALL drop_column_if_exists('kds_stores', 'default_vat_rate');
CALL drop_column_if_exists('kds_stores', 'billing_system');
CALL drop_column_if_exists('kds_stores', 'eod_cutoff_hour');
CALL drop_column_if_exists('kds_stores', 'pr_receipt_type');
CALL drop_column_if_exists('kds_stores', 'pr_receipt_ip');
CALL drop_column_if_exists('kds_stores', 'pr_receipt_port');
CALL drop_column_if_exists('kds_stores', 'pr_receipt_mac');
CALL drop_column_if_exists('kds_stores', 'pr_sticker_type');
CALL drop_column_if_exists('kds_stores', 'pr_sticker_ip');
CALL drop_column_if_exists('kds_stores', 'pr_sticker_port');
CALL drop_column_if_exists('kds_stores', 'pr_sticker_mac');

-- 清理临时存储过程
DROP PROCEDURE IF EXISTS drop_column_if_exists;


-- ============================================================================
-- PART 3: 删除POS相关表
-- ============================================================================

-- 3.1 POS订单相关 (先删有外键依赖的)
DROP TABLE IF EXISTS `pos_invoice_items`;
DROP TABLE IF EXISTS `pos_invoices`;
DROP TABLE IF EXISTS `pos_invoice_counters`;
DROP TABLE IF EXISTS `pos_vr_counters`;

-- 3.2 POS运营相关
DROP TABLE IF EXISTS `pos_eod_reports`;
DROP TABLE IF EXISTS `pos_eod_records`;
DROP TABLE IF EXISTS `pos_shifts`;
DROP TABLE IF EXISTS `pos_held_orders`;
DROP TABLE IF EXISTS `pos_daily_tracking`;
DROP TABLE IF EXISTS `pos_product_availability`;

-- 3.3 次卡/会员相关
DROP TABLE IF EXISTS `pass_redemptions`;
DROP TABLE IF EXISTS `pass_redemption_batches`;
DROP TABLE IF EXISTS `pass_daily_usage`;
DROP TABLE IF EXISTS `member_passes`;
DROP TABLE IF EXISTS `pass_plans`;
DROP TABLE IF EXISTS `topup_orders`;

-- 3.4 会员系统
DROP TABLE IF EXISTS `pos_member_points_log`;
DROP TABLE IF EXISTS `pos_member_issued_coupons`;
DROP TABLE IF EXISTS `pos_members`;
DROP TABLE IF EXISTS `pos_member_levels`;

-- 3.5 促销系统
DROP TABLE IF EXISTS `pos_coupons`;
DROP TABLE IF EXISTS `pos_promotions`;
DROP TABLE IF EXISTS `pos_point_redemption_rules`;

-- 3.6 POS菜单/商品
DROP TABLE IF EXISTS `pos_addon_tag_map`;
DROP TABLE IF EXISTS `pos_product_tag_map`;
DROP TABLE IF EXISTS `pos_item_variants`;
DROP TABLE IF EXISTS `pos_addons`;
DROP TABLE IF EXISTS `pos_menu_items`;
DROP TABLE IF EXISTS `pos_categories`;
DROP TABLE IF EXISTS `pos_tags`;

-- 3.7 POS设置/打印
DROP TABLE IF EXISTS `pos_settings`;
DROP TABLE IF EXISTS `pos_print_templates`;

-- 3.8 总仓库存
DROP TABLE IF EXISTS `expsys_warehouse_stock`;


-- ============================================================================
-- PART 4: 完成
-- ============================================================================

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;

-- 输出完成信息
SELECT '数据库迁移完成！' AS status, NOW() AS executed_at;
SELECT
    '新增表' AS category,
    'expsys_store_stock, stock_import_logs, stock_import_details, kds_print_templates' AS tables
UNION ALL
SELECT
    '删除表' AS category,
    'POS相关表(约30个), expsys_warehouse_stock' AS tables
UNION ALL
SELECT
    '修改表' AS category,
    'kds_stores (移除POS相关字段)' AS tables;
