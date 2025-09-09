# BG3模组脚手架生成器

一个用于快速生成博德之门3(Baldur's Gate 3)模组项目结构的命令行工具。

## 功能特性

- 🚀 **快速生成**: 一键创建标准BG3模组目录结构
- 🌍 **多语言支持**: 自动生成英文、简体中文、繁体中文本地化文件
- 🆔 **UUID生成**: 自动生成或手动输入模组UUID
- 📝 **交互式配置**: 友好的命令行交互界面
- 📁 **标准结构**: 基于官方模组模板的标准目录结构
- 📊 **数据文件模板**: 可选择创建Passive.txt、Weapon.txt、Status.txt等常用数据文件模板

## 安装

```bash
# 安装依赖
npm install

# 全局安装(可选)
npm install -g .
```

## 使用方法

### 方法1: 直接运行
```bash
node bg3-mod-scaffold.js
```

### 方法2: 使用npm脚本
```bash
npm run scaffold
```

### 方法3: 全局命令(需要全局安装)
```bash
bg3-scaffold
```

## 交互式配置

运行脚手架工具后，会提示输入以下信息:

1. **模组名称**: 模组的唯一标识符(只能包含字母、数字、下划线和连字符)
2. **作者名称**: 模组作者(默认: Shenlang)
3. **模组描述**: 模组的简短描述
4. **生成路径**: 模组文件生成的目标路径(默认: Source文件夹)
5. **UUID生成**: 选择自动生成或手动输入UUID
6. **数据文件选择**: 选择需要创建的数据文件模板(可多选)

## 生成的目录结构

```
[ModName]/
├── Mods/
│   └── [ModName]/
│       ├── meta.lsx                    # 模组元数据文件
│       └── Localization/               # 本地化文件夹
│           ├── English/
│           │   └── [ModName].xml
│           ├── Chinese/
│           │   └── [ModName].xml
│           └── ChineseTraditional/
│               └── [ModName].xml
└── Public/
    └── [ModName]/
        ├── Levelmaps/                  # 关卡地图
        ├── Lists/                      # 列表文件
        └── Stats/
            └── Generated/
                └── Data/               # 游戏数据文件
                    ├── Passive.txt     # 被动技能数据(可选)
                    ├── Weapon.txt      # 武器数据(可选)
                    ├── Status.txt      # 状态效果数据(可选)
                    ├── Spell_Target.txt # 目标法术数据(可选)
                    ├── Spell_Shout.txt # 喊话法术数据(可选)
                    ├── Spell_Projectile.txt # 投射物法术数据(可选)
                    └── Interrupt.txt   # 中断数据(可选)
```

## 文件说明

### meta.lsx
模组的核心元数据文件，包含:
- 模组名称、作者、描述
- UUID(唯一标识符)
- 版本信息
- 目标模式配置

### 本地化文件
支持多语言的文本内容文件:
- `English/`: 英文本地化
- `Chinese/`: 简体中文本地化
- `ChineseTraditional/`: 繁体中文本地化

### 目录结构
- `Mods/`: 模组逻辑和配置文件
- `Public/`: 游戏资源和数据文件
- `Levelmaps/`: 自定义关卡地图
- `Lists/`: 游戏列表配置
- `Stats/Generated/Data/`: 游戏统计和数据文件

### 数据文件模板
脚手架工具提供以下数据文件模板，每个模板都包含详细的注释和示例代码:

- **Passive.txt**: 被动技能定义，包含技能效果、触发条件等
- **Weapon.txt**: 武器属性定义，包含伤害、属性、特殊效果等
- **Status.txt**: 状态效果定义，包含持续时间、效果描述等
- **Spell_Target.txt**: 目标法术定义，包含施法距离、目标类型等
- **Spell_Shout.txt**: 喊话法术定义，包含范围效果、持续时间等
- **Spell_Projectile.txt**: 投射物法术定义，包含弹道、爆炸效果等
- **Interrupt.txt**: 中断定义，包含触发条件、响应动作等

每个模板文件都包含:
- 标准的数据结构格式
- 详细的字段说明注释
- 实用的示例代码
- 常用属性和数值参考

## 示例

```bash
$ node bg3-mod-scaffold.js
🎮 BG3模组脚手架生成器
====================

? 模组名称: MyAwesomeMod
? 作者名称: Shenlang
? 模组描述: 一个很棒的BG3模组
? 生成路径: Source/
? 自动生成UUID? Yes
? 选择要创建的数据文件: Passive.txt, Weapon.txt, Status.txt

✅ BG3模组 "MyAwesomeMod" 创建成功!
📁 位置: D:\Games\BG3MOD\BG3Mods\Source\MyAwesomeMod
🆔 UUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890
📊 已创建数据文件: Passive.txt, Weapon.txt, Status.txt
```

## 依赖项

- `inquirer`: 交互式命令行界面
- `uuid`: UUID生成器
- `fs-extra`: 增强的文件系统操作

## 许可证

ISC

## 贡献

欢迎提交Issue和Pull Request来改进这个工具!