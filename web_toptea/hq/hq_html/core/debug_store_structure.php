<?php
/**
 * Debug Script: Check kds_stores table structure and test save operation
 */

require_once __DIR__ . '/config.php';

echo "=== Database Connection Test ===\n";
echo "Connected to: " . $db_name . "\n\n";

echo "=== Current kds_stores Table Structure ===\n";
try {
    $stmt = $pdo->query("DESCRIBE kds_stores");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "Total columns: " . count($columns) . "\n\n";

    foreach ($columns as $col) {
        echo sprintf("%-30s %-20s %-10s %-10s\n",
            $col['Field'],
            $col['Type'],
            $col['Null'],
            $col['Key']
        );
    }

    echo "\n=== Checking for Required Columns ===\n";
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

    $existing_cols = array_column($columns, 'Field');

    foreach ($required as $col_name) {
        $exists = in_array($col_name, $existing_cols) ? '✓ EXISTS' : '✗ MISSING';
        echo sprintf("%-30s %s\n", $col_name, $exists);
    }

    echo "\n=== Test Sample Data Insert ===\n";

    // Check if we can do a test insert
    $test_data = [
        'store_code' => 'TEST_DEBUG_' . time(),
        'store_name' => 'Test Store Debug',
        'is_active' => 1
    ];

    // Try to add optional columns if they exist
    $optional_data = [
        'invoice_prefix' => 'T' . substr(time(), -3),
        'billing_system' => 'NONE',
        'default_vat_rate' => 10.00,
        'eod_cutoff_hour' => 3,
        'pr_receipt_type' => 'NONE',
        'pr_sticker_type' => 'NONE',
        'pr_kds_type' => 'NONE'
    ];

    foreach ($optional_data as $key => $value) {
        if (in_array($key, $existing_cols)) {
            $test_data[$key] = $value;
        } else {
            echo "WARNING: Column '$key' not found in table\n";
        }
    }

    // Build INSERT query
    $cols = array_keys($test_data);
    $placeholders = array_fill(0, count($cols), '?');

    $sql = "INSERT INTO kds_stores (" . implode(', ', $cols) . ") VALUES (" . implode(', ', $placeholders) . ")";

    echo "\nTest SQL:\n$sql\n\n";
    echo "Test Data:\n";
    print_r($test_data);

    $stmt = $pdo->prepare($sql);
    $stmt->execute(array_values($test_data));

    $test_id = $pdo->lastInsertId();
    echo "\n✓ Test insert successful! ID: $test_id\n";

    // Clean up test data
    $pdo->prepare("DELETE FROM kds_stores WHERE id = ?")->execute([$test_id]);
    echo "✓ Test data cleaned up\n";

} catch (PDOException $e) {
    echo "\n✗ DATABASE ERROR:\n";
    echo "Error Code: " . $e->getCode() . "\n";
    echo "Error Message: " . $e->getMessage() . "\n";
    echo "\nSQL State: " . $e->errorInfo[0] . "\n";
    echo "Driver Error Code: " . $e->errorInfo[1] . "\n";
    echo "Driver Error Message: " . $e->errorInfo[2] . "\n";
} catch (Exception $e) {
    echo "\n✗ GENERAL ERROR:\n";
    echo $e->getMessage() . "\n";
    echo $e->getTraceAsString() . "\n";
}

echo "\n=== Debug Complete ===\n";
?>
