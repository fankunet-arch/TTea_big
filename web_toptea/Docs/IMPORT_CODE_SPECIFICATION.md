# TopTea 入库码 (Import Code) 技术规范

> **版本**: 1.0
> **最后更新**: 2026-01-27
> **适用对象**: MRS (物料管理系统) 开发团队

---

## 1. 概述

### 1.1 什么是入库码

入库码是 MRS 系统向门店发货后生成的**一次性导入凭证**，门店员工通过在 TopTea KDS 或 HQ 后台输入此码，即可批量导入库存数据。

### 1.2 设计目标

- **简单**: 员工只需复制粘贴一段码即可完成入库
- **安全**: 内置校验机制防止数据篡改
- **防重复**: 系统自动检测重复导入
- **可追溯**: 完整记录每次入库的来源和明细

### 1.3 基本流程

```
MRS系统 → 生成入库码 → 发送给门店 → 员工输入 → TopTea解析验证 → 入库成功
```

---

## 2. 入库码格式

### 2.1 编码方式

入库码 = **Base64( JSON字符串 )**

```
原始JSON → UTF-8编码 → Base64标准编码 → 入库码
```

### 2.2 JSON 结构

```json
{
  "v": 1,
  "store": "A1001",
  "ref": "MRS-2026-001234",
  "date": "2026-01-27",
  "items": [
    {
      "code": "01",
      "qty": 10.5,
      "unit": "1",
      "batch": "B20260127",
      "shelf": "2026-03-27"
    }
  ],
  "checksum": "a1b2c3d4"
}
```

---

## 3. 字段详细说明

### 3.1 根级字段

| 字段 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| `v` | integer | **是** | 版本号，当前固定为 `1` |
| `store` | string | **是** | 目标门店代码，必须与 TopTea 系统中的 `store_code` 完全一致 |
| `ref` | string | **是** | MRS 出货单号/发货单号，用于追溯 |
| `date` | string | **是** | 出货日期，格式 `YYYY-MM-DD` |
| `items` | array | **是** | 物料明细数组，至少包含1项 |
| `checksum` | string | **是** | 数据校验码，8位十六进制字符 |

### 3.2 items 数组元素字段

| 字段 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| `code` | string | **是** | 物料编码，必须与 TopTea 系统中的 `material_code` 一致 |
| `qty` | number | **是** | 数量，支持最多3位小数 |
| `unit` | string | **是** | 单位编码，必须与 TopTea 系统中的 `unit_code` 一致 |
| `batch` | string | 否 | 批次号，用于追溯 |
| `shelf` | string | 否 | 未开封保质期截止日期，格式 `YYYY-MM-DD` |

---

## 4. 字段格式要求

### 4.1 版本号 (v)

```
类型: 正整数
当前值: 1
说明: 预留版本升级用，目前必须为 1
```

### 4.2 门店代码 (store)

```
类型: 字符串
长度: 1-20 字符
字符集: 字母、数字
示例: "A1001", "MAD01", "BCN02"
注意: 大小写敏感，必须与 TopTea 系统中配置的 store_code 完全一致
```

**如何获取门店代码**:
- 从 TopTea HQ 后台 "门店管理" 页面查看
- 或通过 API 接口查询（如已对接）

### 4.3 MRS 参考号 (ref)

```
类型: 字符串
长度: 1-100 字符
字符集: 字母、数字、连字符(-)、下划线(_)
示例: "MRS-2026-001234", "DO_20260127_001", "INV2026012700001"
用途: 出货单号，便于日后对账和追溯
```

### 4.4 出货日期 (date)

```
类型: 字符串
格式: YYYY-MM-DD (ISO 8601 日期格式)
示例: "2026-01-27"
注意: 必须是有效日期
```

### 4.5 物料编码 (items[].code)

```
类型: 字符串
长度: 1-10 字符
内容: TopTea 系统中定义的 material_code
示例: "01", "02", "103"
注意:
  - 可能是纯数字或字母数字组合
  - 必须在 TopTea 系统 kds_materials 表中存在
  - 大小写敏感
```

**如何获取物料编码**:
- 从 TopTea HQ 后台 "物料管理" 页面导出
- 通常为2-3位数字编码

### 4.6 数量 (items[].qty)

```
类型: 数字 (number)
范围: > 0
精度: 最多3位小数
示例: 10, 5.5, 100.125
注意:
  - 必须大于0
  - JSON中直接写数字，不要用字符串
  - 避免浮点数精度问题，建议使用整数或最多3位小数
```

### 4.7 单位编码 (items[].unit)

```
类型: 字符串
长度: 1-10 字符
内容: TopTea 系统中定义的 unit_code
示例: "1", "2", "10"
注意:
  - 必须在 TopTea 系统 kds_units 表中存在
  - 通常为1-2位数字编码
```

**常见单位编码对照** (以实际系统配置为准):

| 编码 | 含义 |
|-----|------|
| 1 | 毫升 (ml) |
| 2 | 克 (g) |
| 3 | 个 |
| 4 | 包 |
| 5 | 袋 |
| 6 | 瓶 |
| 7 | 箱 |

### 4.8 批次号 (items[].batch)

```
类型: 字符串 (可选)
长度: 0-50 字符
示例: "B20260127", "LOT001", "202601-A"
用途: 生产批次追溯
注意: 如果没有批次信息，可以省略此字段或设为 null
```

### 4.9 未开封保质期 (items[].shelf)

```
类型: 字符串 (可选)
格式: YYYY-MM-DD
示例: "2026-03-27"
用途: 物料未开封状态的保质期截止日期
注意:
  - 如果没有保质期信息，可以省略此字段或设为 null
  - 这是未开封保质期，开封后的效期由 TopTea 系统根据物料规则自动计算
```

---

## 5. 校验码计算

### 5.1 算法说明

校验码用于验证数据完整性，防止传输过程中被篡改。

**计算步骤**:

1. 构造不含 checksum 的原始对象
2. 将对象序列化为 JSON 字符串（紧凑格式，无空格）
3. 对 JSON 字符串计算 SHA-256 哈希
4. 取哈希值的**前8个字符**（小写十六进制）

### 5.2 伪代码

```
function generateChecksum(payload):
    // 1. 复制对象，移除 checksum 字段
    data = copy(payload)
    delete data.checksum

    // 2. 序列化为 JSON (紧凑格式，key按原顺序)
    jsonString = JSON.stringify(data)

    // 3. 计算 SHA-256
    hash = SHA256(jsonString)

    // 4. 取前8位
    return hash.substring(0, 8).toLowerCase()
```

### 5.3 关键要求

| 要求 | 说明 |
|-----|------|
| JSON格式 | 紧凑格式，无多余空格和换行 |
| 字符编码 | UTF-8 |
| 哈希算法 | SHA-256 |
| 结果长度 | 8个字符 |
| 大小写 | 小写十六进制 |

### 5.4 JSON 序列化注意事项

为确保校验码一致，JSON 序列化时需注意：

1. **无空格**: 键值之间不加空格
   - 正确: `{"v":1,"store":"A1001"}`
   - 错误: `{"v": 1, "store": "A1001"}`

2. **无换行**: 整个 JSON 在一行内

3. **数字格式**: 数字不加引号，不使用科学计数法
   - 正确: `"qty":10.5`
   - 错误: `"qty":"10.5"` 或 `"qty":1.05e1`

4. **null 处理**: 可选字段如果没有值，建议直接省略该字段，而不是设为 null

5. **字段顺序**: 建议保持固定顺序 (v → store → ref → date → items → checksum)

---

## 6. 完整示例

### 6.1 原始数据

```json
{
  "v": 1,
  "store": "A1001",
  "ref": "MRS-2026-001234",
  "date": "2026-01-27",
  "items": [
    {
      "code": "01",
      "qty": 10,
      "unit": "1",
      "batch": "B20260127",
      "shelf": "2026-03-27"
    },
    {
      "code": "02",
      "qty": 5.5,
      "unit": "2"
    },
    {
      "code": "15",
      "qty": 100,
      "unit": "3",
      "batch": "LOT001"
    }
  ]
}
```

### 6.2 计算校验码

**Step 1**: 序列化为紧凑 JSON (不含 checksum)

```
{"v":1,"store":"A1001","ref":"MRS-2026-001234","date":"2026-01-27","items":[{"code":"01","qty":10,"unit":"1","batch":"B20260127","shelf":"2026-03-27"},{"code":"02","qty":5.5,"unit":"2"},{"code":"15","qty":100,"unit":"3","batch":"LOT001"}]}
```

**Step 2**: 计算 SHA-256

```
SHA256("...上述JSON...") = "e8f4a2b1c9d0e5f6789012345678901234567890abcdef1234567890abcdef12"
```

**Step 3**: 取前8位

```
checksum = "e8f4a2b1"
```

### 6.3 完整 JSON (含校验码)

```json
{"v":1,"store":"A1001","ref":"MRS-2026-001234","date":"2026-01-27","items":[{"code":"01","qty":10,"unit":"1","batch":"B20260127","shelf":"2026-03-27"},{"code":"02","qty":5.5,"unit":"2"},{"code":"15","qty":100,"unit":"3","batch":"LOT001"}],"checksum":"e8f4a2b1"}
```

### 6.4 Base64 编码

```
eyJ2IjoxLCJzdG9yZSI6IkExMDAxIiwicmVmIjoiTVJTLTIwMjYtMDAxMjM0IiwiZGF0ZSI6IjIwMjYtMDEtMjciLCJpdGVtcyI6W3siY29kZSI6IjAxIiwicXR5IjoxMCwidW5pdCI6IjEiLCJiYXRjaCI6IkIyMDI2MDEyNyIsInNoZWxmIjoiMjAyNi0wMy0yNyJ9LHsiY29kZSI6IjAyIiwicXR5Ijo1LjUsInVuaXQiOiIyIn0seyJjb2RlIjoiMTUiLCJxdHkiOjEwMCwidW5pdCI6IjMiLCJiYXRjaCI6IkxPVDAwMSJ9XSwiY2hlY2tzdW0iOiJlOGY0YTJiMSJ9
```

**这就是最终的入库码**，员工将此码粘贴到系统中即可。

---

## 7. 代码示例

### 7.1 Python

```python
import json
import hashlib
import base64

def generate_import_code(store_code: str, ref: str, date: str, items: list) -> str:
    """
    生成 TopTea 入库码

    Args:
        store_code: 门店代码 (如 "A1001")
        ref: MRS出货单号 (如 "MRS-2026-001234")
        date: 出货日期 (如 "2026-01-27")
        items: 物料列表，每项包含 code, qty, unit, 可选 batch, shelf

    Returns:
        Base64编码的入库码字符串
    """

    # 1. 构造数据对象
    payload = {
        "v": 1,
        "store": store_code,
        "ref": ref,
        "date": date,
        "items": items
    }

    # 2. 计算校验码
    json_str = json.dumps(payload, separators=(',', ':'), ensure_ascii=False)
    checksum = hashlib.sha256(json_str.encode('utf-8')).hexdigest()[:8]

    # 3. 添加校验码
    payload["checksum"] = checksum

    # 4. 序列化并 Base64 编码
    final_json = json.dumps(payload, separators=(',', ':'), ensure_ascii=False)
    import_code = base64.b64encode(final_json.encode('utf-8')).decode('ascii')

    return import_code


# 使用示例
if __name__ == "__main__":
    items = [
        {"code": "01", "qty": 10, "unit": "1", "batch": "B20260127", "shelf": "2026-03-27"},
        {"code": "02", "qty": 5.5, "unit": "2"},
        {"code": "15", "qty": 100, "unit": "3", "batch": "LOT001"}
    ]

    code = generate_import_code(
        store_code="A1001",
        ref="MRS-2026-001234",
        date="2026-01-27",
        items=items
    )

    print("入库码:")
    print(code)
```

### 7.2 JavaScript (Node.js)

```javascript
const crypto = require('crypto');

/**
 * 生成 TopTea 入库码
 * @param {string} storeCode - 门店代码
 * @param {string} ref - MRS出货单号
 * @param {string} date - 出货日期 (YYYY-MM-DD)
 * @param {Array} items - 物料列表
 * @returns {string} Base64编码的入库码
 */
function generateImportCode(storeCode, ref, date, items) {
    // 1. 构造数据对象
    const payload = {
        v: 1,
        store: storeCode,
        ref: ref,
        date: date,
        items: items
    };

    // 2. 计算校验码
    const jsonStr = JSON.stringify(payload);
    const hash = crypto.createHash('sha256').update(jsonStr, 'utf8').digest('hex');
    const checksum = hash.substring(0, 8);

    // 3. 添加校验码
    payload.checksum = checksum;

    // 4. 序列化并 Base64 编码
    const finalJson = JSON.stringify(payload);
    const importCode = Buffer.from(finalJson, 'utf8').toString('base64');

    return importCode;
}

// 使用示例
const items = [
    { code: "01", qty: 10, unit: "1", batch: "B20260127", shelf: "2026-03-27" },
    { code: "02", qty: 5.5, unit: "2" },
    { code: "15", qty: 100, unit: "3", batch: "LOT001" }
];

const code = generateImportCode("A1001", "MRS-2026-001234", "2026-01-27", items);
console.log("入库码:", code);
```

### 7.3 PHP

```php
<?php
/**
 * 生成 TopTea 入库码
 *
 * @param string $storeCode 门店代码
 * @param string $ref MRS出货单号
 * @param string $date 出货日期 (YYYY-MM-DD)
 * @param array $items 物料列表
 * @return string Base64编码的入库码
 */
function generateImportCode(string $storeCode, string $ref, string $date, array $items): string {
    // 1. 构造数据对象
    $payload = [
        'v' => 1,
        'store' => $storeCode,
        'ref' => $ref,
        'date' => $date,
        'items' => $items
    ];

    // 2. 计算校验码
    $jsonStr = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    $checksum = substr(hash('sha256', $jsonStr), 0, 8);

    // 3. 添加校验码
    $payload['checksum'] = $checksum;

    // 4. 序列化并 Base64 编码
    $finalJson = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    $importCode = base64_encode($finalJson);

    return $importCode;
}

// 使用示例
$items = [
    ['code' => '01', 'qty' => 10, 'unit' => '1', 'batch' => 'B20260127', 'shelf' => '2026-03-27'],
    ['code' => '02', 'qty' => 5.5, 'unit' => '2'],
    ['code' => '15', 'qty' => 100, 'unit' => '3', 'batch' => 'LOT001']
];

$code = generateImportCode('A1001', 'MRS-2026-001234', '2026-01-27', $items);
echo "入库码: " . $code . "\n";
```

### 7.4 Java

```java
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class ImportCodeGenerator {

    private static final Gson gson = new GsonBuilder()
            .disableHtmlEscaping()
            .create();

    /**
     * 生成 TopTea 入库码
     */
    public static String generateImportCode(String storeCode, String ref, String date,
                                            List<Map<String, Object>> items) throws Exception {
        // 1. 构造数据对象
        Map<String, Object> payload = new java.util.LinkedHashMap<>();
        payload.put("v", 1);
        payload.put("store", storeCode);
        payload.put("ref", ref);
        payload.put("date", date);
        payload.put("items", items);

        // 2. 计算校验码
        String jsonStr = gson.toJson(payload);
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(jsonStr.getBytes(StandardCharsets.UTF_8));
        String hashHex = bytesToHex(hashBytes);
        String checksum = hashHex.substring(0, 8);

        // 3. 添加校验码
        payload.put("checksum", checksum);

        // 4. 序列化并 Base64 编码
        String finalJson = gson.toJson(payload);
        String importCode = Base64.getEncoder().encodeToString(
            finalJson.getBytes(StandardCharsets.UTF_8)
        );

        return importCode;
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
```

### 7.5 C#

```csharp
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

public class ImportCodeGenerator
{
    /// <summary>
    /// 生成 TopTea 入库码
    /// </summary>
    public static string GenerateImportCode(string storeCode, string reference,
                                            string date, List<Dictionary<string, object>> items)
    {
        // 1. 构造数据对象
        var payload = new Dictionary<string, object>
        {
            ["v"] = 1,
            ["store"] = storeCode,
            ["ref"] = reference,
            ["date"] = date,
            ["items"] = items
        };

        // 2. 计算校验码
        var options = new JsonSerializerOptions { WriteIndented = false };
        string jsonStr = JsonSerializer.Serialize(payload, options);
        string checksum = ComputeSha256(jsonStr).Substring(0, 8);

        // 3. 添加校验码
        payload["checksum"] = checksum;

        // 4. 序列化并 Base64 编码
        string finalJson = JsonSerializer.Serialize(payload, options);
        string importCode = Convert.ToBase64String(Encoding.UTF8.GetBytes(finalJson));

        return importCode;
    }

    private static string ComputeSha256(string input)
    {
        using var sha256 = SHA256.Create();
        byte[] hashBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(input));
        return BitConverter.ToString(hashBytes).Replace("-", "").ToLower();
    }
}
```

---

## 8. 验证规则

TopTea 系统在接收入库码时会执行以下验证：

### 8.1 格式验证

| 检查项 | 错误信息 |
|-------|---------|
| Base64 解码失败 | "入库码格式错误：无法解码" |
| JSON 解析失败 | "入库码格式错误：JSON无效" |
| 缺少必填字段 | "入库码格式错误：缺少字段 {字段名}" |

### 8.2 数据验证

| 检查项 | 错误信息 |
|-------|---------|
| 校验码不匹配 | "入库码校验失败：数据可能被篡改" |
| 门店代码不存在 | "入库码错误：门店代码 {code} 不存在" |
| 门店不匹配 (KDS) | "入库码错误：此入库码是给门店 {code} 的，与当前门店不匹配" |
| 物料编码不存在 | "第N项：物料代码 {code} 不存在" |
| 单位编码不存在 | "第N项：单位代码 {code} 不存在" |

### 8.3 业务验证

| 检查项 | 错误信息 |
|-------|---------|
| 重复导入 | "此入库码已于 {时间} 导入过，不能重复使用" |

---

## 9. 最佳实践

### 9.1 入库码生成建议

1. **一单一码**: 每张出货单生成独立的入库码
2. **及时生成**: 发货确认后立即生成，避免数据不一致
3. **安全存储**: 入库码包含库存数据，妥善保管
4. **传输方式**: 可通过短信、邮件、打印二维码等方式发送给门店

### 9.2 编码映射管理

建议 MRS 系统维护一份与 TopTea 系统的编码映射表：

```
MRS物料SKU  →  TopTea物料编码 (material_code)
MRS单位     →  TopTea单位编码 (unit_code)
MRS门店ID   →  TopTea门店代码 (store_code)
```

### 9.3 错误处理

MRS 系统应提供：

1. **入库码预览**: 生成后显示明细供确认
2. **重新生成**: 发现错误可重新生成（注：旧码仍可能被使用一次）
3. **作废机制**: 如需作废已发出的码，需通知门店不要使用

### 9.4 日志记录

建议 MRS 系统记录每次入库码生成：

- 生成时间
- 操作人
- 出货单号
- 目标门店
- 物料明细
- 入库码哈希值（用于追溯）

---

## 10. 测试清单

在正式对接前，请确保通过以下测试：

### 10.1 基础测试

- [ ] 单个物料入库码生成与解析
- [ ] 多个物料入库码生成与解析
- [ ] 校验码验证正确
- [ ] Base64 编码/解码正确

### 10.2 边界测试

- [ ] 物料数量为小数 (如 5.5)
- [ ] 物料数量为整数 (如 10)
- [ ] 可选字段为空的情况
- [ ] 可选字段存在的情况
- [ ] 特殊字符 (中文物料名称不影响编码)

### 10.3 错误测试

- [ ] 错误的门店代码
- [ ] 错误的物料编码
- [ ] 错误的单位编码
- [ ] 篡改后校验失败
- [ ] 重复导入被拒绝

---

## 11. 联调接口

如需实时查询 TopTea 系统的编码信息，可通过以下 API（需授权）：

### 11.1 获取门店列表

```
GET /api/cpsys_api_gateway.php?res=stores&act=get
```

响应示例：
```json
{
  "status": "success",
  "data": [
    {"id": 1, "store_code": "A1001", "store_name": "马德里店"},
    {"id": 2, "store_code": "BCN01", "store_name": "巴塞罗那店"}
  ]
}
```

### 11.2 获取物料列表

```
GET /api/cpsys_api_gateway.php?res=materials&act=get
```

### 11.3 获取单位列表

```
GET /api/cpsys_api_gateway.php?res=units&act=get
```

---

## 12. 版本历史

| 版本 | 日期 | 变更说明 |
|-----|------|---------|
| 1.0 | 2026-01-27 | 初始版本 |

---

## 13. 联系方式

如有技术问题，请联系 TopTea 技术团队。

---

*文档结束*
