# 门店检查系统技术文档

> Version: 1.0
> Date: 2026-01-27
> Author: Claude

## 1. 系统概述

门店检查系统用于管理门店的定期检查任务，如消防设备检查、应急灯检查、食品卫生检查等。系统支持周度、月度、年度三种检查周期，店长通过 KDS 系统提交检查照片完成任务。

### 1.1 核心功能

| 功能 | 描述 |
|-----|------|
| 检查模板管理 | 后台配置检查项目、周期、门店范围 |
| 任务自动生成 | 根据周期自动为门店生成检查任务 |
| 照片上传验证 | 拍照/相册上传，自动压缩，EXIF提取 |
| 完成报表 | 按门店/周期查看完成情况 |
| 照片真实性 | 记录拍摄时间、设备、GPS，防篡改哈希 |

### 1.2 用户角色

| 角色 | 系统 | 权限 |
|-----|------|------|
| HQ 管理员 | CPSYS 后台 | 管理检查模板、查看报表 |
| 门店店长 | KDS 门店 | 查看任务、上传照片、完成检查 |
| 门店员工 | KDS 门店 | 无权限（检查清单页面不可见） |

---

## 2. 数据库设计

### 2.1 表结构

```
store_inspection_templates     检查模板表
         │
         ├─────────────────────────────┐
         │                             │
         ▼                             ▼
store_inspection_template_stores   store_inspection_tasks
   (模板-门店关联)                    (检查任务)
                                       │
                                       ▼
                              store_inspection_photos
                                 (检查照片)
```

### 2.2 检查模板表 (store_inspection_templates)

| 字段 | 类型 | 说明 |
|-----|------|------|
| id | INT | 主键 |
| template_code | VARCHAR(50) | 模板代码 (唯一) |
| template_name | VARCHAR(100) | 检查名称 |
| description | TEXT | 检查说明/要求 |
| frequency_type | ENUM | 周期类型: weekly/monthly/yearly |
| due_day | INT | 月度/年度截止日 (1-31) |
| due_weekday | INT | 周度截止日 (1=周一, 7=周日) |
| due_month | INT | 年度截止月 (1-12) |
| photo_hint | VARCHAR(255) | 照片拍摄提示 |
| apply_to_all | TINYINT | 1=全部门店, 0=指定门店 |
| is_active | TINYINT | 是否启用 |

### 2.3 检查任务表 (store_inspection_tasks)

| 字段 | 类型 | 说明 |
|-----|------|------|
| id | INT | 主键 |
| store_id | INT | 门店ID |
| template_id | INT | 模板ID |
| period_key | VARCHAR(10) | 周期标识 (2026-01/2026-W04/2026) |
| period_start | DATE | 周期开始日期 |
| period_end | DATE | 截止日期 |
| status | ENUM | pending/completed |
| completed_at | DATETIME | 完成时间 |
| completed_by | INT | 完成人 (kds_users.id) |
| notes | TEXT | 店长备注 |

### 2.4 检查照片表 (store_inspection_photos)

| 字段 | 类型 | 说明 |
|-----|------|------|
| id | INT | 主键 |
| task_id | INT | 任务ID |
| photo_path | VARCHAR(255) | 照片路径 |
| file_size | INT | 文件大小(字节) |
| file_hash | VARCHAR(64) | SHA256 哈希 |
| taken_at | DATETIME | 拍摄时间 (EXIF) |
| device_make | VARCHAR(100) | 设备厂商 |
| device_model | VARCHAR(100) | 设备型号 |
| latitude | DECIMAL(10,8) | GPS纬度 |
| longitude | DECIMAL(11,8) | GPS经度 |
| uploaded_at | DATETIME | 上传时间 |
| uploaded_by | INT | 上传者ID |
| upload_ip | VARCHAR(45) | 上传者IP |
| validation_flags | JSON | 验证标记 |

---

## 3. 周期计算规则

### 3.1 周期标识 (period_key)

| 周期类型 | 格式 | 示例 |
|---------|------|------|
| weekly | YYYY-Www | 2026-W04 |
| monthly | YYYY-MM | 2026-01 |
| yearly | YYYY | 2026 |

### 3.2 截止日期计算

```php
// 周度: 根据 due_weekday 计算本周截止日
$period_end = 本周一 + (due_weekday - 1) 天

// 月度: 根据 due_day 计算本月截止日
$period_end = 本月 + due_day 天 (不超过当月最后一天)

// 年度: 根据 due_month 和 due_day 计算
$period_end = 本年 + due_month 月 + due_day 天
```

### 3.3 任务自动生成

任务在以下时机自动生成：

1. **店长访问检查清单时** - 调用 `ensureCurrentTasksExist()`
2. **后台手动触发** - 点击"生成当期任务"按钮

---

## 4. 照片处理

### 4.1 前端压缩

```javascript
// 压缩参数
maxWidth: 1920px
maxHeight: 1440px
quality: 0.75 (JPEG 75%)

// 目标大小: 200-400KB
```

### 4.2 EXIF 信息提取

后端从 JPEG 照片提取以下信息：

| 字段 | EXIF 标签 | 用途 |
|-----|----------|------|
| 拍摄时间 | DateTimeOriginal | 验证照片时效 |
| 设备厂商 | Make | 设备识别 |
| 设备型号 | Model | 设备识别 |
| GPS坐标 | GPSLatitude/GPSLongitude | 位置验证 |

### 4.3 验证标记 (validation_flags)

```json
{
    "no_exif": true,        // 无EXIF信息 (可能是截图或编辑过)
    "old_photo": true,      // 照片拍摄时间早于任务周期
    "resolution_low": true, // 分辨率过低 (<800x600)
    "edited_software": true // 检测到编辑软件痕迹
}
```

### 4.4 存储路径

```
/store_images/inspections/
    └── {store_id}/
        └── {year}/
            └── {month}/
                └── task_{task_id}_{timestamp}_{hash}.jpg
```

---

## 5. API 接口

### 5.1 HQ 后台 API

| 资源 | 动作 | 说明 |
|-----|------|------|
| inspection_templates | get | 获取模板列表/详情 |
| inspection_templates | save | 保存模板 |
| inspection_templates | delete | 删除模板 |
| inspection_report | get | 获取报表数据 |
| inspection_report | task_detail | 获取任务详情 |
| inspection_report | generate_tasks | 手动生成任务 |

### 5.2 KDS 门店 API

| 资源 | 动作 | 说明 |
|-----|------|------|
| inspection | get_tasks | 获取检查任务列表 |
| inspection | task_detail | 获取任务详情 |
| inspection | upload_photo | 上传检查照片 |
| inspection | complete_task | 完成检查任务 |

---

## 6. 文件清单

### 6.1 HQ 后台

```
hq/hq_html/
├── html/cpsys/
│   ├── index.php                    # 添加路由
│   ├── api/registries/
│   │   └── cpsys_registry_inspection.php  # API 注册表
│   └── js/
│       ├── inspection_template.js   # 模板管理 JS
│       └── inspection_report.js     # 报表 JS
└── app/views/cpsys/
    ├── layouts/main.php             # 添加菜单
    ├── inspection_template_view.php # 模板管理视图
    └── inspection_report_view.php   # 报表视图
```

### 6.2 KDS 门店

```
store/store_html/
├── html/kds/
│   ├── inspection.php               # 检查清单入口
│   ├── api/registries/
│   │   └── kds_registry.php         # 添加 inspection 资源
│   └── js/
│       └── kds_inspection.js        # 检查清单 JS
└── kds_backend/views/
    └── inspection_view.php          # 检查清单视图
```

### 6.3 数据库

```
Docs/migrations/
└── 2026_01_27_inspection_system.sql # 数据库迁移脚本
```

---

## 7. 部署步骤

### 7.1 数据库迁移

```bash
mysql -u root -p toptea < Docs/migrations/2026_01_27_inspection_system.sql
```

### 7.2 创建照片目录

```bash
mkdir -p store/store_images/inspections
chmod 755 store/store_images/inspections
```

### 7.3 验证

1. 登录 HQ 后台，检查"门店检查"菜单是否显示
2. 创建测试检查模板
3. 登录 KDS (店长账号)，检查检查清单是否显示
4. 上传测试照片，验证压缩和 EXIF 提取

---

## 8. 注意事项

### 8.1 权限控制

- 检查清单仅对 `role='manager'` 的 KDS 用户可见
- HQ 后台需要 `ROLE_ADMIN` 权限

### 8.2 照片存储

- 照片按门店/年/月分目录存储
- 建议定期清理 2 年以上的历史照片

### 8.3 时区处理

- 数据库统一使用 UTC 时间
- 前端显示时转换为本地时区
