local vanillamodids = {
	"ed539163-bb70-431b-96a7-f5b2eda5376b", -- Shared
	"b176a0ac-d79f-ed9d-5a87-5c2c80874e10", -- DiceSet_02
	"e842840a-2449-588c-b0c4-22122cfce31b", -- DiceSet_01
	"e0a4d990-7b9b-8fa9-d7c6-04017c6cf5b1", -- DiceSet_03
	"ee4989eb-aab8-968f-8674-812ea2f4bfd7", -- DiceSet_06
    "630daa32-70f8-3da5-41b9-154fe8410236", -- MainUI
    "ee5a55ff-eb38-0b27-c5b0-f358dc306d34", -- ModBrowser
	"3d0c5ff8-c95d-c907-ff3e-34b204f1c630", -- SharedDev
	"991c9c7a-fb80-40cb-8f0d-b92d4e80e9b1", -- Gustav
	"28ac9ce2-2aba-8cda-b3b5-6e922f71b6b8", -- GustavDev
}
Ext.RegisterConsoleCommand("dumpallitems", function()
    Ext.IO.SaveFile("_Dumps/AllItems.json", Ext.DumpExport(ItemManager.AllItems))
end)
Ext.RegisterConsoleCommand("dumpallarmors", function()
    Ext.IO.SaveFile("_Dumps/AllArmors.json", Ext.DumpExport(ItemManager.AllArmors))
end)
Ext.RegisterConsoleCommand("dumpallweapons", function()
    Ext.IO.SaveFile("_Dumps/AllWeapons.json", Ext.DumpExport(ItemManager.AllWeapons))
end)

--- TODO later, cache items and only regenerate on request or mods loaded hash?
---@class ECItemManager
---@field AllItems table<ECItem>
---@field AllNames table<table<string, integer>>
---@field AllArmors table<ECItem>
---@field Armor table<table<ECItem>>
---@field AllWeapons table<ECItem>
---@field AllInstruments table<ECItem>
---@field AllPotions table<ECItem>
---@field AllScrolls table<ECItem>
---@field AllBooks table<ECItem>
---@field AllThrowables table<ECItem>
---@field AllDye table<ECItem>
---@field AllFood table<ECItem>
---@field AllAlchemy table<ECItem>
---@field AllArrows table<ECItem>
---@field AllMisc table<ECItem>
---@field AllItemMap table<string, ECItem>
---@field HasPopulated boolean
---@field _KnownVanillaItems table<string>
ItemManager = _Class:Create("ECItemManager", nil, {
    AllItems = {},
    AllNames = {},
    AllArmors = {},
    Armor = {
        Helmet = {},
        Cloak = {},
        Breast = {},
        Gloves = {},
        Boots = {},
        Ring = {},
        Amulet = {},
        VanityBody = {},
        VanityBoots = {},
        Underwear = {},
        Shield = {}
    },
    AllWeapons = {},
    AllInstruments = {},
    AllPotions = {},
    AllScrolls = {},
    AllBooks = {},
    AllThrowables = {},
    AllDye = {},
    AllFood = {},
    AllAlchemy = {},
    AllArrows = {},
    AllMisc = {},
    AllItemMap = {},
    HasPopulated = false,
    _KnownVanillaItems = {},
})
local ItemWithVisuals = {
    Helmet = true,
    Cloak = true,
    Breast = true,
    Gloves = true,
    Boots = true,
    Ring = true,
    Amulet = true,
    VanityBody = true,
    VanityBoots = true,
    Underwear = true,
    AllItems = true,
}

---Gives table of given type of ECItem
---@param itemType string
---@return table<ECItem>|nil
function ItemManager:GetItemsOfType(itemType)
    if itemType == "Helmet"     then return self.Armor.Helmet   end
    if itemType == "Cloak"      then return self.Armor.Cloak    end
    if itemType == "Breast"     then return self.Armor.Breast   end
    if itemType == "Gloves"     then return self.Armor.Gloves   end
    if itemType == "Boots"      then return self.Armor.Boots    end
    if itemType == "Ring"       then return self.Armor.Ring   end
    if itemType == "Amulet"     then return self.Armor.Amulet   end
    if itemType == "VanityBody" then return self.Armor.VanityBody    end
    if itemType == "VanityBoots"then return self.Armor.VanityBoots   end
    if itemType == "Underwear"  then return self.Armor.Underwear   end
    if itemType == "Shield"     then return self.Armor.Shield    end
    if itemType == "Misc"       then return self.AllMisc    end
    if itemType == "Books"      then return self.AllBooks    end
    if itemType == "Weapon"     then return self.AllWeapons    end
    if itemType == "Instrument" then return self.AllInstruments   end
    if itemType == "Potion"     then return self.AllPotions   end
    if itemType == "Scroll"     then return self.AllScrolls   end
    if itemType == "Dye"        then return self.AllDye   end
    if itemType == "Food"       then return self.AllFood   end
    if itemType == "Alchemy"    then return self.AllAlchemy   end
    if itemType == "Arrows"     then return self.AllArrows   end
    if itemType == "Throwables" then return self.AllThrowables   end
    if itemType == "AllItems"   then return self.AllItems   end
    return nil
end
---Gives item by a specifically formatted string
---@param itemstring string format "PotentRobe (1e64badf-4898-4169-9b02-3910518dc73d)"
---@return ECItem|nil
function ItemManager:GetItemByString(itemstring)
    if not itemstring then return nil end
    -- _, _, name, templateid = string.find(itemstring, "(%S+) %((.*)%)")
    -- ECDebug("GetItemByString: %s and %s", name, templateid)
    for k, v in ipairs(self.AllItems) do
        --if  v.Name == name then
        if  v.DisplayName == itemstring or v.Name == itemstring then
        --ECDebug("Returning: %s", v)
            return v
        end
    end
    return nil
end
---Returns a table of formatted strings, given table of ECItem
---@param itemtype string 
---@param vanilla boolean|nil nil = both, true = vanilla, false = modded
---@param eqrace string|nil optional EquipmentRace
---@param rarityNum number?
---@return table<string> table of formatted strings from tostring(ECItem)
function ItemManager:GetItemStringsOfType(itemtype, vanilla, eqrace, rarityNum)
    local items = self:GetItemsOfType(itemtype)
    local strings = {}
    for k, v in pairs(items) do
        if vanilla == nil or vanilla == v.IsVanilla then
            if rarityNum == nil or rarityNum == 0 or Data.ItemRarity[rarityNum] == v.Rarity then
                if eqrace == nil or ItemWithVisuals[itemtype] == nil or v:HasValidVisualsForRace(eqrace) then
                    if v.DisplayName ~= nil and v.DisplayName:gsub(" ", "") ~= "" and strings[v.DisplayName] == nil then
                        table.insert(strings, v.DisplayName)
                    else
                        table.insert(strings, v.Name)
                    end
                end
            end
        end
    end
    table.sort(strings)
    return strings
end

---Returns matching items strings based on given search text
---@param search string|nil
---@param vanilla boolean|nil nil = both, true = vanilla, false = modded
---@param eqrace string|nil optional EquipmentRace
---@return table<string>
function ItemManager:GetMatchingItemStrings(search, itemtype, vanilla, eqrace, rarityNum)
    local items = self:GetItemsOfType(itemtype)
    if not items then return {} end  -- 添加这行检查
    if not search then return {} end
    search = search:lower()
    local matches = {}
    for k, v in pairs(items) do
        if vanilla == nil or vanilla == v.IsVanilla then
            if string.find(v.Name:lower(), search, 1, true)
            or string.find(v.DisplayName:lower(), search, 1, true)
            or string.find(v.TemplateId, search, 1, true)
            --or string.find(v.ModId, search, 1, true)
            or Ext.Mod.GetMod(v.ModId) ~= nil and string.find(Ext.Mod.GetMod(v.ModId).Info.Name:lower(), search, 1, true) then
                if rarityNum == nil or rarityNum == 0 or Data.ItemRarity[rarityNum] == v.Rarity then
                    if eqrace == nil or ItemWithVisuals[itemtype] == nil or v:HasValidVisualsForRace(eqrace) then
                        if v.DisplayName ~= nil and v.DisplayName:gsub(" ", "") ~= "" and matches[v.DisplayName] == nil then
                            table.insert(matches, v.DisplayName)
                        else
                            table.insert(matches, v.Name)
                        end
                    end
                end
            end
        end
    end
    return matches
end

---Returns matching items based on given search text
---@param search string|nil
---@param vanilla boolean|nil nil = both, true = vanilla, false = modded
---@param eqrace string|nil optional EquipmentRace
---@return table<ECItem>
function ItemManager:GetMatchingItems(search, itemtype, vanilla, eqrace, rarityNum)
    local items = self:GetItemsOfType(itemtype)
    if not search then return {} end
    search = search:lower()
    local matches = {}
    for k, v in pairs(items) do
        if vanilla == nil or vanilla == v.IsVanilla then
            if string.find(v.Name:lower(), search, 1, true)
            or string.find(v.DisplayName:lower(), search, 1, true)
            or string.find(v.TemplateId, search, 1, true)
            --or string.find(v.ModId, search, 1, true)
            or Ext.Mod.GetMod(v.ModId) ~= nil and string.find(Ext.Mod.GetMod(v.ModId).Info.Name:lower(), search, 1, true) then
                if rarityNum == nil or rarityNum == 0 or Data.ItemRarity[rarityNum] == v.Rarity then
                    if eqrace == nil or ItemWithVisuals[itemtype] == nil or v:HasValidVisualsForRace(eqrace) then
                        table.insert(matches, v)
                    end
                end
            end
        end
    end
    return matches
end

function ItemManager:HandleDisplayName(roottemplate)
    local handle = roottemplate.DisplayName.Handle.Handle
    local translated = Ext.Loca.GetTranslatedString(handle)
    local count = self.AllNames[translated]
    if count == nil then
        self.AllNames[translated] = 1
        return translated
    end
    -- found a duplicate if we're here, append count (#) and increment
    --ECDebug("Duplicate (%d) %s", count, translated)
    self.AllNames[translated] = count + 1

    translated = string.format("%s (%d)", translated, count)
    return translated
end

---Internal: Adds item to internal indexes during Population
---@param item ECItem
function ItemManager:AddMainItem(item)
    table.insert(self.AllItems, item)
    self.AllItemMap[item.TemplateId] = item
end

function ItemManager:CheckValidRT(rt)
    local success,valid = pcall(function() return rt.CanBePickedUp and rt.CanBePickedUp == rt.Icon ~= nil end)
    if success and valid then return true else return false end
end

---Does the bulk of the class work, populating all tables, disgusting beast
function ItemManager:Populate()
    -- Ext.Mod.GetLoadOrder()[8] is GustavDev, should be last vanilla "mod" as of patch 6
    -- Ext.Mod.GetLoadOrder()[10] is GustavDev, should be last vanilla "mod" as of patch 7
    local gustavIndex = 1
    for i,v in ipairs(Ext.Mod.GetLoadOrder()) do
        local mod = Ext.Mod.GetMod(v)
        if mod ~= nil and mod.Info.Name == "GustavDev" then
            gustavIndex = i
            break
        end
    end
    for _, entry in pairs(Ext.Stats.GetStatsLoadedBefore(Ext.Mod.GetLoadOrder()[gustavIndex])) do
        self._KnownVanillaItems[entry] = true
    end
    if self.HasPopulated then return end
    for _, entry in pairs(Ext.Stats.GetStats("Armor")) do
        local stat = Ext.Stats.Get(entry) --[[@as Armor]]
        if stat ~= nil and stat.RootTemplate ~= "" and stat.RootTemplate ~= Helpers.Format.NullUuid and self.AllItemMap[stat.RootTemplate] == nil then
            local rt = Ext.Template.GetRootTemplate(stat.RootTemplate) --[[@as ItemTemplate]]
            if rt ~= nil and self:CheckValidRT(rt) then
                local item = Item:New{
                    Stats = stat,
                    Name = stat.Name,
                    TemplateId = stat.RootTemplate,
                    Icon = rt.Icon or "Item_Unknown",
                    Rarity = stat.Rarity or "Default",
                    ModId = stat.ModId,
                    DisplayName = self:HandleDisplayName(rt),
                    Description = Ext.Loca.GetTranslatedString(rt.Description.Handle.Handle),
                    Slot = stat.Slot or "Sentinel",
                    Unique = stat.Unique or false,
                    StoryItem = rt.StoryItem or false,
                    Weight = stat.Weight,
                    Boosts = stat.Boosts,
                    DefaultBoosts = stat.DefaultBoosts,
                    PassivesOnEquip = stat.PassivesOnEquip,
                    ArmorType = stat.ArmorType,
                    ProficiencyGroup = stat["Proficiency Group"],
                    IsVanilla = self._KnownVanillaItems[entry] ~= nil and true or false,
                }
                local added = false
                if stat.Slot == "Helmet" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Helmet, item)
                    added = true
                end
                if stat.Slot == "Cloak" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Cloak, item)
                    added = true
                end
                if stat.Slot == "Breast" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Breast, item)
                    added = true
                end
                if stat.Slot == "Gloves" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Gloves, item)
                    added = true
                end
                if stat.Slot == "Boots" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Boots, item)
                    added = true
                end
                if stat.Slot == "Ring" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Ring, item)
                    added = true
                end
                if stat.Slot == "Amulet" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Amulet, item)
                    added = true
                end
                if stat.Slot == "VanityBody" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.VanityBody, item)
                    added = true
                end
                if stat.Slot == "VanityBoots" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.VanityBoots, item)
                    added = true
                end
                if stat.Slot == "Underwear" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Underwear, item)
                    added = true
                end
                if stat.Shield == "Yes" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.Armor.Shield, item)
                    added = true
                end
                if stat.Slot == "MusicalInstrument" then
                    self:AddMainItem(item)
                    table.insert(self.AllArmors, item)
                    table.insert(self.AllInstruments, item)
                    added = true
                end
                if not added then
                    --ECDebug("What is this? %s (%s)", stat.Name, stat.RootTemplate)
                    self:AddMainItem(item)
                    table.insert(self.AllMisc, item)
                end
            end
        else --ECWarn("Couldn't process: %s", entry)
        end
    end
    for _, entry in pairs(Ext.Stats.GetStats("Weapon")) do
        local stat = Ext.Stats.Get(entry) --[[@as Weapon]]
        if stat ~= nil and stat.RootTemplate ~= "" and stat.RootTemplate ~= Helpers.Format.NullUuid and self.AllItemMap[stat.RootTemplate] == nil then
            local rt = Ext.Template.GetRootTemplate(stat.RootTemplate) --[[@as ItemTemplate]]
            if rt ~= nil and self:CheckValidRT(rt) then
                local item = Item:New{
                    Stats = stat,
                    Name = stat.Name,
                    TemplateId = stat.RootTemplate,
                    Icon = rt.Icon,
                    Rarity = stat.Rarity or "Default",
                    ModId = stat.ModId,
                    DisplayName = self:HandleDisplayName(rt),
                    Description = Ext.Loca.GetTranslatedString(rt.Description.Handle.Handle),
                    Slot = stat.Slot or "Sentinel",
                    Unique = stat.Unique or false,
                    StoryItem = rt.StoryItem or false,
                    Weight = stat.Weight,
                    Boosts = stat.Boosts,
                    DefaultBoosts = stat.DefaultBoosts,
                    PassivesOnEquip = stat.PassivesOnEquip,
                    ProficiencyGroup = stat["Proficiency Group"],
                    WeaponGroup = stat["Weapon Group"],
                    WeaponProperties = stat["Weapon Properties"],
                    WeaponRange = stat.WeaponRange,
                    DamageType = stat["Damage Type"],
                    Damage = stat.Damage,
                    IsVanilla = self._KnownVanillaItems[entry] ~= nil and true or false,
                }
                self:AddMainItem(item)
                table.insert(self.AllWeapons, item)
            end
        end
    end
    --Ext.IO.SaveFile("_Dumps/allobjects.json", Ext.DumpExport(Ext.Stats.GetStats("Object")))
    --Ext.IO.SaveFile("_Dumps/allenums.json", Ext.DumpExport(Ext.Enums))
    -- FIXME Clean this and find more things to blacklist from spawnables
    local function quickblacklist(name)
        local nameblacklist = { ["FOCUSDYES_"] = true}
        for i, v in pairs(nameblacklist) do
            if string.find(name, i) ~= nil then
                return true
            end
        end
    end

    for _, entry in pairs(Ext.Stats.GetStats("Object")) do
        local stat = Ext.Stats.Get(entry) --[[@as Object]]
        if stat ~= nil and stat.RootTemplate ~= "" and stat.RootTemplate ~= Helpers.Format.NullUuid and self.AllItemMap[stat.RootTemplate] == nil then
            local rt = Ext.Template.GetRootTemplate(stat.RootTemplate) --[[@as ItemTemplate]]
            -- can't process?
            if rt ~= nil and self:CheckValidRT(rt) then
                -- don't want?
                if stat.InventoryTab ~= "Equipment" and not quickblacklist(stat.Name) then
                    local item = Item:New{
                        Stat = stat, -- maybe don't store this...?
                        Name = stat.Name,
                        TemplateId = stat.RootTemplate,
                        Icon = rt.Icon,
                        Rarity = stat.Rarity or "Default",
                        ModId = stat.ModId,
                        DisplayName = self:HandleDisplayName(rt),
                        Description = Ext.Loca.GetTranslatedString(rt.Description.Handle.Handle),
                        Unique = stat.Unique or false,
                        StoryItem = rt.StoryItem or false,
                        Weight = stat.Weight,
                        IsVanilla = self._KnownVanillaItems[entry] ~= nil and true or false,
                    }
                    local added = false
                    if stat.ItemUseType == "Potion" then
                        self:AddMainItem(item)
                        table.insert(self.AllPotions, item)
                        added = true
                    end
                    if stat.ItemUseType == "Scroll" then
                        self:AddMainItem(item)
                        table.insert(self.AllScrolls, item)
                        added = true
                    end
                    if string.find(stat.ObjectCategory, "Dye") ~= nil or string.find(stat.Name, "_DYE") ~= nil then
                        self:AddMainItem(item)
                        table.insert(self.AllDye, item) -- ffffff why dye mods so nonstandard
                        added = true
                    end
                    if string.find(stat.Name, "ALCH_") ~= nil then
                        self:AddMainItem(item)
                        table.insert(self.AllAlchemy, item)
                        added = true
                    end
                    if string.find(stat.ObjectCategory, "Arrow") ~= nil then
                        self:AddMainItem(item)
                        table.insert(self.AllArrows, item)
                        added = true
                    end
                    if string.find(stat.ObjectCategory, "Food") ~= nil or string.find(stat.ObjectCategory, "Drink") ~= nil or
                        string.find(stat.Name, "Food_") ~= nil or string.find(stat.ObjectCategory, "Drink_") ~= nil or
                        string.find(stat.Name, "FOOD_") ~= nil or string.find(stat.ObjectCategory, "DRINK_") ~= nil then
                        self:AddMainItem(item)
                        table.insert(self.AllFood, item) -- ffffff why food category so messy
                        added = true
                    end
                    if string.find(stat.Name, "BOOK") ~= nil then
                        self:AddMainItem(item)
                        table.insert(self.AllBooks, item)
                        added = true
                    end
                    if stat.ItemUseType == "Grenade" then
                        self:AddMainItem(item)
                        table.insert(self.AllThrowables, item)
                        added = true
                    end
                    if not added then
                        --ECDebug("What is this? %s (%s)", stat.Name, stat.RootTemplate)
                        self:AddMainItem(item)
                        table.insert(self.AllMisc, item)
                    end
                end
            else --ECWarn("Couldn't process: %s", entry)
            end
        end
    end
    self.HasPopulated = true
    ECPrint("ItemManager populated with %d items", #self.AllItems)
end

Ext.Events.SessionLoaded:Subscribe(function()
    ItemManager:Populate()
end)
Ext.Events.ResetCompleted:Subscribe(function()
    ItemManager:Populate()
end)