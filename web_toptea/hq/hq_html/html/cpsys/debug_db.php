<?php
/**
 * Database Structure Debug Page
 * Access via: /cpsys/debug_db.php
 */

require_once realpath(__DIR__ . '/../../core/config.php');

header('Content-Type: text/plain; charset=utf-8');

echo "=== kds_stores Table Structure Debug ===\n";
echo "Time: " . date('Y-m-d H:i:s') . "\n\n";

try {
    // Get table structure
    $stmt = $pdo->query("DESCRIBE kds_stores");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "Total columns: " . count($columns) . "\n\n";
    echo str_repeat('=', 80) . "\n";
    echo sprintf("%-30s %-30s %-10s %-10s\n", 'Field', 'Type', 'Null', 'Key');
    echo str_repeat('=', 80) . "\n";

    $existing_cols = [];
    foreach ($columns as $col) {
        echo sprintf("%-30s %-30s %-10s %-10s\n",
            $col['Field'],
            $col['Type'],
            $col['Null'],
            $col['Key']
        );
        $existing_cols[] = $col['Field'];
    }

    echo "\n" . str_repeat('=', 80) . "\n";
    echo "Required Columns Check\n";
    echo str_repeat('=', 80) . "\n";

    $required = [
        'invoice_prefix',
        'billing_system',
        'default_vat_rate',
        'eod_cutoff_hour',
        'pr_receipt_type',
        'pr_receipt_ip',
        'pr_receipt_port',
        'pr_receipt_mac',
        'pr_sticker_type',
        'pr_sticker_ip',
        'pr_sticker_port',
        'pr_sticker_mac'
    ];

    $missing = [];
    foreach ($required as $col_name) {
        $exists = in_array($col_name, $existing_cols);
        echo sprintf("%-30s %s\n", $col_name, $exists ? '[OK] EXISTS' : '[FAIL] MISSING');
        if (!$exists) {
            $missing[] = $col_name;
        }
    }

    if (!empty($missing)) {
        echo "\n" . str_repeat('=', 80) . "\n";
        echo "PROBLEM FOUND!\n";
        echo str_repeat('=', 80) . "\n";
        echo "Missing columns (" . count($missing) . "):\n";
        foreach ($missing as $col) {
            echo "  - $col\n";
        }

        echo "\n\nGenerated ALTER TABLE Statement:\n";
        echo str_repeat('-', 80) . "\n";

        $alter_parts = [];
        $col_definitions = [
            'invoice_prefix' => "ADD COLUMN `invoice_prefix` VARCHAR(10) NOT NULL DEFAULT ''",
            'billing_system' => "ADD COLUMN `billing_system` ENUM('NONE','TICKETBAI','VERIFACTU') NOT NULL DEFAULT 'NONE'",
            'default_vat_rate' => "ADD COLUMN `default_vat_rate` DECIMAL(5,2) NOT NULL DEFAULT 10.00",
            'eod_cutoff_hour' => "ADD COLUMN `eod_cutoff_hour` TINYINT UNSIGNED NOT NULL DEFAULT 3",
            'pr_receipt_type' => "ADD COLUMN `pr_receipt_type` ENUM('NONE','WIFI','BLUETOOTH','USB') NOT NULL DEFAULT 'NONE'",
            'pr_receipt_ip' => "ADD COLUMN `pr_receipt_ip` VARCHAR(45) DEFAULT NULL",
            'pr_receipt_port' => "ADD COLUMN `pr_receipt_port` INT DEFAULT NULL",
            'pr_receipt_mac' => "ADD COLUMN `pr_receipt_mac` VARCHAR(50) DEFAULT NULL",
            'pr_sticker_type' => "ADD COLUMN `pr_sticker_type` ENUM('NONE','WIFI','BLUETOOTH','USB') NOT NULL DEFAULT 'NONE'",
            'pr_sticker_ip' => "ADD COLUMN `pr_sticker_ip` VARCHAR(45) DEFAULT NULL",
            'pr_sticker_port' => "ADD COLUMN `pr_sticker_port` INT DEFAULT NULL",
            'pr_sticker_mac' => "ADD COLUMN `pr_sticker_mac` VARCHAR(50) DEFAULT NULL"
        ];

        foreach ($missing as $col) {
            if (isset($col_definitions[$col])) {
                $alter_parts[] = $col_definitions[$col];
            }
        }

        echo "ALTER TABLE `kds_stores`\n  ";
        echo implode(",\n  ", $alter_parts);
        echo ";\n";
    } else {
        echo "\n[SUCCESS] All required columns exist!\n";
    }

    // Test existing stores
    echo "\n" . str_repeat('=', 80) . "\n";
    echo "Existing Stores Count\n";
    echo str_repeat('=', 80) . "\n";

    $count_stmt = $pdo->query("SELECT COUNT(*) as cnt FROM kds_stores WHERE deleted_at IS NULL");
    $count = $count_stmt->fetch()['cnt'];
    echo "Active stores: $count\n";

} catch (PDOException $e) {
    echo "\n[DATABASE ERROR]\n";
    echo str_repeat('=', 80) . "\n";
    echo "Error Code: " . $e->getCode() . "\n";
    echo "Error Message: " . $e->getMessage() . "\n";
    echo "\nError Info:\n";
    print_r($e->errorInfo);
} catch (Exception $e) {
    echo "\n[GENERAL ERROR]\n";
    echo str_repeat('=', 80) . "\n";
    echo $e->getMessage() . "\n";
    echo "\nTrace:\n" . $e->getTraceAsString() . "\n";
}

echo "\n=== End of Debug ===\n";
?>
