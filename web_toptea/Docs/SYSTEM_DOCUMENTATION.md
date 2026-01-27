# TopTea 系统技术文档

> **版本**: 2.0 (后台重构版)
> **最后更新**: 2026-01-27
> **适用范围**: HQ后台管理系统 + KDS门店出品系统

---

## 目录

1. [系统概述](#1-系统概述)
2. [目录结构](#2-目录结构)
3. [数据库架构](#3-数据库架构)
4. [API 设计模式](#4-api-设计模式)
5. [前端架构](#5-前端架构)
6. [命名规范](#6-命名规范)
7. [核心功能模块](#7-核心功能模块)
8. [安全机制](#8-安全机制)
9. [部署与配置](#9-部署与配置)
10. [开发指南](#10-开发指南)
11. [常见问题](#11-常见问题)

---

## 1. 系统概述

### 1.1 系统定位

TopTea 系统是一套为茶饮连锁店设计的后台管理系统，核心功能包括：

| 子系统 | 功能 | 部署位置 |
|-------|------|---------|
| **HQ (CPSYS)** | 配方管理、门店管理、库存管理、用户管理 | 总部服务器 |
| **KDS** | 门店出品指引、效期管理、库存导入 | 门店设备 |

### 1.2 系统版本说明

**2026-01-26 后台重构**后，系统精简为两大模块：

- ✅ **配方管理 (RMS)** - 产品配方、物料、杯型、冰量、甜度等
- ✅ **门店库存管理** - 库存查询、入库码导入、效期追踪

以下模块已**移除**（将使用第三方系统）：
- ❌ POS 销售系统
- ❌ 总仓库存管理
- ❌ 会员系统

### 1.3 技术栈

| 层级 | 技术 |
|-----|------|
| 后端 | PHP 8.x (无框架，原生 PHP) |
| 数据库 | MySQL 8.x |
| 前端 | Bootstrap 5.3 + 原生 JavaScript |
| 打印 | TSPL (热敏标签打印机) |

---

## 2. 目录结构

### 2.1 总体结构

```
web_toptea/
├── Docs/                           # 文档与迁移脚本
│   ├── migrations/                 # 数据库迁移脚本
│   │   └── 2026_01_26_backend_redesign.sql
│   ├── db_schema_structure_only.sql
│   └── SYSTEM_DOCUMENTATION.md     # 本文档
│
├── hq/                             # HQ 后台系统
│   └── hq_html/
│       ├── app/                    # 应用核心
│       │   ├── core/               # API 引擎
│       │   ├── helpers/            # 辅助函数
│       │   └── views/              # 视图模板
│       ├── core/                   # 系统核心 (config, auth)
│       └── html/
│           ├── cpsys/              # 主后台入口
│           │   ├── api/            # API 网关
│           │   │   └── registries/ # API 资源注册表
│           │   ├── css/            # 样式文件
│           │   └── js/             # JavaScript
│           └── smsys/              # 门店管理系统入口 (预留)
│
└── store/                          # 门店系统
    └── store_html/
        ├── html/
        │   └── kds/                # KDS 前端
        │       ├── api/            # KDS API 网关
        │       │   └── registries/ # KDS API 注册表
        │       ├── css/
        │       └── js/
        ├── kds_backend/            # KDS 后端
        │   ├── core/               # 核心配置
        │   ├── helpers/            # 辅助函数
        │   └── views/              # 视图模板
        └── store_images/           # 门店图片资源
            └── kds/                # KDS 物料图片
```

### 2.2 关键文件说明

| 文件路径 | 功能 |
|---------|------|
| `hq/hq_html/core/config.php` | HQ 数据库配置、全局常量 |
| `hq/hq_html/core/auth_core.php` | HQ 登录验证、Session 管理 |
| `hq/hq_html/html/cpsys/index.php` | **HQ 主入口/路由控制器** |
| `hq/hq_html/html/cpsys/api/cpsys_api_gateway.php` | **HQ API 统一网关** |
| `hq/hq_html/app/core/api_core.php` | **通用 API 引擎 (run_api)** |
| `store/store_html/kds_backend/core/config.php` | KDS 数据库配置 |
| `store/store_html/html/kds/api/kds_api_gateway.php` | **KDS API 统一网关** |

---

## 3. 数据库架构

### 3.1 表前缀命名规范

| 前缀 | 含义 | 示例 |
|-----|------|------|
| `cpsys_` | HQ 后台系统表 | `cpsys_users`, `cpsys_roles` |
| `kds_` | KDS/门店相关表 | `kds_products`, `kds_stores`, `kds_materials` |
| `expsys_` | 效期/库存系统表 | `expsys_store_stock` |
| `stock_` | 入库管理表 | `stock_import_logs`, `stock_import_details` |

### 3.2 核心表结构

#### 3.2.1 用户与权限

```sql
-- HQ 用户
cpsys_users (id, username, password_hash, role_id, is_active, ...)
cpsys_roles (id, role_name, role_description)

-- 门店用户
kds_users (id, store_id, username, password_hash, role, is_active, ...)
```

**角色层级** (数字越小权限越高):
| 常量 | 值 | 说明 |
|-----|---|------|
| `ROLE_SUPER_ADMIN` | 1 | 超级管理员 |
| `ROLE_PRODUCT_MANAGER` | 2 | 产品经理 |
| `ROLE_STORE_MANAGER` / `ROLE_ADMIN` | 3 | 门店管理员 |
| `ROLE_STORE_USER` | 4 | 门店员工 |
| `ROLE_USER` | 5 | 普通登录用户 |

#### 3.2.2 配方管理 (RMS)

```sql
-- 产品主表
kds_products (id, product_code, status_id, category_id, is_active, ...)

-- 产品翻译 (多语言)
kds_product_translations (id, product_id, language_code, product_name)

-- 物料字典
kds_materials (id, material_code, material_type, base_unit_id, expiry_rule_type, ...)
kds_material_translations (id, material_id, language_code, material_name)

-- 产品配方 (L1 基础层)
kds_product_recipes (id, product_id, material_id, unit_id, quantity, step_category, ...)

-- 配方动态调整 (L3 产品专属规则)
kds_recipe_adjustments (id, product_id, material_id, cup_id, ice_option_id, sweetness_option_id, quantity, unit_id, ...)

-- 全局调整规则 (L2 跨产品规则)
kds_global_adjustment_rules (id, rule_name, priority, cond_cup_id, cond_ice_id, action_type, action_material_id, action_value, ...)

-- 杯型、冰量、甜度选项
kds_cups (id, cup_code, cup_name, volume_ml, ...)
kds_ice_options (id, ice_code, ...)
kds_ice_option_translations (id, ice_option_id, language_code, ice_option_name)
kds_sweetness_options (id, sweetness_code, ...)
kds_sweetness_option_translations (id, sweetness_option_id, language_code, sweetness_option_name)

-- 产品-选项关联
kds_product_ice_options (product_id, ice_option_id)
kds_product_sweetness_options (product_id, sweetness_option_id)

-- 单位字典
kds_units (id, unit_code, ...)
kds_unit_translations (id, unit_id, language_code, unit_name)
```

#### 3.2.3 门店与库存

```sql
-- 门店信息
kds_stores (id, store_code, store_name, store_city, store_address, is_active, pr_kds_type, pr_kds_ip, pr_kds_port, ...)

-- 门店库存
expsys_store_stock (store_id, material_id, quantity, last_updated_at)
  PRIMARY KEY (store_id, material_id)

-- 入库日志
stock_import_logs (id, store_id, import_code_hash, mrs_reference, shipment_date, items_count, imported_at, import_source, ...)

-- 入库明细
stock_import_details (id, import_log_id, material_id, quantity, unit_id, batch_code, shelf_life_date)
```

#### 3.2.4 效期管理

```sql
-- 物料效期追踪
kds_material_expiries (id, store_id, material_id, batch_code, opened_at, expires_at, status, handler_id, ...)
  status: ENUM('ACTIVE', 'USED', 'DISCARDED')

-- 打印模板
kds_print_templates (id, template_code, template_name, template_type, paper_width, paper_height, template_content, is_active, ...)
```

### 3.3 配方计算层级

配方系统采用**三层覆盖**机制：

```
L1 (基础配方) → L2 (全局规则) → L3 (产品专属调整) → 最终配方
```

| 层级 | 数据源 | 优先级 | 说明 |
|-----|-------|-------|------|
| L1 | `kds_product_recipes` | 最低 | 产品基础配方 |
| L2 | `kds_global_adjustment_rules` | 中 | 跨产品的通用规则 (如糖量公式) |
| L3 | `kds_recipe_adjustments` | 最高 | 单产品特殊覆盖规则 |

**L2 规则动作类型** (`action_type`):
- `SET_VALUE` - 设为固定值
- `ADD_MATERIAL` - 添加物料
- `CONDITIONAL_OFFSET` - 条件偏移
- `MULTIPLY_BASE` - 乘以基础值

### 3.4 多语言设计

系统采用**翻译表分离**模式：

```
主表 (kds_materials)  ←→  翻译表 (kds_material_translations)
     id                     material_id + language_code + material_name
```

**支持的语言代码**:
- `zh-CN` - 中文
- `es-ES` - 西班牙语

### 3.5 软删除机制

所有核心业务表使用软删除：

```sql
deleted_at DATETIME(6) DEFAULT NULL
```

- `deleted_at IS NULL` → 记录有效
- `deleted_at IS NOT NULL` → 记录已删除

### 3.6 时间戳规范

所有表统一使用 UTC 时间 + 微秒精度：

```sql
created_at DATETIME(6) NOT NULL DEFAULT (utc_timestamp(6))
updated_at DATETIME(6) NOT NULL DEFAULT (utc_timestamp(6)) ON UPDATE CURRENT_TIMESTAMP(6)
```

---

## 4. API 设计模式

### 4.1 注册表驱动架构

系统采用**资源注册表 (Registry)** 模式统一管理 API：

```
请求 → API 网关 (Gateway) → 注册表 (Registry) → 处理函数 (Handler)
```

#### 4.1.1 网关入口

```php
// hq/hq_html/html/cpsys/api/cpsys_api_gateway.php

// 1. 加载配置
require_once realpath(__DIR__ . '/../../../core/config.php');

// 2. 加载注册表
$registry_base = require_once __DIR__ . '/registries/cpsys_registry_base.php';
$registry_rms = require_once __DIR__ . '/registries/cpsys_registry_rms.php';
$registry_stock = require_once __DIR__ . '/registries/cpsys_registry_stock.php';
// ...

// 3. 合并注册表
$full_registry = array_merge($registry_base, $registry_rms, $registry_stock, ...);

// 4. 运行引擎
run_api($full_registry, $pdo);
```

#### 4.1.2 注册表结构

```php
// 示例: cpsys_registry_stock.php

return [
    'store_stock' => [
        'table' => 'expsys_store_stock',      // 关联表名
        'pk' => null,                          // 主键 (null = 复合主键)
        'auth_role' => ROLE_ADMIN,            // 所需权限
        'custom_actions' => [                  // 自定义动作
            'get' => 'handle_store_stock_get',
            'adjust' => 'handle_store_stock_adjust',
        ],
    ],

    'import_code' => [
        'table' => 'stock_import_logs',
        'auth_role' => ROLE_ADMIN,
        'custom_actions' => [
            'parse' => 'handle_import_code_parse',
            'execute' => 'handle_import_code_execute',
        ],
    ],
];
```

### 4.2 API 调用规范

#### 4.2.1 URL 格式

```
[网关路径]?res=[资源名]&act=[动作名]&[其他参数]
```

**示例**:
```
GET  /api/cpsys_api_gateway.php?res=materials&act=get
GET  /api/cpsys_api_gateway.php?res=materials&act=get&id=123
POST /api/cpsys_api_gateway.php?res=materials&act=save
POST /api/cpsys_api_gateway.php?res=materials&act=delete
POST /api/cpsys_api_gateway.php?res=import_code&act=parse
```

#### 4.2.2 标准动作

| 动作 | HTTP 方法 | 说明 |
|-----|----------|------|
| `get` | GET | 获取列表或单条 (带 `id` 参数) |
| `save` | POST | 新增或更新 (带 `id` 则更新) |
| `delete` | POST | 删除 |

#### 4.2.3 请求/响应格式

**请求体** (POST):
```json
{
  "data": {
    "id": 123,
    "material_code": "001",
    "material_name": "茶叶"
  }
}
```

**成功响应**:
```json
{
  "status": "success",
  "message": "操作成功",
  "data": { ... }
}
```

**错误响应**:
```json
{
  "status": "error",
  "message": "错误信息",
  "code": 400
}
```

### 4.3 注册表配置项

| 配置项 | 类型 | 说明 |
|-------|-----|------|
| `table` | string | 数据库表名 |
| `pk` | string | 主键字段名 (默认 `id`) |
| `auth_role` | int | 所需角色常量 |
| `soft_delete_col` | string | 软删除字段 (默认 `deleted_at`) |
| `visible_cols` | array | GET 返回的字段列表 |
| `writable_cols` | array | SAVE 允许写入的字段 |
| `default_order` | string | 默认排序 |
| `custom_actions` | array | 自定义动作映射 |
| `hooks` | array | 生命周期钩子 |

### 4.4 自定义处理函数

```php
/**
 * 处理函数签名
 * @param PDO $pdo 数据库连接
 * @param array $config 当前资源的注册配置
 * @param array $input_data 请求数据 (包含 'data' 键)
 */
function handle_custom_action(PDO $pdo, array $config, array $input_data): void {
    // 业务逻辑...

    // 成功返回
    json_ok(['id' => $id], '操作成功');

    // 或错误返回
    json_error('错误信息', 400);
}
```

---

## 5. 前端架构

### 5.1 页面路由

HQ 后台采用**单入口 + 查询参数**路由：

```
index.php?page=[页面名]
```

路由在 `index.php` 中通过 `switch` 语句处理：

```php
switch ($page) {
    case 'dashboard':
        check_role(ROLE_USER);
        $page_title = '仪表盘';
        $view_path = '.../dashboard_view.php';
        break;

    case 'material_management':
        check_role(ROLE_PRODUCT_MANAGER);
        $page_title = '物料管理';
        $js_files[] = 'material_management.js';
        $data['materials'] = getAllMaterials($pdo);
        $view_path = '.../material_management_view.php';
        break;
    // ...
}
```

### 5.2 视图模板结构

```php
// 布局模板: app/views/cpsys/layouts/main.php
<!DOCTYPE html>
<html>
<head>
    <title><?= $page_title ?></title>
    <!-- Bootstrap 5, Bootstrap Icons, Chart.js -->
</head>
<body>
    <nav class="sidebar"><!-- 导航菜单 --></nav>
    <main>
        <?php include $view_path; ?>  <!-- 内容区域 -->
    </main>
    <?php if ($page_js): ?>
        <script src="js/<?= $page_js ?>"></script>
    <?php endif; ?>
</body>
</html>
```

### 5.3 JavaScript 模式

每个功能页面对应一个 JS 文件，遵循以下模式：

```javascript
// 示例: material_management.js

// 1. 常量定义
const API_URL = 'api/cpsys_api_gateway.php';

// 2. DOM 加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    initTable();
    bindEvents();
});

// 3. 数据加载
async function loadData() {
    const response = await fetch(`${API_URL}?res=materials&act=get`);
    const result = await response.json();
    if (result.status === 'success') {
        renderTable(result.data);
    }
}

// 4. 表单提交
async function saveItem(data) {
    const response = await fetch(`${API_URL}?res=materials&act=save`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ data })
    });
    // ...
}

// 5. 删除操作
async function deleteItem(id) {
    if (!confirm('确认删除?')) return;
    const response = await fetch(`${API_URL}?res=materials&act=delete`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
    });
    // ...
}
```

### 5.4 KDS 多语言支持

KDS 系统支持运行时语言切换：

```javascript
// kds_state.js
var KDS_STATE = {
    lang: 'zh-CN',  // 或 'es-ES'
    templates: {}
};

// 语言切换
localStorage.setItem('kds_lang', 'es-ES');
KDS_STATE.lang = 'es-ES';

// 获取翻译
function pick(zh, es) {
    return KDS_STATE.lang === 'es-ES' ? (es || zh) : zh;
}
```

---

## 6. 命名规范

### 6.1 数据库命名

| 类型 | 规范 | 示例 |
|-----|------|------|
| 表名 | `[前缀]_[实体]_[描述]` (snake_case) | `kds_product_translations` |
| 列名 | `[描述]_[类型]` (snake_case) | `store_id`, `created_at`, `is_active` |
| 外键列 | `[关联表单数]_id` | `material_id`, `store_id` |
| 布尔列 | `is_[状态]` | `is_active`, `is_deleted_flag` |
| 时间列 | `[动作]_at` | `created_at`, `opened_at`, `expires_at` |
| 枚举列 | `[名词]` | `status`, `action_type`, `material_type` |

### 6.2 代码规范

| 类型 | 规范 | 示例 |
|-----|------|------|
| PHP 文件 | snake_case | `cpsys_registry_stock.php` |
| PHP 函数 | snake_case | `handle_store_stock_get()` |
| PHP 常量 | UPPER_SNAKE_CASE | `ROLE_SUPER_ADMIN` |
| JS 文件 | snake_case | `material_management.js` |
| JS 函数 | camelCase | `loadMaterials()`, `saveItem()` |
| CSS 类 | kebab-case / BEM | `.kds-cup-number`, `.nav-link` |

### 6.3 API 命名

| 类型 | 规范 | 示例 |
|-----|------|------|
| 资源名 | snake_case (复数) | `materials`, `store_stock` |
| 动作名 | snake_case (动词) | `get`, `save`, `delete`, `parse`, `execute` |
| 处理函数 | `handle_[资源]_[动作]` | `handle_import_code_parse` |

### 6.4 编码规范 (自定义短码)

系统使用短数字编码标识字典项：

| 实体 | 字段 | 位数 | 示例 |
|-----|------|-----|------|
| 杯型 | `cup_code` | 1-2 | 1=中杯, 2=大杯 |
| 冰量 | `ice_code` | 1-2 | 0=去冰, 1=少冰, 2=正常 |
| 甜度 | `sweetness_code` | 1-2 | 0=无糖, 5=半糖, 10=全糖 |
| 物料 | `material_code` | 2-3 | 01=红茶, 02=绿茶 |
| 单位 | `unit_code` | 1-2 | 1=ml, 2=g |

---

## 7. 核心功能模块

### 7.1 入库码系统

#### 7.1.1 入库码格式

入库码为 **Base64 编码的 JSON**，由 MRS (物料管理系统) 生成：

```json
{
  "v": 1,                           // 版本号
  "store": "A1001",                 // 门店代码
  "ref": "MRS-2026-001234",         // MRS出货单号
  "date": "2026-01-27",             // 出货日期
  "items": [
    {
      "code": "01",                 // 物料编码
      "qty": 10,                    // 数量
      "unit": "1",                  // 单位编码
      "batch": "B20260127",         // 批次号 (可选)
      "shelf": "2026-03-27"         // 未开封保质期 (可选)
    }
  ],
  "checksum": "a1b2c3d4"            // SHA256校验码前8位
}
```

**校验码计算**:
```php
$checksum_data = $payload;
unset($checksum_data['checksum']);
$checksum = substr(hash('sha256', json_encode($checksum_data)), 0, 8);
```

#### 7.1.2 入库流程

```
1. 员工在 KDS/HQ 输入入库码
2. 系统 Base64 解码 + JSON 解析
3. 验证校验码、门店匹配
4. 检查是否重复导入 (hash 唯一)
5. 解析物料明细，验证物料/单位存在
6. 预览确认后执行入库
7. 更新 expsys_store_stock 库存
8. 记录 stock_import_logs/details 日志
```

### 7.2 效期管理系统

#### 7.2.1 效期规则

物料定义效期规则：

```sql
expiry_rule_type: ENUM('HOURS', 'DAYS', 'END_OF_DAY')
expiry_duration: INT  -- 规则为 HOURS/DAYS 时的数值
```

| 规则类型 | 说明 | 示例 |
|---------|------|------|
| `HOURS` | 开封后 N 小时过期 | 开封后4小时 |
| `DAYS` | 开封后 N 天过期 | 开封后7天 |
| `END_OF_DAY` | 当日营业结束过期 | 每日制备 |

#### 7.2.2 效期追踪流程

```
1. 员工在 KDS "物料制备" 页面点击 "开封"
2. 系统记录 kds_material_expiries (opened_at, expires_at)
3. 自动打印效期标签 (TSPL 打印机)
4. 效期列表显示倒计时，临近过期高亮提醒
5. 员工处理后更新状态 (USED/DISCARDED)
```

### 7.3 SOP 配方查询

#### 7.3.1 查询码格式

KDS 支持多种查询码格式，通过 `kds_sop_query_rules` 配置：

```json
// DELIMITER 类型配置
{
  "delimiter": "-",
  "segments": ["p", "a", "m", "t"],
  "prefix_skip": 0
}
```

**P-A-M-T 段含义**:
- `P` - Product Code (产品编码)
- `A` - Attribute/Cup (杯型编码)
- `M` - Modification/Ice (冰量编码)
- `T` - Taste/Sweetness (甜度编码)

**示例**: `101-2-1-5` = 产品101, 大杯, 少冰, 半糖

#### 7.3.2 配方计算流程

```
1. 解析查询码 → 获取 (product_id, cup_id, ice_id, sweet_id)
2. 加载 L1 基础配方 (kds_product_recipes)
3. 应用 L2 全局规则 (kds_global_adjustment_rules)
4. 应用 L3 产品调整 (kds_recipe_adjustments)
5. 返回最终配方 + 选项名称
```

### 7.4 打印系统

#### 7.4.1 TSPL 模板格式

```json
{
  "commands": [
    {"type": "text", "x": 10, "y": 10, "font": 2, "content": "{{material_name}}"},
    {"type": "divider", "x": 0, "y": 35, "width": 300},
    {"type": "kv", "x": 10, "y": 45, "font": 1, "label": "开封:", "value": "{{opened_at_time}}"},
    {"type": "kv", "x": 10, "y": 70, "font": 1, "label": "过期:", "value": "{{expires_at_time}}"}
  ],
  "copies": 1
}
```

**模板变量**:
| 变量 | 说明 |
|-----|------|
| `{{material_name}}` | 物料名称 |
| `{{opened_at_time}}` | 开封时间 |
| `{{expires_at_time}}` | 过期时间 |
| `{{time_left}}` | 剩余时间 |
| `{{handler_name}}` | 操作员 |

---

## 8. 安全机制

### 8.1 身份验证

#### 8.1.1 HQ 登录

```php
// core/auth_core.php
session_start();
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}
```

**Session 变量**:
| 变量 | 说明 |
|-----|------|
| `$_SESSION['user_id']` | 用户 ID |
| `$_SESSION['username']` | 用户名 |
| `$_SESSION['role_id']` | 角色 ID |

#### 8.1.2 KDS 登录

```php
// kds_backend/core/kds_auth_core.php
$_SESSION['kds_user_id']
$_SESSION['kds_store_id']
$_SESSION['kds_role']  // 'staff' 或 'manager'
```

### 8.2 权限检查

```php
// 页面级别
check_role(ROLE_PRODUCT_MANAGER);  // 抛出 AuthException

// API 级别 (注册表配置)
'auth_role' => ROLE_ADMIN
```

### 8.3 SQL 注入防护

```php
// 1. 使用预处理语句
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$id]);

// 2. 验证 SQL 标识符
function validate_sql_identifier(string $str): bool {
    return preg_match('/^[a-zA-Z0-9_., ()`]+$/', $str) === 1
        && !preg_match('/(;|--|\/\*|union|select|insert|delete|drop)/i', $str);
}
```

### 8.4 XSS 防护

```php
// 输出转义
htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
```

### 8.5 CSRF 防护

建议在表单中添加 CSRF Token (当前系统未完全实现)。

---

## 9. 部署与配置

### 9.1 环境要求

| 组件 | 要求 |
|-----|------|
| PHP | >= 8.0 (推荐 8.1+) |
| MySQL | >= 8.0 |
| Web Server | Apache / Nginx |
| PHP 扩展 | pdo_mysql, json, mbstring |

### 9.2 数据库配置

```php
// hq/hq_html/core/config.php
define('DB_HOST', 'your_db_host');
define('DB_NAME', 'your_db_name');
define('DB_USER', 'your_db_user');
define('DB_PASS', 'your_db_pass');

$pdo = new PDO(
    "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
    DB_USER, DB_PASS,
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
);
```

### 9.3 目录权限

```bash
# 确保 Web 用户有写入权限
chmod 755 web_toptea/store/store_html/store_images/kds/
chmod 755 web_toptea/hq/hq_html/html/smsys/uploads/
```

### 9.4 数据库迁移

```bash
# 执行迁移脚本
mysql -u user -p database < Docs/migrations/2026_01_26_backend_redesign.sql
```

---

## 10. 开发指南

### 10.1 添加新 API 资源

1. **创建注册表文件** (如果是新模块):
   ```php
   // cpsys_registry_[module].php
   return [
       'new_resource' => [
           'table' => 'table_name',
           'pk' => 'id',
           'auth_role' => ROLE_ADMIN,
           'visible_cols' => ['id', 'name', 'created_at'],
           'writable_cols' => ['name'],
           'soft_delete_col' => 'deleted_at',
       ],
   ];
   ```

2. **在网关中加载**:
   ```php
   // cpsys_api_gateway.php
   $registry_new = require_once __DIR__ . '/registries/cpsys_registry_new.php';
   $full_registry = array_merge(..., $registry_new);
   ```

3. **添加自定义动作** (如果需要):
   ```php
   'custom_actions' => [
       'special_action' => 'handle_new_resource_special',
   ],

   function handle_new_resource_special(PDO $pdo, array $config, array $input_data): void {
       // 实现逻辑
       json_ok($data, '成功');
   }
   ```

### 10.2 添加新页面

1. **创建视图文件**:
   ```
   app/views/cpsys/new_page_view.php
   ```

2. **创建 JS 文件**:
   ```
   html/cpsys/js/new_page.js
   ```

3. **在 index.php 添加路由**:
   ```php
   case 'new_page':
       check_role(ROLE_ADMIN);
       $page_title = '新页面';
       $js_files[] = 'new_page.js';
       $data['items'] = getItems($pdo);
       $view_path = realpath(__DIR__ . '/../../app/views/cpsys/new_page_view.php');
       break;
   ```

4. **在 main.php 添加菜单**:
   ```php
   <li class="nav-item">
       <a class="nav-link" href="index.php?page=new_page">新页面</a>
   </li>
   ```

### 10.3 添加新数据库表

1. **创建迁移脚本**:
   ```sql
   -- Docs/migrations/YYYY_MM_DD_description.sql
   CREATE TABLE IF NOT EXISTS `prefix_new_table` (
       `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
       `name` VARCHAR(100) NOT NULL,
       `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
       `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
       `deleted_at` DATETIME(6) DEFAULT NULL,
       PRIMARY KEY (`id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
   ```

2. **更新 db_schema_structure_only.sql** (完整 schema 备份)

### 10.4 KDS 开发注意事项

1. **多语言**: 所有用户可见文本需支持 `zh-CN` 和 `es-ES`
2. **离线友好**: 减少对网络的依赖，关键数据可缓存
3. **触摸优化**: 按钮足够大，间距合理
4. **打印集成**: 测试 TSPL 模板在不同打印机的兼容性

---

## 11. 常见问题

### Q1: API 返回 "资源未定义"

**原因**: 请求的 `res` 参数在注册表中不存在

**排查**:
1. 检查 URL 中的 `res` 参数拼写
2. 确认注册表文件已在 gateway 中加载
3. 确认 `return [...]` 包含了该资源

### Q2: 权限不足 (403)

**原因**: 当前用户角色 ID > 资源要求的 `auth_role`

**排查**:
1. 检查 `$_SESSION['role_id']` 值
2. 检查资源配置的 `auth_role` 值
3. 角色层级: 1 > 2 > 3 > 4 > 5

### Q3: 配方计算结果不正确

**排查顺序**:
1. 检查 L1 基础配方 (`kds_product_recipes`)
2. 检查 L2 全局规则优先级 (`priority` 字段)
3. 检查 L3 产品调整的条件匹配
4. 使用 KDS 的调试模式查看中间结果

### Q4: 打印机不工作

**排查**:
1. 检查 `kds_stores` 表的 `pr_kds_*` 字段配置
2. 确认打印机 IP/端口可达 (`ping`, `telnet`)
3. 检查 `kds_print_templates` 模板内容格式
4. 查看浏览器控制台的 `KDS_PRINT_BRIDGE` 日志

### Q5: 入库码导入失败

**常见错误**:
- "无法解码" → Base64 格式错误
- "JSON无效" → JSON 语法错误
- "校验失败" → 数据被篡改或校验码计算错误
- "已导入过" → 同一码重复使用
- "门店不匹配" → 码中的 store 与当前登录门店不同

---

## 附录

### A. 角色常量定义

```php
define('ROLE_SUPER_ADMIN', 1);
define('ROLE_PRODUCT_MANAGER', 2);
define('ROLE_STORE_MANAGER', 3);
define('ROLE_ADMIN', 3);  // 别名
define('ROLE_STORE_USER', 4);
define('ROLE_USER', 5);
```

### B. HTTP 响应码

| 码 | 含义 | 使用场景 |
|---|------|---------|
| 200 | OK | 成功 |
| 400 | Bad Request | 参数错误 |
| 401 | Unauthorized | 未登录 |
| 403 | Forbidden | 权限不足 |
| 404 | Not Found | 资源不存在 |
| 409 | Conflict | 唯一约束冲突 |
| 500 | Server Error | 服务器内部错误 |

### C. 文件命名示例

| 类型 | 命名格式 | 示例 |
|-----|---------|------|
| API 注册表 | `cpsys_registry_[模块].php` | `cpsys_registry_stock.php` |
| 视图文件 | `[功能]_view.php` | `material_management_view.php` |
| JS 文件 | `[功能].js` | `material_management.js` |
| 处理函数 | `handle_[资源]_[动作]` | `handle_import_code_parse` |
| 辅助函数 | `[动作][实体]` | `getAllMaterials`, `getStoreById` |

---

*文档结束*
