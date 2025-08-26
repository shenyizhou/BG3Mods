---@class ECItem: MetaClass
---@field ModId string
---@field TemplateId Guid
---@field Name string
---@field DisplayName string|nil
---@field Icon string|nil
---@field IconFlaggedUnknown boolean
---@field Description string|nil
---@field Rarity string|nil
---@field Stats string|nil
---@field TemplateType string|nil item?
---@field Slot StatsItemSlot|nil
---@field Unique boolean
---@field StoryItem boolean -- from RT
---@field Weight nil|number string...?
---@field Boosts nil|string raw string
---@field DefaultBoosts nil|string
---@field PassivesOnEquip nil|string
---@field WeaponGroup nil|string
---@field WeaponProperties nil|string
---@field WeaponRange nil|string
---@field DamageType nil|string
---@field Damage nil|string
---@field ArmorType nil|string
---@field ProficiencyGroup nil|string
---@field IsVanilla boolean -- found in vanilla files
Item = _Class:Create("ECItem", nil, {
    ModId = "",
    TemplateId = "",
    Name = "",
    DisplayName = "", -- Ext.Loca on DisplayName.Handle
    Icon = "",
    IconFlaggedUnknown = false,
    Description = "", -- Ext.Loca ShortDescription.Handle
    Rarity = "",
    Stats = "", -- don't store this maybe?
    TemplateType = "item", -- always going to be item for us?
    Slot = nil,
    Unique = false,
    StoryItem = false,
    Weight = nil,
    Boosts = nil,           -- Armor/Weapon
    DefaultBoosts = nil,    -- Armor/Weapon
    PassivesOnEquip = nil,  -- Armor/Weapon
    ProficiencyGroup = nil, -- Armor/Weapon
    ArmorType = nil,        -- Armor
    WeaponGroup = nil,      -- Weapon
    WeaponProperties = nil, -- Weapon
    WeaponRange = nil,      -- Weapon
    DamageType = nil,       -- Weapon
    Damage = nil,           -- Weapon
    IsVanilla = false,
    --LockDifficultyClassID = "?"
})
---Returns name of Mod the item comes from (allegedly)
---@return string
function Item:GetModName()
    return Ext.Mod.GetMod(self.ModId).Info.Name
end

function Item:Init()
    self.TemplateId = self.TemplateId or Helpers.Format.NullUuid
    self.Name = self.Name or ""
    self.DisplayName = self.DisplayName or ""
    self.Description = self.Description or ""
    self.ModId = self.ModId or Helpers.Format.NullUuid
    self.Icon = self.Icon or "Item_Unknown"
    self.IconFlaggedUnknown = self.IconFlaggedUnknown or false
    self.Rarity = self.Rarity or "Default"
    self.Unique = self.Unique or false
    self.StoryItem = self.StoryItem or false
    self.IsVanilla = self.IsVanilla or false
end

--"PotentRobe (1e64badf-4898-4169-9b02-3910518dc73d)"
function Item:__tostring() return string.format("%s (%s)", self.Name, self.TemplateId) end

if Data == nil then Data = {} end
Data.ItemRarity = {
    [0] = "Default",
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "VeryRare",
    [5] = "Legendary",
}

function Item:GetColorByRarity()
    if self.Rarity == "Legendary"        then return {0.92, 0.78, 0.03, 1.0}
    elseif self.Rarity == "VeryRare" then return {0.82, 0.00, 0.49, 1.0}
    --elseif self.Rarity == "Epic"      then return {0.64, 0.27, 0.91, 1.0}
    elseif self.Rarity == "Rare"      then return {0.20, 0.80, 1.00, 1.0}
    elseif self.Rarity == "Uncommon"  then return {0.00, 0.66, 0.00, 1.0}
    --elseif self.Rarity == "Unique"    then return {0.78, 0.65, 0.35, 1.0}
    elseif self.Rarity == "Common"    then return {1.00, 1.00, 1.00, 1.0}
    else return {0.30, 0.30, 0.30, 1.0} end -- Default or anything else
end

---Doesn't catch everything, not sure what to do about it
---@param eqrace string EquipmentRace
---@return boolean
function Item:HasValidVisualsForRace(eqrace)
    if eqrace ~= nil and eqrace ~= Helpers.Format.NullUuid then
        local rt = Ext.Template.GetRootTemplate(self.TemplateId) --[[@as ItemTemplate]]
        if rt ~= nil and rt.Equipment ~= nil then
            if rt.Equipment.Visuals[eqrace] ~= nil then
                return true
            end
        end
    end
    return false
end

--#region --TODO color item UI based on rarity?
-- new itemtype "Common","ffffff","","1.000",Common,Common,0
-- minlevel 1
-- new boostgroup dropChance 1

-- new itemtype "Unique","c7a758","Item_Unique","1.000",Unique,Unique,4
-- minlevel 1
-- new boostgroup dropChance 1

-- new itemtype "Uncommon","00a900","Item_Magical","1.000",Uncommon,Uncommon,2
-- minlevel 1
-- new boostgroup dropChance 1

-- new itemtype "Rare","33ccff","Item_Rare","1.000",Rare,Rare,1
-- minlevel 1
-- new boostgroup dropChance 1

-- new itemtype "Epic","a346e9","Item_Epic","1.000",Epic,Epic,5
-- minlevel 1
-- new boostgroup dropChance 1

-- new itemtype "Legendary","d1007c","Item_Legendary","1.000",Legendary,Legendary,6
-- minlevel 1
-- new boostgroup dropChance 1

-- new itemtype "Divine","ebc808","Item_Divine","1.000",Divine,Divine,3
-- minlevel 1
-- new boostgroup dropChance 1
--#endregion