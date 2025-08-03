# 野蛮人刀狂子职业技术文档 (Barbarian DaoKuang Technical Documentation)

## 模组结构 (Mod Structure)

### 文件组织 (File Organization)
```
BarbarianDaoKuang/
├── README.md                           # 主说明文档
├── TECHNICAL_DOCUMENTATION.md          # 技术文档
├── Mods/BarbarianDaoKuang/
│   └── meta.lsx                        # 模组元数据
├── Public/BarbarianDaoKuang/
│   ├── meta.lsx                        # 公共模组元数据
│   ├── ClassDescriptions/
│   │   └── ClassDescriptions.lsx      # 子职业定义
│   ├── Progressions/
│   │   └── Progressions.lsx           # 进阶系统配置
│   └── Stats/Generated/Data/
│       ├── Spell_DaoKuang.txt          # 主要技能定义
│       ├── Spell_DaoKuang_Extra.txt    # 额外技能定义
│       ├── Status_DaoKuang.txt         # 状态效果定义
│       └── Passive_DaoKuang.txt        # 被动能力定义
└── Localization/
    ├── Chinese/BarbarianDaoKuang.loca  # 中文本地化
    └── English/BarbarianDaoKuang.loca  # 英文本地化
```

## 核心系统设计 (Core System Design)

### 1. 饮血系统 (Blood Drinking System)

#### 机制设计 (Mechanism Design)
- **触发条件**: 必须在狂暴状态下使用
- **生命值消耗**: 固定消耗当前生命值的50%
- **吸血效果**: 基于等级的治疗量，生命值越低效果越强
- **状态持续**: 直到狂暴结束

#### 技术实现 (Technical Implementation)
```
// 饮血技能核心逻辑
data "SpellSuccess" "ApplyStatus(DAOKUANG_BLOOD_DRINKING,100,10);DealDamage(MainMeleeWeapon,Necrotic,LevelMapValue(DaoKuang_BloodCost));IF(HasStatus('SG_Rage')):ApplyStatus(DAOKUANG_FURY_STACK,100,10)"
data "Requirements" "HasStatus('SG_Rage')"
```

### 2. 怒火层数系统 (Fury Stack System)

#### 层数机制 (Stack Mechanism)
- **最大层数**: 7层
- **获得条件**: 饮血状态下造成近战伤害
- **效果**: 每层提供+1近战攻击和伤害加值
- **持续时间**: 与狂暴状态同步

#### 技术实现 (Technical Implementation)
```
// 怒火层数状态配置
data "StackType" "Additive"
data "MaxStackAmount" "7"
data "Boosts" "RollBonus(MeleeWeaponAttack,1);RollBonus(MeleeWeaponDamage,1)"
```

### 3. 火焰伤害系统 (Fire Damage System)

#### 8级特性 (Level 8 Features)
- **基础火焰伤害**: 1d8火焰伤害
- **低血量加成**: 生命值≤50%时额外1d8火焰伤害
- **地形创造**: 攻击时在目标位置创建火焰地形

#### 技术实现 (Technical Implementation)
```
// 火焰伤害被动
data "Boosts" "WeaponAttackRollBonus(1d8,Fire);IF(PercentHealthLTE(50)):WeaponAttackRollBonus(1d8,Fire)"
data "StatsFunctors" "ApplyStatus(DAOKUANG_FLAME_GROUND,100,1):OnAttack:WeaponAttack"
```

### 4. 燃烧交互系统 (Burning Interaction System)

#### 10级特性 (Level 10 Features)
- **移动速度加成**: 自身燃烧时每层亢奋+1.5米移动速度
- **暴击优势**: 对燃烧敌人暴击骰-1
- **低血量强化**: 生命值≤50%时额外-1暴击骰

#### 技术实现 (Technical Implementation)
```
// 燃烧狂热被动
data "Boosts" "IF(HasStatus('BURNING')):MovementSpeedIncrease(1.5);CriticalHitExtraDice(-1,Melee,Burning);IF(PercentHealthLTE(50)):CriticalHitExtraDice(-1,Melee,Burning)"
```

### 5. 连击系统 (Combo System)

#### 14级特性 (Level 14 Features)
- **暴击连击**: 暴击触发额外攻击
- **移动恢复**: 暴击或击杀恢复满移动速度
- **无限制**: 理论上可以无限连击

#### 技术实现 (Technical Implementation)
```
// 无尽杀戮被动
data "StatsFunctors" "UnlockSpell(DaoKuang_ExtraAttack):OnAttack:CriticalHit;ActionResource(Movement,100,0):OnAttack:CriticalHit;ActionResource(Movement,100,0):OnKill"
```

## 平衡性设计 (Balance Design)

### 风险收益机制 (Risk-Reward Mechanism)

#### 高风险要素 (High Risk Elements)
1. **生命值消耗**: 饮血消耗50%当前生命值
2. **狂暴依赖**: 核心能力需要狂暴状态
3. **武器限制**: 血饮狂刀需要特定武器类型
4. **短休限制**: 饮血技能短休1次

#### 高回报要素 (High Reward Elements)
1. **强力吸血**: 基于等级的治疗效果
2. **伤害叠加**: 怒火层数+火焰伤害
3. **移动优势**: 多种移动速度提升
4. **连击潜力**: 暴击触发额外攻击

### 成长曲线 (Growth Curve)

#### 等级分布 (Level Distribution)
- **3级**: 基础血腥战斗风格建立
- **8级**: 火焰元素加入，伤害显著提升
- **10级**: 燃烧交互，战术深度增加
- **14级**: 连击系统，爆发力达到顶峰

## 兼容性考虑 (Compatibility Considerations)

### 游戏系统兼容 (Game System Compatibility)
- **狂暴系统**: 完全兼容原版狂暴机制
- **武器系统**: 支持所有刀类武器
- **状态系统**: 与原版燃烧等状态兼容
- **动作经济**: 遵循原版动作点系统

### 模组兼容性 (Mod Compatibility)
- **职业模组**: 不冲突，可与其他职业模组共存
- **武器模组**: 支持添加新刀类武器的模组
- **状态模组**: 兼容修改燃烧等状态的模组

## 调试信息 (Debug Information)

### 关键UUID列表 (Key UUID List)
```
子职业UUID: 12345678-1234-5678-9abc-123456789abf
进阶表UUID: 12345678-1234-5678-9abc-123456789abe
饮血技能: 12345678-1234-5678-9abc-123456789ac4
血饮狂刀: 12345678-1234-5678-9abc-123456789ac5
```

### 状态ID列表 (Status ID List)
```
DAOKUANG_BLOOD_DRINKING: 饮血状态
DAOKUANG_FURY_STACK: 怒火层数
DAOKUANG_FLAME_FURY: 火焰之怒
DAOKUANG_BURNING_FRENZY: 燃烧狂热
DAOKUANG_ENDLESS_SLAUGHTER: 无尽杀戮
```

## 已知问题 (Known Issues)

### 当前限制 (Current Limitations)
1. **AI行为**: AI可能不会最优使用饮血技能
2. **视觉效果**: 某些状态可能缺少独特视觉效果
3. **平衡性**: 高等级时可能过于强力，需要进一步测试

### 未来改进 (Future Improvements)
1. **AI优化**: 改进AI使用饮血技能的逻辑
2. **视觉增强**: 添加更多独特的视觉效果
3. **平衡调整**: 基于玩家反馈调整数值
4. **功能扩展**: 可能添加更多与血液/火焰相关的能力

## 开发者注意事项 (Developer Notes)

### 修改建议 (Modification Suggestions)
- 修改伤害数值时，注意保持风险收益平衡
- 添加新状态时，确保与现有系统兼容
- 修改UUID时，需要同步更新所有引用

### 测试要点 (Testing Points)
- 验证饮血技能在不同生命值下的效果
- 测试怒火层数的正确叠加和上限
- 确认火焰地形创建的正确性
- 验证暴击连击的触发条件

---

**版本**: 1.0.0  
**最后更新**: 2024年  
**维护者**: 模组开发团队