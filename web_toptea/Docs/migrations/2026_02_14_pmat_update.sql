-- PMAT 数据更新脚本 (基于 配方数据_去重.xlsx / 原料列表.xlsx / 最新PMAT码规则)
START TRANSACTION;
UPDATE kds_sop_query_rules SET config_json = '{"mapping": {"a": "A", "m": "M", "p": "P", "t": "T", "ord": "ORD"}, "template": "{P}-B0{A}-W0{M}-T0{T}"}' WHERE id = 1;
UPDATE kds_cups SET cup_name = '700cc', sop_description_zh = '700cc' WHERE id = 1;
UPDATE kds_cups SET cup_name = '500cc', sop_description_zh = '500cc' WHERE id = 2;
INSERT INTO kds_ice_options (id, ice_code, created_at, updated_at, deleted_at) VALUES (5, 5, utc_timestamp(6), utc_timestamp(6), NULL) ON DUPLICATE KEY UPDATE ice_code = VALUES(ice_code), deleted_at = NULL, updated_at = utc_timestamp(6);
UPDATE kds_ice_option_translations SET ice_option_name = '正常冰', sop_description = '正常冰' WHERE ice_option_id = 1 AND language_code = 'zh-CN';
UPDATE kds_ice_option_translations SET ice_option_name = '少冰', sop_description = '少冰' WHERE ice_option_id = 2 AND language_code = 'zh-CN';
UPDATE kds_ice_option_translations SET ice_option_name = '去冰', sop_description = '去冰' WHERE ice_option_id = 3 AND language_code = 'zh-CN';
UPDATE kds_ice_option_translations SET ice_option_name = '温热', sop_description = '温热' WHERE ice_option_id = 4 AND language_code = 'zh-CN';
INSERT INTO kds_ice_option_translations (ice_option_id, language_code, ice_option_name, sop_description) VALUES (5, 'zh-CN', '冰沙', '冰沙') ON DUPLICATE KEY UPDATE ice_option_name = VALUES(ice_option_name), sop_description = VALUES(sop_description);
UPDATE kds_sweetness_option_translations SET sweetness_option_name = '正常糖', sop_description = '正常糖' WHERE sweetness_option_id = 1 AND language_code = 'zh-CN';
UPDATE kds_sweetness_option_translations SET sweetness_option_name = '少糖', sop_description = '少糖' WHERE sweetness_option_id = 2 AND language_code = 'zh-CN';
UPDATE kds_sweetness_option_translations SET sweetness_option_name = '少少糖', sop_description = '少少糖' WHERE sweetness_option_id = 3 AND language_code = 'zh-CN';
UPDATE kds_sweetness_option_translations SET sweetness_option_name = '不另外加糖', sop_description = '不另外加糖' WHERE sweetness_option_id = 4 AND language_code = 'zh-CN';
UPDATE kds_sweetness_options SET deleted_at = utc_timestamp(6) WHERE id = 5;
UPDATE kds_sweetness_option_translations SET sweetness_option_name = '停用', sop_description = '停用' WHERE sweetness_option_id = 5 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP033' WHERE id = 33;
UPDATE kds_product_translations SET product_name = '双蛋波波奶茶' WHERE product_id = 33 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP006' WHERE id = 6;
UPDATE kds_product_translations SET product_name = '咸奶酪抹茶鲜奶茶' WHERE product_id = 6 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP005' WHERE id = 5;
UPDATE kds_product_translations SET product_name = '咸奶酪茉莉鲜奶茶' WHERE product_id = 5 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP017' WHERE id = 17;
UPDATE kds_product_translations SET product_name = '多肉葡萄' WHERE product_id = 17 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP020' WHERE id = 20;
UPDATE kds_product_translations SET product_name = '多肉蜜桃' WHERE product_id = 20 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP004' WHERE id = 4;
UPDATE kds_product_translations SET product_name = '布蕾蛋糕黑糖珍珠奶茶' WHERE product_id = 4 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP003' WHERE id = 3;
UPDATE kds_product_translations SET product_name = '布蕾黑糖啵啵抹茶冰' WHERE product_id = 3 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP030' WHERE id = 30;
UPDATE kds_product_translations SET product_name = '开心果芝芝' WHERE product_id = 30 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP031' WHERE id = 31;
UPDATE kds_product_translations SET product_name = '开心果芝芝茉莉' WHERE product_id = 31 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP035' WHERE id = 35;
UPDATE kds_product_translations SET product_name = '抹茶拿铁' WHERE product_id = 35 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP034' WHERE id = 34;
UPDATE kds_product_translations SET product_name = '抹茶椰椰' WHERE product_id = 34 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP014' WHERE id = 14;
UPDATE kds_product_translations SET product_name = '暴打鲜橙' WHERE product_id = 14 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP016' WHERE id = 16;
UPDATE kds_product_translations SET product_name = '杨枝甘露' WHERE product_id = 16 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP018' WHERE id = 18;
UPDATE kds_product_translations SET product_name = '桑葚草莓' WHERE product_id = 18 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP001' WHERE id = 1;
UPDATE kds_product_translations SET product_name = '烤布蕾黑糖啵啵奶茶' WHERE product_id = 1 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP002' WHERE id = 2;
UPDATE kds_product_translations SET product_name = '烤布蕾黑糖啵啵抹茶' WHERE product_id = 2 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP023' WHERE id = 23;
UPDATE kds_product_translations SET product_name = '牛油果甘露' WHERE product_id = 23 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP021' WHERE id = 21;
UPDATE kds_product_translations SET product_name = '牛油果莓莓' WHERE product_id = 21 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP022' WHERE id = 22;
UPDATE kds_product_translations SET product_name = '牛油果鲜奶昔' WHERE product_id = 22 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP019' WHERE id = 19;
UPDATE kds_product_translations SET product_name = '生椰芒芒' WHERE product_id = 19 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP025' WHERE id = 25;
UPDATE kds_product_translations SET product_name = '白桃轻乳茶' WHERE product_id = 25 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP013' WHERE id = 13;
UPDATE kds_product_translations SET product_name = '百香芒芒' WHERE product_id = 13 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP029' WHERE id = 29;
UPDATE kds_product_translations SET product_name = '芝芝抹茶' WHERE product_id = 29 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP008' WHERE id = 8;
UPDATE kds_product_translations SET product_name = '芝芝桃桃' WHERE product_id = 8 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP012' WHERE id = 12;
UPDATE kds_product_translations SET product_name = '芝芝桑葚' WHERE product_id = 12 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP028' WHERE id = 28;
UPDATE kds_product_translations SET product_name = '芝芝红茶' WHERE product_id = 28 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP009' WHERE id = 9;
UPDATE kds_product_translations SET product_name = '芝芝芒芒' WHERE product_id = 9 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP027' WHERE id = 27;
UPDATE kds_product_translations SET product_name = '芝芝茉莉' WHERE product_id = 27 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP011' WHERE id = 11;
UPDATE kds_product_translations SET product_name = '芝芝草莓' WHERE product_id = 11 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP010' WHERE id = 10;
UPDATE kds_product_translations SET product_name = '芝芝葡萄' WHERE product_id = 10 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP024' WHERE id = 24;
UPDATE kds_product_translations SET product_name = '茉莉轻乳茶' WHERE product_id = 24 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP026' WHERE id = 26;
UPDATE kds_product_translations SET product_name = '草莓轻乳' WHERE product_id = 26 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP007' WHERE id = 7;
UPDATE kds_product_translations SET product_name = '血糯米奶茶' WHERE product_id = 7 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP015' WHERE id = 15;
UPDATE kds_product_translations SET product_name = '西瓜椰椰' WHERE product_id = 15 AND language_code = 'zh-CN';
UPDATE kds_products SET product_code = 'CP032' WHERE id = 32;
UPDATE kds_product_translations SET product_name = '黑糖珍珠奶茶' WHERE product_id = 32 AND language_code = 'zh-CN';
DELETE FROM kds_product_ice_options;
INSERT INTO kds_product_ice_options (product_id, ice_option_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(8, 5),
(9, 5),
(10, 5),
(11, 5),
(12, 5),
(13, 1),
(13, 2),
(14, 1),
(14, 2),
(15, 5),
(16, 5),
(17, 5),
(18, 5),
(19, 5),
(20, 5),
(21, 5),
(22, 5),
(23, 5),
(24, 1),
(24, 2),
(24, 3),
(24, 4),
(25, 1),
(25, 2),
(25, 3),
(25, 4),
(26, 1),
(26, 2),
(26, 3),
(27, 1),
(27, 2),
(27, 3),
(27, 4),
(28, 1),
(28, 2),
(28, 3),
(28, 4),
(29, 1),
(29, 2),
(29, 3),
(29, 4),
(30, 1),
(30, 2),
(30, 3),
(31, 1),
(31, 2),
(31, 3),
(31, 4),
(32, 1),
(32, 2),
(32, 3),
(32, 4),
(33, 1),
(33, 2),
(33, 3),
(33, 4),
(34, 1),
(34, 2),
(34, 3),
(34, 4),
(35, 1),
(35, 2),
(35, 3),
(35, 4);
DELETE FROM kds_product_sweetness_options;
INSERT INTO kds_product_sweetness_options (product_id, sweetness_option_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(4, 1),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
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
(35, 1);
-- 更新原料字典 (M1-M35)
UPDATE kds_materials SET material_code = 9, base_unit_id = 2 WHERE material_code = 9;
UPDATE kds_material_translations SET material_name = '抹茶汁' WHERE material_id = 9 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 10, base_unit_id = 2 WHERE material_code = 10;
UPDATE kds_material_translations SET material_name = '淡奶油' WHERE material_id = 10 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 11, base_unit_id = 2 WHERE material_code = 11;
UPDATE kds_material_translations SET material_name = '蜜桃汁' WHERE material_id = 11 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 12, base_unit_id = 1 WHERE material_code = 12;
UPDATE kds_material_translations SET material_name = '桃子肉' WHERE material_id = 12 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 13, base_unit_id = 2 WHERE material_code = 13;
UPDATE kds_material_translations SET material_name = '绿茶茶汤' WHERE material_id = 13 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 14, base_unit_id = 1 WHERE material_code = 14;
UPDATE kds_material_translations SET material_name = '桃子果肉' WHERE material_id = 14 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 15, base_unit_id = 1 WHERE material_code = 15;
UPDATE kds_material_translations SET material_name = '脆波波' WHERE material_id = 15 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 16, base_unit_id = 1 WHERE material_code = 16;
UPDATE kds_material_translations SET material_name = '芒果果粒' WHERE material_id = 16 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 17, base_unit_id = 1 WHERE material_code = 17;
UPDATE kds_material_translations SET material_name = '芒果酱' WHERE material_id = 17 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 18, base_unit_id = 1 WHERE material_code = 18;
UPDATE kds_material_translations SET material_name = '葡萄果肉' WHERE material_id = 18 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 19, base_unit_id = 2 WHERE material_code = 19;
UPDATE kds_material_translations SET material_name = '葡萄汁' WHERE material_id = 19 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 20, base_unit_id = 1 WHERE material_code = 20;
UPDATE kds_material_translations SET material_name = '草莓果肉' WHERE material_id = 20 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 21, base_unit_id = 1 WHERE material_code = 21;
UPDATE kds_material_translations SET material_name = '草莓酱' WHERE material_id = 21 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 22, base_unit_id = 1 WHERE material_code = 22;
UPDATE kds_material_translations SET material_name = '桑葚果肉' WHERE material_id = 22 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 23, base_unit_id = 1 WHERE material_code = 23;
UPDATE kds_material_translations SET material_name = '桑葚酱' WHERE material_id = 23 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 24, base_unit_id = 1 WHERE material_code = 24;
UPDATE kds_material_translations SET material_name = '百香果酱' WHERE material_id = 24 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 25, base_unit_id = 2 WHERE material_code = 25;
UPDATE kds_material_translations SET material_name = '橙汁' WHERE material_id = 25 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 26, base_unit_id = 2 WHERE material_code = 26;
UPDATE kds_material_translations SET material_name = '椰浆' WHERE material_id = 26 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 27, base_unit_id = 2 WHERE material_code = 27;
UPDATE kds_material_translations SET material_name = '椰乳' WHERE material_id = 27 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 28, base_unit_id = 1 WHERE material_code = 28;
UPDATE kds_material_translations SET material_name = '芒果果肉' WHERE material_id = 28 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 29, base_unit_id = 1 WHERE material_code = 29;
UPDATE kds_material_translations SET material_name = '葡萄肉' WHERE material_id = 29 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 30, base_unit_id = 1 WHERE material_code = 30;
UPDATE kds_material_translations SET material_name = '芒果粒' WHERE material_id = 30 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 31, base_unit_id = 1 WHERE material_code = 31;
UPDATE kds_material_translations SET material_name = '蜜桃果肉' WHERE material_id = 31 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 32, base_unit_id = 1 WHERE material_code = 32;
UPDATE kds_material_translations SET material_name = '草莓' WHERE material_id = 32 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 33, base_unit_id = 2 WHERE material_code = 33;
UPDATE kds_material_translations SET material_name = '椰青水' WHERE material_id = 33 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 34, base_unit_id = 1 WHERE material_code = 34;
UPDATE kds_material_translations SET material_name = '开心果芝士奶盖' WHERE material_id = 34 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 35, base_unit_id = 2 WHERE material_code = 35;
UPDATE kds_material_translations SET material_name = '椰奶' WHERE material_id = 35 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 8, base_unit_id = 1 WHERE material_code = 8;
UPDATE kds_material_translations SET material_name = '芝士奶盖' WHERE material_id = 8 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 7, base_unit_id = 2 WHERE material_code = 7;
UPDATE kds_material_translations SET material_name = '茉莉绿茶' WHERE material_id = 7 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 6, base_unit_id = 2 WHERE material_code = 6;
UPDATE kds_material_translations SET material_name = '热水' WHERE material_id = 6 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 5, base_unit_id = 2 WHERE material_code = 5;
UPDATE kds_material_translations SET material_name = '冰水' WHERE material_id = 5 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 4, base_unit_id = 2 WHERE material_code = 4;
UPDATE kds_material_translations SET material_name = '基底乳' WHERE material_id = 4 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 3, base_unit_id = 2 WHERE material_code = 3;
UPDATE kds_material_translations SET material_name = '纯牛奶' WHERE material_id = 3 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 2, base_unit_id = 1 WHERE material_code = 2;
UPDATE kds_material_translations SET material_name = '蔗糖' WHERE material_id = 2 AND language_code = 'zh-CN';
UPDATE kds_materials SET material_code = 1, base_unit_id = 2 WHERE material_code = 1;
UPDATE kds_material_translations SET material_name = '2号滇红红茶' WHERE material_id = 1 AND language_code = 'zh-CN';
COMMIT;
