<?php
/**
 * Toptea - 单用户密码设置脚本
 * 为指定用户设置新密码 (bcrypt)
 *
 * [AUDIT FIX 2026-01-25]
 *
 * 使用方法:
 *   php set_user_password.php --table=kds_users --username=admin --password=NewPass123
 *   php set_user_password.php --table=cpsys_users --username=admin  (自动生成密码)
 *
 * 安全警告:
 *   - 此脚本仅限命令行运行
 *   - 运行后请立即删除此脚本
 */

// 安全检查: 仅允许CLI运行
if (php_sapi_name() !== 'cli') {
    http_response_code(403);
    die("此脚本仅允许通过命令行运行。\n");
}

// 解析命令行参数
$options = getopt('', ['table:', 'username:', 'password:', 'user-id:', 'help']);

if (isset($options['help']) || (!isset($options['username']) && !isset($options['user-id']))) {
    echo <<<HELP
Toptea 单用户密码设置脚本
========================

用法: php set_user_password.php [选项]

选项:
  --table=NAME      目标表 (必填: kds_users 或 cpsys_users)
  --username=NAME   用户名 (与 --user-id 二选一)
  --user-id=ID      用户ID (与 --username 二选一)
  --password=PASS   新密码 (可选，不提供则自动生成)
  --help            显示此帮助信息

示例:
  php set_user_password.php --table=kds_users --username=admin --password=MyNewPass123
  php set_user_password.php --table=cpsys_users --user-id=1
  php set_user_password.php --table=kds_users --username=staff01

HELP;
    exit(0);
}

$tableName = $options['table'] ?? null;
$username = $options['username'] ?? null;
$userId = $options['user-id'] ?? null;
$newPassword = $options['password'] ?? null;

// 验证表名
if (!$tableName || !in_array($tableName, ['kds_users', 'cpsys_users'])) {
    die("✗ 错误: 必须指定有效的表名 (--table=kds_users 或 --table=cpsys_users)\n");
}

// 数据库配置
$db_host = 'mhdlmskv3gjbpqv3.mysql.db';
$db_name = 'mhdlmskv3gjbpqv3';
$db_user = 'mhdlmskv3gjbpqv3';
$db_pass = 'zqVdVfAWYYaa4gTAuHWX7CngpRDqR';
$db_char = 'utf8mb4';

// 连接数据库
$dsn = "mysql:host=$db_host;dbname=$db_name;charset=$db_char";
try {
    $pdo = new PDO($dsn, $db_user, $db_pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    die("✗ 数据库连接失败: " . $e->getMessage() . "\n");
}

// 查找用户
if ($userId) {
    $stmt = $pdo->prepare("SELECT id, username, display_name FROM {$tableName} WHERE id = ? AND deleted_at IS NULL");
    $stmt->execute([$userId]);
} else {
    $stmt = $pdo->prepare("SELECT id, username, display_name FROM {$tableName} WHERE username = ? AND deleted_at IS NULL");
    $stmt->execute([$username]);
}

$user = $stmt->fetch();

if (!$user) {
    die("✗ 用户未找到: " . ($username ?: "ID:{$userId}") . "\n");
}

// 生成密码（如果未提供）
if (!$newPassword) {
    $chars = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#$%';
    $newPassword = '';
    for ($i = 0; $i < 12; $i++) {
        $newPassword .= $chars[random_int(0, strlen($chars) - 1)];
    }
}

// 生成bcrypt哈希
$bcryptHash = password_hash($newPassword, PASSWORD_BCRYPT, ['cost' => 12]);

// 更新密码
$updateStmt = $pdo->prepare("UPDATE {$tableName} SET password_hash = ? WHERE id = ?");
$updateStmt->execute([$bcryptHash, $user['id']]);

echo "\n";
echo "╔══════════════════════════════════════════════════════════════╗\n";
echo "║              密码设置成功                                    ║\n";
echo "╚══════════════════════════════════════════════════════════════╝\n";
echo "\n";
echo "  表:       {$tableName}\n";
echo "  用户ID:   {$user['id']}\n";
echo "  用户名:   {$user['username']}\n";
echo "  显示名:   {$user['display_name']}\n";
echo "  新密码:   {$newPassword}\n";
echo "\n";
echo "  ⚠ 请妥善保管此密码，并通知用户。\n";
echo "\n";
