#!/usr/bin/env node

const readline = require('readline');
const { v4: uuidv4 } = require('uuid');
const fs = require('fs-extra');
const path = require('path');

// 创建readline接口
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// 模板文件内容
const templates = {
  metaLsx: (modInfo) => `<?xml version="1.0" encoding="utf-8"?>
<save>
  <version major="4" minor="0" revision="6" build="5" />
  <region id="Config">
    <node id="root">
      <children>
        <node id="Dependencies" />
        <node id="ModuleInfo">
          <attribute id="Author" type="LSWString" value="${modInfo.author}" />
          <attribute id="CharacterCreationLevelName" type="FixedString" value="" />
          <attribute id="Description" type="LSWString" value="${modInfo.description}" />
          <attribute id="Folder" type="LSWString" value="${modInfo.name}" />
          <attribute id="GMTemplate" type="FixedString" value="" />
          <attribute id="LobbyLevelName" type="FixedString" value="" />
          <attribute id="MD5" type="LSWString" value="" />
          <attribute id="MainMenuBackgroundVideo" type="FixedString" value="" />
          <attribute id="MenuLevelName" type="FixedString" value="" />
          <attribute id="Name" type="FixedString" value="${modInfo.name}" />
          <attribute id="NumPlayers" type="uint8" value="4" />
          <attribute id="PhotoBooth" type="FixedString" value="" />
          <attribute id="StartupLevelName" type="FixedString" value="" />
          <attribute id="Tags" type="LSWString" value="" />
          <attribute id="Type" type="FixedString" value="Add-on" />
          <attribute id="UUID" type="FixedString" value="${modInfo.uuid}" />
          <attribute id="Version64" type="int64" value="36028797018963968" />
          <children>
            <node id="PublishVersion">
              <attribute id="Version64" type="int64" value="36028797018963968" />
            </node>
            <node id="Scripts" />
            <node id="TargetModes">
              <children>
                <node id="Target">
                  <attribute id="Object" type="FixedString" value="Story" />
                </node>
              </children>
            </node>
          </children>
        </node>
      </children>
    </node>
  </region>
</save>`,

  localizationXml: (date) => `<contentList date="${date}"></contentList>`,

  // BG3数据文件模板
  dataFiles: {
    'Passive.txt': `// 被动技能数据文件
// 用于定义模组中的被动技能
// 示例格式:
// new entry "YourPassiveName"
// type "PassiveData"
// data "DisplayName" "h12345678g1234g1234g1234g123456789012;1"
// data "Description" "h12345678g1234g1234g1234g123456789012;2"
// data "Icon" "PassiveFeature_Generic_Damage"
// data "Properties" "Highlighted;OncePerTurn"
// data "Boosts" "ActionResource(ActionPoint,1,0)"
`,
    
    'Weapon.txt': `// 武器数据文件
// 用于定义模组中的武器属性
// 示例格式:
// new entry "YourWeaponName"
// type "Weapon"
// data "RootTemplate" "12345678-1234-1234-1234-123456789012"
// data "Damage Type" "Slashing"
// data "Damage" "1d8+1"
// data "Damage Range" "150"
// data "Weight" "1.35"
// data "Price" "15"
// data "Rarity" "Common"
// data "Weapon Group" "SimpleMeleeWeapon"
// data "Weapon Properties" "Finesse;Light"
`,
    
    'Status.txt': `// 状态效果数据文件
// 用于定义模组中的状态效果
// 示例格式:
// new entry "YourStatusName"
// type "StatusData"
// data "StatusType" "BOOST"
// data "DisplayName" "h12345678g1234g1234g1234g123456789012;1"
// data "Description" "h12345678g1234g1234g1234g123456789012;2"
// data "Icon" "statIcons_Condition"
// data "StackId" "YourStatusName"
// data "Boosts" "Advantage(AttackRoll)"
// data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
`,
    
    'Spell_Target.txt': `// 目标法术数据文件
// 用于定义模组中的目标法术
// 示例格式:
// new entry "YourSpellName"
// type "SpellData"
// data "SpellType" "Target"
// data "Level" "1"
// data "SpellSchool" "Evocation"
// data "TargetRadius" "300"
// data "AreaRadius" "200"
// data "ExplodeRadius" "0"
// data "TargetConditions" "Character() and not Dead()"
// data "Icon" "Spell_Evocation_MagicMissile"
// data "DisplayName" "h12345678g1234g1234g1234g123456789012;1"
// data "Description" "h12345678g1234g1234g1234g123456789012;2"
// data "TooltipDamageList" "DealDamage(1d4+1,Force)"
// data "CastSound" "Spell_Cast_Damage_Force_MagicMissile_L1to3"
// data "TargetSound" "Spell_Impact_Damage_Force_MagicMissile_L1to3"
// data "VocalComponentSound" "Vocal_Component_EnchantWeapon"
// data "CastTextEvent" "Cast"
// data "CycleConditions" "Enemy() and not Dead()"
// data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:1"
// data "SpellAnimation" "dd86aa43-8189-4d9f-9a5c-454b5fe4a197,,;,,;d8925ce4-d6d9-400c-92da-be4c0531bbf5,,;,,;,"
// data "VerbalIntent" "Damage"
// data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful"
// data "PrepareEffect" "d85c0d00-8b5e-4b80-9aad-6770b0fca5e6"
// data "CastEffect" "d85c0d00-8b5e-4b80-9aad-6770b0fca5e6"
// data "TargetEffect" "69b0ad69-5b90-4909-9fb9-5c9d92ad4c9b"
`,
    
    'Spell_Projectile.txt': `// 投射物法术数据文件
// 用于定义模组中的投射物法术
// 示例格式:
// new entry "YourProjectileSpell"
// type "SpellData"
// data "SpellType" "Projectile"
// data "Level" "1"
// data "SpellSchool" "Evocation"
// data "TargetRadius" "1800"
// data "AreaRadius" "0"
// data "ExplodeRadius" "0"
// data "ProjectileCount" "3"
// data "Projectile" "12345678-1234-1234-1234-123456789012"
// data "Icon" "Spell_Evocation_MagicMissile"
// data "DisplayName" "h12345678g1234g1234g1234g123456789012;1"
// data "Description" "h12345678g1234g1234g1234g123456789012;2"
// data "TooltipDamageList" "DealDamage(1d4+1,Force)"
// data "CastSound" "Spell_Cast_Damage_Force_MagicMissile_L1to3"
// data "TargetSound" "Spell_Impact_Damage_Force_MagicMissile_L1to3"
// data "VocalComponentSound" "Vocal_Component_EnchantWeapon"
// data "CastTextEvent" "Cast"
// data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:1"
// data "SpellAnimation" "dd86aa43-8189-4d9f-9a5c-454b5fe4a197,,;,,;d8925ce4-d6d9-400c-92da-be4c0531bbf5,,;,,;,"
// data "VerbalIntent" "Damage"
// data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful"
// data "PrepareEffect" "d85c0d00-8b5e-4b80-9aad-6770b0fca5e6"
// data "CastEffect" "d85c0d00-8b5e-4b80-9aad-6770b0fca5e6"
`,
    
    'Spell_Shout.txt': `// 喊话法术数据文件
// 用于定义范围效果法术
// 示例格式:
// new entry "YourShoutSpell"
// type "SpellData"
// data "SpellType" "Shout"
// data "Level" "1"
// data "SpellSchool" "Enchantment"
// data "TargetRadius" "0"
// data "AreaRadius" "300"
// data "ExplodeRadius" "0"
// data "Icon" "Spell_Enchantment_CharmPerson"
// data "DisplayName" "h12345678g1234g1234g1234g123456789012;1"
// data "Description" "h12345678g1234g1234g1234g123456789012;2"
// data "CastSound" "Spell_Cast_Utility_CharmPerson_L1to3"
// data "TargetSound" "Spell_Impact_Utility_CharmPerson_L1to3"
// data "VocalComponentSound" "Vocal_Component_EnchantWeapon"
// data "CastTextEvent" "Cast"
// data "CycleConditions" "Enemy() and not Dead()"
// data "UseCosts" "ActionPoint:1;SpellSlot:1:1"
// data "SpellAnimation" "83fb6c44-f0bb-49c4-9ca8-e2c9a0c9e78a,,;,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;,,"
// data "VerbalIntent" "Utility"
// data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;Concentration;IsHarmful"
// data "PrepareEffect" "12345678-1234-1234-1234-123456789012"
// data "CastEffect" "12345678-1234-1234-1234-123456789012"
// data "TargetEffect" "12345678-1234-1234-1234-123456789012"
`,
    
    'Interrupt.txt': `// 中断数据文件
// 用于定义反应和机会攻击等中断行为
// 示例格式:
// new entry "YourInterruptName"
// type "InterruptData"
// data "InterruptContext" "OnDamaged"
// data "InterruptContextScope" "Nearby"
// data "Conditions" "HasStatus('YourCondition')"
// data "Properties" "Reaction"
// data "Cost" "ReactionActionPoint:1"
// data "InterruptDefaultValue" "Ask"
// data "EnableCondition" "HasActionResource('ReactionActionPoint', 1, 0, false, false, context.Source)"
// data "EnableContext" "OnDamaged"
// data "InterruptFlags" "TriggerSelf"
// data "Description" "h12345678g1234g1234g1234g123456789012;1"
// data "DescriptionParams" "DealDamage(1d6,Fire)"
// data "Icon" "Action_Reaction_FireShield"
// data "DisplayName" "h12345678g1234g1234g1234g123456789012;2"
`
  }
};

// 询问问题的辅助函数
function askQuestion(question, defaultValue = '') {
  return new Promise((resolve) => {
    const prompt = defaultValue ? `${question} (默认: ${defaultValue}): ` : `${question}: `;
    rl.question(prompt, (answer) => {
      resolve(answer.trim() || defaultValue);
    });
  });
}

// 创建目录结构
async function createModStructure(modInfo, targetPath) {
  const modPath = path.join(targetPath, modInfo.name);
  
  // 创建主要目录结构
  const directories = [
    `Mods/${modInfo.name}`,
    `Mods/${modInfo.name}/Localization/English`,
    `Mods/${modInfo.name}/Localization/Chinese`,
    `Mods/${modInfo.name}/Localization/ChineseTraditional`,
    `Public/${modInfo.name}`,
    `Public/${modInfo.name}/Levelmaps`,
    `Public/${modInfo.name}/Lists`,
    `Public/${modInfo.name}/Stats/Generated/Data`
  ];

  for (const dir of directories) {
    await fs.ensureDir(path.join(modPath, dir));
  }

  // 创建 meta.lsx 文件
  const metaPath = path.join(modPath, `Mods/${modInfo.name}/meta.lsx`);
  await fs.writeFile(metaPath, templates.metaLsx(modInfo));

  // 创建本地化文件
  const currentDate = new Date().toLocaleDateString('en-US', {
    month: '2-digit',
    day: '2-digit', 
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false
  }).replace(',', '');

  const localizationFiles = [
    `Mods/${modInfo.name}/Localization/English/${modInfo.name}.xml`,
    `Mods/${modInfo.name}/Localization/Chinese/${modInfo.name}.xml`,
    `Mods/${modInfo.name}/Localization/ChineseTraditional/${modInfo.name}.xml`
  ];

  for (const locFile of localizationFiles) {
    await fs.writeFile(
      path.join(modPath, locFile),
      templates.localizationXml(currentDate)
    );
  }

  // 创建选定的数据文件
  if (modInfo.selectedDataFiles && modInfo.selectedDataFiles.length > 0) {
    console.log('\n📄 创建数据文件...');
    for (const fileName of modInfo.selectedDataFiles) {
      const dataFilePath = path.join(modPath, `Public/${modInfo.name}/Stats/Generated/Data/${fileName}`);
      const templateContent = templates.dataFiles[fileName];
      await fs.writeFile(dataFilePath, templateContent);
      console.log(`✅ 已创建: ${fileName}`);
    }
  }

  console.log(`\n✅ BG3模组 "${modInfo.name}" 创建成功!`);
  console.log(`📁 位置: ${modPath}`);
  console.log(`🆔 UUID: ${modInfo.uuid}`);
  console.log(`\n📋 生成的文件结构:`);
  console.log(`├── Mods/${modInfo.name}/`);
  console.log(`│   ├── meta.lsx`);
  console.log(`│   └── Localization/`);
  console.log(`│       ├── English/${modInfo.name}.xml`);
  console.log(`│       ├── Chinese/${modInfo.name}.xml`);
  console.log(`│       └── ChineseTraditional/${modInfo.name}.xml`);
  console.log(`└── Public/${modInfo.name}/`);
  console.log(`    ├── Levelmaps/`);
  console.log(`    ├── Lists/`);
  console.log(`    └── Stats/Generated/Data/`);
  
  // 显示创建的数据文件
  if (modInfo.selectedDataFiles && modInfo.selectedDataFiles.length > 0) {
    modInfo.selectedDataFiles.forEach(fileName => {
      console.log(`    │   ├── ${fileName}`);
    });
  }
}

// 验证模组名称
function validateModName(name) {
  if (!name.trim()) {
    return '请输入模组名称';
  }
  if (!/^[a-zA-Z0-9_-]+$/.test(name)) {
    return '模组名称只能包含字母、数字、下划线和连字符';
  }
  return null;
}

// 验证UUID
function validateUUID(uuid) {
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  if (!uuidRegex.test(uuid)) {
    return '请输入有效的UUID格式';
  }
  return null;
}

// 生成UUID功能
async function generateUUIDs() {
  console.log('🆔 UUID生成器');
  console.log('=============\n');

  try {
    // 询问生成数量
    let count;
    while (true) {
      const input = await askQuestion('生成UUID数量 (1-10)', '1');
      count = parseInt(input);
      if (count >= 1 && count <= 10) break;
      console.log('❌ 请输入1-10之间的数字');
    }

    // 询问UUID格式
    console.log('\n选择UUID格式:');
    console.log('1. 标准格式 (12345678-1234-1234-1234-123456789012)');
    console.log('2. 句柄格式 (h12345678g1234g1234g1234g123456789012)');
    console.log('3. 两种格式都生成');
    
    const formatChoice = await askQuestion('请选择格式 (1/2/3)', '1');
    
    const uuids = [];
    const handleUuids = [];
    
    // 生成UUID
    for (let i = 0; i < count; i++) {
      const uuid = uuidv4();
      const handleUuid = 'h' + uuid.replace(/-/g, 'g');
      
      uuids.push(uuid);
      handleUuids.push(handleUuid);
    }
    
    // 显示结果
    console.log('\n✅ 生成的UUID:');
    console.log('================');
    
    for (let i = 0; i < count; i++) {
      console.log(`\n${i + 1}.`);
      if (formatChoice === '1' || formatChoice === '3') {
        console.log(`   标准格式: ${uuids[i]}`);
      }
      if (formatChoice === '2' || formatChoice === '3') {
        console.log(`   句柄格式: ${handleUuids[i]}`);
      }
    }
    
    // 询问是否保存到文件
    const saveToFile = await askQuestion('\n是否保存到文件? (y/n)', 'n');
    
    if (saveToFile.toLowerCase() === 'y' || saveToFile.toLowerCase() === 'yes') {
      const fileName = await askQuestion('文件名', 'generated_uuids.txt');
      const filePath = path.join(process.cwd(), fileName);
      
      let content = `BG3 UUID生成结果\n生成时间: ${new Date().toLocaleString()}\n生成数量: ${count}\n\n`;
      
      for (let i = 0; i < count; i++) {
        content += `${i + 1}.\n`;
        if (formatChoice === '1' || formatChoice === '3') {
          content += `   标准格式: ${uuids[i]}\n`;
        }
        if (formatChoice === '2' || formatChoice === '3') {
          content += `   句柄格式: ${handleUuids[i]}\n`;
        }
        content += '\n';
      }
      
      await fs.writeFile(filePath, content, 'utf8');
      console.log(`\n💾 已保存到: ${filePath}`);
    }
    
  } catch (error) {
    console.error('❌ UUID生成失败:', error.message);
  }
}

// 显示主菜单
async function showMainMenu() {
  console.log('🎮 BG3模组脚手架工具');
  console.log('==================\n');
  console.log('请选择功能:');
  console.log('1. 创建模组');
  console.log('2. 生成UUID');
  console.log('3. 退出\n');
  
  const choice = await askQuestion('请输入选项 (1/2/3)', '1');
  return choice;
}

// 创建模组功能
async function createMod() {
  console.log('🎮 BG3模组创建器');
  console.log('================\n');

  try {
    // 获取模组名称
    let modName;
    while (true) {
      modName = await askQuestion('模组名称');
      const nameError = validateModName(modName);
      if (!nameError) break;
      console.log(`❌ ${nameError}`);
    }

    // 获取作者名称
    const author = await askQuestion('作者名称', 'Shenlang');

    // 获取模组描述
    const description = await askQuestion('模组描述', '');

    // 获取生成路径
    let targetPath;
    while (true) {
      targetPath = await askQuestion('生成路径', path.join(process.cwd(), 'Source'));
      if (fs.existsSync(targetPath)) break;
      console.log('❌ 路径不存在，请输入有效路径');
    }

    // 询问是否自动生成UUID
    const autoUuid = await askQuestion('自动生成UUID? (y/n)', 'y');
    let uuid;
    
    if (autoUuid.toLowerCase() === 'y' || autoUuid.toLowerCase() === 'yes') {
      uuid = uuidv4();
      console.log(`🆔 生成的UUID: ${uuid}`);
    } else {
      while (true) {
        uuid = await askQuestion('请输入UUID');
        const uuidError = validateUUID(uuid);
        if (!uuidError) break;
        console.log(`❌ ${uuidError}`);
      }
    }

    // 询问要创建的数据文件
    console.log('\n📋 选择要创建的数据文件:');
    const dataFileOptions = [
      { key: 'Passive.txt', name: '被动技能 (Passive.txt)' },
      { key: 'Weapon.txt', name: '武器 (Weapon.txt)' },
      { key: 'Status.txt', name: '状态效果 (Status.txt)' },
      { key: 'Spell_Target.txt', name: '目标法术 (Spell_Target.txt)' },
      { key: 'Spell_Projectile.txt', name: '投射物法术 (Spell_Projectile.txt)' },
      { key: 'Spell_Shout.txt', name: '范围法术 (Spell_Shout.txt)' },
      { key: 'Interrupt.txt', name: '中断/反应 (Interrupt.txt)' }
    ];

    dataFileOptions.forEach((option, index) => {
      console.log(`${index + 1}. ${option.name}`);
    });
    console.log('0. 跳过数据文件创建');

    const selectedFiles = [];
    while (true) {
      const choice = await askQuestion('\n请输入要创建的文件编号 (多个用逗号分隔，如: 1,2,3)', '0');
      
      if (choice === '0') {
        console.log('⏭️ 跳过数据文件创建');
        break;
      }

      const choices = choice.split(',').map(c => parseInt(c.trim()) - 1);
      const validChoices = choices.filter(c => c >= 0 && c < dataFileOptions.length);
      
      if (validChoices.length === 0) {
        console.log('❌ 请输入有效的编号');
        continue;
      }

      validChoices.forEach(index => {
        const fileKey = dataFileOptions[index].key;
        if (!selectedFiles.includes(fileKey)) {
          selectedFiles.push(fileKey);
        }
      });

      console.log(`✅ 已选择: ${selectedFiles.map(f => f.replace('.txt', '')).join(', ')}`);
      break;
    }

    const modInfo = {
      name: modName,
      author: author,
      description: description,
      uuid: uuid,
      selectedDataFiles: selectedFiles
    };

    await createModStructure(modInfo, targetPath);
    
  } catch (error) {
    console.error('❌ 生成失败:', error.message);
  }
}

// 主函数
async function main() {
  try {
    while (true) {
      const choice = await showMainMenu();
      
      switch (choice) {
        case '1':
          await createMod();
          break;
        case '2':
          await generateUUIDs();
          break;
        case '3':
          console.log('👋 再见!');
          return;
        default:
          console.log('❌ 无效选项，请重新选择\n');
          continue;
      }
      
      // 询问是否继续
      const continueChoice = await askQuestion('\n是否继续使用? (y/n)', 'y');
      if (continueChoice.toLowerCase() !== 'y' && continueChoice.toLowerCase() !== 'yes') {
        console.log('👋 再见!');
        break;
      }
      console.log('\n');
    }
  } catch (error) {
    console.error('❌ 程序运行失败:', error.message);
  } finally {
    rl.close();
  }
}

// 如果直接运行此文件
if (require.main === module) {
  main();
}

module.exports = { createModStructure, templates };