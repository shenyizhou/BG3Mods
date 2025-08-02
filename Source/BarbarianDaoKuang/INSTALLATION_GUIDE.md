# 野蛮人刀狂子职业安装指南 (Barbarian DaoKuang Installation Guide)

## 系统要求 (System Requirements)

### 游戏版本 (Game Version)
- **博德之门3**: 版本 4.1.1.x 或更高
- **平台**: Steam, GOG, PlayStation 5, Xbox Series X/S
- **DLC要求**: 无特殊DLC要求

### 模组支持 (Mod Support)
- **模组管理器**: 推荐使用 BG3 Mod Manager
- **Script Extender**: 不需要
- **其他依赖**: 无

## 安装步骤 (Installation Steps)

### 方法一：使用BG3 Mod Manager (推荐)

#### 步骤1：下载模组管理器
1. 访问 [BG3 Mod Manager](https://github.com/LaughingLeader/BG3ModManager) 官方页面
2. 下载最新版本的模组管理器
3. 解压并运行 `BG3ModManager.exe`

#### 步骤2：配置模组管理器
1. 首次运行时，模组管理器会自动检测游戏路径
2. 如果检测失败，手动设置游戏安装路径
3. 确认模组文件夹路径正确

#### 步骤3：安装刀狂模组
1. 下载 `BarbarianDaoKuang.zip` 模组文件
2. 在模组管理器中点击 "Import Mod"
3. 选择下载的模组文件
4. 模组会自动添加到模组列表中

#### 步骤4：启用模组
1. 在模组列表中找到 "Barbarian DaoKuang"
2. 勾选模组旁边的复选框以启用
3. 点击 "Export Order to Game" 应用模组

### 方法二：手动安装

#### 步骤1：定位游戏文件夹
找到博德之门3的模组文件夹：
- **Windows**: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods`
- **Mac**: `~/Library/Application Support/Larian Studios/Baldur's Gate 3/Mods`
- **Linux**: `~/.local/share/larian-studios/baldurs-gate-3/Mods`

#### 步骤2：复制模组文件
1. 解压 `BarbarianDaoKuang.zip`
2. 将 `BarbarianDaoKuang` 文件夹复制到 `Mods` 目录
3. 确保文件结构正确

#### 步骤3：修改配置文件
1. 打开 `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\modsettings.lsx`
2. 在 `<node id="Mods">` 部分添加：
```xml
<node id="ModuleShortDesc">
    <attribute id="Folder" type="LSString" value="BarbarianDaoKuang"/>
    <attribute id="MD5" type="LSString" value=""/>
    <attribute id="Name" type="LSString" value="Barbarian DaoKuang"/>
    <attribute id="UUID" type="FixedString" value="12345678-1234-5678-9abc-123456789abc"/>
    <attribute id="Version64" type="int64" value="36028797018963968"/>
</node>
```

## 验证安装 (Verify Installation)

### 游戏内检查
1. 启动博德之门3
2. 创建新角色
3. 选择野蛮人职业
4. 在子职业选择界面应该能看到 "刀狂" 选项
5. 选择刀狂子职业并继续创建角色

### 功能测试
1. 创建3级野蛮人刀狂角色
2. 进入战斗并使用狂暴
3. 检查是否有 "饮血" 和 "血饮狂刀" 技能
4. 装备刀类武器测试血饮狂刀功能

## 故障排除 (Troubleshooting)

### 常见问题 (Common Issues)

#### 问题1：子职业不显示
**症状**: 创建角色时看不到刀狂子职业选项

**解决方案**:
1. 确认模组已正确安装到Mods文件夹
2. 检查modsettings.lsx文件是否正确修改
3. 重启游戏
4. 尝试创建新的存档

#### 问题2：技能无法使用
**症状**: 技能显示但无法使用或效果不正确

**解决方案**:
1. 确认角色等级达到技能要求
2. 检查技能使用条件（如狂暴状态、武器类型）
3. 验证模组文件完整性
4. 重新安装模组

#### 问题3：游戏崩溃
**症状**: 启用模组后游戏崩溃或无法启动

**解决方案**:
1. 检查游戏版本兼容性
2. 禁用其他模组测试冲突
3. 验证游戏文件完整性
4. 重新安装模组

#### 问题4：本地化问题
**症状**: 技能名称或描述显示为代码

**解决方案**:
1. 确认本地化文件已正确安装
2. 检查游戏语言设置
3. 重新安装模组的本地化文件

### 模组冲突 (Mod Conflicts)

#### 已知兼容模组
- 大部分职业和种族模组
- 武器和装备模组
- 界面优化模组

#### 可能冲突的模组
- 修改野蛮人基础职业的模组
- 大幅修改战斗系统的模组
- 修改狂暴机制的模组

#### 冲突解决
1. 使用模组管理器调整加载顺序
2. 禁用冲突模组进行测试
3. 查看模组说明了解兼容性信息

## 卸载模组 (Uninstalling the Mod)

### 使用模组管理器卸载
1. 在BG3 Mod Manager中找到 "Barbarian DaoKuang"
2. 取消勾选模组
3. 点击 "Export Order to Game"
4. 删除模组文件（可选）

### 手动卸载
1. 从Mods文件夹删除 `BarbarianDaoKuang` 文件夹
2. 从modsettings.lsx中移除相关条目
3. 重启游戏

## 更新模组 (Updating the Mod)

### 自动更新
- 如果使用支持自动更新的模组管理器，会自动检测更新

### 手动更新
1. 下载新版本模组文件
2. 备份当前存档（推荐）
3. 卸载旧版本模组
4. 安装新版本模组
5. 测试功能正常性

## 技术支持 (Technical Support)

### 获取帮助
- **GitHub Issues**: 报告bug和功能请求
- **模组社区**: 参与讨论和获取帮助
- **官方论坛**: 查看最新信息和公告

### 报告问题时请提供
1. 游戏版本信息
2. 模组版本信息
3. 其他已安装的模组列表
4. 详细的问题描述
5. 重现步骤
6. 错误截图或日志文件

---

**注意**: 使用模组可能影响游戏稳定性和成就解锁。建议在使用模组前备份存档文件。

**Note**: Using mods may affect game stability and achievement unlocking. It's recommended to backup save files before using mods.