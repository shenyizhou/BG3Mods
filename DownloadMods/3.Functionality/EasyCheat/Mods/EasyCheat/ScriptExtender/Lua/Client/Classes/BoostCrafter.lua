---@class ECBoostCrafter:MetaClass
---@field CurrentCharacterUuid CHARACTER|nil
---@field TreeParent ExtuiTreeParent
BoostCrafter = _Class:Create("ECBoostCrafter", nil,{

})

---@param entity EntityHandle|nil
function BoostCrafter:OnCharacterChanged(entity)
    if entity == nil then
        entity = Helpers.Character:GetLocalControlledEntity()
        if entity == nil then return end
        self.CurrentCharacterUuid = Helpers.Object:GetGuid(entity)
        if self.CurrentCharacterUuid == nil then return end -- currently controlled entity has no guid, bail
    end
end

---@param entity EntityHandle|nil
---@param el ExtuiStyledRenderable
---@return EntityHandle|nil
function BoostCrafter:_characterCheckAndClear(entity, el)
    if entity == nil then
        entity = Helpers.Character:GetLocalControlledEntity()
        if entity == nil then return end -- bail if no entity available
    end
    self.CurrentCharacterUuid = Helpers.Object:GetGuid(entity)
    if self.CurrentCharacterUuid == nil then return end -- currently controlled entity has no guid, bail
    Imgui.ClearChildren(el)
    return entity -- ready
end
-- Simple Boosts: UnlockSpell
local BoostComponentMap = {
    AC = 0,
	Ability = "AbilityBoost",
	RollBonus = 2,
	Advantage = 3,
	ActionResource = 4,
	CriticalHit = 5,
	AbilityFailedSavingThrow = 6,
	Resistance = 7,
	WeaponDamageResistance = 8,
	ProficiencyBonusOverride = 9,
	ActionResourceOverride = 10,
	AddProficiencyToAC = 11,
	JumpMaxDistanceMultiplier = 12,
	AddProficiencyToDamage = 13,
	ActionResourceConsumeMultiplier = 14,
	BlockVerbalComponent = 15,
	BlockSomaticComponent = 16,
	HalveWeaponDamage = 17,
	UnlockSpell = 19,
	SourceAdvantageOnAttack = 20,
	ProficiencyBonus = 21,
	BlockSpellCast = 22,
	Proficiency = "ProficiencyBoost",
	SourceAllyAdvantageOnAttack = 24,
	IncreaseMaxHP = 25,
	ActionResourceBlock = 26,
	StatusImmunity = 27,
	UseBoosts = 28,
	CannotHarmCauseEntity = 29,
	TemporaryHP = 30,
	Weight = 31,
	WeightCategory = 32,
	FactionOverride = 33,
	ActionResourceMultiplier = 34,
	BlockRegainHP = 35,
	Initiative = 36,
	DarkvisionRange = 37,
	DarkvisionRangeMin = 38,
	DarkvisionRangeOverride = 39,
	Tag = 40,
	IgnoreDamageThreshold = 41,
	Skill = 42,
	WeaponDamage = 43,
	NullifyAbilityScore = 44,
	IgnoreFallDamage = 45,
	Reroll = 46,
	DownedStatus = 47,
	Invulnerable = 48,
	WeaponEnchantment = 49,
	GuaranteedChanceRollOutcome = 50,
	Attribute = 51,
	IgnoreLeaveAttackRange = 52,
	GameplayLight = 53,
	DialogueBlock = 54,
	DualWielding = 55,
	Savant = 56,
	MinimumRollResult = 57,
	Lootable = 58,
	CharacterWeaponDamage = 59,
	ProjectileDeflect = 60,
	AbilityOverrideMinimum = 61,
	ACOverrideFormula = 62,
	FallDamageMultiplier = 63,
	ActiveCharacterLight = 64,
	Invisibility = 65,
	TwoWeaponFighting = 66,
	WeaponAttackTypeOverride = 67,
	WeaponDamageDieOverride = 68,
	CarryCapacityMultiplier = 69,
	WeaponProperty = 70,
	WeaponAttackRollAbilityOverride = 71,
	BlockTravel = 72,
	BlockGatherAtCamp = 73,
	BlockAbilityModifierDamageBonus = 74,
	VoicebarkBlock = 75,
	HiddenDuringCinematic = 76,
	SightRangeAdditive = 77,
	SightRangeMinimum = 78,
	SightRangeMaximum = 79,
	SightRangeOverride = 80,
	CannotBeDisarmed = 81,
	MovementSpeedLimit = 82,
	NonLethal = 83,
	UnlockSpellVariant = 84,
	DetectDisturbancesBlock = 85,
	BlockAbilityModifierFromAC = 86,
	ScaleMultiplier = 87,
	CriticalDamageOnHit = 88,
	DamageReduction = 89,
	ReduceCriticalAttackThreshold = 90,
	PhysicalForceRangeBonus = 91,
	ObjectSize = 92,
	ObjectSizeOverride = 93,
	ItemReturnToOwner = 94,
	AiArchetypeOverride = 95,
	ExpertiseBonus = 96,
	EntityThrowDamage = 97,
	WeaponDamageTypeOverride = 98,
	MaximizeHealing = 99,
	IgnoreEnterAttackRange = 100,
	DamageBonus = "DamageBonusBoost", -- Condition
	Detach = 102,
	ConsumeItemBlock = 103,
	AdvanceSpells = 104,
	SpellResistance = 105,
	WeaponAttackRollBonus = 106,
	SpellSaveDC = 107,
	RedirectDamage = 108,
	CanSeeThrough = 109,
	CanShootThrough = 110,
	CanWalkThrough = 111,
	MonkWeaponAttackOverride = 112,
	MonkWeaponDamageDiceOverride = 113,
	IntrinsicSummonerProficiency = 114,
	HorizontalFOVOverride = 115,
	CharacterUnarmedDamage = 116,
	UnarmedMagicalProperty = 117,
	ActionResourceReplenishTypeOverride = 118,
	AreaDamageEvade = 119,
	ActionResourcePreventReduction = 120,
	AttackSpellOverride = 121,
	Lock = 122,
	NoAOEDamageOnLand = 123,
	IgnorePointBlankDisadvantage = 124,
	CriticalHitExtraDice = 125,
	DodgeAttackRoll = 126,
	GameplayObscurity = 127,
	MaximumRollResult = 128,
	UnlockInterrupt = 129,
	IntrinsicSourceProficiency = 130,
	JumpMaxDistanceBonus = 131,
	ArmorAbilityModifierCapOverride = 132,
	IgnoreResistance = 133,
	ConcentrationIgnoreDamage = 134,
	LeaveTriggers = 135,
	IgnoreLowGroundPenalty = 136,
	IgnoreSurfaceCover = 137,
	EnableBasicItemInteractions = 138,
	SoundsBlocked = 139,
	ProficiencyBonusIncrease = 140,
	NoDamageOnThrown = 141,
	DamageTakenBonus = 142,
	ReceivingCriticalDamageOnHit = 143,
}

---@class QuickBoostData
---@field ID string Status Name
---@field Data ECStatStatus
---@field Lifetime number Duration
---@field Dynamic boolean Whether it was found in StatusManager or not, likely dynamic if true

---@param entity EntityHandle
---@return table<BoostType, QuickBoostData> # BoostType-indexed QuickBoostData 
function BoostCrafter:_gatherBoosts(entity)
    if entity == nil then ECWarn("BoostCrafter: Tried to get boosts without a given entity.") return {} end
    if entity.BoostsContainer == nil then return {} end

    local boostTable = {}
    for _,boostBucket in ipairs(entity.BoostsContainer.Boosts) do
        boostTable[boostBucket.Type] = {}
        for i, boost in ipairs(boostBucket.Boosts) do
            local serailizedInfo = Ext.Types.Serialize(boost.BoostInfo)
            if serailizedInfo ~= nil then
                local quickBoostData = {}

                boostTable[boostBucket.Type][i] = serailizedInfo
            else
                local params = boost.BoostInfo.Params
                ECWarn("What is this Boost? %s [%s] %s(%s,%s)", boost, boostBucket.Type, params.Boost, params.Params, params.Params2)
            end
        end
    end

    return boostTable
end

---comment
---@param treeParent ExtuiTreeParent
---@param data any
function BoostCrafter:GenericDisplay(treeParent, data)
    if treeParent == nil or data == nil then return end
    if type(data) == "string" or type(data) == "number" or type(data) == "boolean" or type(data) == "userdata" then
        treeParent:AddText(tostring(data)).SameLine = true
    elseif type(data) == "table" then
        for k, v in pairs(data) do
            if not string.find(k, "field") and v ~= nil and v ~= Helpers.Format.NullUuid and v ~= "" then
                treeParent:AddText(k).PositionOffset = {20,0}
                self:GenericDisplay(treeParent, v)
            end
        end
    end
end

function BoostCrafter:RegenerateBoostInfo()
    if self.TreeParent == nil then return end
    local entity = self:_characterCheckAndClear(nil, self.TreeParent )
    if entity == nil then return end

    local tbl = self:_gatherBoosts(entity)
    -- ECDump(tbl)
    for k, v in table.pairsByKeys(tbl) do
        Imgui.SetChunkySeparator(self.TreeParent:AddSeparatorText(k))
        for _,boost in pairs(v) do
            local serialized = type(boost) == "userdata" and Ext.Types.Serialize(boost) or boost
            local imtbl = self.TreeParent:AddTable(k,2)
            imtbl.SizingFixedFit = true
            imtbl.Borders = true
            imtbl.RowBg = true
            imtbl.NoClip = true
            for key,data in pairs(serialized) do
                if not string.find(key, "field") and not string.find(key, "Owner") then
                    local row = imtbl:AddRow()
                    row:AddCell():AddText(key)
                    self:GenericDisplay(row:AddCell(), data)
                end
            end
        end
        Imgui.SetChunkySeparator(self.TreeParent:AddSeparator())
    end
end

--#TODO stashed working alternate