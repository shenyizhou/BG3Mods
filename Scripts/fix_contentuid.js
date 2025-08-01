const fs = require('fs');
const path = require('path');

// 生成随机的 contentuid
function generateRandomContentUID() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const segments = [];
    
    // 生成 5 个段，每段 8 个字符
    for (let i = 0; i < 5; i++) {
        let segment = '';
        for (let j = 0; j < 8; j++) {
            segment += chars[Math.floor(Math.random() * chars.length)];
        }
        segments.push(segment);
    }
    
    return 'h' + segments.join('g');
}

// 检查是否为中文 contentuid（包含中文字符）
function isChineseContentUID(contentuid) {
    return /[\u4e00-\u9fff]/.test(contentuid);
}

// 处理文件
function processFile(filePath) {
    console.log(`处理文件: ${filePath}`);
    
    let content = fs.readFileSync(filePath, 'utf8');
    let modified = false;
    const replacements = new Map();
    
    // 查找所有 contentuid
    const regex = /contentuid="([^"]*)"/g;
    let match;
    
    while ((match = regex.exec(content)) !== null) {
        const originalUID = match[1];
        
        if (isChineseContentUID(originalUID)) {
            if (!replacements.has(originalUID)) {
                const newUID = generateRandomContentUID();
                replacements.set(originalUID, newUID);
                console.log(`  替换: ${originalUID} -> ${newUID}`);
            }
        }
    }
    
    // 执行替换
    for (const [oldUID, newUID] of replacements) {
        const oldPattern = `contentuid="${oldUID.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}"`;
        const newPattern = `contentuid="${newUID}"`;
        content = content.replace(new RegExp(oldPattern, 'g'), newPattern);
        modified = true;
    }
    
    if (modified) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`  文件已更新，共替换 ${replacements.size} 个 contentuid`);
    } else {
        console.log(`  文件无需修改`);
    }
    
    return replacements.size;
}

// 递归查找所有 XML 文件
function findXMLFiles(dir) {
    const files = [];
    
    function traverse(currentDir) {
        const items = fs.readdirSync(currentDir);
        
        for (const item of items) {
            const fullPath = path.join(currentDir, item);
            const stat = fs.statSync(fullPath);
            
            if (stat.isDirectory()) {
                traverse(fullPath);
            } else if (item.endsWith('.xml')) {
                files.push(fullPath);
            }
        }
    }
    
    traverse(dir);
    return files;
}

// 主函数
function main() {
    const projectDir = '/Users/shenyizhou/BG3Mods/KungFuMaster';
    
    console.log('开始检查和修复 contentuid...');
    console.log(`项目目录: ${projectDir}`);
    
    const xmlFiles = findXMLFiles(projectDir);
    console.log(`找到 ${xmlFiles.length} 个 XML 文件`);
    
    let totalReplacements = 0;
    
    for (const file of xmlFiles) {
        totalReplacements += processFile(file);
    }
    
    console.log(`\n处理完成！`);
    console.log(`总共替换了 ${totalReplacements} 个中文 contentuid`);
}

if (require.main === module) {
    main();
}

module.exports = { generateRandomContentUID, isChineseContentUID, processFile };