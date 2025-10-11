RequireFiles("Server/", {
   "EventHandlers",
   "EntityEditor",
})

-- When the game is started, load the MCM settings
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "before", EHandlers.OnLevelGameplayStarted)
Ext.Events.ResetCompleted:Subscribe(EHandlers.OnResetCompleted)

Ext.Osiris.RegisterListener("DB_PartyMembers", 1, "after", EHandlers.OnPartyMembersChanged)
Ext.Osiris.RegisterListener("DB_PartyMembers", 1, "afterDelete", EHandlers.OnPartyMembersChanged)

-- TODO Subscribe to current player and track+subscribe to entity changes
Ext.Osiris.RegisterListener("GainedControl", 1, "after", EHandlers.OnCharacterChange)

Ext.RegisterNetListener(ECChannels.DoCheat, EHandlers.OnClientRequestCheat)
Ext.RegisterNetListener(ECChannels.RequestPartyUpdate, EHandlers.OnRequestPartyUpdate)
Ext.RegisterNetListener(ECChannels.RequestRelationshipStatus, EHandlers.OnRequestRelationshipStatus)
Ext.RegisterNetListener(ECChannels.UpdateTargetEntities, EHandlers.OnClientUpdateTargetEntities)
Ext.RegisterNetListener(ECChannels.SpawnItem, EHandlers.OnClientSpawnItemRequest)
Ext.RegisterNetListener(ECChannels.RequestToggleHostOnly, EHandlers.OnRequestHostOnlyToggle)

Ext.RegisterNetListener(ECChannels.RequestCharacterChange, EHandlers.OnRequestCharacterChange)
Ext.RegisterNetListener(ECChannels.RequestItemVisualFix, EHandlers.OnRequestItemVisualFix)
Ext.RegisterNetListener(ECChannels.ChangeDailyBuffs, EHandlers.OnRequestChangeDailyBuffs)
Ext.RegisterNetListener(ECChannels.RequestPreviewItem, EHandlers.OnRequestPreviewItem)

--Message handler for when the (IMGUI) client requests a setting to be set
--Ext.RegisterNetListener(CMChannels.MCM_CLIENT_REQUEST_SET_SETTING_VALUE, EHandlers.OnClientRequestSetSettingValue)

-- Ext.RegisterNetListener("MCM_Saved_Setting", function(call, payload)
--    local data = Ext.Json.Parse(payload)
--    if not data or data.modGUID ~= ModuleUUID or not data.settingId then
--        return
--    end

--    if data.settingId == "ec_HostOnlyToggle" then
--        ECDebug("Setting Host-only toggle to ", tostring(data.Value))
--        
--    end
-- end)

-- Stat spells
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(character, status, source, _)
    if status == "JUSTDIEALREADY" then
        -- remove immortality if it exists
        Osi.SetImmortal(character, 0)
        -- flag dying
        Osi.Dying(character)
        -- kill and attribute death to caster of kill spell
        Osi.Die(character, 3, source, 1, 0, 0)
        
        --get rid of crimes if guards were killed? probably needs a delay
        for _, v in ipairs(Osi.DB_CRIME_GuardKiller:Get(nil, nil, nil, nil, nil, nil, nil)) do
            Osi.CrimeSuspend(v[7])
            print(v[7])
        end
        Osi.RemoveStatus(source, "GB_GUARDKILLER")
        Osi.DB_CRIME_GuardKiller:Delete(nil, nil, nil, nil, nil, nil, nil)
    end
end)
---@param character CHARACTER
---@param forceApply boolean?
local function ApplyDailyBuffs(character, forceApply)
    if not character or character == "" then return end
    -- ECDebug("Long rest triggered.")
    local vars
    vars = Helpers.ModVars:Get(ModuleUUID)

    if vars and vars[ModVarIDs.DailyBuffs] and (forceApply or vars[ModVarIDs.DailyBuffs].Apply) then
        local dbuffs
        dbuffs = vars[ModVarIDs.DailyBuffs]
        ECPrint("Applying daily buffs to %s", Helpers.Loca:GetDisplayName(character) or string.format("Unknown(%s)", character or "Unknown"))
        Helpers.Timer:OnTime(3000, function()
            local charLevel = Osi.GetLevel(character) or 1
            -- ECDebug("Character level: %d", charLevel)
            local accessibleSpellLevel = math.min(math.ceil(charLevel*0.5), 9) -- 1~9
            
            for statusName, buffData in pairs(dbuffs.Buffs) do
                if buffData[tostring(accessibleSpellLevel)] then
                    Osi.ApplyStatus(character, statusName, -1)
                end
            end
            Helpers.Timer:OnTime(2000, function()
                -- delay upcasts/aid
                for _, buffData in pairs(dbuffs.Upcasting) do
                    if buffData[tostring(accessibleSpellLevel)] then
                        --ECPrint("Applying: %s", buffData[tostring(accessibleSpellLevel)])
                        Osi.ApplyStatus(character, buffData[tostring(accessibleSpellLevel)], -1)
                    end
                end
            end)
        end)
    end
end

---@param character CHARACTER
-- -@param isFullRest integer
Ext.Osiris.RegisterListener("UserCharacterLongRested", 2, "after", function(character, _)
    ApplyDailyBuffs(character)
end)
Ext.RegisterNetListener(ECChannels.ApplyDailyBuffs, function(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = payload ~= nil and payload ~= "" and Ext.Json.Parse(payload) or {}
    local entityUuid = p.Character
    if entityUuid ~= nil then
        -- apply to just one character
        ApplyDailyBuffs(entityUuid, true)
    else
        -- apply to all characters
        for _, v in ipairs(Ext.Entity.GetAllEntitiesWithComponent("PartyMember")) do
            local uuid = Helpers.Object:GetGuid(v)
            if uuid then
                ApplyDailyBuffs(uuid, true)
            end
        end
    end
end)