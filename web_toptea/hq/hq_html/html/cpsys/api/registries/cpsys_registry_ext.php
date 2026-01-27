<?php
/**
 * Toptea HQ - CPSYS API 注册表 (Extensional)
 * 注册未来新增的、或不属于 Base/BMS/RMS 的资源
 * Version: 1.0.002 (Audit Clarification)
 * Date: 2026-01-27
 *
 * [GEMINI V1.5 FIX]: Corrected realpath() to ../../../
 *
 * [AUDIT FIX 2026-01-27] Architecture Clarification:
 * The following handlers are NOT part of this HQ CPSYS registry. They belong to the
 * STORE-SIDE KDS API registry (store/store_html/html/kds/api/registries/kds_registry.php):
 *   - handle_kds_sop_get
 *   - handle_kds_expiry_record
 *   - handle_kds_get_preppable
 *   - handle_kds_get_expiry_items
 *   - handle_kds_update_expiry_status
 *
 * These handlers are correctly implemented in the store-side registry where they are
 * registered. Any audit finding about "missing handlers" in cpsys_registry_ext.php
 * is a false positive due to confusion between the two separate API subsystems:
 *   - HQ CPSYS API (this file's parent) - for back-office management
 *   - Store KDS API - for store-side KDS device operations
 */

// 确保 kds_helper 已加载
require_once realpath(__DIR__ . '/../../../../app/helpers/kds_helper.php');
// 确保 auth_helper 已加载
require_once realpath(__DIR__ . '/../../../../app/helpers/auth_helper.php');


// --- 处理器 ---
// (暂无)


// --- 注册表 ---
return [

    // (示例)
    /*
    'example_resource' => [
        'table' => 'example_table',
        'pk' => 'id',
        'soft_delete_col' => 'deleted_at',
        'auth_role' => ROLE_SUPER_ADMIN,
        'visible_cols' => ['id', 'name'],
        'writable_cols' => ['name'],
    ],
    */

];
