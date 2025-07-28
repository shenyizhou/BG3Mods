# KungFuMonk 武僧版本安装指南

## 概述
这是从原始 KungFuCleric（牧师武功领域）转换而来的武僧版本。该版本将原有的牧师职业转换为武僧职业，使用气点系统替代优势骰系统。

## 主要变化

### 核心职业转换
- **基础职业**: 从牧师 (Cleric) 转换为武僧 (Monk)
- **资源系统**: 从优势骰 (Superiority Die) 转换为气点 (Ki Point)
- **主要属性**: 从感知 (Wisdom) 保持为感知 (Wisdom)
- **施法能力**: 移除了必须准备法术的要求

### 等级进度重构
- **1级**: 无甲防御 (Unarmored Defense)
- **2级**: 无甲移动 (Unarmored Movement)
- **3级**: 偏斜飞弹 (Deflect Missiles)
- **4级**: 缓落 (Slow Fall)
- **5级**: 额外攻击 (Extra Attack)
- **6级**: 气劲打击 (Ki-Empowered Strikes)
- **7级**: 闪避 (Evasion)
- **8级**: 心如止水 (Stillness of Mind)
- **9级**: 改进无甲移动 (Improved Unarmored Movement)
- **10级**: 纯净之体 (Purity of Body)
- **13级**: 日月之语 (Tongue of the Sun and Moon)
- **14级**: 钻石魂魄 (Diamond Soul)
- **15级**: 不老之体 (Timeless Body)
- **18级**: 空灵之体 (Empty Body)
- **20级**: 完美自我 (Perfect Self)

### 武功门派系统
保留了原有的七大武功门派：
1. **医药** (YiYao) - 医疗和恢复技能
2. **硬功** (YingGong) - 防御和抗性技能
3. **软功** (RuanGong) - 灵活性和适应性技能
4. **轻功** (QingGong) - 移动和敏捷技能
5. **内功** (NeiGong) - 内在力量和精神技能
6. **外功** (WaiGong) - 外在力量和攻击技能
7. **拆招** (ChaiZhao) - 反击和破解技能

## 安装步骤

1. **备份原版本**（如果需要保留）
   ```
   将原始 KungFuCleric 文件夹重命名或移动到其他位置
   ```

2. **安装武僧版本**
   ```
   将 KungFuMonk_Version 文件夹内容复制到 BG3 模组目录
   ```

3. **模组目录结构**
   ```
   YourBG3ModsFolder/
   ├── Mods/KungFuCleric/meta.lsx
   ├── Public/KungFuCleric/
   ├── Localization/Chinese/
   └── Scripts/thoth/
   ```

## 文件修改清单

### 核心配置文件
- `meta.lsx` - 模组元数据，更新为武僧版本
- `ClassDescriptions.lsx` - 职业描述，从牧师改为武僧
- `Progressions.lsx` - 等级进度，完全重构为武僧进度
- `ProgressionDescriptions.lsx` - 进度描述更新

### 法术和被动技能
- `SpellLists.lsx` - 法术列表，适配武僧技能
- `PassiveLists.lsx` - 被动技能列表保持不变
- `Stats/Generated/Data/` - 所有武功数据文件

### 本地化文件
- `Chinese_KungFuCleric.xml` - 中文本地化，更新为武僧术语
- `Chinese_KungFuCleric.loca` - 本地化资源文件

### 脚本文件
- `KungFuMonk.khn` - Lua脚本，更新气点系统注释

## 兼容性说明

- **游戏版本**: 适用于博德之门3最新版本
- **其他模组**: 与大多数模组兼容，但可能与其他职业模组冲突
- **存档兼容**: 建议在新游戏中使用，现有存档可能需要重新创建角色

## 已知问题

- 某些武僧特有技能可能需要额外的被动技能定义
- 气点系统的平衡性可能需要进一步调整
- 部分UI文本可能仍显示为牧师相关内容

## 技术支持

如遇到问题，请检查：
1. 模组文件是否完整复制
2. 游戏版本是否兼容
3. 是否与其他模组冲突

## 更新日志

详细的更新内容请参考 `MONK_VERSION_CHANGELOG.md` 文件。

---

**作者**: 沈浪  
**版本**: 1.0.0  
**更新日期**: 2024年12月  
**模组类型**: 职业子类模组（武僧版本）