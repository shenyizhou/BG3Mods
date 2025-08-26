--[[#region
-- Entity specific/Party
--- [x] Level Up
--- [x] Break/Restore Oath
--- [x] Respec
--- [x] Mirror
--- [x] Go to Camp
--- [x] Add Gold
--- [x] Add Tadpoles
--- [x] Immortality toggle
--- [ ] (Maybe?)Clear Map fog
--- [ ] General/Party resources, Inspiration?
--- [ ] Carry Capacity increase toggle
--- [ ] Resurrect
--- [ ] Add/Remove Passives for crits (look into portent interrupts, SetRoll(1) SetRoll(20))
--- [ ] Disable Fall Damage (featherfall)
--- [ ] Give protection spell
--- [ ] Give elixir buffs

--TODO Collapseable Party Watch
--- [ ] Clean/dirty watch/toggle
--- [ ] Approval/Relationship/Dating
--- [ ] Staged/Stuck/TeleportToMe
--- [ ] In dialog watch
--- [ ] In combat watch
--TODO Action Resources
--- [ ] Restore and watch spell slots, individually with rollout
--- [ ] Restore and watch Action/Bonus/Reaction
--#endregion]]--

--FIXME reorganize so this isn't so gross
--#region Levelup
CheatManager.Cheats["LevelUp"].ClientUI = function (treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("ha6ed1b5f4fc746b8b900cbf229d463bed64a"), "LevelUp", Ext.Loca.GetTranslatedString("h67d530b0fd6a44dea6b37b58c7e95493bead"))
end
CheatManager.Cheats["LevelUp"].ServerCode = function (entity, args)
    local e = Ext.Entity.Get(entity)
    -- ECDebug("EOCLevel: "..e.EocLevel.Level)
    -- ECDebug("AvailableLevel: "..e.AvailableLevel.Level)
    -- ECDump(e.Experience)
    if e.AvailableLevel.Level <= e.EocLevel.Level then
        Osi.PROC_LevelUpBy(entity, 1)
    else
        -- Needs to be capped at max level or crash
        --e.AvailableLevel.Level = e.AvailableLevel.Level + 1
    end
    -- ECDebug("EOCLevel: "..e.EocLevel.Level)
    -- ECDebug("AvailableLevel: "..e.AvailableLevel.Level)
    -- ECDump(e.Experience)
    --[[
    Notes:
    EocLevel.Level should match #LevelUp.LevelUps
    LevelUp.LevelUps == CCLevelUp.LevelUps
    When reaching exp threshold
    -> AvailableLevel.Level increases by 1
    -> Experience.CurrentLevelExperience gets set to 0 again (+overflow exp)

    
    -- THIS: Calculates exp to level up and gives exp to entity
    Osi.PROC_LevelUpBy()
    -- NOT: entity.AvailableLevel.Level = entity.AvailableLevel.Level + 1
    ]]--
end --#endregion

--#region GiveGold
CheatManager.Cheats["GiveGold"].ClientUI = function (treeParent)
    local goldbutton, slider = ImguiHelpers:CreateIntSlider(treeParent, Ext.Loca.GetTranslatedString("he736a96c17144cd081ab5cfe8dff8cdb2ff4"), {1000, -1000, 5000}, 250, "Gold")
    goldbutton.OnClick = function()
        --ECPrint("Attempting to give %d gold", slider.Value[1])
        StatusNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("h2c64c6606a7e43979e3510c110ed153b65e7"), slider.Value[1]), 1, StatusNotify.DefaultFadeTime)
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats["GiveGold"].Name, Args = { Amount = slider.Value[1] }}))
    end
end
CheatManager.Cheats["GiveGold"].ServerCode = function(entity, args)
    --ECDebug("Entity: %s, Amount: %s", entity, args.Amount)
    Osi.AddGold(entity, args.Amount)
end --#endregion

--#region GiveExperience
CheatManager.Cheats["GiveExperience"].ClientUI = function(treeParent)
    local giveexpbutton, slider = ImguiHelpers:CreateIntSlider(treeParent, Ext.Loca.GetTranslatedString("hb7605d085ff94360887f6b44304faf491b5b"), {1000, -300, 10000}, 200, "Exp")
    giveexpbutton.OnClick = function()
        --ECPrint("Attempting to give %d exp", slider.Value[1])
        StatusNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("h8862405978384b6ba49fb3a53585e8b296f3"), slider.Value[1]), 1, StatusNotify.DefaultFadeTime)
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats["GiveExperience"].Name, Args = { Amount = slider.Value[1] }}))
    end
end
CheatManager.Cheats["GiveExperience"].ServerCode = function (entity, args)
    PlayerLevel.ChangeExpAndLevelSafely(entity, args.Amount)
end --#endregion

--#region GiveTadpole
CheatManager.Cheats["GiveTadpole"].ClientUI = function(treeParent)
    local giveexpbutton, slider = ImguiHelpers:CreateIntSlider(treeParent, Ext.Loca.GetTranslatedString("h0650fea7f10f4a44a1f32c7c24262bf1c792"), {1, -5, 10}, 1, "Tadpole")
    giveexpbutton.OnClick = function()
        --ECPrint("Attempting to give %d tadpole", slider.Value[1])
        StatusNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("h16151fe7388e4778a5c4da46229ce754a2a8"), slider.Value[1]), 1, StatusNotify.DefaultFadeTime)
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats["GiveTadpole"].Name, Args = { Amount = slider.Value[1] }}))
    end
end
CheatManager.Cheats["GiveTadpole"].ServerCode = function (entity, args)
    Osi.AddTadpole(entity, args.Amount)
end --#endregion

--#region GiveInspiration
CheatManager.Cheats["GiveInspiration"].ClientUI = function(treeParent)
    local giveinspbutton, slider = ImguiHelpers:CreateIntSlider(treeParent, Ext.Loca.GetTranslatedString("h0f32c9477cd34e7895bbccd050b713cdc7a9"), {1, -1, 4}, 1, "Inspiration")
    slider.AlwaysClamp = true
    giveinspbutton.OnClick = function()
        --ECPrint("Attempting to give %d tadpole", slider.Value[1])
        StatusNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("he2051fd8dc864f18bde7c86358d94e7c1a79"), slider.Value[1]), 1, StatusNotify.DefaultFadeTime)
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats["GiveInspiration"].Name, Args = { Amount = slider.Value[1] }}))
    end
end
CheatManager.Cheats["GiveInspiration"].ServerCode = function (entity, args)
    Osi.PartyIncreaseActionResourceValue(entity, "InspirationPoint", args.Amount) -- should allow negatives
    -- Osi.GiveInspirationPoints(entity, args.Amount, "", "")
end --#endregion

--#region BreakOath
CheatManager.Cheats["BreakOath"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h71361de328a34bcb84d9ee66a654af5750bb"), "BreakOath", Ext.Loca.GetTranslatedString("hffee0fe2fbe4412d8140c327d5e9d480gd76"))
end
CheatManager.Cheats["BreakOath"].ServerCode = function (entity, args)
    Osi.PROC_GLO_PaladinOathbreaker_BrokeOath(entity)
    Osi.ApplyStatus(entity, "PASSIVE_BANE", 3)
    --Osi.PROC_GLO_PaladinOathbreaker_BecomesOathbreaker(entity)
    --Osi.ApplyStatus(entity, "PALADIN_OATH_BROKEN", -1)
end-- #endregion

--#region RestoreOath
CheatManager.Cheats["RestoreOath"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h5305cf0e8d72458ea416448c0c5499a1ge7g"), "RestoreOath", Ext.Loca.GetTranslatedString("hc85050d6ba45431285c1849b4e1ed649e9e8"))
end
CheatManager.Cheats["RestoreOath"].ServerCode = function (entity, args)
    Osi.ApplyStatus(entity, "COL_RITUALCANDLE_VFX", 3)
    Osi.PROC_GLO_PaladinOathbreaker_RedemptionObtained(entity)
end-- #endregion

--#region Respec
CheatManager.Cheats["Respec"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h74ac7c6bc9454f5e93877c31a53ea76e365g"), "Respec", Ext.Loca.GetTranslatedString("h3b9566dd36f14775a7c4a9ac8fee2d6f5dc0"))
end
CheatManager.Cheats["Respec"].ServerCode = function (entity, args)
    Osi.StartRespec(entity)
end-- #endregion

--#region Mirror
CheatManager.Cheats["Mirror"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h070498aa2ae1408ca69f19c8d9c22494cafe"), "Mirror", Ext.Loca.GetTranslatedString("ha6b51a091f974e78ac8f8d4133f1e90dfb25"))
end
CheatManager.Cheats["Mirror"].ServerCode = function (entity, args)
    Osi.StartChangeAppearance(entity)
end-- #endregion

--#region Long Rest
CheatManager.Cheats["RestLong"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h3252bf52030a4f3c8d6c94c9079a8517aa7f"), "RestLong", Ext.Loca.GetTranslatedString("h7c95b0a2f919475ab3c35b4552bccf438c1e"))
end
CheatManager.Cheats["RestLong"].ServerCode = function (entity, args)
    --Osi.RestoreParty(entity) meh
    -- flag long rest event?
    Helpers.Character:FullRestoreEntity(entity)
    Osi.UserCharacterLongRested(entity, 1)
    Osi.ShortRested(entity)
    -- use ShortRested for vfx/sfx until custom vfx/sfx
end-- #endregion

--#region Short Rest
CheatManager.Cheats["RestShort"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h535cc3796a4342f59554aa2a0c160d01f631"), "RestShort", Ext.Loca.GetTranslatedString("hac2dcfefe95c4b7381e7be6e710d043d8da0"))
end
CheatManager.Cheats["RestShort"].ServerCode = function (entity, args)
    --ECWarn("Not implemented: %s", cheat)
    --mindful of Durable feat, font of inspiration
    -- flag short rest event?
    Helpers.Character:ShortRestEntity(entity)
    Osi.ShortRested(entity)
end-- #endregion

--#region TeleportCamp
CheatManager.Cheats["TeleportCamp"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h3fd5e866c1344680975cebafaa80572854a7"), "TeleportCamp", Ext.Loca.GetTranslatedString("h0733fc3609e6429aa7fc5a2ec0c67fd14f03"))
end
CheatManager.Cheats["TeleportCamp"].ServerCode = function (entity, args)
    Helpers.Character:TeleportToCamp(entity)
end-- #endregion

--#region Immortality
CheatManager.Cheats["Immortality"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("haf4d9273f7e94f32869f1571e372c77c3fb8"), "Immortality", Ext.Loca.GetTranslatedString("h0b69729cc8a44b398160fc21cba6b9734fc0"))
end
CheatManager.Cheats["Immortality"].ServerCode = function (entity, args)
    if Osi.IsImmortal(entity) == 1 then
        Osi.RemoveStatus(entity, "LOW_RAPHAEL_SOUL_UNSTABLE")
        Osi.RemoveStatus(entity, "INVULNERABLE")
        Osi.SetImmortal(entity, 0)
    else
        Osi.ApplyStatus(entity, "LOW_RAPHAEL_SOUL_UNSTABLE", 6)
        Osi.ApplyStatus(entity, "INVULNERABLE", -1)
        Osi.SetImmortal(entity, 1)
    end
end-- #endregion
--#region Revive
CheatManager.Cheats["Revive"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h5c34c4560eb14c3f8d0ae3192691d55b5dce"), "Revive", Ext.Loca.GetTranslatedString("hc06b88ae2e23419fa141b6b42adee87a7ea7"))
end
CheatManager.Cheats["Revive"].ServerCode = function (entity, args)
    Osi.ApplyStatus(entity, "GLO_JERGAL_RESURRECTION_END_VFX", 0)
    Osi.Resurrect(entity)
end-- #endregion

--#region DisableFallDamage
CheatManager.Cheats["DisableFallDamage"].ClientUI = function(treeParent)
    return ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("h9721dad1a01141e99a470673143ef8cd292e"), "DisableFallDamage", Ext.Loca.GetTranslatedString("h6bf35cf72c1c4c469dcdecf0eefb26e8ba28"))
end
CheatManager.Cheats["DisableFallDamage"].ServerCode = function (entity, args)
    --ECWarn("Not implemented: %s", cheat)
    --mindful of Durable feat, font of inspiration
    -- flag short rest event?
    if Osi.HasActiveStatus(entity, "EC_FEATHER_FALL") == 1 then
        Osi.RemoveStatus(entity, "EC_FEATHER_FALL")
        Osi.ApplyStatus(entity, "Lightsource_Quest_CMB_StalkBulb", 0)
    else
        Osi.ApplyStatus(entity, "EC_FEATHER_FALL", -1)
        Osi.ApplyStatus(entity, "LOOT_CORPSE_DUMMY_VFX", 0)
    end
end-- #endregion

CheatManager.Cheats["Teleport"].ServerCode = function(entity, args)
    -- May be useful:
    -- PROC_Debug_ORI_GoToLevel(STRING)
    local e = Ext.Entity.Get(entity)
    --if e.CanTravel.ErrorFlags & Ext.Enums.TravelErrorFlags.Dialog == Ext.Enums.TravelErrorFlags.Dialog then return end
    if args.Act ~= nil then
        return Osi.PROC_TeleportPartiesTo(args.Trigger, "")
    end
    if e.Level ~= nil and e.Level.LevelName ~= args.LevelName then
        -- not on the same level as given, Teleport to Level
        ECWarn("Teleporting to new area, an additional teleport may be necessary to reach the intended position.")
        return Osi.TeleportPartiesToLevelWithMovie(args.LevelName, "", "")
    end
    if args.Position ~= nil and e.Level ~= nil and e.Level.LevelName == args.LevelName then
        local x1,y1,z1 = Osi.GetPosition(entity)
        local x2,y2,z2 = table.unpack(args.Position)

        -- ECWarn("Doing Teleport {%.04f,%.04f,%.04f} to {%.04f,%.04f,%.04f}", x1, y1, z1, x2, y2, z2)
        -- ECDebug("Direction0: %s\nDirection1: %s\nDirection2: %s",
        --     table.concat(args.Direction0,", "), table.concat(args.Direction1,", "), table.concat(args.Direction2, ", "))
        -- local m = Ext.Math.BuildFromEulerAngles3(args.Direction1)
        -- ECDebug("Matrix:\n\t%.6f, %.6f, %.6f\n\t%.6f, %.6f, %.6f\n\t%.6f, %.6f, %.6f", table.unpack(m))
        -- local aheadPos0 = Ext.Math.Add(args.Position, args.Direction0)
        -- Osi.RequestPing(aheadPos0[1], aheadPos0[2], aheadPos0[3],"", "")
        -- local aheadPos1 = Ext.Math.Add(args.Position, args.Direction1)
        -- Osi.RequestPing(aheadPos1[1], aheadPos1[2], aheadPos1[3],"", "")
        -- local aheadPos2 = Ext.Math.Add(args.Position, args.Direction2)
        -- Osi.RequestPing(aheadPos2[1], aheadPos2[2], aheadPos2[3],"", "")
        -- -- InvisibleHelper_A: 4cc75168-a81e-4a5c-85cd-1bab8d7bb641
        -- -- InvisibleHelper_H: 0a0c1e0f-60a9-493f-a98b-d761187c7d38
        -- -- TeleportTrigger RT: f7bd7465-b0ec-45b3-81f6-6f01d6c68c48
        -- for i = 1, 5, 1 do
        --     local startobj = Osi.CreateAt("0a0c1e0f-60a9-493f-a98b-d761187c7d38", x1+(i*args.Direction1[1]), y1+(i*args.Direction1[2]), z1+(i*args.Direction1[3]), 1, 0, "")
        --     Helpers.Timer:OnTicks(i+(i*2), function(t)
        --         Osi.ApplyStatus(startobj, "LOW_CAZADORSPALACE_SARCOPHAGUS_BEAM_001", 6)
        --         Helpers.Timer:OnTicks(20, function() Osi.RequestDelete(startobj) end)
        --     end)
        -- end
        -- TODO: teleport helperobj to position, then teleport entity to helperobj
        local helperobj = Osi.CreateAt("4cc75168-a81e-4a5c-85cd-1bab8d7bb641", x2, y2, z2, 1, 0, "")
        --Osi.SteerTo(entity, helperobj, 1)
        Osi.LookAtEntity(entity, helperobj, 1)
        --PROC_FaceCharacter(CHARACTER, GUIDSTRING)
        --PROC_FaceEachother(CHARACTER, CHARACTER)
        --Osi.RequestPing(x2,y2,z2, helperobj, entity)
        --Osi.ApplyStatus(entity, "MIST_FORM_VAMPIRE_REMOVE_VFX", 1)
        Osi.ApplyStatus(entity, "INTERRUPT_CUTTING_WORDS_TARGET", 0)
        Helpers.Timer:OnTicks(5, function()
            --Osi.AppearAtPosition(entity, x2, y2, z2, 0, Helpers.Format.NullUuid, "") -- only works on living entities
            --Osi.TeleportToPosition(entity, x2, y2, z2)
            -- linked/followers/summons args are ignored by Osi.TeleportToPosition(). Neat
            Osi.TeleportToPosition(entity, x2, y2, z2, "ECTeleport", args.BringLinked and 1 or 0, args.BringFollowers and 1 or 0, args.BringSummons and 1 or 0)
            ECPrint("Teleporting to: %.6f, %.6f, %.6f", x2, y2, z2)
            if helperobj ~= nil then
                Osi.RequestDelete(helperobj)
            end
        end)
    else
        if args.Trigger ~= nil then
            ECPrint("Teleporting to: "..args.Trigger)
            -- Have to be in the correct region
            --PROC_Debug_TeleportToAct(STRING)
            -- PROC_Debug_ORI_GoToLevel(STRING)
            -- Possibly set trigger in DB_WaypointTravel_RegionswapDestination to automatically go to after region change?
            Osi.PROC_TeleportPartiesTo(args.Trigger, "")
        else
            Osi.TeleportPartiesToLevelWithMovie(args.LevelName, "", "")
            ECWarn("Tried to trigger teleport, but no Trigger provided")
        end
    end
end

CheatManager.Cheats["StayClean"].ClientUI = function (treeParent)
    local context = string.format("%s%sbutton", treeParent.IDContext, "StayClean")
    local button = treeParent:AddButton(Ext.Loca.GetTranslatedString("hd411ececf2f04ef1a2aa7f3fbeab4a618727"))
    button.IDContext = context
    
    Helpers.Timer:OnTicks(5, function()
        -- Has to be delayed so modvars has time to sync on first load
        local stayClean = Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.StayClean]
        local isCurrentlyOn = stayClean == 1
        --ECDebug("IS CURRENTLY ON: %s", isCurrentlyOn)
        button.Label = string.format(Ext.Loca.GetTranslatedString("hc6ee3f53698848a99682e44402ea9a220219").." %s", isCurrentlyOn and Ext.Loca.GetTranslatedString("h1c1c3537fa794b8d81131bb4ee4071e108ed") or Ext.Loca.GetTranslatedString("hacb89347b34746f886c9dd249b6004a715a6"))
        button:SetColor("Button", isCurrentlyOn and Imgui.Colors.Olive or Imgui.Colors.BG3Brown)
    end)
    
    ---@param b ExtuiButton
    button.OnClick = function(b)
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats["StayClean"].Name}))
        local sc = Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.StayClean]
        local isOn = sc == 1
        isOn = not isOn -- toggle
        --ECDebug("Toggling StayClean: %s", isOn)
        local statusMessage = string.format(Ext.Loca.GetTranslatedString("hd5b591f96e7b4388bbb8ec25621f698bff0c").." %s", isOn and Ext.Loca.GetTranslatedString("h1c1c3537fa794b8d81131bb4ee4071e108ed") or Ext.Loca.GetTranslatedString("hacb89347b34746f886c9dd249b6004a715a6"))
        
        b.Label = string.format(Ext.Loca.GetTranslatedString("hc6ee3f53698848a99682e44402ea9a220219").." %s", isOn and Ext.Loca.GetTranslatedString("h1c1c3537fa794b8d81131bb4ee4071e108ed") or Ext.Loca.GetTranslatedString("hacb89347b34746f886c9dd249b6004a715a6"))
        b:SetColor("Button", isOn and Imgui.Colors.Olive or Imgui.Colors.BG3Brown)
        StatusNotify:NewStatus(statusMessage, isOn and 1 or 0, StatusNotify.DefaultFadeTime)
    end
end
---The idea of staying clean (no blood spatter) is in global ExtraData
---@param entity CHARACTER
---@param args table<any>
CheatManager.Cheats["StayClean"].ServerCode = function(entity, args)
    if Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.StayClean] == 1 then
        -- currently clean, toggle off
        ECPrint("Unsetting StayClean Stats")
        CheatUtils.UnsetStayCleanStats()
    else
        -- currently off, toggle on
        ECPrint("Setting StayClean Stats")
        CheatUtils.SetStayCleanStats()
    end
end

CheatManager.Cheats["DisableFog"].ClientUI = function (treeParent)
    local context = string.format("%s%sbutton", treeParent.IDContext, "DisableFog")
    local button = treeParent:AddButton(Ext.Loca.GetTranslatedString("h469b3065fd354d1d87bb6551247b34ae5fa8", "Disable Map Fog:"))
    button.IDContext = context
    
    Helpers.Timer:OnTicks(5, function()
        -- Has to be delayed so modvars has time to sync on first load
        local disableFog = Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.DisableFog]
        local isCurrentlyOn = disableFog == 1
        --ECDebug("IS CURRENTLY ON: %s", isCurrentlyOn)
        button.Label = string.format(Ext.Loca.GetTranslatedString("h469b3065fd354d1d87bb6551247b34ae5fa8", "Disable Map Fog:").." %s",
            isCurrentlyOn and Ext.Loca.GetTranslatedString("h1c1c3537fa794b8d81131bb4ee4071e108ed")
            or Ext.Loca.GetTranslatedString("hacb89347b34746f886c9dd249b6004a715a6"))
        button:SetColor("Button", isCurrentlyOn and Imgui.Colors.Olive or Imgui.Colors.BG3Brown)
    end)
    
    ---@param b ExtuiButton
    button.OnClick = function(b)
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats["DisableFog"].Name}))
        local sc = Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.DisableFog]
        local isOn = sc == 1
        isOn = not isOn -- toggle
        --ECDebug("Toggling DisableFog: %s", isOn)
        local statusMessage = string.format(Ext.Loca.GetTranslatedString("h4410f638356446078b980fa17872256b0bd3", "Toggling map fog (global):").." %s",
            isOn and Ext.Loca.GetTranslatedString("h1c1c3537fa794b8d81131bb4ee4071e108ed")
            or Ext.Loca.GetTranslatedString("hacb89347b34746f886c9dd249b6004a715a6"))
        
        b.Label = string.format(Ext.Loca.GetTranslatedString("h469b3065fd354d1d87bb6551247b34ae5fa8", "Disable Map Fog:").." %s",
            isOn and Ext.Loca.GetTranslatedString("h1c1c3537fa794b8d81131bb4ee4071e108ed")
            or Ext.Loca.GetTranslatedString("hacb89347b34746f886c9dd249b6004a715a6"))
        b:SetColor("Button", isOn and Imgui.Colors.Olive or Imgui.Colors.BG3Brown)
        StatusNotify:NewStatus(statusMessage, isOn and 1 or 0, StatusNotify.DefaultFadeTime)
    end
end
---The idea of staying clean (no blood spatter) is in global ExtraData
---@param entity CHARACTER
---@param args table<any>
CheatManager.Cheats["DisableFog"].ServerCode = function(entity, args)
    if Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.DisableFog] == 1 then
        -- currently on, toggle off
        ECPrint("Rendering map fog on.")
        Osi.ShroudRender(1)
        Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.DisableFog] = 0
        Helpers.ModVars:Sync(ModuleUUID)
    else
        -- currently off, toggle on
        ECPrint("Rendering map fog off.")
        Osi.ShroudRender(0)
        Helpers.ModVars:Get(ModuleUUID)[ModVarIDs.DisableFog] = 1
        Helpers.ModVars:Sync(ModuleUUID)
    end
end
CheatManager.Cheats["UnlockStoryControls"].ClientUI = function(treeParent)
    local b = ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("ha04abc1f8c00421681231bc27948322a4848"), "UnlockStoryControls", Ext.Loca.GetTranslatedString("h573fbc802f74415a906a7dae3a02a6dd9g31"))
    local tt = Imgui.SetPopupStyle(b:Tooltip())
    tt:AddText("\t"..wrap(Ext.Loca.GetTranslatedString("h6afc1e5048d04168afbe4a008f2de70e6597"), 60))
    tt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("h13eb9771g59b9g4093g9cd0g511644416d75"), 55)) -- story control effects
    tt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("h346a965bg9cdcg4cdagb5dbg9dbffe5573b9"), 55)) -- force crit
    tt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("h7950d9d2g6139g469cgaa38gd45c13da1e95"), 55)) -- fail
    tt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("h00eee852g6834g4be9ga62bg07c855b259dc"), 55)) -- succeed
    tt:AddImage("Action_AstralKnowledge", {32, 32})
    tt:AddImage("PassiveFeature_Portent_20", {32, 32}).SameLine = true
    tt:AddImage("Spell_Enchantment_CommandGrovel", {32, 32}).SameLine = true
    tt:AddImage("Spell_Divination_Guidance", {32, 32}).SameLine = true
    return b
end
---Add/Remove stat spells as a toggle
---@param entity CHARACTER
---@param args table<any>
CheatManager.Cheats["UnlockStoryControls"].ServerCode = function(entity, args)
    if Osi.HasSpell(entity, "Target_StoryControlContainer") == 1 then
        -- Toggle off
        ECPrint("Removing Story spells from %s", Helpers.Loca:GetDisplayName(entity) or entity)
        Osi.RemoveSpell(entity, "Target_StoryControlContainer", 1)
    else-- Toggle on
        ECPrint("Adding Story spells to %s", Helpers.Loca:GetDisplayName(entity) or entity)
        Osi.AddSpell(entity, "Target_StoryControlContainer", 1, 1)
    end
end
CheatManager.Cheats["UnlockKill"].ClientUI = function(treeParent)
    local b = ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("heb404f5beb6c49adba632235d633a8e6d852"), "UnlockKill", Ext.Loca.GetTranslatedString("h7a706e0d46c04a7e8022eca437247816da6a"))
    local tt = Imgui.SetPopupStyle(b:Tooltip())
    tt:AddText("\t"..wrap(Ext.Loca.GetTranslatedString("h6afc1e5048d04168afbe4a008f2de70e6597"), 60))
    tt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("ha710e4b8g122eg47b4ga83ag954612e7629f"), 55))
    tt:AddImage("Spell_Enchantment_PowerWordKill", {32, 32})
    return b
end
---Add/Remove stat spells as a toggle
---@param entity CHARACTER
---@param args table<any>
CheatManager.Cheats["UnlockKill"].ServerCode = function(entity, args)
    if Osi.HasSpell(entity, "Target_PowerWordsDieAlready") == 1 then
        -- Toggle off
        ECPrint("Removing Kill spell from %s", Helpers.Loca:GetDisplayName(entity) or entity)
        Osi.RemoveSpell(entity, "Target_PowerWordsDieAlready", 1)
    else-- Toggle on
        ECPrint("Adding Kill spell to %s", Helpers.Loca:GetDisplayName(entity) or entity)
        Osi.AddSpell(entity, "Target_PowerWordsDieAlready", 1, 1)
    end
end
CheatManager.Cheats["UnlockProtection"].ClientUI = function(treeParent)
    local b = ImguiHelpers:CreateSimpleClickCheat(treeParent, Ext.Loca.GetTranslatedString("hc80add6c2bca49e9b4141bf33cfa94929a39"), "UnlockProtection", Ext.Loca.GetTranslatedString("h9e828c15e507458f8d056541ef27fe61g8c3"))
    local tt = Imgui.SetPopupStyle(b:Tooltip())
    tt:AddText("\t"..wrap(Ext.Loca.GetTranslatedString("h6afc1e5048d04168afbe4a008f2de70e6597"), 60))
    tt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("h73962452g7946g49d9g9944g7b739f5a53ab"), 55))
    tt:AddImage("Spell_Abjuration_DumbProtection", {32, 32})
    return b
end
---Add/Remove stat spells as a toggle
---@param entity CHARACTER
---@param args table<any>
CheatManager.Cheats["UnlockProtection"].ServerCode = function(entity, args)
    if Osi.HasSpell(entity, "Target_ProtectionFromDumb") == 1 then
        -- Toggle off
        Osi.RemoveSpell(entity, "Target_ProtectionFromDumb", 1)
        ECPrint("Removing Protection spell from %s", Helpers.Loca:GetDisplayName(entity) or entity)
    else-- Toggle on
        ECPrint("Adding Protection spell to %s", Helpers.Loca:GetDisplayName(entity) or entity)
        Osi.AddSpell(entity, "Target_ProtectionFromDumb", 1, 1)
    end
end


--[[#region --TODO: Unimplemented cheats
-- Notes, maybe useful
--      DB_GLO_UsingSpell
--      DB_GLO_CastedSpell
--      DB_GLO_UsingSpellTarget
-- DB_SelfHealing_ImportantResources <-- is this related to pods?
-- DB_GLO_TutorialEvents_LongRestReplenishables
-- DB_GLO_TutorialEvents_ShortRestReplenishables
-- Goals: GLO_Spells_PostEA
--  -> GLO_Spells_ArcaneGate_WaitForOwnerToGetSet
--  -> DB_GLO_Spells_SpawningArcaneGate

Osi.GiveInspirationPoints()
PROC_TEMP_RequestStopDialog(GUIDSTRING)
PROC_TryRequestStopDialog(GUIDSTRING, INTEGER)
PROC_TryStopDialogFor(CHARACTER)
PROC_PeacefulResolve(CHARACTER)
PROC_ClearAutomatedDialog(INTEGER)
PROC_ForceStopDefaultDialog(GUIDSTRING)
PROC_ForceStopDialog(GUIDSTRING)
PROC_ForceStopSpecificDialog(GUIDSTRING, DIALOGRESOURCE)
PROC_ClearDialogCounts(INTEGER)
PROC_ClearDialogNPCs(INTEGER)
PROC_ClearDialogPlayers(INTEGER)
PROC_ClearDialogSpeakers(INTEGER)
PROC_DialogRequestCache_ClearCache(DIALOGRESOURCE, INTEGER)
PROC_DialogRequestCache_MakeSpeakerLists_Evaluate(DIALOGRESOURCE, INTEGER, GUIDSTRING)
PROC_DialogRequestCache_MakeSpeakerLists_UpdateCount(DIALOGRESOURCE, INTEGER, GUIDSTRING)
PROC_DialogRequestCache_RemoveSpeaker(DIALOGRESOURCE, INTEGER, GUIDSTRING)
PROC_DialogRequestCache_UpdateNPCCount(DIALOGRESOURCE, INTEGER)
PROC_DialogRequestCache_UpdatePlayerCount(DIALOGRESOURCE, INTEGER)

    -- if cheat == CheatManager.Cheats.StayClean then
    --     ECWarn("Not implemented: %s", cheat)
    --  Ext.Stats.GetStatsManager().ExtraData.SplatterBloodPerAttack : 0.10000000149
    --  Ext.Stats.GetStatsManager().ExtraData.SplatterMaxBloodLimit : 1.0
    --  Ext.Stats.GetStatsManager().ExtraData.SplatterMaxDirtLimit : 0.8999999
    --  Ext.Stats.GetStatsManager().ExtraData.SplatterSweatDelta : 0.1000000149
    _C().ServerCharacter.Template.BloodSurfaceType = 0 _C().Replicate("ServerCharacter")
    -- end
    -- if cheat == CheatManager.Cheats.DialogCrits then
    --     ECWarn("Not implemented: %s", cheat)
    -- end
    -- if cheat == CheatManager.Cheats.DialogFails then
    --     ECWarn("Not implemented: %s", cheat)
    -- end
    -- if cheat == CheatManager.Cheats.ElixirBloodlust then
    --     Osi.ApplyStatus(entity, "ALCH_ELIXIR_BLOODLUST", -1)
    -- end
    -- if cheat == CheatManager.Cheats.ElixirHillGiant then
    --     Osi.ApplyStatus(entity, "POTION_OF_STRENGTH_HILL_GIANT", -1)
    -- end
    -- if cheat == CheatManager.Cheats.ElixirCloudGiant then
    --     Osi.ApplyStatus(entity, "POTION_OF_STRENGTH_CLOUD_GIANT", -1)
    -- end
    -- if cheat == CheatManager.Cheats.ElixirViciousness then
    --     Osi.ApplyStatus(entity, "ALCH_ELIXIR_CRITICALS", -1)
    -- end
    -- if cheat == CheatManager.Cheats.DisableFallDamage then
    --     ECWarn("Not implemented: %s", cheat)
    -- end
    -- if cheat == CheatManager.Cheats.UnlockProtection then
    --     ECWarn("Not implemented: %s", cheat)
    --     --Target_ProtectionFromDumb
    -- end
    -- if cheat == CheatManager.Cheats.RestoreSpellSlot then
    --     ECWarn("Not implemented: %s", cheat)
    -- end
    -- if cheat == CheatManager.Cheats.RestoreResource then
    --     ECWarn("Not implemented: %s", cheat)
    -- end
--#endregion ]]--