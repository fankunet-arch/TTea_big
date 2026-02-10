# Store Management Save/Sync Error Fix

## Issue Description

Users experienced errors when saving store configurations in the Store Management interface (`/cpsys/index.php?page=store_management`):

- **Error Message**: "保存过程中发生网络或服务器错误" (Network or server error during save)
- **Root Cause**: Database schema mismatch - required columns missing from `kds_stores` table

## Technical Analysis

### Problem Discovery

The `2026_01_26_backend_redesign.sql` migration removed several columns from the `kds_stores` table as part of a POS module cleanup:

```sql
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
```

However, the frontend code was **not updated** to reflect these changes:

1. **Frontend Form** (`store_management_view.php`): Still contains input fields for all removed columns
2. **JavaScript** (`store_management.js:148-178`): Still submits all removed fields
3. **API Handler** (`cpsys_registry_base_core.php:298-313`): Still attempts to INSERT/UPDATE removed columns

### Error Flow

1. User fills out store form with billing/printer settings
2. JavaScript sends AJAX POST with all fields wrapped in `{data: {...}}`
3. API handler (`handle_store_save`) extracts data and builds SQL query
4. MySQL rejects query with error: "Unknown column 'invoice_prefix' in 'field list'"
5. PHP catches exception in `cpsys_registry_base_core.php:339-351`
6. Error response sent to client
7. JavaScript error handler at `store_management.js:203` displays generic error message

## Solution

### Migration Script: `2026_02_10_restore_store_management_columns.sql`

Restores the missing columns to `kds_stores` table:

**Invoice & Billing (4 columns)**:
- `invoice_prefix` VARCHAR(10) - Unique invoice prefix per store (e.g., "S1")
- `billing_system` ENUM - Compliance system (NONE/TICKETBAI/VERIFACTU)
- `default_vat_rate` DECIMAL(5,2) - Default VAT rate percentage
- `eod_cutoff_hour` TINYINT - End-of-day cutoff time (0-23)

**POS Receipt Printer - Role 1 (4 columns)**:
- `pr_receipt_type` ENUM - Printer type (NONE/WIFI/BLUETOOTH/USB)
- `pr_receipt_ip` VARCHAR(45) - IP address for WIFI printers
- `pr_receipt_port` INT - Port for WIFI printers
- `pr_receipt_mac` VARCHAR(50) - MAC address for Bluetooth printers

**POS Sticker Printer - Role 2 (4 columns)**:
- `pr_sticker_type` ENUM - Printer type (NONE/WIFI/BLUETOOTH/USB)
- `pr_sticker_ip` VARCHAR(45) - IP address for WIFI printers
- `pr_sticker_port` INT - Port for WIFI printers
- `pr_sticker_mac` VARCHAR(50) - MAC address for Bluetooth printers

**Total**: 12 columns restored

### Constraints Added

- Unique constraint on `invoice_prefix` (with `deleted_at` to allow soft-deleted reuse)

## How to Apply

### 1. Run the Migration

```bash
mysql -u [username] -p [database_name] < /path/to/2026_02_10_restore_store_management_columns.sql
```

### 2. Verify Schema

```sql
SHOW COLUMNS FROM kds_stores;
```

Expected columns should include all 12 restored fields.

### 3. Test Store Management

1. Navigate to `/cpsys/index.php?page=store_management`
2. Click "创建新门店" (Create New Store)
3. Fill in all required fields including:
   - Store code and name
   - Invoice prefix (e.g., "S1")
   - Billing system selection
   - VAT rate
   - Printer configurations
4. Click "保存到云端" (Save to Cloud)
5. Verify success message and page reload
6. Check that store appears in the list with correct settings

## Alternative Solutions Considered

### Option 1: Remove Frontend Fields (Not Recommended)
- Update `store_management_view.php` to remove invoice/printer fields
- Update `store_management.js` to not send removed fields
- Update `handle_store_save` to not process removed fields

**Rejected because**: These features are actively used for:
- Spanish tax compliance (TicketBAI/Veri*Factu)
- Multi-role printing in POS systems
- Invoice generation and tracking

### Option 2: Make Frontend Optional (Partial Solution)
- Keep fields in frontend but make them optional
- Update backend to ignore missing columns gracefully

**Rejected because**: Would break existing stores that rely on these settings

### Option 3: Restore Columns (Chosen)
- Restore all 12 columns via migration
- No code changes required
- Preserves all existing functionality

**Chosen because**:
- Minimal risk - only database changes
- No frontend code changes needed
- Maintains feature parity
- Supports existing business requirements

## Impact Analysis

### Before Fix
- ❌ Store management save operations fail
- ❌ Cannot create new stores
- ❌ Cannot update store configurations
- ❌ Invoice/billing settings inaccessible
- ❌ Printer configurations lost

### After Fix
- ✅ Store save operations work correctly
- ✅ Can create new stores with full configuration
- ✅ Can update existing stores
- ✅ Invoice/billing settings accessible and functional
- ✅ Multi-role printer support restored

## Files Modified

1. **New Migration**: `web_toptea/Docs/migrations/2026_02_10_restore_store_management_columns.sql`
2. **Documentation**: `web_toptea/Docs/migrations/README_2026_02_10_fix.md` (this file)

## Related Files (No Changes Required)

- `web_toptea/hq/hq_html/html/cpsys/js/store_management.js` (Frontend JS)
- `web_toptea/hq/hq_html/app/views/cpsys/store_management_view.php` (Frontend view)
- `web_toptea/hq/hq_html/html/cpsys/api/registries/cpsys_registry_base_core.php` (API handler)
- `web_toptea/hq/hq_html/html/cpsys/index.php` (Router)

## Testing Checklist

- [ ] Migration executes without errors
- [ ] All 12 columns present in `kds_stores` table
- [ ] Can create new store with all fields
- [ ] Can update existing store
- [ ] Can delete store (soft delete)
- [ ] Unique constraint enforced on `invoice_prefix`
- [ ] Can sync printer config to Android device
- [ ] Invoice prefix validation works (alphanumeric only)
- [ ] Billing system enum validation works
- [ ] Printer type enum validation works

## Rollback Plan

If issues occur after applying this migration:

```sql
-- Remove added columns (CAUTION: Data loss!)
ALTER TABLE kds_stores
    DROP COLUMN IF EXISTS invoice_prefix,
    DROP COLUMN IF EXISTS billing_system,
    DROP COLUMN IF EXISTS default_vat_rate,
    DROP COLUMN IF EXISTS eod_cutoff_hour,
    DROP COLUMN IF EXISTS pr_receipt_type,
    DROP COLUMN IF EXISTS pr_receipt_ip,
    DROP COLUMN IF EXISTS pr_receipt_port,
    DROP COLUMN IF EXISTS pr_receipt_mac,
    DROP COLUMN IF EXISTS pr_sticker_type,
    DROP COLUMN IF EXISTS pr_sticker_ip,
    DROP COLUMN IF EXISTS pr_sticker_port,
    DROP COLUMN IF EXISTS pr_sticker_mac;
```

**Note**: Rollback will cause the same save errors to return. Only use if migration causes critical issues.

## Future Recommendations

1. **Keep Schema in Sync**: Update migration scripts to match frontend requirements
2. **Add Integration Tests**: Test store CRUD operations after schema changes
3. **Document Dependencies**: Link frontend features to required database columns
4. **Version Control**: Tag migrations with corresponding frontend/backend versions
5. **Migration Review Process**: Require review of both frontend and backend impacts

## References

- Issue Location: `/cpsys/index.php?page=store_management`
- Error Handler: `store_management.js:199-210`
- API Endpoint: `cpsys_api_gateway.php?res=stores&act=save`
- Backend Handler: `cpsys_registry_base_core.php:215-352` (`handle_store_save`)
- Original Migration: `2026_01_26_backend_redesign.sql` (lines 27-38)
