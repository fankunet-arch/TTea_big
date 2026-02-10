<?php
/**
 * Database Structure Fix Tool
 * Purpose: Check and fix missing columns in kds_stores table
 *
 * Usage: Access via web browser at /cpsys/fix_database_structure.php?action=check
 *        To apply fixes: /cpsys/fix_database_structure.php?action=fix&confirm=yes
 */

require_once realpath(__DIR__ . '/../../core/config.php');
require_once realpath(__DIR__ . '/../../core/auth_core.php');
require_once realpath(__DIR__ . '/../../app/helpers/auth_helper.php');

// Require Super Admin role
check_role(ROLE_ADMIN);

$action = $_GET['action'] ?? 'check';
$confirm = $_GET['confirm'] ?? 'no';

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>数据库结构修复工具</title>
    <style>
        body { font-family: 'Courier New', monospace; background: #1a1a1a; color: #00ff00; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: #000; padding: 20px; border: 2px solid #00ff00; }
        h1 { color: #00ff00; border-bottom: 2px solid #00ff00; padding-bottom: 10px; }
        h2 { color: #ffff00; margin-top: 30px; }
        .success { color: #00ff00; }
        .error { color: #ff0000; }
        .warning { color: #ffaa00; }
        .info { color: #00aaff; }
        pre { background: #111; padding: 10px; border-left: 3px solid #00ff00; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 10px; text-align: left; border: 1px solid #333; }
        th { background: #222; color: #ffff00; }
        tr:nth-child(even) { background: #0a0a0a; }
        .button { background: #00ff00; color: #000; padding: 10px 20px; text-decoration: none; display: inline-block; margin: 10px 5px; border: none; cursor: pointer; font-weight: bold; }
        .button:hover { background: #00dd00; }
        .button-danger { background: #ff3333; color: #fff; }
        .button-danger:hover { background: #dd0000; }
    </style>
</head>
<body>
<div class="container">
    <h1>🔧 数据库结构修复工具</h1>
    <p class="info">当前用户: <?php echo htmlspecialchars($_SESSION['username']); ?> | 权限级别: 超级管理员</p>

<?php

$required_columns = [
    'invoice_prefix' => [
        'type' => 'VARCHAR(10)',
        'null' => 'NO',
        'default' => "''",
        'definition' => "ADD COLUMN `invoice_prefix` VARCHAR(10) NOT NULL DEFAULT '' COMMENT '票号前缀 (e.g., S1)'"
    ],
    'billing_system' => [
        'type' => "ENUM('NONE','TICKETBAI','VERIFACTU')",
        'null' => 'NO',
        'default' => "'NONE'",
        'definition' => "ADD COLUMN `billing_system` ENUM('NONE','TICKETBAI','VERIFACTU') NOT NULL DEFAULT 'NONE' COMMENT '票据合规系统'"
    ],
    'default_vat_rate' => [
        'type' => 'DECIMAL(5,2)',
        'null' => 'NO',
        'default' => '10.00',
        'definition' => "ADD COLUMN `default_vat_rate` DECIMAL(5,2) NOT NULL DEFAULT 10.00 COMMENT '默认税率 (%)'"
    ],
    'eod_cutoff_hour' => [
        'type' => 'TINYINT UNSIGNED',
        'null' => 'NO',
        'default' => '3',
        'definition' => "ADD COLUMN `eod_cutoff_hour` TINYINT UNSIGNED NOT NULL DEFAULT 3 COMMENT '日结截止时间 (0-23)'"
    ],
    'pr_receipt_type' => [
        'type' => "ENUM('NONE','WIFI','BLUETOOTH','USB')",
        'null' => 'NO',
        'default' => "'NONE'",
        'definition' => "ADD COLUMN `pr_receipt_type` ENUM('NONE','WIFI','BLUETOOTH','USB') NOT NULL DEFAULT 'NONE' COMMENT '角色1: POS小票打印机类型'"
    ],
    'pr_receipt_ip' => [
        'type' => 'VARCHAR(45)',
        'null' => 'YES',
        'default' => 'NULL',
        'definition' => "ADD COLUMN `pr_receipt_ip` VARCHAR(45) DEFAULT NULL COMMENT '角色1: IP地址'"
    ],
    'pr_receipt_port' => [
        'type' => 'INT',
        'null' => 'YES',
        'default' => 'NULL',
        'definition' => "ADD COLUMN `pr_receipt_port` INT DEFAULT NULL COMMENT '角色1: 端口'"
    ],
    'pr_receipt_mac' => [
        'type' => 'VARCHAR(50)',
        'null' => 'YES',
        'default' => 'NULL',
        'definition' => "ADD COLUMN `pr_receipt_mac` VARCHAR(50) DEFAULT NULL COMMENT '角色1: 蓝牙MAC'"
    ],
    'pr_sticker_type' => [
        'type' => "ENUM('NONE','WIFI','BLUETOOTH','USB')",
        'null' => 'NO',
        'default' => "'NONE'",
        'definition' => "ADD COLUMN `pr_sticker_type` ENUM('NONE','WIFI','BLUETOOTH','USB') NOT NULL DEFAULT 'NONE' COMMENT '角色2: POS杯贴打印机类型'"
    ],
    'pr_sticker_ip' => [
        'type' => 'VARCHAR(45)',
        'null' => 'YES',
        'default' => 'NULL',
        'definition' => "ADD COLUMN `pr_sticker_ip` VARCHAR(45) DEFAULT NULL COMMENT '角色2: IP地址'"
    ],
    'pr_sticker_port' => [
        'type' => 'INT',
        'null' => 'YES',
        'default' => 'NULL',
        'definition' => "ADD COLUMN `pr_sticker_port` INT DEFAULT NULL COMMENT '角色2: 端口'"
    ],
    'pr_sticker_mac' => [
        'type' => 'VARCHAR(50)',
        'null' => 'YES',
        'default' => 'NULL',
        'definition' => "ADD COLUMN `pr_sticker_mac` VARCHAR(50) DEFAULT NULL COMMENT '角色2: 蓝牙MAC'"
    ]
];

try {
    // Step 1: Get current table structure
    $stmt = $pdo->query("DESCRIBE kds_stores");
    $current_columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $existing_column_names = array_column($current_columns, 'Field');

    echo "<h2>📊 当前表结构分析</h2>";
    echo "<p>表名: <strong>kds_stores</strong></p>";
    echo "<p>总列数: <strong>" . count($current_columns) . "</strong></p>";

    // Step 2: Check for missing columns
    $missing_columns = [];
    foreach ($required_columns as $col_name => $col_info) {
        if (!in_array($col_name, $existing_column_names)) {
            $missing_columns[$col_name] = $col_info;
        }
    }

    if (empty($missing_columns)) {
        echo "<p class='success'>✅ 恭喜！所有必需的列都存在。数据库结构正常。</p>";
        echo "<a href='index.php?page=store_management' class='button'>返回门店管理</a>";
    } else {
        echo "<p class='error'>❌ 发现 " . count($missing_columns) . " 个缺失的列！</p>";

        echo "<h2>🔍 缺失列详情</h2>";
        echo "<table>";
        echo "<tr><th>列名</th><th>类型</th><th>可空</th><th>默认值</th></tr>";
        foreach ($missing_columns as $col_name => $col_info) {
            echo "<tr>";
            echo "<td class='error'>" . htmlspecialchars($col_name) . "</td>";
            echo "<td>" . htmlspecialchars($col_info['type']) . "</td>";
            echo "<td>" . htmlspecialchars($col_info['null']) . "</td>";
            echo "<td>" . htmlspecialchars($col_info['default']) . "</td>";
            echo "</tr>";
        }
        echo "</table>";

        if ($action === 'check') {
            echo "<h2>🔨 修复SQL语句预览</h2>";
            echo "<p class='warning'>⚠️ 以下SQL将添加缺失的列到数据库中</p>";
            echo "<pre>";
            echo "ALTER TABLE `kds_stores`\n";
            $alter_statements = array_map(function($col_info) {
                return "  " . $col_info['definition'];
            }, $missing_columns);
            echo implode(",\n", $alter_statements);
            echo ";\n";
            echo "</pre>";

            echo "<h2>⚠️ 执行修复</h2>";
            echo "<p class='warning'><strong>警告：</strong>这将修改数据库结构。请确保已备份数据库。</p>";
            echo "<a href='?action=fix&confirm=yes' class='button button-danger' onclick='return confirm(\"确定要执行数据库修复吗？此操作将添加 " . count($missing_columns) . " 个列到 kds_stores 表。\");'>⚠️ 确认并执行修复</a>";
            echo "<a href='index.php?page=store_management' class='button'>取消</a>";

        } elseif ($action === 'fix' && $confirm === 'yes') {
            echo "<h2>🔧 正在执行修复...</h2>";

            $pdo->beginTransaction();
            try {
                // Build ALTER TABLE statement
                $alter_parts = array_map(function($col_info) {
                    return $col_info['definition'];
                }, $missing_columns);

                $sql = "ALTER TABLE `kds_stores`\n  " . implode(",\n  ", $alter_parts);

                echo "<pre class='info'>" . htmlspecialchars($sql) . "</pre>";

                $pdo->exec($sql);
                $pdo->commit();

                echo "<p class='success'>✅ 修复成功！已添加 " . count($missing_columns) . " 个列。</p>";

                // Verify
                $stmt = $pdo->query("DESCRIBE kds_stores");
                $new_columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
                $new_column_names = array_column($new_columns, 'Field');

                $still_missing = [];
                foreach (array_keys($missing_columns) as $col_name) {
                    if (!in_array($col_name, $new_column_names)) {
                        $still_missing[] = $col_name;
                    }
                }

                if (empty($still_missing)) {
                    echo "<p class='success'>✅ 验证通过：所有列已成功添加。</p>";
                    echo "<a href='index.php?page=store_management' class='button'>返回门店管理</a>";
                } else {
                    echo "<p class='error'>❌ 验证失败：以下列仍然缺失：</p>";
                    echo "<ul>";
                    foreach ($still_missing as $col) {
                        echo "<li class='error'>" . htmlspecialchars($col) . "</li>";
                    }
                    echo "</ul>";
                }

            } catch (Exception $e) {
                $pdo->rollBack();
                echo "<p class='error'>❌ 修复失败！</p>";
                echo "<p class='error'>错误信息: " . htmlspecialchars($e->getMessage()) . "</p>";
                if ($e instanceof PDOException) {
                    echo "<p class='error'>SQL State: " . htmlspecialchars($e->errorInfo[0]) . "</p>";
                    echo "<p class='error'>Driver Code: " . htmlspecialchars($e->errorInfo[1]) . "</p>";
                    echo "<p class='error'>Driver Message: " . htmlspecialchars($e->errorInfo[2]) . "</p>";
                }
            }
        }
    }

    // Always show current structure at the bottom
    echo "<h2>📋 完整表结构</h2>";
    echo "<table>";
    echo "<tr><th>列名</th><th>类型</th><th>可空</th><th>键</th><th>默认值</th><th>额外</th></tr>";
    foreach ($current_columns as $col) {
        $is_missing = in_array($col['Field'], array_keys($missing_columns));
        $class = $is_missing ? 'error' : '';
        echo "<tr class='$class'>";
        echo "<td>" . htmlspecialchars($col['Field']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Type']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Null']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Key']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Default'] ?? 'NULL') . "</td>";
        echo "<td>" . htmlspecialchars($col['Extra'] ?? '') . "</td>";
        echo "</tr>";
    }
    echo "</table>";

} catch (Exception $e) {
    echo "<p class='error'>❌ 错误：" . htmlspecialchars($e->getMessage()) . "</p>";
}

?>

</div>
</body>
</html>
