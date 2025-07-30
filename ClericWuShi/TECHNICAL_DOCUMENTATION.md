# 武师牧师模组技术文档

## 模组架构概述

武师牧师模组是一个完整的博德之门3牧师子职业扩展，包含以下核心组件：

### 文件结构

```
ClericWuShi/
├── Mods/ClericWuShi/meta.lsx          # 模组元数据
├── Public/ClericWuShi/                 # 游戏数据文件
│   ├── ClassDescriptions/             # 职业描述
│   ├── Lists/                         # 法术列表
│   ├── Progressions/                  # 等级进展
│   └── Stats/Generated/Data/          # 技能数据
├── Localization/                      # 本地化文件
│   ├── Chinese/                       # 中文本地化
│   └── English/                       # 英文本地化
└── Documentation/                     # 文档文件
```

## 核心技术实现

### 1. 职业系统集成

#### ClassDescriptions.lsx
- **ParentGuid**: `114e7aee-d1d4-4371-8d90-8a2080592faf` (牧师基类)
- **UUID**: `b2c3d4e5-f6a7-8901-bcde-f23456789012` (武师子职业唯一标识)
- **ProgressionTableUUID**: `a1b2c3d4-e5f6-7890-abcd-ef1234567890` (进展表引用)

#### Progressions.lsx
武师子职业的等级进展定义：
- **1级**: 重甲熟练度
- **3级**: 金钟罩技能
- **5级**: 铁布衫被动
- **7级**: 金钟罩强化
- **10级**: 金刚不坏神功

### 2. 技能系统实现

#### 金钟罩 (Golden Bell Shield)
```
SpellType: Target
Level: 1
TargetRadius: 9
AreaRadius: 9
UseCosts: ActionPoint:1;SpellSlot:1:1
SpellSuccess: ApplyStatus(WuShi_JinZhongZhao_Status,100,600)
```

**状态效果**:
- `Resistance(All,Resistant)` - 全伤害抗性
- 持续时间: 600回合
- 视觉效果: `VFX_Status_Shield_01`

#### 铁布衫 (Iron Cloth Shirt)
```
type: PassiveData
Boosts: Resistance(Piercing,Resistant);Resistance(Slashing,Resistant);
        Resistance(Bludgeoning,Resistant);Resistance(Force,Resistant);
        StatusImmunity(SG_Incapacitated);StatusImmunity(DOWNED)
StatsFunctors: IF(Incoming_Damage_Would_Kill()):ApplyStatus(SELF,WuShi_TieBuShan_DeathSave,100,1)
```

**防死机制**:
- 检测致命伤害: `Incoming_Damage_Would_Kill()`
- 应用防死状态: `MinimumHitPoints(1)`
- 触发后移除铁布衫效果

#### 金刚不坏神功 (WuShi_JinGangBuHuai_New)
```
SpellType: Target
Level: 2
TargetRadius: 9
AreaRadius: 9
UseCosts: ActionPoint:1;SpellSlot:2:1
SpellSuccess: ApplyStatus(WuShi_JinGangBuHuai_Status,100,600)
```

**状态效果**:
- `Resistance(All,Resistant)` - 全伤害抗性
- `IncreaseMaxHP(2d10)` - 最大生命值增加
- `OnTurn: Heal(2d10)` - 每回合恢复生命值

#### 不灭金身 (WuShi_BuMieJinShen)
```
SpellType: Target
Level: 5
TargetConditions: Self() and HPPercentageLT(50)
UseCosts: ReactionActionPoint:1
SpellFlags: IsReaction
RechargeValues: ShortRest
SpellSuccess: ApplyStatus(WuShi_BuMieJinShen_Status,100,10);Heal(MaxHP())
```

**状态效果**:
- `DamageBonus(ConstitutionModifier,Melee)` - 近战伤害加值
- `DamageBonus(ConstitutionModifier,Force)` - 力场伤害加值
- `StatusImmunity(CONCENTRATING)` - 无法专注
- `BlockSpellCast()` - 阻止施法
- `OnRemoveFunctors: ApplyStatus(SELF,SG_Exhausted,100,-1)` - 结束后力竭

### 3. 平衡性设计

#### 资源消耗
- **金钟罩**: 1级法术位 + 1行动点
- **铁布衫**: 无消耗（被动）
- **金钟罩强化**: 无消耗（被动）
- **金刚不坏神功**: 1反应点，短休限制

#### 限制机制
- **金钟罩**: 需要法术位，有施法时间
- **铁布衫**: 防死效果触发后结束
- **金刚不坏神功**: 50%血量触发条件，结束后力竭

### 4. 本地化系统

#### 翻译键值映射
```
技能名称: h[16位十六进制]g[4位]g[4位]g[4位]g[12位]
技能描述: h[16位十六进制]g[4位]g[4位]g[4位]g[12位]
```

#### 支持语言
- 简体中文 (Chinese)
- 英语 (English)

### 5. UUID管理

所有UUID都经过精心设计，避免与原版和其他模组冲突：

```
武师子职业: b2c3d4e5-f6a7-8901-bcde-f23456789012
进展表: a1b2c3d4-e5f6-7890-abcd-ef1234567890
金钟罩法术: d4e5f6a7-b8c9-0123-def4-56789012345a
金刚不坏神功: b8c9d0e1-f2a3-4567-b890-123456789cde
```

## 扩展性设计

### 添加新技能
1. 在 `Spell_WuShi.txt` 中定义新技能
2. 在 `Progressions.lsx` 中添加等级进展
3. 在本地化文件中添加翻译
4. 更新 `SpellLists.lsx` 如需要

### 修改现有技能
1. 修改对应的 `.txt` 文件中的数据
2. 更新本地化描述
3. 测试平衡性

### 兼容性考虑
- 使用独特的命名空间前缀 `WuShi_`
- 避免修改原版文件
- 使用标准的博德之门3模组API

## 调试和测试

### 常用调试命令
```
// 添加技能
AddSpell(WuShi_JinZhongZhao)

// 应用状态
ApplyStatus(WuShi_JinZhongZhao_Status,100,600)

// 检查状态
HasStatus('WuShi_JinZhongZhao_Status')
```

### 测试检查清单
- [ ] 职业选择界面显示正确
- [ ] 各等级技能正常获得
- [ ] 技能效果符合预期
- [ ] 本地化文本正确显示
- [ ] 无错误日志输出
- [ ] 与其他模组兼容性测试

## 性能优化

### 状态检查优化
- 使用条件判断减少不必要的计算
- 合理设置状态优先级
- 避免过于频繁的状态更新

### 内存使用
- 及时清理临时状态
- 使用合适的状态持续时间
- 避免状态堆叠冲突

## 版本控制

### 版本号规则
- 主版本.次版本.修订版本
- 主版本: 重大功能变更
- 次版本: 新增功能或重要修改
- 修订版本: 错误修复和小幅调整

### 更新策略
- 向后兼容性保证
- 渐进式功能发布
- 充分的测试周期

---

**开发者注意**: 修改任何核心文件前请备份，并在测试环境中验证所有更改。