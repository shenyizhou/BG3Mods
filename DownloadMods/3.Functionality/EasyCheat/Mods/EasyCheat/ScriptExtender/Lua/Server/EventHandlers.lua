EHandlers = {}

local function RestoreVars()
    -- Check globals and all members in the current party at time of function call (started/reset?)

    -- Restore modvars
    local modvars = Helpers.ModVars:Get(ModuleUUID)
    local stayClean = modvars[ModVarIDs.StayClean]
    local disableFog = modvars[ModVarIDs.DisableFog]
    local dailyBuffs = modvars[ModVarIDs.DailyBuffs]

    if table.isEmpty(dailyBuffs) then
        modvars[ModVarIDs.DailyBuffs] = CheatUtils.DailyBuffs.GetDefault() -- initialize
    end
    CheatUtils.DailyBuffs.ReapplyEffects()
    
    -- Apply global changes
    if stayClean == 1 then
        CheatUtils.SetStayCleanStats()
        ECPrint("Restoring vars: StayCleanCheat restored.")
    end
    if disableFog == 1 then
        Osi.ShroudRender(0)
    end
end

function EHandlers.OnLevelGameplayStarted()
    local partymembers = Helpers.Object:GetCurrentParty()
    local vars = Helpers.ModVars:Get(ModuleUUID)
    --ECDump(partymembers)
    Ext.Net.BroadcastMessage(ECChannels.PartyChanged, Ext.Json.Stringify({ PartyMembers = partymembers}))
    
    local conts = Ext.Entity.GetAllEntitiesWithComponent("ClientControl")
    if conts ~= nil then
        for k, v in pairs(conts) do
            Ext.Net.PostMessageToUser(v.UserReservedFor.UserID, ECChannels.CharacterChanged, Ext.Json.Stringify({ Entity = v.Uuid.EntityUuid}))
        end
    end
    Ext.Net.BroadcastMessage(ECChannels.HostOnlyToggled, Ext.Json.Stringify({ Value = vars.HostOnlyCheats == 1 }))
    RestoreVars()
end
function EHandlers.OnResetCompleted()
    Ext.Timer.WaitFor(2000, function()
        local partymembers = Helpers.Object:GetCurrentParty()
        local vars = Helpers.ModVars:Get(ModuleUUID)
        --ECDump(partymembers)
        Ext.Net.BroadcastMessage(ECChannels.PartyChanged, Ext.Json.Stringify({ PartyMembers = partymembers}))
        
        local conts = Ext.Entity.GetAllEntitiesWithComponent("ClientControl")
        if conts ~= nil then
            for k, v in pairs(conts) do
                Ext.Net.PostMessageToUser(v.UserReservedFor.UserID, ECChannels.CharacterChanged, Ext.Json.Stringify({ Entity = v.Uuid.EntityUuid}))
            end
        end
        Ext.Net.BroadcastMessage(ECChannels.HostOnlyToggled, Ext.Json.Stringify({ Value = vars.HostOnlyCheats == 1 }))
    end)
    RestoreVars()
end
function EHandlers.OnCharacterChange(entity)
    -- DONE? this probably needs to check what hostID controls this character
    local e = Ext.Entity.Get(entity)
    if e ~= nil then
        Ext.Net.PostMessageToUser(e.UserReservedFor.UserID, ECChannels.CharacterChanged, Ext.Json.Stringify({ Entity = entity }))
    end
end
function EHandlers.OnPartyMembersChanged(character)
    local partymembers = Helpers.Object:GetCurrentParty()
    --ECDump(partymembers)
    Ext.Net.BroadcastMessage(ECChannels.PartyChanged, Ext.Json.Stringify({ PartyMembers = partymembers}))
end
function EHandlers.OnRequestPartyUpdate(_, payload, user)
    local p = Ext.Json.Parse(payload)
    local partymembers = Helpers.Object:GetCurrentParty()
    --ECDump(partymembers)
    Ext.Net.PostMessageToUser(user, ECChannels.PartyChanged, Ext.Json.Stringify({ PartyMembers = partymembers}))
    local conts = Ext.Entity.GetAllEntitiesWithComponent("ClientControl")
    if conts ~= nil then
        for k, v in pairs(conts) do
            if v.UserReservedFor.UserID == user then
                if p.Count == nil then
                    Ext.Net.PostMessageToUser(user, ECChannels.CharacterChanged, Ext.Json.Stringify({ Entity = v.Uuid.EntityUuid}))
                else
                    Ext.Net.PostMessageToUser(user, ECChannels.CharacterChanged, Ext.Json.Stringify({ Entity = v.Uuid.EntityUuid, Count = p.Count + 1}))
                end
            end
        end
    end
end
function EHandlers.OnRequestRelationshipStatus(_, payload, user)
    --ECDebug("Processing relationship status request.")
    local p = Ext.Json.Parse(payload)
    local origin = p.Character --[[@as EntityHandle]]
    local relationshipData = {}
    for _, v in pairs(Data.Origins) do
        if v.Uuid == origin then
            local a = Osi.DB_ORI_Dating:Get(nil,nil)
            for _, value in ipairs(a) do
                local pc = value[1] --[[@as CHARACTER]]
                local npc = value[2]--[[@as CHARACTER]]
                if pc ~= nil and npc ~= nil then
                    pc = Helpers.Format:Guid(pc)
                    npc = Helpers.Format:Guid(npc)
                    if npc == origin then
                        -- NPC is dating PC
                        relationshipData.Dating = pc
                        break
                    end
                end
            end
            local b = Osi.DB_ORI_Partnered:Get(nil,nil)
            for i,value in ipairs(b) do
                local pc = value[1] --[[@as CHARACTER]]
                local npc = value[2]--[[@as CHARACTER]]
                if pc ~= nil and npc ~= nil then
                    pc = Helpers.Format:Guid(pc)
                    npc = Helpers.Format:Guid(npc)
                    if npc == origin then
                        -- NPC is partnered with PC
                        relationshipData.Partner = pc
                        break
                    end
                end
            end
            local c = Osi.DB_ORI_Partnered_Secondary:Get(nil,nil)
            for i,value in ipairs(c) do
                local pc = value[1] --[[@as CHARACTER]]
                local npc = value[2]--[[@as CHARACTER]]
                if pc ~= nil and npc ~= nil then
                    pc = Helpers.Format:Guid(pc)
                    npc = Helpers.Format:Guid(npc)
                    if npc == origin then
                        -- NPC is partnered with PC
                        relationshipData.PartnerSecondary = pc
                        break
                    end
                end
            end
            break
        end
    end
    -- ECDebug("Current relationship data for %s", Helpers.Loca:GetDisplayName(origin))
    -- ECDump(relationshipData)
    Ext.Net.PostMessageToUser(user, ECChannels.RelationshipStatusResponse, Ext.Json.Stringify({
        Character = origin,
        RelationshipData = relationshipData
    }))
end

function EHandlers.OnClientRequestCheat(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local cheat = p.Operation
    local args = p.Args
    CheatManager:ProcessCheat(u, cheat, args)
end
function EHandlers.OnClientUpdateTargetEntities(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local entities = p.TargetEntities
    CheatManager:UpdateTargetEntities(u, entities)
end

function EHandlers.OnClientSpawnItemRequest(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local itemuuid = p.ItemToSpawn
    local amount = p.Amount or 1
    -- ECDebug("Requesting spawn item %s %s for %s", amount, itemuuid, Osi.GetUserName(u))
    CheatManager:SpawnItem(u, itemuuid, amount)
end
function EHandlers.OnRequestHostOnlyToggle(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local requestedValue = p.Value
    CheatManager:RequestHostOnlyToggle(u, requestedValue)
end
function EHandlers.OnRequestChangeDailyBuffs(_, payload, user)
    -- ECPrint("Requested daily buff change") -- annoying
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local mv = Helpers.ModVars:Get(ModuleUUID)
    local db = mv.DailyBuffs

    -- Handle toggle changes
    if p.Apply ~= nil then
        db.Apply = p.Apply
        mv.DailyBuffs = db
        return
    end
    if p.DisableVFX ~= nil then
        db.DisableVFX = p.DisableVFX
        CheatUtils.DailyBuffs.ToggleEffects(p.DisableVFX, nil)
        mv.DailyBuffs = db
        return
    end
    if p.DisableSFX ~= nil then
        db.DisableSFX = p.DisableSFX
        CheatUtils.DailyBuffs.ToggleEffects(nil, p.DisableSFX)
        mv.DailyBuffs = db
        return
    end

    -- Handle status changes
    local status = p.Status
    local level = p.Level
    local newValue = p.NewValue
    local upcastStatus = p.UpcastStatus

    -- Change this chechbox's setting in the modvar
    if db.Buffs[status] ~= nil then
        -- most buffs
        db.Buffs[status][tostring(level)] = newValue
    elseif db.Upcasting[status] ~= nil then
        -- just AID so far
        if newValue then
            db.Upcasting[status][tostring(level)] = upcastStatus
        else
            db.Upcasting[status][tostring(level)] = nil
        end
    else
        -- Not accounted for, new status added?
        local default = CheatUtils.DailyBuffs.GetDefault()
        if default ~= nil then
            if default.Buffs[status] ~= nil then
                -- Found it, initialize then change
                db.Buffs[status] = {}
                for i, v in pairs(default.Buffs[status]) do
                    db.Buffs[status][tostring(i)] = v
                end
                -- Assign changed value
                db.Buffs[status][tostring(level)] = newValue
            elseif default.Upcasting[status] ~= nil then
                db.Upcasting[status] = {}
                for i,v in pairs(default.Upcasting[status]) do
                    db.Upcasting[status][tostring(i)] = v
                end
                if newValue then
                    db.Upcasting[status][tostring(level)] = upcastStatus
                else
                    db.Upcasting[status][tostring(level)] = nil
                end
            else
                ECWarn("Couldn't find new status added to daily buffs: %s", status)
            end
        end
    end
    mv.DailyBuffs = db
    -- ECDump(mv.DailyBuffs)
    -- Helpers.ModVars:Sync(ModuleUUID)
end
local function SendPartyUpdate()
    local party = Osi.DB_PartyMembers:Get(nil)
    local partymembers = {}
    for k, v in pairs(party) do
        local g = Helpers.Object:GetGuid(v[1])
        if g ~= nil then
            table.insert(partymembers, g)
        else
            -- ignore?
            --ALWarn("Unable to get party member (%s), remember to delay slightly after party changes.", v[1])
        end
    end
    if partymembers ~= nil then
        Ext.Net.BroadcastMessage(ECChannels.PartyChanged, Ext.Json.Stringify({ PartyMembers = partymembers}))
    end
end
function EHandlers.OnRequestCharacterChange(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local change = p.Change
    local entityUuid = p.Character
    local a = p.Args
    --ECDebug("Requested Character change [%s] to %s", change, entityUuid)

    local callingCharacter = Osi.GetCurrentCharacter(u) or Osi.GetHostCharacter() -- wow this feels gross
    if callingCharacter == nil then return ECWarn("Couldn't perform character change, no valid entity provided.") end

    -- cringe lua switch is table
    local changeSwitch = {
        ["RecruitAsCompanion"] = function(e, host, args)
            ECPrint("Recruiting as Companion: %s (%s)", Helpers.Loca:GetDisplayName(e), e)
            Osi.PROC_DebugBook_RecruitCompanion(e, host)
            SendPartyUpdate()
        end,
        ["RecruitAsAvatar"] = function(e, host, args)
            ECPrint("Recruiting as Avatar: %s (%s)", Helpers.Loca:GetDisplayName(e), e)
            Osi.PROC_DebugBook_RecruitAvatar(e, host)
            SendPartyUpdate()
        end,
        ["RecruitToCamp"] = function(e, host, args)
            ECPrint("Recruiting to Camp: %s (%s)", Helpers.Loca:GetDisplayName(e), e)
            Osi.PROC_DebugBook_RecruitCamp(e, host)
            SendPartyUpdate()
        end,
        ["DismissToCamp"] = function(e, host, args)
            ECPrint("Dismissing to Camp: %s (%s)", Helpers.Loca:GetDisplayName(e), e)
            --Osi.DetachFromPartyGroup(e)
            --PROC_ORI_SendToCampAfterDialog

            Helpers.Timer:OnTicks(3, function()
                local x,y,z = Osi.GetPosition(e)
                Osi.PlayEffectAtPosition("f0cf792a-0f74-d17e-ad0d-6052a6131416", x,y,z) -- manual Osi.PROC_Foop(e)
                Helpers.Character:TeleportToCamp(e)
                -- -- foop -> teleport -> remove
                local entity = Ext.Entity.Get(e)
                if entity ~= nil and entity.ServerCharacter ~= nil and entity.ServerCharacter.Summons ~= nil then
                    -- teleport summons to camp for their own safety
                    for k, v in pairs(entity.ServerCharacter.Summons) do
                        -- useful? Osi.QRY_IsSummonOrPartyFollower("uuid")
                        -- Osi.RemoveSummons(character, dieInteger)
                        ---275cee8d-2c1a-4afc-b6a0-0ef6ed2b11ee
                        local uuid = Helpers.Object:GetGuid(v)
                        if uuid ~= nil then
                            ECPrint("Sending summon to camp: %s", uuid)
                            --Osi.DetachFromPartyGroup(uuid)
                            Osi.TeleportTo(uuid, e)
                        end
                    end
                end
                
                Helpers.Timer:OnTicks(3, function()
                    Osi.PROC_GLO_PartyMembers_Remove(e, 1)
                    -- local ent = Ext.Entity.Get(e)
                    -- for k, v in pairs(entity.ServerCharacter.Summons) do
                    --     -- useful? Osi.QRY_IsSummonOrPartyFollower("uuid")
                    --     ---275cee8d-2c1a-4afc-b6a0-0ef6ed2b11ee
                    --     local uuid = Helpers.Object:GetGuid(v)
                    --     if uuid ~= nil then
                    --         Osi.DetachFromPartyGroup(uuid)
                    --     end
                    -- end
                    Helpers.Timer:OnTicks(3, function()
                        SendPartyUpdate()
                    end)
                end)
            end)
        end,
        ["AddToParty"] = function(e, host, args)
            ECPrint("AddToParty: Adding %s to control of %s", Helpers.Loca:GetDisplayName(e), Helpers.Loca:GetDisplayName(host))
            Osi.PROC_GLO_PartyMembers_CheckAdd(e, host)
            Helpers.Timer:OnTicks(3, function()
                if Osi.IsInPartyWith(e, host) == 1 and not next(Osi.DB_InCamp:Get(host)) then
                    Osi.ApplyStatus(e, "GREMISHKA_WILDSHAPE_PANTHER_REMOVE_VFX", 0)
                    Osi.TeleportTo(e, host)
                    local entity = Ext.Entity.Get(e)
                    if entity ~= nil and entity.ServerCharacter ~= nil and entity.ServerCharacter.Summons ~= nil then
                        -- teleport summons
                        for k, v in pairs(entity.ServerCharacter.Summons) do
                            local uuid = Helpers.Object:GetGuid(v)
                            if uuid ~= nil then
                                Osi.TeleportTo(uuid,e)
                            end
                        end
                    end
                    Osi.AttachToPartyGroup(e, host)
                    Helpers.Timer:OnTicks(3, function()
                        SendPartyUpdate()
                    end)
                end
            end)
        end,
        ["ApprovalSet"] = function(e, host, args)
            local amount = args.Amount
            if amount == nil then return end
            -- Calculate the change needed to set entity's approval to requested amount
            local currentApproval = Osi.GetApprovalRating(e, host) or 0
            if currentApproval == amount then return end -- current approval is same as requested, no need to do anything
            local delta = 0
            if currentApproval > amount then
                -- Need a negative amount
                delta = 0 - (currentApproval - amount)
            else --currentApproval < amount
                delta  = amount - currentApproval
            end
            ECPrint("ChangeApproval: Adjusting %s's approval of %s by %d", Helpers.Loca:GetDisplayName(e), Helpers.Loca:GetDisplayName(host), delta)
            Osi.ChangeApprovalRating(e, host, 0, delta)
            Osi.AddAttitudeTowardsPlayer(e, host, delta)
        end,
        ["TeleportToCamp"] = function(e, host, args)
            ECPrint("Teleporting %s to camp", Helpers.Loca:GetDisplayName(e))
            Osi.ApplyStatus(e, "GREMISHKA_WILDSHAPE_PANTHER_REMOVE_VFX", 0)
            Helpers.Character:TeleportToCamp(e)
        end,
        ["TeleportMeTo"] = function(e, host, args)
            ECPrint("Summoning %s to %s", Helpers.Loca:GetDisplayName(host), Helpers.Loca:GetDisplayName(e))
            Osi.ApplyStatus(host, "GREMISHKA_WILDSHAPE_PANTHER_REMOVE_VFX", 0)
            Osi.TeleportTo(host, e)
        end,
        ["Summon"] = function(e, host, args)
            ECPrint("Summoning %s to %s", Helpers.Loca:GetDisplayName(e), Helpers.Loca:GetDisplayName(host))
            Osi.ApplyStatus(e, "GREMISHKA_WILDSHAPE_PANTHER_REMOVE_VFX", 0)
            Osi.TeleportTo(e, host)
        end,
        ["Revive"] = function(e, host, args)
            if Helpers.Character:IsDead(e) then
                ECPrint("Reviving %s", Helpers.Loca:GetDisplayName(e))
                Osi.ApplyStatus(e, "GLO_JERGAL_RESURRECTION_END_VFX", 0)
                Osi.Resurrect(e)
            end
        end,
        ["ShortRest"] = function(e, host, args)
            ECPrint("Short-resting %s", Helpers.Loca:GetDisplayName(e))
            Helpers.Character:ShortRestEntity(e)
            Osi.ShortRested(e)
        end,
        ["LongRest"] = function(e, host, args)
            ECPrint("Long-resting %s", Helpers.Loca:GetDisplayName(e))
            Helpers.Character:FullRestoreEntity(e)
            Osi.UserCharacterLongRested(e, 1)
            Osi.ShortRested(e)
        end,
        ["Unstick"] = function(e, host, args)
            ECPrint("Unsticking %s (%s)", Helpers.Loca:GetDisplayName(e), e)
            --Osi.ApplyStatus(e, "MIST_FORM_VAMPIRE_REMOVE_VFX", 0)
            Osi.ApplyStatus(e, "CLOAKER_PHANTASM_VFX", 0)
            -- turn it off and on again
            Osi.SetOnStage(e, 0)
            Osi.SetOnStage(e, 1)
        end,
        ["Respec"] = function(e, host, args)
            Osi.StartRespec(e)
        end,
        ["Mirror"] = function(e, host, args)
            Osi.StartChangeAppearance(e)
        end,
        ["StartRelationship"] = function(e, host, args)
            for k, v in pairs(Data.Origins) do
                if v.Uuid == e and v.RelationshipFlag ~= nil then
                    Osi.SetFlag(v.RelationshipFlag, host)
                    ECPrint("%s started a relationship with %s (%s).", Helpers.Loca:GetDisplayName(host), Helpers.Loca:GetDisplayName(e), e)
                end
            end
        end,
        ["StartDating"] = function(e, host, args)
            for k, v in pairs(Data.Origins) do
                if v.Uuid == e and v.LoverFlag ~= nil then
                    Osi.SetFlag(v.LoverFlag, host)
                    ECPrint("%s should now be partnered with %s (%s).", Helpers.Loca:GetDisplayName(host), Helpers.Loca:GetDisplayName(e), e)
                end
            end
        end,
        ["BreakUp"] = function(e, host, args)
            --PROC_ORI_ClearPartnersIfAvatar(CHARACTER)
            --PROC_ORI_ClearPartnersIfCompanion(CHARACTER)
            for k, v in pairs(Data.Origins) do
                if v.Uuid == e and v.ClearLoverFlags ~= nil then
                    for i, flag in ipairs(v.ClearLoverFlags) do
                        Osi.ClearFlag(flag, host)
                    end
                    ECPrint("Cleared all relationship flags on %s (%s) for %s.", Helpers.Loca:GetDisplayName(e), e, Helpers.Loca:GetDisplayName(host))
                end
            end
        end,
    }

    local switchResult = changeSwitch[change]
    if switchResult then
        if entityUuid == "Party" then
            local party = Helpers.Object:GetCurrentParty()
            if party ~= nil then 
                for _, e in ipairs(party) do
                    switchResult(e, callingCharacter, a)
                end
            end
        else
            switchResult(entityUuid, callingCharacter, a)
        end
    end
    -- AddToParty
    -- DismissToCamp -- PROC_DismissToCamp
    -- RecruitAsCompanion
    -- RecruitAsAvatar
    --CheatManager:RequestHostOnlyToggle(u, requestedValue)
    -- May be useful
    -- PROC_DebugBook_RecruitAvatar(CHARACTER, CHARACTER)
    -- PROC_DebugBook_RecruitCamp(CHARACTER, CHARACTER)
    -- PROC_DebugBook_RecruitCompanion(CHARACTER, CHARACTER)
    -- DB_PartOfTheTeam(_Var1) -- sanity checks
end
function EHandlers.OnRequestItemVisualFix(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local itemTemplateId = p.TemplateId
    local equipmentRaceToFix = p.EquipmentRaceToFix
    local entity = p.Entity
    local e = Ext.Entity.Get(entity)
    
    local rt = Ext.Template.GetRootTemplate(itemTemplateId) --[[@as ItemTemplate]]
    if rt ~= nil and e ~= nil then
        rt.Equipment.ParentRace[equipmentRaceToFix] = nil
        e:Replicate("GameObjectVisual")
        
        Osi.ApplyStatus(entity, "ITEM_SHIMMER_DISARMED", 3)
    end
end
function EHandlers.OnRequestPreviewItem(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local itemTemplateId = p.TemplateId
    local entityUuid = p.Character
    -- Display to console or no...?
    -- ECPrint("Received request to preview item from %s (%s)", Helpers.Loca:GetDisplayName(entityUuid), Osi.GetUserName(u))
    ItemPreviewManager.PreviewItem(entityUuid, itemTemplateId)
end