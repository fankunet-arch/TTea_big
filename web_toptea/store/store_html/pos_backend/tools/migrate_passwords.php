<?php
/**
 * Toptea - 密码迁移脚本
 * 将现有用户密码从 SHA256 迁移到 bcrypt
 *
 * [AUDIT FIX 2026-01-25]
 * 由于登录处理器从 SHA256 迁移到 password_verify()，
 * 需要为所有现有用户重新生成 bcrypt 哈希密码。
 *
 * 使用方法:
 *   php migrate_passwords.php [--dry-run] [--table=kds_users|cpsys_users|all]
 *
 * 参数:
 *   --dry-run   仅预览，不实际修改数据库
 *   --table     指定要迁移的表 (默认: all)
 *
 * 安全警告:
 *   - 此脚本仅限命令行运行
 *   - 运行后请立即删除此脚本
 *   - 请妥善保管生成的密码列表
 */

// 安全检查: 仅允许CLI运行
if (php_sapi_name() !== 'cli') {
    http_response_code(403);
    die("此脚本仅允许通过命令行运行。\n");
}

// 解析命令行参数
$options = getopt('', ['dry-run', 'table:', 'help']);

if (isset($options['help'])) {
    echo <<<HELP
Toptea 密码迁移脚本
==================

用法: php migrate_passwords.php [选项]

选项:
  --dry-run     仅预览，不实际修改数据库
  --table=NAME  指定要迁移的表
                可选值: kds_users, cpsys_users, all (默认)
  --help        显示此帮助信息

示例:
  php migrate_passwords.php --dry-run
  php migrate_passwords.php --table=kds_users
  php migrate_passwords.php --table=all

HELP;
    exit(0);
}

$dryRun = isset($options['dry-run']);
$targetTable = $options['table'] ?? 'all';

// 数据库配置 (与 POS/HQ 统一)
$db_host = 'mhdlmskv3gjbpqv3.mysql.db';
$db_name = 'mhdlmskv3gjbpqv3';
$db_user = 'mhdlmskv3gjbpqv3';
$db_pass = 'zqVdVfAWYYaa4gTAuHWX7CngpRDqR';
$db_char = 'utf8mb4';

// 连接数据库
$dsn = "mysql:host=$db_host;dbname=$db_name;charset=$db_char";
$options_pdo = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];

try {
    $pdo = new PDO($dsn, $db_user, $db_pass, $options_pdo);
    echo "✓ 数据库连接成功\n\n";
} catch (PDOException $e) {
    die("✗ 数据库连接失败: " . $e->getMessage() . "\n");
}

/**
 * 生成随机密码
 * @param int $length 密码长度
 * @return string 随机密码
 */
function generatePassword(int $length = 12): string {
    $chars = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#$%';
    $password = '';
    $max = strlen($chars) - 1;
    for ($i = 0; $i < $length; $i++) {
        $password .= $chars[random_int(0, $max)];
    }
    return $password;
}

/**
 * 迁移指定表的用户密码
 */
function migrateTable(PDO $pdo, string $tableName, bool $dryRun): array {
    $results = [];

    // 检查表是否存在
    $stmt = $pdo->prepare("SHOW TABLES LIKE ?");
    $stmt->execute([$tableName]);
    if (!$stmt->fetch()) {
        echo "⚠ 表 {$tableName} 不存在，跳过\n";
        return $results;
    }

    // 确定字段名
    $usernameField = 'username';
    $displayNameField = $tableName === 'cpsys_users' ? 'display_name' : 'display_name';
    $storeField = $tableName === 'kds_users' ? 'store_id' : null;

    // 查询所有活跃用户
    $sql = "SELECT id, {$usernameField}, {$displayNameField}";
    if ($storeField) {
        $sql .= ", {$storeField}";
    }
    $sql .= " FROM {$tableName} WHERE deleted_at IS NULL";

    $stmt = $pdo->query($sql);
    $users = $stmt->fetchAll();

    if (empty($users)) {
        echo "⚠ 表 {$tableName} 中没有活跃用户\n";
        return $results;
    }

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    echo "表: {$tableName} (共 " . count($users) . " 个用户)\n";
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n";

    // 准备更新语句
    $updateStmt = $pdo->prepare("UPDATE {$tableName} SET password_hash = ? WHERE id = ?");

    foreach ($users as $user) {
        $newPassword = generatePassword(12);
        $bcryptHash = password_hash($newPassword, PASSWORD_BCRYPT, ['cost' => 12]);

        $storeInfo = '';
        if ($storeField && isset($user[$storeField])) {
            // 获取门店名称
            $storeStmt = $pdo->prepare("SELECT store_name FROM kds_stores WHERE id = ?");
            $storeStmt->execute([$user[$storeField]]);
            $storeName = $storeStmt->fetchColumn() ?: "ID:{$user[$storeField]}";
            $storeInfo = " (门店: {$storeName})";
        }

        $results[] = [
            'table' => $tableName,
            'id' => $user['id'],
            'username' => $user[$usernameField],
            'display_name' => $user[$displayNameField] ?? '',
            'store_info' => $storeInfo,
            'new_password' => $newPassword,
        ];

        if (!$dryRun) {
            $updateStmt->execute([$bcryptHash, $user['id']]);
        }

        $status = $dryRun ? '[预览]' : '[已更新]';
        echo "{$status} {$user[$usernameField]}{$storeInfo}\n";
        echo "         新密码: {$newPassword}\n\n";
    }

    return $results;
}

// 主程序
echo "╔══════════════════════════════════════════════════════════════╗\n";
echo "║           Toptea 密码迁移工具 (SHA256 → bcrypt)              ║\n";
echo "╚══════════════════════════════════════════════════════════════╝\n\n";

if ($dryRun) {
    echo "⚠ 预览模式 (--dry-run)：不会实际修改数据库\n\n";
}

$allResults = [];

// 根据参数选择要迁移的表
$tables = [];
if ($targetTable === 'all' || $targetTable === 'kds_users') {
    $tables[] = 'kds_users';
}
if ($targetTable === 'all' || $targetTable === 'cpsys_users') {
    $tables[] = 'cpsys_users';
}

if (empty($tables)) {
    die("✗ 无效的表名: {$targetTable}\n");
}

foreach ($tables as $table) {
    $results = migrateTable($pdo, $table, $dryRun);
    $allResults = array_merge($allResults, $results);
}

// 生成密码清单文件
if (!empty($allResults)) {
    $timestamp = date('Ymd_His');
    $filename = __DIR__ . "/password_list_{$timestamp}.csv";

    $csvContent = "表,用户ID,用户名,显示名,门店,新密码\n";
    foreach ($allResults as $row) {
        $csvContent .= implode(',', [
            $row['table'],
            $row['id'],
            $row['username'],
            '"' . str_replace('"', '""', $row['display_name']) . '"',
            '"' . str_replace('"', '""', $row['store_info']) . '"',
            $row['new_password'],
        ]) . "\n";
    }

    if (!$dryRun) {
        file_put_contents($filename, $csvContent);
        echo "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
        echo "✓ 密码清单已保存到: {$filename}\n";
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    } else {
        echo "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
        echo "预览模式：密码清单未保存\n";
        echo "移除 --dry-run 参数以实际执行迁移\n";
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    }
}

echo "\n";
echo "╔══════════════════════════════════════════════════════════════╗\n";
echo "║                      迁移完成                                ║\n";
echo "║                                                              ║\n";
echo "║  总计处理: " . str_pad(count($allResults) . " 个用户", 47) . "║\n";
echo "║                                                              ║\n";
echo "║  ⚠ 安全提醒:                                                ║\n";
echo "║    1. 请妥善保管密码清单文件                                 ║\n";
echo "║    2. 分发密码后请删除清单文件                               ║\n";
echo "║    3. 运行完成后请删除此脚本                                 ║\n";
echo "╚══════════════════════════════════════════════════════════════╝\n";
