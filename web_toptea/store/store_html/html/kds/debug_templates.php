<?php
/**
 * Debug: Check KDS Print Templates
 * Access: /kds/debug_templates.php
 */

require_once realpath(__DIR__ . '/../../kds_backend/core/kds_auth_core.php');
require_once realpath(__DIR__ . '/../../kds_backend/core/config.php');

header('Content-Type: text/plain; charset=utf-8');

echo "=== KDS Print Templates Debug ===\n";
echo "Time: " . date('Y-m-d H:i:s') . "\n\n";

try {
    // Check if kds_print_templates table exists
    $stmt = $pdo->query("SHOW TABLES LIKE 'kds_print_templates'");
    if ($stmt->rowCount() === 0) {
        echo "❌ ERROR: Table 'kds_print_templates' does not exist!\n";
        echo "\nYou need to run the migration to create this table.\n";
        exit;
    }
    echo "✓ Table 'kds_print_templates' exists\n\n";

    // Get all templates
    $stmt = $pdo->query("
        SELECT id, template_code, template_name, template_type,
               paper_width, paper_height, is_active,
               LENGTH(template_content) as content_length
        FROM kds_print_templates
        ORDER BY id
    ");
    $templates = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "Total templates: " . count($templates) . "\n";
    echo str_repeat('=', 80) . "\n";

    if (empty($templates)) {
        echo "❌ No templates found in database!\n\n";
        echo "You need to insert the default EXPIRY_LABEL template.\n";
        echo "Run the migration: 2026_01_26_backend_redesign.sql (lines 81-93)\n";
        exit;
    }

    foreach ($templates as $tpl) {
        echo "\nTemplate ID: " . $tpl['id'] . "\n";
        echo "Code: " . $tpl['template_code'] . "\n";
        echo "Name: " . $tpl['template_name'] . "\n";
        echo "Type: " . $tpl['template_type'] . "\n";
        echo "Size: " . $tpl['paper_width'] . 'x' . $tpl['paper_height'] . "mm\n";
        echo "Active: " . ($tpl['is_active'] ? 'YES' : 'NO') . "\n";
        echo "Content Length: " . $tpl['content_length'] . " bytes\n";
    }

    // Check EXPIRY_LABEL specifically
    echo "\n" . str_repeat('=', 80) . "\n";
    echo "Checking EXPIRY_LABEL Template\n";
    echo str_repeat('=', 80) . "\n";

    $stmt = $pdo->prepare("
        SELECT template_code, template_content, paper_width, paper_height, is_active
        FROM kds_print_templates
        WHERE template_code = 'EXPIRY_LABEL'
    ");
    $stmt->execute();
    $expiry_tpl = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$expiry_tpl) {
        echo "❌ EXPIRY_LABEL template NOT FOUND!\n";
        echo "\nThis is the problem! You need to insert this template.\n";
        echo "\nSQL to insert:\n";
        echo str_repeat('-', 80) . "\n";
        echo "INSERT INTO `kds_print_templates`
    (`template_code`, `template_name`, `template_type`, `paper_width`, `paper_height`, `template_content`, `description`)
VALUES
    ('EXPIRY_LABEL', '效期标签', 'TSPL', 40, 30,
     JSON_OBJECT(
         'commands', JSON_ARRAY(
             JSON_OBJECT('type', 'text', 'x', 10, 'y', 10, 'font', 2, 'content', '{{material_name}}'),
             JSON_OBJECT('type', 'divider', 'x', 0, 'y', 35, 'width', 300),
             JSON_OBJECT('type', 'kv', 'x', 10, 'y', 45, 'font', 1, 'label', '开封:', 'value', '{{opened_at_time}}'),
             JSON_OBJECT('type', 'kv', 'x', 10, 'y', 70, 'font', 1, 'label', '过期:', 'value', '{{expires_at_time}}'),
             JSON_OBJECT('type', 'text', 'x', 10, 'y', 95, 'font', 2, 'content', '剩余: {{time_left}}'),
             JSON_OBJECT('type', 'kv', 'x', 10, 'y', 120, 'font', 1, 'label', '操作员:', 'value', '{{handler_name}}')
         ),
         'copies', 1
     ),
     '物料开封后打印的效期追踪标签');\n";
        echo str_repeat('-', 80) . "\n";
    } else {
        echo "✓ EXPIRY_LABEL template found\n";
        echo "Active: " . ($expiry_tpl['is_active'] ? 'YES' : 'NO') . "\n";
        echo "Size: " . $expiry_tpl['paper_width'] . 'x' . $expiry_tpl['paper_height'] . "mm\n\n";

        // Check template_content structure
        echo "Template Content Analysis:\n";
        echo str_repeat('-', 80) . "\n";

        $content = json_decode($expiry_tpl['template_content'], true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            echo "❌ JSON Parse Error: " . json_last_error_msg() . "\n";
        } else {
            echo "✓ JSON is valid\n";

            if (isset($content['commands']) && is_array($content['commands'])) {
                echo "✓ 'commands' field exists and is an array\n";
                echo "  Commands count: " . count($content['commands']) . "\n";

                // Show structure that JS expects
                echo "\nExpected JS structure:\n";
                echo "  template.content = array of command objects\n";
                echo "  template.size = '{$expiry_tpl['paper_width']}x{$expiry_tpl['paper_height']}'\n";

                echo "\nActual structure:\n";
                echo "  template.content.commands = " . json_encode($content['commands']) . "\n";

                echo "\n⚠️ PROBLEM FOUND!\n";
                echo "The DB stores: {commands: [...], copies: 1}\n";
                echo "But JS expects: template.content = [...]  (direct array)\n";
                echo "\nThe handler needs to extract 'commands' from template_content!\n";

            } else {
                echo "❌ 'commands' field missing or not an array\n";
            }

            echo "\nFull content:\n";
            echo json_encode($content, JSON_PRETTY_PRINT) . "\n";
        }
    }

} catch (Exception $e) {
    echo "\n❌ ERROR: " . $e->getMessage() . "\n";
    echo "\nTrace:\n" . $e->getTraceAsString() . "\n";
}

echo "\n=== End of Debug ===\n";
?>
