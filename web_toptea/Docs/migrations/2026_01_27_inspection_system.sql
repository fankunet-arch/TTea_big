-- ============================================================================
-- Toptea 门店检查系统 - 数据库迁移脚本
-- Version: 1.0
-- Date: 2026-01-27
-- Description: 创建门店月度/周度/年度检查系统的数据表
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

-- ============================================================================
-- PART 1: 创建检查模板表
-- ============================================================================

CREATE TABLE IF NOT EXISTS `store_inspection_templates` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `template_code` VARCHAR(50) NOT NULL COMMENT '模板代码 (唯一)',
    `template_name` VARCHAR(100) NOT NULL COMMENT '检查名称，如"消防设备检查"',
    `description` TEXT COMMENT '检查说明/要求',

    -- 周期设置
    `frequency_type` ENUM('weekly', 'monthly', 'yearly') NOT NULL DEFAULT 'monthly' COMMENT '检查周期类型',
    `due_day` INT UNSIGNED DEFAULT 25 COMMENT '月度/年度: 每月/年第几天截止 (1-31)',
    `due_weekday` INT UNSIGNED DEFAULT 5 COMMENT '周度: 周几截止 (1=周一, 7=周日)',
    `due_month` INT UNSIGNED DEFAULT 12 COMMENT '年度: 第几月截止 (1-12)',

    -- 照片要求
    `photo_hint` VARCHAR(255) COMMENT '照片拍摄提示，如"请拍摄所有灭火器"',

    -- 门店范围
    `apply_to_all` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=全部门店, 0=指定门店',

    `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
    `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_template_code` (`template_code`),
    INDEX `idx_frequency_active` (`frequency_type`, `is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查模板表';


-- ============================================================================
-- PART 2: 创建模板-门店关联表
-- ============================================================================

CREATE TABLE IF NOT EXISTS `store_inspection_template_stores` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `template_id` INT UNSIGNED NOT NULL COMMENT '模板ID',
    `store_id` INT UNSIGNED NOT NULL COMMENT '门店ID',
    `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_template_store` (`template_id`, `store_id`),
    INDEX `idx_store` (`store_id`),

    CONSTRAINT `fk_inspection_template_stores_template`
        FOREIGN KEY (`template_id`) REFERENCES `store_inspection_templates`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_inspection_template_stores_store`
        FOREIGN KEY (`store_id`) REFERENCES `kds_stores`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查模板-门店关联表';


-- ============================================================================
-- PART 3: 创建检查任务表
-- ============================================================================

CREATE TABLE IF NOT EXISTS `store_inspection_tasks` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `store_id` INT UNSIGNED NOT NULL COMMENT '门店ID',
    `template_id` INT UNSIGNED NOT NULL COMMENT '模板ID',

    -- 周期标识
    `period_key` VARCHAR(10) NOT NULL COMMENT '周期标识: 2026-01(月), 2026-W04(周), 2026(年)',
    `period_start` DATE NOT NULL COMMENT '周期开始日期',
    `period_end` DATE NOT NULL COMMENT '周期截止日期',

    -- 状态
    `status` ENUM('pending', 'completed') NOT NULL DEFAULT 'pending' COMMENT '任务状态',
    `completed_at` DATETIME COMMENT '完成时间',
    `completed_by` INT UNSIGNED COMMENT '完成人 (kds_users.id)',
    `notes` TEXT COMMENT '店长备注',

    `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_store_template_period` (`store_id`, `template_id`, `period_key`),
    INDEX `idx_store_status` (`store_id`, `status`),
    INDEX `idx_period_key` (`period_key`),
    INDEX `idx_period_end` (`period_end`),

    CONSTRAINT `fk_inspection_task_store`
        FOREIGN KEY (`store_id`) REFERENCES `kds_stores`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_inspection_task_template`
        FOREIGN KEY (`template_id`) REFERENCES `store_inspection_templates`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查任务表';


-- ============================================================================
-- PART 4: 创建检查照片表
-- ============================================================================

CREATE TABLE IF NOT EXISTS `store_inspection_photos` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `task_id` INT UNSIGNED NOT NULL COMMENT '任务ID',

    -- 文件信息
    `photo_path` VARCHAR(255) NOT NULL COMMENT '照片存储路径',
    `file_size` INT UNSIGNED COMMENT '文件大小(字节)',
    `file_hash` VARCHAR(64) COMMENT 'SHA256 哈希值(防篡改)',

    -- 拍摄信息 (从EXIF提取)
    `taken_at` DATETIME COMMENT '拍摄时间',
    `device_make` VARCHAR(100) COMMENT '设备厂商',
    `device_model` VARCHAR(100) COMMENT '设备型号',

    -- 位置信息
    `latitude` DECIMAL(10, 8) COMMENT '纬度',
    `longitude` DECIMAL(11, 8) COMMENT '经度',

    -- 上传信息
    `uploaded_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `uploaded_by` INT UNSIGNED COMMENT '上传者 (kds_users.id)',
    `upload_ip` VARCHAR(45) COMMENT '上传者IP',

    -- 照片说明
    `photo_note` VARCHAR(255) COMMENT '照片说明',

    -- 验证标记
    `validation_flags` JSON COMMENT '校验结果 (no_exif, old_photo等)',

    PRIMARY KEY (`id`),
    INDEX `idx_task` (`task_id`),
    INDEX `idx_uploaded_at` (`uploaded_at`),

    CONSTRAINT `fk_inspection_photo_task`
        FOREIGN KEY (`task_id`) REFERENCES `store_inspection_tasks`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检查照片表';


-- ============================================================================
-- PART 5: 插入示例检查模板
-- ============================================================================

INSERT INTO `store_inspection_templates`
    (`template_code`, `template_name`, `description`, `frequency_type`, `due_day`, `photo_hint`, `apply_to_all`)
VALUES
    ('FIRE_EQUIPMENT', '消防设备检查', '1. 检查所有灭火器是否在有效期内\n2. 检查灭火器压力是否正常\n3. 检查消防通道是否畅通\n4. 检查应急出口标识是否完好', 'monthly', 25, '请拍摄所有灭火器，每个灭火器一张照片', 1),
    ('EMERGENCY_LIGHT', '应急灯检查', '1. 检查应急照明灯是否正常工作\n2. 检查安全出口指示灯是否亮\n3. 测试断电后应急灯是否自动启动', 'monthly', 25, '请拍摄每个应急灯的工作状态', 1),
    ('FOOD_HYGIENE', '食品卫生检查', '1. 检查冰箱温度是否在标准范围内\n2. 检查食材是否在保质期内\n3. 检查工作台和设备清洁情况', 'weekly', 5, '请拍摄冰箱温度计、食材标签、工作台照片', 1)
ON DUPLICATE KEY UPDATE `updated_at` = CURRENT_TIMESTAMP(6);


-- ============================================================================
-- PART 6: 完成
-- ============================================================================

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;

-- 输出完成信息
SELECT '门店检查系统数据库迁移完成！' AS status, NOW() AS executed_at;
SELECT
    '新增表' AS category,
    'store_inspection_templates, store_inspection_template_stores, store_inspection_tasks, store_inspection_photos' AS tables;
