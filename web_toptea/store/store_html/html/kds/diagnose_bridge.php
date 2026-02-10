<?php
/**
 * Diagnose AndroidBridge Status
 * Shows what JavaScript interfaces are available
 */

require_once realpath(__DIR__ . '/../../kds_backend/core/kds_auth_core.php');
require_once realpath(__DIR__ . '/../../kds_backend/core/config.php');

$page_title = 'AndroidBridge 诊断';
$page_js = null;

?>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $page_title; ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #1a1a1a; color: #00ff00; font-family: 'Courier New', monospace; padding: 20px; }
        .card { background: #000; border: 2px solid #00ff00; margin-bottom: 20px; }
        .card-header { background: #003300; color: #00ff00; font-weight: bold; }
        .success { color: #00ff00; }
        .error { color: #ff3333; }
        .warning { color: #ffaa00; }
        .info { color: #00aaff; }
        pre { background: #111; padding: 15px; border-left: 3px solid #00ff00; overflow-x: auto; }
        .test-result { padding: 10px; margin: 10px 0; border-left: 4px solid; }
        .test-pass { border-color: #00ff00; background: #001100; }
        .test-fail { border-color: #ff3333; background: #110000; }
        .test-warn { border-color: #ffaa00; background: #111100; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <h1>🔍 AndroidBridge 接口诊断</h1>
        <p class="info">此页面检查安卓APP是否正确注入了打印接口</p>

        <div class="card">
            <div class="card-header">环境检测</div>
            <div class="card-body">
                <div id="env-info"></div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">AndroidBridge 接口检测</div>
            <div class="card-body">
                <div id="bridge-info"></div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">打印接口测试</div>
            <div class="card-body">
                <button id="test-print" class="btn btn-success">测试打印功能</button>
                <div id="test-result" class="mt-3"></div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">所有 window 对象属性</div>
            <div class="card-body">
                <button id="show-window" class="btn btn-info">显示所有 window 属性</button>
                <pre id="window-props" style="max-height: 400px; overflow-y: auto;"></pre>
            </div>
        </div>
    </div>

    <script>
        // 环境检测
        function detectEnvironment() {
            const ua = navigator.userAgent;
            const info = [];

            info.push('User Agent: ' + ua);
            info.push('Platform: ' + navigator.platform);
            info.push('是否移动设备: ' + /Android|iPhone|iPad/i.test(ua));
            info.push('是否Android: ' + /Android/i.test(ua));

            document.getElementById('env-info').innerHTML =
                '<pre>' + info.join('\n') + '</pre>';
        }

        // AndroidBridge 检测
        function detectBridge() {
            const results = [];

            // Test 1: window.AndroidBridge exists
            if (typeof window.AndroidBridge !== 'undefined') {
                results.push('<div class="test-result test-pass">✅ window.AndroidBridge 存在</div>');

                // Test 2: printRaw method
                if (typeof window.AndroidBridge.printRaw === 'function') {
                    results.push('<div class="test-result test-pass">✅ AndroidBridge.printRaw 方法存在</div>');
                } else {
                    results.push('<div class="test-result test-fail">❌ AndroidBridge.printRaw 方法不存在</div>');
                    results.push('<div class="test-result test-warn">类型: ' + typeof window.AndroidBridge.printRaw + '</div>');
                }

                // List all methods
                const methods = Object.getOwnPropertyNames(window.AndroidBridge);
                results.push('<div class="test-result test-pass">可用方法列表:</div>');
                results.push('<pre>' + JSON.stringify(methods, null, 2) + '</pre>');

            } else {
                results.push('<div class="test-result test-fail">❌ window.AndroidBridge 不存在！</div>');
                results.push('<div class="test-result test-warn">⚠️ 可能原因:</div>');
                results.push('<ul>' +
                    '<li>不在APP中运行（在浏览器中）</li>' +
                    '<li>APP版本太旧，未注入此接口</li>' +
                    '<li>WebView配置错误</li>' +
                    '<li>接口名称已更改</li>' +
                    '</ul>');
            }

            // Test 3: Alternative names
            const alternatives = ['Android', 'AndroidInterface', 'NativeBridge', 'PrintBridge'];
            const found = alternatives.filter(name => typeof window[name] !== 'undefined');

            if (found.length > 0) {
                results.push('<div class="test-result test-warn">⚠️ 发现其他可能的接口:</div>');
                found.forEach(name => {
                    results.push('<div class="test-result test-warn">- window.' + name + ' 存在</div>');
                    const methods = Object.getOwnPropertyNames(window[name]);
                    results.push('<pre>  方法: ' + JSON.stringify(methods, null, 2) + '</pre>');
                });
            }

            document.getElementById('bridge-info').innerHTML = results.join('');
        }

        // 测试打印
        document.getElementById('test-print').addEventListener('click', function() {
            const resultDiv = document.getElementById('test-result');

            if (typeof window.AndroidBridge !== 'undefined' &&
                typeof window.AndroidBridge.printRaw === 'function') {

                try {
                    // 测试打印一个简单的TSPL命令
                    const testTSPL = 'SIZE 40 mm, 30 mm\nGAP 0 mm, 0 mm\nCLS\nTEXT 10,10,"3",0,1,1,"TEST PRINT"\nPRINT 1\n';

                    resultDiv.innerHTML = '<div class="test-result test-pass">正在调用 AndroidBridge.printRaw()...</div>';
                    resultDiv.innerHTML += '<pre>' + testTSPL + '</pre>';

                    window.AndroidBridge.printRaw(testTSPL);

                    resultDiv.innerHTML += '<div class="test-result test-pass">✅ 调用成功！请检查打印机是否打印</div>';

                } catch (e) {
                    resultDiv.innerHTML = '<div class="test-result test-fail">❌ 调用失败: ' + e.message + '</div>';
                    resultDiv.innerHTML += '<pre>' + e.stack + '</pre>';
                }

            } else {
                resultDiv.innerHTML = '<div class="test-result test-fail">❌ AndroidBridge.printRaw 不可用</div>';
            }
        });

        // 显示所有window属性
        document.getElementById('show-window').addEventListener('click', function() {
            const props = Object.getOwnPropertyNames(window).filter(prop => {
                // 过滤掉标准DOM属性
                return !['document', 'location', 'navigator', 'screen', 'history',
                         'localStorage', 'sessionStorage', 'console'].includes(prop) &&
                       prop.indexOf('webkit') === -1 &&
                       prop.indexOf('chrome') === -1 &&
                       typeof window[prop] === 'object';
            }).sort();

            const output = props.map(prop => {
                const value = window[prop];
                if (typeof value === 'object' && value !== null) {
                    const methods = Object.getOwnPropertyNames(value);
                    return prop + ':\n  ' + methods.join(', ');
                }
                return prop;
            }).join('\n\n');

            document.getElementById('window-props').textContent = output || '(无自定义对象)';
        });

        // 页面加载时执行
        detectEnvironment();
        detectBridge();
    </script>
</body>
</html>
