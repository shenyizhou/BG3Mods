setmetatable(Mods.AahzEasyCheat, {__index = Mods.AahzLib})

UserVarIDs = {}
UserVarIDs.ItemPreview = "EC_ItemPreviewData"

ModVarIDs = {}
ModVarIDs.HostOnlyCheats = "HostOnlyCheats"
ModVarIDs.StayClean = "StayClean"
ModVarIDs.DailyBuffs = "DailyBuffs"
ModVarIDs.DisableFog = "DisableFog"

Helpers.ModVars:Register(ModVarIDs.HostOnlyCheats, ModuleUUID, 1, {
    Server = true,
    Client = true,
    SyncToClient = true,
}) -- 1 == true, 0 == false
Helpers.ModVars:Register(ModVarIDs.StayClean, ModuleUUID, 0, {
    Server = true,
    Client = true,
    SyncToClient = true,
})
Helpers.ModVars:Register(ModVarIDs.DisableFog, ModuleUUID, 0, {
    Server = true,
    Client = true,
    SyncToClient = true,
})
Helpers.UserVars:Register(UserVarIDs.ItemPreview)

--DevelReady = Ext.Utils:Version() >= 17 or Ext.Debug.IsDeveloperMode()

---Ext.Require files at the path
---@param path string
---@param files string[]
function RequireFiles(path, files)
    for _, file in pairs(files) do
        Ext.Require(string.format("%s%s.lua", path, file))
    end
end

RequireFiles("Shared/", {
    "MetaClass",
    "Helpers/_Init",
    "Classes/_Init",
    "ECChannels"
})
Helpers.ModVars:Register(ModVarIDs.DailyBuffs, ModuleUUID, CheatUtils.DailyBuffs.GetDefault(), {
    Server = true,
    Client = true,
    SyncToClient = true,
    DontCache = true,
})

-- NetChannels, new tech
DailyBuffNetChannel = Ext.Net.CreateChannel(ModuleUUID, "EasyCheat.DailyBuffs")
if Ext.IsServer() then
    -- Use RequestToServer()
    DailyBuffNetChannel:SetRequestHandler(function(args)
        ECPrint("DailyBuffNetChannel request received.")
        if args.Request == "Get" then
            local modvars = Helpers.ModVars:Get(ModuleUUID)
            local dailyBuffs = modvars[ModVarIDs.DailyBuffs]
        
            if table.isEmpty(dailyBuffs) then
                modvars[ModVarIDs.DailyBuffs] = CheatUtils.DailyBuffs.GetDefault() -- initialize
                dailyBuffs = modvars[ModVarIDs.DailyBuffs]
            end
            return {
                DailyBuffs = dailyBuffs,
            }
        end
        return {} -- empty response
    end)
    -- Use SendToServer()
    DailyBuffNetChannel:SetHandler(function(msg)
        ECPrint("DailyBuffNetChannel message received.")
        if msg.Request == "Set" then
            -- local modvars = Helpers.ModVars:Get(ModuleUUID) -- TODO
        end
    end)
end

--ECPrint(string.format("Done loading %s", ModVersion(ModuleUUID)))
--Ext.Stats.LoadStatsFile("Public\\EasyCheat\\Stats\\Generated\\Data\\EasyCheat.txt", 0)
Ext.Events.StatsLoaded:Subscribe(function()
    -- Add better effects if library mods are found
    if Ext.Mod.IsModLoaded("dd19db12-96c0-4bca-9ef6-e8d733801d23") then
        ECPrint("Shivero's mod found, editing spells")
        -- Shivero's mod required for certain cheat spell effects, disable if not present
        local diespell = Ext.Stats.Get("Target_PowerWordsDieAlready") --[[@as SpellData]]
        if diespell ~= nil then
            ECWarn("Edited Power Words: Die Already")
            -- Chaos NetherMistSphere Traj+Prepare+Cast
            diespell.Trajectories = "fc769c11-26f0-4476-8b1e-4375b3a9f9a4"
            diespell.PrepareEffect = "3c48812a-0efa-41dc-906a-fd3c92b60924"
            diespell.CastEffect = "de404880-a67b-42a5-940c-0ad5b4d069bc"
            --diespell:Sync()
        end
        local dieStatus = Ext.Stats.Get("JUSTDIEALREADY") --[[@as StatusData]]
        if dieStatus ~= nil then
            ECWarn("Edited Power Words: Die Already status")
            -- MistyStep Chaos
            dieStatus.StatusEffect = "71859b27-57e4-42ef-9118-34a7a6bca312"
            --dieStatus:Sync()
        end
    else
        --ECPrint("No shivero's mod")
    end

    -- Create daily buff stats if not found
    local aid7 = Ext.Stats.Get("AID_7")
    if not aid7 then
        aid7 = Ext.Stats.Create("AID_7", "StatusData", "AID_6", true) --[[@as StatusData]]
        aid7.Boosts = "IncreaseMaxHP(30)"
        aid7.DescriptionParams = "30"
        aid7:Sync()
    end
    local aid8 = Ext.Stats.Get("AID_8")
    if not aid8 then
        aid8 = Ext.Stats.Create("AID_8", "StatusData", "AID_6", true) --[[@as StatusData]]
        aid8.Boosts = "IncreaseMaxHP(35)"
        aid8.DescriptionParams = "35"
        aid8:Sync()
    end
    local aid9 = Ext.Stats.Get("AID_9")
    if not aid9 then
        aid9 = Ext.Stats.Create("AID_9", "StatusData", "AID_6", true) --[[@as StatusData]]
        aid9.Boosts = "IncreaseMaxHP(40)"
        aid9.DescriptionParams = "40"
        aid9:Sync()
    end
    
    -- back up any known vfx/sfx data for daily buff statuses to file, so they survive context reloads
    CheatUtils.DailyBuffs.BackupEffects()
    -- back up ExtraData for compatibility with other things editing it, eg- Carry Weight mods
    CheatUtils.BackupExtraData()
end)