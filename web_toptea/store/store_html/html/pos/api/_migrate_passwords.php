<?php
/**
 * Toptea - 网页版密码迁移工具
 * 将现有用户密码从 SHA256 迁移到 bcrypt
 *
 * [AUDIT FIX 2026-01-25]
 *
 * 访问方式:
 *   https://store.toptea.es/pos/api/_migrate_passwords.php?key=YOUR_SECRET_KEY
 *
 * 安全措施:
 *   - 需要提供正确的访问密钥
 *   - 运行后请立即删除此文件
 */

// ============================================================
// 【重要】请修改此密钥后再上传到服务器
// ============================================================
define('ACCESS_KEY', 'CHANGE_THIS_TO_A_RANDOM_STRING_123456');
// ============================================================

// 安全验证
$providedKey = $_GET['key'] ?? '';
if ($providedKey !== ACCESS_KEY || ACCESS_KEY === 'CHANGE_THIS_TO_A_RANDOM_STRING_123456') {
    http_response_code(403);
    die('<!DOCTYPE html><html><head><meta charset="UTF-8"><title>访问拒绝</title></head><body>
    <h1>403 访问拒绝</h1>
    <p>请提供正确的访问密钥: <code>?key=YOUR_SECRET_KEY</code></p>
    <p style="color:red;">如果您是管理员，请先编辑此文件修改 ACCESS_KEY 常量。</p>
    </body></html>');
}

// 数据库配置 (与 POS/HQ 统一)
$db_host = 'mhdlmskv3gjbpqv3.mysql.db';
$db_name = 'mhdlmskv3gjbpqv3';
$db_user = 'mhdlmskv3gjbpqv3';
$db_pass = 'zqVdVfAWYYaa4gTAuHWX7CngpRDqR';
$db_char = 'utf8mb4';

// 获取操作参数
$action = $_GET['action'] ?? 'preview';
$table = $_GET['table'] ?? 'all';

// 连接数据库
$dsn = "mysql:host=$db_host;dbname=$db_name;charset=$db_char";
try {
    $pdo = new PDO($dsn, $db_user, $db_pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    $dbStatus = '✓ 数据库连接成功';
} catch (PDOException $e) {
    $dbStatus = '✗ 数据库连接失败: ' . htmlspecialchars($e->getMessage());
    $pdo = null;
}

/**
 * 生成随机密码
 */
function generatePassword(int $length = 12): string {
    $chars = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    $password = '';
    for ($i = 0; $i < $length; $i++) {
        $password .= $chars[random_int(0, strlen($chars) - 1)];
    }
    return $password;
}

/**
 * 获取用户列表
 */
function getUsers(PDO $pdo, string $tableName): array {
    $stmt = $pdo->prepare("SHOW TABLES LIKE ?");
    $stmt->execute([$tableName]);
    if (!$stmt->fetch()) return [];

    $sql = "SELECT id, username, display_name FROM {$tableName} WHERE deleted_at IS NULL";
    if ($tableName === 'kds_users') {
        $sql = "SELECT u.id, u.username, u.display_name, s.store_name
                FROM kds_users u
                LEFT JOIN kds_stores s ON u.store_id = s.id
                WHERE u.deleted_at IS NULL";
    }
    return $pdo->query($sql)->fetchAll();
}

/**
 * 迁移用户密码
 */
function migrateUsers(PDO $pdo, string $tableName): array {
    $users = getUsers($pdo, $tableName);
    $results = [];

    $updateStmt = $pdo->prepare("UPDATE {$tableName} SET password_hash = ? WHERE id = ?");

    foreach ($users as $user) {
        $newPassword = generatePassword(12);
        $bcryptHash = password_hash($newPassword, PASSWORD_BCRYPT, ['cost' => 12]);
        $updateStmt->execute([$bcryptHash, $user['id']]);

        $results[] = [
            'id' => $user['id'],
            'username' => $user['username'],
            'display_name' => $user['display_name'] ?? '',
            'store_name' => $user['store_name'] ?? '-',
            'new_password' => $newPassword,
        ];
    }
    return $results;
}

// HTML 输出
header('Content-Type: text/html; charset=UTF-8');
?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Toptea 密码迁移工具</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 { color: #333; margin-top: 0; }
        .status-ok { color: #28a745; }
        .status-error { color: #dc3545; }
        .warning {
            background: #fff3cd;
            border: 1px solid #ffc107;
            padding: 15px;
            border-radius: 4px;
            margin: 15px 0;
        }
        .danger {
            background: #f8d7da;
            border: 1px solid #dc3545;
            padding: 15px;
            border-radius: 4px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
            font-size: 14px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th { background: #f8f9fa; font-weight: 600; }
        tr:hover { background: #f8f9fa; }
        .password {
            font-family: monospace;
            background: #e9ecef;
            padding: 2px 6px;
            border-radius: 3px;
            user-select: all;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            margin-right: 10px;
        }
        .btn-primary { background: #007bff; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn:hover { opacity: 0.9; }
        select, input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .copy-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
        }
        #csvOutput {
            width: 100%;
            height: 200px;
            font-family: monospace;
            font-size: 12px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>🔐 Toptea 密码迁移工具</h1>
        <p>将用户密码从 SHA256 迁移到 bcrypt (安全哈希)</p>
        <p class="<?= $pdo ? 'status-ok' : 'status-error' ?>"><?= $dbStatus ?></p>
    </div>

    <div class="card danger">
        <strong>⚠️ 安全警告</strong>
        <ul style="margin: 10px 0;">
            <li>此工具仅供一次性使用</li>
            <li>运行完成后请<strong>立即删除此文件</strong></li>
            <li>妥善保管生成的密码列表</li>
        </ul>
    </div>

<?php if ($pdo): ?>

    <?php if ($action === 'preview'): ?>
    <!-- 预览模式 -->
    <div class="card">
        <h2>📋 用户列表预览</h2>

        <form method="get" style="margin-bottom: 20px;">
            <input type="hidden" name="key" value="<?= htmlspecialchars($providedKey) ?>">
            <label>选择目标表：</label>
            <select name="table">
                <option value="all" <?= $table === 'all' ? 'selected' : '' ?>>全部用户</option>
                <option value="kds_users" <?= $table === 'kds_users' ? 'selected' : '' ?>>门店用户 (kds_users)</option>
                <option value="cpsys_users" <?= $table === 'cpsys_users' ? 'selected' : '' ?>>总部用户 (cpsys_users)</option>
            </select>
            <button type="submit" class="btn btn-secondary">刷新预览</button>
        </form>

        <?php
        $tables = [];
        if ($table === 'all' || $table === 'kds_users') $tables[] = 'kds_users';
        if ($table === 'all' || $table === 'cpsys_users') $tables[] = 'cpsys_users';

        $totalUsers = 0;
        foreach ($tables as $t):
            $users = getUsers($pdo, $t);
            $totalUsers += count($users);
        ?>

        <h3><?= $t ?> (<?= count($users) ?> 个用户)</h3>
        <?php if (empty($users)): ?>
            <p>该表中没有活跃用户</p>
        <?php else: ?>
        <table>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>显示名</th>
                <?php if ($t === 'kds_users'): ?><th>门店</th><?php endif; ?>
            </tr>
            <?php foreach ($users as $user): ?>
            <tr>
                <td><?= $user['id'] ?></td>
                <td><?= htmlspecialchars($user['username']) ?></td>
                <td><?= htmlspecialchars($user['display_name'] ?? '-') ?></td>
                <?php if ($t === 'kds_users'): ?>
                <td><?= htmlspecialchars($user['store_name'] ?? '-') ?></td>
                <?php endif; ?>
            </tr>
            <?php endforeach; ?>
        </table>
        <?php endif; ?>

        <?php endforeach; ?>

        <div class="warning">
            <strong>即将为 <?= $totalUsers ?> 个用户重置密码</strong><br>
            点击下方按钮将为所有用户生成新密码并更新数据库。此操作不可撤销！
        </div>

        <a href="?key=<?= urlencode($providedKey) ?>&action=migrate&table=<?= urlencode($table) ?>"
           class="btn btn-danger"
           onclick="return confirm('确定要重置所有用户密码吗？\n\n此操作不可撤销！');">
            🔄 执行密码迁移
        </a>
    </div>

    <?php elseif ($action === 'migrate'): ?>
    <!-- 执行迁移 -->
    <div class="card">
        <h2>✅ 密码迁移完成</h2>

        <?php
        $tables = [];
        if ($table === 'all' || $table === 'kds_users') $tables[] = 'kds_users';
        if ($table === 'all' || $table === 'cpsys_users') $tables[] = 'cpsys_users';

        $allResults = [];
        $csvLines = ["表,用户ID,用户名,显示名,门店,新密码"];

        foreach ($tables as $t):
            $results = migrateUsers($pdo, $t);
            foreach ($results as $r) {
                $allResults[] = array_merge(['table' => $t], $r);
                $csvLines[] = implode(',', [
                    $t,
                    $r['id'],
                    $r['username'],
                    '"' . str_replace('"', '""', $r['display_name']) . '"',
                    '"' . str_replace('"', '""', $r['store_name']) . '"',
                    $r['new_password']
                ]);
            }
        ?>

        <h3><?= $t ?> (<?= count($results) ?> 个用户已更新)</h3>
        <table>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>显示名</th>
                <?php if ($t === 'kds_users'): ?><th>门店</th><?php endif; ?>
                <th>新密码</th>
            </tr>
            <?php foreach ($results as $r): ?>
            <tr>
                <td><?= $r['id'] ?></td>
                <td><?= htmlspecialchars($r['username']) ?></td>
                <td><?= htmlspecialchars($r['display_name']) ?></td>
                <?php if ($t === 'kds_users'): ?>
                <td><?= htmlspecialchars($r['store_name']) ?></td>
                <?php endif; ?>
                <td><span class="password"><?= htmlspecialchars($r['new_password']) ?></span></td>
            </tr>
            <?php endforeach; ?>
        </table>

        <?php endforeach; ?>

        <h3>📥 导出密码清单 (CSV)</h3>
        <p>请复制以下内容保存为 CSV 文件：</p>
        <button class="copy-btn" onclick="copyCSV()">📋 复制到剪贴板</button>
        <textarea id="csvOutput" readonly><?= htmlspecialchars(implode("\n", $csvLines)) ?></textarea>

        <div class="danger" style="margin-top: 20px;">
            <strong>⚠️ 重要提醒</strong>
            <ol>
                <li>请立即保存上方的密码清单</li>
                <li>通过FTP删除此文件：<code>/pos/api/_migrate_passwords.php</code></li>
                <li>将新密码分发给各用户</li>
            </ol>
        </div>

        <p style="margin-top: 20px;">
            <a href="?key=<?= urlencode($providedKey) ?>" class="btn btn-secondary">返回预览</a>
        </p>
    </div>
    <?php endif; ?>

<?php endif; ?>

    <script>
    function copyCSV() {
        const textarea = document.getElementById('csvOutput');
        textarea.select();
        document.execCommand('copy');
        alert('已复制到剪贴板！请粘贴到文本编辑器并保存为 .csv 文件');
    }
    </script>
</body>
</html>
