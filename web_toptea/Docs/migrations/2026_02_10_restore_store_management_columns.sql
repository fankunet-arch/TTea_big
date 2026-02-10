-- ============================================================================
-- Toptea - Restore Store Management Columns Migration
-- Version: 1.0
-- Date: 2026-02-10
-- Description: Restore columns removed by 2026_01_26 migration that are still
--              needed by the store management frontend
-- Issue: Store management save/sync errors due to missing database columns
-- ============================================================================

-- Use transaction to ensure atomicity
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

-- ============================================================================
-- Add back required columns to kds_stores table
-- ============================================================================

-- 1. Invoice and billing system columns
ALTER TABLE `kds_stores`
    ADD COLUMN IF NOT EXISTS `invoice_prefix` VARCHAR(10) NOT NULL DEFAULT '' COMMENT '票号前缀 (e.g., S1)' AFTER `tax_id`,
    ADD COLUMN IF NOT EXISTS `billing_system` ENUM('NONE','TICKETBAI','VERIFACTU') NOT NULL DEFAULT 'NONE' COMMENT '票据合规系统' AFTER `invoice_prefix`,
    ADD COLUMN IF NOT EXISTS `default_vat_rate` DECIMAL(5,2) NOT NULL DEFAULT 10.00 COMMENT '默认税率 (%)' AFTER `billing_system`,
    ADD COLUMN IF NOT EXISTS `eod_cutoff_hour` TINYINT UNSIGNED NOT NULL DEFAULT 3 COMMENT '日结截止时间 (0-23)' AFTER `default_vat_rate`;

-- 2. Add unique constraint for invoice_prefix
ALTER TABLE `kds_stores`
    ADD UNIQUE KEY IF NOT EXISTS `uniq_invoice_prefix` (`invoice_prefix`, `deleted_at`);

-- 3. POS Receipt Printer (角色1) columns
ALTER TABLE `kds_stores`
    ADD COLUMN IF NOT EXISTS `pr_receipt_type` ENUM('NONE','WIFI','BLUETOOTH','USB') NOT NULL DEFAULT 'NONE' COMMENT '角色1: POS小票打印机类型' AFTER `pr_kds_mac`,
    ADD COLUMN IF NOT EXISTS `pr_receipt_ip` VARCHAR(45) DEFAULT NULL COMMENT '角色1: IP地址' AFTER `pr_receipt_type`,
    ADD COLUMN IF NOT EXISTS `pr_receipt_port` INT DEFAULT NULL COMMENT '角色1: 端口' AFTER `pr_receipt_ip`,
    ADD COLUMN IF NOT EXISTS `pr_receipt_mac` VARCHAR(50) DEFAULT NULL COMMENT '角色1: 蓝牙MAC' AFTER `pr_receipt_port`;

-- 4. POS Sticker Printer (角色2) columns
ALTER TABLE `kds_stores`
    ADD COLUMN IF NOT EXISTS `pr_sticker_type` ENUM('NONE','WIFI','BLUETOOTH','USB') NOT NULL DEFAULT 'NONE' COMMENT '角色2: POS杯贴打印机类型' AFTER `pr_receipt_mac`,
    ADD COLUMN IF NOT EXISTS `pr_sticker_ip` VARCHAR(45) DEFAULT NULL COMMENT '角色2: IP地址' AFTER `pr_sticker_type`,
    ADD COLUMN IF NOT EXISTS `pr_sticker_port` INT DEFAULT NULL COMMENT '角色2: 端口' AFTER `pr_sticker_ip`,
    ADD COLUMN IF NOT EXISTS `pr_sticker_mac` VARCHAR(50) DEFAULT NULL COMMENT '角色2: 蓝牙MAC' AFTER `pr_sticker_port`;

-- ============================================================================
-- Commit transaction
-- ============================================================================

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- Migration complete
-- ============================================================================
-- This migration restores the columns that were removed in the 2026-01-26
-- backend redesign migration but are still required by the store management
-- interface for:
-- - Invoice/billing configuration (invoice_prefix, billing_system, VAT)
-- - POS receipt printer settings (pr_receipt_*)
-- - POS sticker printer settings (pr_sticker_*)
--
-- These columns support critical functionality for store operations including
-- invoice generation, tax compliance, and multi-role printing capabilities.
-- ============================================================================
