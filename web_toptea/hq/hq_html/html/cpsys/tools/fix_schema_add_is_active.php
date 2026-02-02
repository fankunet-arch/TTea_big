<?php
/**
 * Toptea HQ - Database Migration Tool
 * Fix: Add 'is_active' column to kds_materials table
 *
 * Usage: Access via browser or command line
 */

require_once realpath(__DIR__ . '/../../../../core/config.php');

header('Content-Type: text/plain');

try {
    echo "Checking kds_materials table...\n";

    // Check if column exists
    $stmt = $pdo->prepare("
        SELECT COUNT(*)
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = :db
          AND TABLE_NAME = 'kds_materials'
          AND COLUMN_NAME = 'is_active'
    ");
    $stmt->execute([':db' => $db_name]);
    $exists = (bool)$stmt->fetchColumn();

    if ($exists) {
        echo "Column 'is_active' already exists.\n";
    } else {
        echo "Column 'is_active' missing. Adding...\n";

        $sql = "ALTER TABLE kds_materials ADD COLUMN is_active TINYINT(1) NOT NULL DEFAULT 1 AFTER image_url";
        $pdo->exec($sql);

        echo "Column 'is_active' added successfully.\n";
    }

    echo "Migration completed.\n";

} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
    http_response_code(500);
}
?>