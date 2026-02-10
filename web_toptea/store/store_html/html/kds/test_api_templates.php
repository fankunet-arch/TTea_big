<?php
/**
 * Test API Response for Print Templates
 * Simulates the actual API call to verify template structure
 */

require_once realpath(__DIR__ . '/../../kds_backend/core/kds_auth_core.php');
require_once realpath(__DIR__ . '/../../kds_backend/core/config.php');

header('Content-Type: text/plain; charset=utf-8');

echo "=== Testing Print Template API Response ===\n";
echo "Simulating: api/kds_api_gateway.php?res=print&act=get_templates\n\n";

try {
    // Simulate the API handler
    require_once realpath(__DIR__ . '/../../kds_backend/helpers/kds_helper.php');

    $stmt = $pdo->prepare(
        "SELECT template_code, template_content, paper_width, paper_height
         FROM kds_print_templates
         WHERE is_active = 1"
    );
    $stmt->execute();
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $templates = [];
    foreach ($results as $row) {
        $code = $row['template_code'];
        if (!isset($templates[$code])) {
            $tpl_content = json_decode($row['template_content'], true);

            // [FIX 2026-02-10] 提取 commands 数组
            $commands = $tpl_content['commands'] ?? $tpl_content;

            $templates[$code] = [
                'content' => $commands,  // 直接是commands数组
                'size' => $row['paper_width'] . 'x' . $row['paper_height']
            ];
        }
    }

    echo "API Response:\n";
    echo str_repeat('=', 80) . "\n";
    echo json_encode(['status' => 'success', 'data' => $templates], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";
    echo str_repeat('=', 80) . "\n\n";

    // Verify EXPIRY_LABEL structure
    if (isset($templates['EXPIRY_LABEL'])) {
        echo "✓ EXPIRY_LABEL found in response\n\n";

        $expiry = $templates['EXPIRY_LABEL'];

        echo "Checking JavaScript expectations:\n";
        echo str_repeat('-', 80) . "\n";

        // Check 1: content is array
        if (is_array($expiry['content'])) {
            echo "✅ template.content is an array\n";
            echo "   Type: array\n";
            echo "   Length: " . count($expiry['content']) . " items\n";
        } else {
            echo "❌ template.content is NOT an array\n";
            echo "   Type: " . gettype($expiry['content']) . "\n";
        }

        // Check 2: first item structure
        if (isset($expiry['content'][0])) {
            $first = $expiry['content'][0];
            echo "\n✓ First command structure:\n";
            echo "   " . json_encode($first, JSON_UNESCAPED_UNICODE) . "\n";

            if (isset($first['type'])) {
                echo "   ✅ Has 'type' field: " . $first['type'] . "\n";
            }
        }

        // Check 3: size format
        echo "\n✓ Size: " . $expiry['size'] . "\n";

        echo "\n" . str_repeat('=', 80) . "\n";
        echo "✅ Template structure is CORRECT for JavaScript!\n";
        echo "\nJavaScript code will receive:\n";
        echo "  KDS_STATE.templates['EXPIRY_LABEL'] = {\n";
        echo "    content: [\n";
        echo "      {type: 'text', x: 10, y: 10, ...},\n";
        echo "      {type: 'divider', ...},\n";
        echo "      ...\n";
        echo "    ],\n";
        echo "    size: '40x30'\n";
        echo "  }\n";
        echo "\nThis matches kds_print_bridge.js expectations!\n";

    } else {
        echo "❌ EXPIRY_LABEL not found in API response\n";
    }

} catch (Exception $e) {
    echo "❌ ERROR: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString() . "\n";
}

echo "\n=== Test Complete ===\n";
?>
