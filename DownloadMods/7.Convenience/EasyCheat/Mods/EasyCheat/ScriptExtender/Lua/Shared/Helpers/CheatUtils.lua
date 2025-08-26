CheatUtils = {}

function CheatUtils.BackupExtraData()
    local ed = Ext.Stats.GetStatsManager().ExtraData
    local saveData = Ext.DumpExport(ed)
    if saveData ~= nil then
        Ext.IO.SaveFile("EasyCheat/CachedExtraData.json", saveData)
    end
end

---@return table<FixedString, number>|nil
function CheatUtils.GetCachedExtraData()
    local contents = Ext.IO.LoadFile("EasyCheat/CachedExtraData.json")
    if contents ~= nil then
        local success, data = pcall(Ext.Json.Parse, contents)
        if success then
            return data
        end
    end
end

function CheatUtils.SetStayCleanStats()
    local statman = Ext.Stats.GetStatsManager()
    statman.ExtraData.SplatterBloodPerAttack = 0
    statman.ExtraData.SplatterMaxBloodLimit = 0
    statman.ExtraData.SplatterMaxDirtLimit = 0
    statman.ExtraData.SplatterSweatDelta = 0

    -- Suds up the party to immediately clean
    -- Osi.RemoveSplatters(entity)
    local party = Osi.DB_PartyMembers:Get(nil)
    for _, v in pairs(party) do
        Osi.ApplyStatus(v[1], "SOAP_WASH", 0, 1)
    end
    Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.StayClean] = 1
    Helpers.ModVars:Sync(ModuleUUID)
end
function CheatUtils.UnsetStayCleanStats()
    local statman = Ext.Stats.GetStatsManager()
    statman.ExtraData.SplatterBloodPerAttack = 0.10000000149011612
    statman.ExtraData.SplatterMaxBloodLimit = 1.0
    statman.ExtraData.SplatterMaxDirtLimit = 0.89999997615814209
    statman.ExtraData.SplatterSweatDelta = 0.10000000149011612
    
    Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.StayClean] = 0
    Helpers.ModVars:Sync(ModuleUUID)
end

---@class CheatUtils_DailyBuffs
---@field AllBuffs table<string,integer>
---@field AllStatuses table<integer,string>
---@field StatusVFXSFX table
CheatUtils.DailyBuffs = {
    AllBuffs = {
        ["EC_FEATHER_FALL"] = 1,
        ["DARKVISION"] = 1,
        ["GUIDANCE"] = 1,
        ["LONGSTRIDER"] = 1,
        ["LONG_JUMP"] = 1,
        ["MAGE_ARMOR"] = 1,
        ["PETPAL"] = 1,
        ["DETECT_THOUGHTS"] = 2,
        ["PROTECTION_FROM_POISON"] = 2,
        ["ALCH_ELIXIR_BLOODLUST"] = 2,
        ["FREEDOM_OF_MOVEMENT"] = 4,
        ["DEATH_WARD"] = 4,
        ["HEROES_FEAST"] = 6,
    },
    AllStatuses = {
        "DARKVISION",
        "GUIDANCE",
        "LONGSTRIDER",
        "LONG_JUMP",
        "MAGE_ARMOR",
        "PETPAL",
        "DETECT_THOUGHTS",
        "PROTECTION_FROM_POISON",
        "ALCH_ELIXIR_BLOODLUST",
        "FREEDOM_OF_MOVEMENT",
        "DEATH_WARD",
        "HEROES_FEAST",
        "AID",
        "AID_3",
        "AID_4",
        "AID_5",
        "AID_6",
        "AID_7",
        "AID_8",
        "AID_9",
        "EC_FEATHER_FALL",
    },
    StatusVFXSFX = {
    }
}
---Creates a default DailyBuffs modvar table
---@return table
function CheatUtils.DailyBuffs.GetDefault()
    local tbl = {
        Apply = false,
        DisableSFX = false,
        DisableVFX = false,
        Upcasting = {
            ["AID"] = {
                ["2"] = "AID",
                ["3"] = "AID_3",
                ["4"] = "AID_4",
                ["5"] = "AID_5",
                ["6"] = "AID_6",
                ["7"] = "AID_7",
                ["8"] = "AID_8",
                ["9"] = "AID_9",
            }
        },
    }
    tbl.Buffs = {}
    for b, start in pairs(CheatUtils.DailyBuffs.AllBuffs) do
        tbl.Buffs[b] = {}
        for i = start, 9, 1 do
            tbl.Buffs[b][tostring(i)] = true
        end
    end
    return tbl
end
function CheatUtils.DailyBuffs.BackupEffects()
    for _, v in ipairs(CheatUtils.DailyBuffs.AllStatuses) do
        CheatUtils.DailyBuffs.StatusVFXSFX[v] = {}
        local status = Ext.Stats.Get(v) --[[@as StatusData]]
        if status ~= nil then
            CheatUtils.DailyBuffs.StatusVFXSFX[v].StatusEffect = status.StatusEffect
            CheatUtils.DailyBuffs.StatusVFXSFX[v].ManagedStatusEffectGroup = status.ManagedStatusEffectGroup
            CheatUtils.DailyBuffs.StatusVFXSFX[v].SoundLoop = status.SoundLoop
            CheatUtils.DailyBuffs.StatusVFXSFX[v].SoundVocalLoop = status.SoundVocalLoop
        end
    end
    -- save to file for safekeeping through context resets
    local saveData = Ext.DumpExport(CheatUtils.DailyBuffs.StatusVFXSFX)
    if saveData ~= nil then
        Ext.IO.SaveFile("EasyCheat/SessionBackupData.json", saveData)
        -- ECDebug("Backed up vfx/sfx")
        -- ECDumpS(CheatUtils.DailyBuffs.StatusVFXSFX)
    end
end
function CheatUtils.DailyBuffs.ReapplyEffects()
    -- Load backup if local cache is empty
    if table.isEmpty(CheatUtils.DailyBuffs.StatusVFXSFX) then
        local contents = Ext.IO.LoadFile("EasyCheat/SessionBackupData.json")
        if contents ~= nil then
            local success, data = pcall(Ext.Json.Parse, contents)
            if not success then
                --ECWarn("Invalid session data.")
            else
                CheatUtils.DailyBuffs.StatusVFXSFX = data
            end
        else
            --ECWarn("No session backup data found.")
        end
    end
    -- Apply effects according to modvars
    local dbuffs = Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.DailyBuffs]
    CheatUtils.DailyBuffs.ToggleEffects(dbuffs.DisableVFX, dbuffs.DisableSFX)
end
function CheatUtils.DailyBuffs.ToggleEffects(disableVfx, disableSfx)
    if table.isEmpty(CheatUtils.DailyBuffs.StatusVFXSFX) then
        return ECWarn("Cannot safely toggle vfx/sfx for buffs, no status backups.")
    end

    for _, v in ipairs(CheatUtils.DailyBuffs.AllStatuses) do
        local status = Ext.Stats.Get(v) --[[@as StatusData]]
        if status ~= nil then
            if disableVfx ~= nil and CheatUtils.DailyBuffs.StatusVFXSFX[v] ~= nil then
                if disableVfx then
                    CheatUtils.DailyBuffs.StatusVFXSFX[v].StatusEffect = status.StatusEffect
                    CheatUtils.DailyBuffs.StatusVFXSFX[v].ManagedStatusEffectGroup = status.ManagedStatusEffectGroup
                    status.StatusEffect = ""
                    status.ManagedStatusEffectGroup = ""
                else
                    status.StatusEffect = CheatUtils.DailyBuffs.StatusVFXSFX[v].StatusEffect
                    status.ManagedStatusEffectGroup = CheatUtils.DailyBuffs.StatusVFXSFX[v].ManagedStatusEffectGroup
                end
            end
            if disableSfx ~= nil and CheatUtils.DailyBuffs.StatusVFXSFX[v] ~= nil  then
                if disableSfx then
                    CheatUtils.DailyBuffs.StatusVFXSFX[v].SoundLoop = status.SoundLoop
                    CheatUtils.DailyBuffs.StatusVFXSFX[v].SoundVocalLoop = status.SoundVocalLoop
                    status.SoundLoop = ""
                    ---@alias SoundVocalType string
                    status.SoundVocalLoop = "NONE" --[[@as SoundVocalType]] -- unserialized? hmm
                else
                    status.SoundLoop = CheatUtils.DailyBuffs.StatusVFXSFX[v].SoundLoop
                    status.SoundVocalLoop = CheatUtils.DailyBuffs.StatusVFXSFX[v].SoundVocalLoop
                end
            end
            status:Sync()
        end
    end
end

PlayerLevel = {}
function PlayerLevel.GetLevelTable()
    local t = {}
    -- Ext.Stats.GetStatsManager().ExtraData.MaxXPLevel ?
    local statsman = Ext.Stats.GetStatsManager()
    for i = 1, 1000, 1 do
        local exp = statsman.ExtraData["Level"..i]
        if exp ~= nil then
            t[i] = exp
        else
            break
        end
    end
    return t
end

function PlayerLevel.ChangeExpAndLevelSafely(character, expToAdd)
    local e = type(character) == "string" and Ext.Entity.Get(character) or character
    if e == nil or e.Experience == nil then return ECWarn("No character provided for exp changes.") end

    -- if AvailableLevel == EocLevel and CurrentLevelExperience + expToAdd < 0, cap to 0
    if e.AvailableLevel.Level == e.EocLevel.Level and e.Experience.CurrentLevelExperience + expToAdd < 0 then
        expToAdd = 0 - e.Experience.CurrentLevelExperience
    end

    -- ECDebug("EOCLevel: "..e.EocLevel.Level)
    -- ECDebug("AvailableLevel: "..e.AvailableLevel.Level)
    -- ECDump(e.Experience)
    Osi.AddExplorationExperience(e.Uuid.EntityUuid, expToAdd)
    Helpers.Timer:OnTicks(3, function()
        -- Exp may be negative now if AvailableLevel was higher than EoCLevel, lower AvailableLevel and recalculate
        if e.AvailableLevel.Level > e.EocLevel.Level and e.Experience.CurrentLevelExperience < 0 then
            local levelTable = PlayerLevel.GetLevelTable()
            local expToCorrect = math.abs(e.Experience.CurrentLevelExperience)
            -- local previousLevel = e.AvailableLevel.Level
            e.AvailableLevel.Level = e.AvailableLevel.Level - 1
            e.Experience.CurrentLevelExperience = levelTable[e.AvailableLevel.Level] - expToCorrect
            local expUpToCurrent = 0
            if e.AvailableLevel.Level ~= 1 then
                for i = 1, e.AvailableLevel.Level-1, 1 do
                    expUpToCurrent = expUpToCurrent + levelTable[i]
                end
            end
            e.Experience.NextLevelExperience = expUpToCurrent + e.Experience.CurrentLevelExperience
            e.Experience.TotalExperience = expUpToCurrent + e.Experience.CurrentLevelExperience
        end
        e:Replicate("Experience")
        
        -- Ext.OnNextTick(function()
        --     ECDebug("EOCLevel: "..e.EocLevel.Level)
        --     ECDebug("AvailableLevel: "..e.AvailableLevel.Level)
        --     ECDump(e.Experience)
        -- end)
    end)
end