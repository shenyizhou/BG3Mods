--- EC template for a StatsObject
---@class ECStat: MetaClass
---@field ModId string
---@field OriginalModId string|nil
---@field Name string
---@field DisplayName string|nil
---@field Icon string|nil
---@field IconFlaggedUnknown boolean
---@field Description string|nil
---@field Using string|nil
ECStatDef = _Class:Create("ECStat", nil, {
    ModId = "",
    OriginalModId = "",
    Name = "",
    DisplayName = "", -- Ext.Loca on DisplayName.Handle
    Icon = "",
    IconFlaggedUnknown = false,
    Description = "", -- Ext.Loca ShortDescription.Handle
    Using = "",
})

--- EC template for PassiveData
---@class ECStatPassive: ECStat
---@field Boosts string
---@field Conditions string|nil
---@field Properties table<string>|nil
ECStatPassiveDef = _Class:Create("ECStatPassive", "ECStat", {
    Boosts = "",
    Conditions = "",
    Properties = "",
})

--- EC template for StatusData
---@class ECStatStatus: ECStat
---@field StatusType string
---@field Boosts string|nil
---@field StackId string|nil
---@field Passives string|nil
---@field StatusPropertyFlags table<string>|nil
---@field StatusGroups table<string>|nil
---@field AuraRadius string|nil
ECStatStatusDef = _Class:Create("ECStatStatus", "ECStat", {
    StatusType = "",
    Boosts = "",
    StackId = "",
    Passives = "",
    StatusPropertyFlags = "",
    StatusGroups = "",
    AuraRadius = "",
})

--- EC template for SpellData
---@class ECStatSpell: ECStat
---@field SpellType string
-- -@field SpellProperties table|nil
---@field SpellFlags table<string>|nil
---@field SpellSchool string|nil
---@field SpellSuccess table|nil
---@field ContainerSpells string|nil
---@field Level integer|nil
---@field Shape string|nil
---@field TargetRadius string|nil
---@field Cooldown string|nil
---@field UseCosts string|nil
---@field RitualCosts string|nil
---@field UpcastIDs nil|table<string>
---@field RootSpellID string|nil
ECStatSpellDef = _Class:Create("ECStatSpell", "ECStat", {
    SpellType = "",
    -- SpellProperties = {},
    SpellFlags = {},
    SpellSchool = "",
    SpellSuccess = {},
    ContainerSpells = "",
    Level = "",
    Shape = "",
    TargetRadius = "",
    Cooldown = "",
    UseCosts = "",
    RitualCosts = "",
    -- UpcastIDs = nil, table of spellID's
    RootSpellID = "",
})

--- tag info from Ext.StaticData.GetAll("Tag")
--- ResourceTag?
-- - @field Categories uint32
-- - @field Description string
-- - @field DisplayDescription TranslatedString
-- - @field DisplayName TranslatedString
-- - @field Icon FixedString
-- - @field Name FixedString
-- - @field Properties uint32
---@class ECTag: MetaClass
---@field TagName string
---@field TagUuid Guid
---@field DisplayName string -- get localized, shouldn't change and also idc if it does
---@field DisplayDescription string -- also get localized
---@field Icon string|nil
---@field IconFlaggedUnknown boolean
ECTagDef = _Class:Create("ECTag", nil, {

})