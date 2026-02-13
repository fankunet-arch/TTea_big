-- ============================================================================
-- 迁移: 灵活冰块计量方式 (Flexible Ice Measurement)
-- 日期: 2026-02-13
-- 说明: 为配方表 (L1, L3) 新增 measurement_type 字段，
--       支持 "标准用量(STANDARD)" 和 "至杯线(FILL_LINE)" 两种计量方式。
--       同时将 unit_id 改为可空，以支持 FILL_LINE 模式下无需指定单位。
-- ============================================================================

-- 1. kds_product_recipes (L1 基础配方) - 新增 measurement_type
ALTER TABLE `kds_product_recipes`
  ADD COLUMN `measurement_type` ENUM('STANDARD', 'FILL_LINE') NOT NULL DEFAULT 'STANDARD'
  COMMENT '计量方式: STANDARD=标准(数量+单位), FILL_LINE=至杯线(如至550线)'
  AFTER `quantity`;

-- 2. kds_product_recipes (L1) - unit_id 改为可空 (FILL_LINE 模式下不需要单位)
ALTER TABLE `kds_product_recipes`
  MODIFY COLUMN `unit_id` int UNSIGNED NULL COMMENT '单位ID (FILL_LINE模式下可为NULL)';

-- 3. kds_recipe_adjustments (L3 产品特例覆盖) - 新增 measurement_type
ALTER TABLE `kds_recipe_adjustments`
  ADD COLUMN `measurement_type` ENUM('STANDARD', 'FILL_LINE') NOT NULL DEFAULT 'STANDARD'
  COMMENT '计量方式: STANDARD=标准(数量+单位), FILL_LINE=至杯线(如至550线)'
  AFTER `quantity`;

-- 4. kds_recipe_adjustments (L3) - unit_id 改为可空
ALTER TABLE `kds_recipe_adjustments`
  MODIFY COLUMN `unit_id` int UNSIGNED NULL COMMENT '单位ID (FILL_LINE模式下可为NULL)';
