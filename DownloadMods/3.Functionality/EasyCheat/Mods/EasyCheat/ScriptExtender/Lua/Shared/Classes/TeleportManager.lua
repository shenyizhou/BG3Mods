---@class ECTriggerInfo
---@field LevelName string eg. "WLD_Main_A"
---@field MapKey Guid eg. "02afd033-7bf9-436e-b8eb-649c814ac7b9"
---@field Name string eg. "S_Tutorials_AdvancedMovement_01"
---@field Transform {Position: string, RotationQuat: string}
---@field Position vec3

---@class ECTeleportManager:MetaClass
---@field Ready boolean
---@field TriggerTable ECTriggerInfo[]
---@field TriggersByLevelName table<string, ECTriggerInfo[]>
---@field CurrentCharacterObservable Observable
---@field TeleportCheckScheduler CooperativeScheduler
---@field MarkerObjTemplate Guid
---@field MaxPerPlayerMarkers integer
---@field DetectionDistance number
---@field MarkerMap table<Guid, Guid> TriggerMapKey : EntityUuid (marker)
---@field TreeParent ExtuiTreeParent
TeleportManager = _Class:Create("ECTeleportManager", nil,{
    Ready = false,
    DetectionDistance = 40.0,
    MaxPerPlayerMarkers = 10,
    MarkerMap = {},
    -- MarkerObjTemplate = "080c2a81-7111-4be1-9a50-19771988f436", --HELPER_Table_Sitting_Checker
    -- MarkerObjTemplate = "2dab7df1-7914-4748-b329-b4fe8b60fcc9", --Helper_Waypoint_A
    -- MarkerObjTemplate = "73e0cff5-c4af-4e76-8ef8-81ad7828ebb5", --Helper_Spell_MagicCircle
    -- MarkerObjTemplate = "06881ca6-7258-42c0-966a-4536636115fa", --PLA_PersistentFlame
    -- MarkerObjTemplate = "0febed02-0ae8-4076-9f7b-65bff3b4121d", --Quest_CMB_LightningStrike 
    MarkerObjTemplate = "c57161c0-bb24-42f2-9961-6795bab5e469", --THR_ThrowableBoulder[ONHOLD]
    -- MarkerObjTemplate = "82d6ff04-db9d-4b02-82aa-fd4db21f5b7d", --Character:Undead_Zombie_Melee_AnimateDead_Swarm
    TriggerTable = {},
    TriggersByLevelName = {},
    CurrentCharacterObservable = RX.Observable.create(),
    TeleportCheckScheduler = RX.CooperativeScheduler.create(),
})
Ext.Entity.OnCreate("ClientControl", function(entity, ct, c)
    -- listen on client where userID == 1?
    if Ext.IsClient() then
        if entity.UserReservedFor == nil or entity.UserReservedFor.UserID ~= 1 then return end -- not us
    else
        if entity.UserReservedFor == nil then return end
    end

    --Push new character entities to the observable
    --TeleportManager.CurrentCharacterObservable(entity)
end)

local function RidiculousPosition(p)
    local epsilon = 0.00000001
    local max = 10000
    local x, y, z = table.unpack(p)
    if math.abs(x) < epsilon and math.abs(y) < epsilon and math.abs(z) < epsilon then
        return true
    end
    if math.abs(x) > max or math.abs(y) > max or math.abs(z) > max then
        return true
    end
    return false
end
if Ext.IsServer() then
    ECPrint("Initializing Teleport Manager")
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "before", function(levelName, isEditorMode) TeleportManager:Init() end)
    Ext.Events.ResetCompleted:Subscribe(function() TeleportManager:Init() end)
end

---
local tpcheckObservable

function TeleportManager:Init()
    if self.Ready then return end
    ECDebug("Init")
    if self:LoadAllTriggers() then
        self.Ready = true
        self:Start()
    end
end
function TeleportManager:Start()
    tpcheckObservable = RX.Observable.fromCoroutine(function()
        while true do
            self:CheckForNearbyTriggers()
            coroutine.yield(table.count(self.MarkerMap))
        end
    end, self.TeleportCheckScheduler)
    tpcheckObservable:subscribe(function(count)
        ECDebug("Count: %s", count)
    end, function(e) ECWarn("TPCheckObservable Error:\n%s", e) end, function() ECWarn("OnComplete") end)
    ECDebug("Init2")
    local fixedTime = 0 -- Ext.Timer to drive the scheduler's internal clock
    Ext.Timer.WaitForRealtime(5000, function() self.TeleportCheckScheduler:update(5) fixedTime = fixedTime+5 end, 5000)
end

function TeleportManager:CheckForNearbyTriggers()
    if self == nil then self = TeleportManager end -- jank dynamic language things in cased call with . instead of :, neat

    local allNearbyMarkers = {}
    local allPlayerPositions = {}
    -- for each player, gather nearby markers
    local controlledCharacters = Ext.Entity.GetAllEntitiesWithComponent("ClientControl")
    for _, player in ipairs(controlledCharacters) do
        local levelName = player.Level and player.Level.LevelName
        local playerPosition = player.Transform and player.Transform.Transform.Translate
        if levelName ~= nil and playerPosition ~= nil then
            table.insert(allPlayerPositions, playerPosition)
            local nearbyTriggers = {} --[[@as {Distance:number,Trigger:ECTriggerInfo}[] ]]
            -- Distance check
            for _, t in pairs(self.TriggersByLevelName[levelName]) do
                local dist = Ext.Math.Distance(playerPosition, t.Position)
                if dist <= self.DetectionDistance then
                    table.insert(nearbyTriggers, {
                        Distance = dist,
                        Trigger = t
                    })
                end
            end
            -- Sort for closest at the top
            ---@param a {Distance:number,Trigger:ECTriggerInfo}
            ---@param b {Distance:number,Trigger:ECTriggerInfo}
            table.sort(nearbyTriggers, function(a,b) return a.Distance < b.Distance end)
            -- TODO filter out triggers that are on top of each other...?

            for i = 1, self.MaxPerPlayerMarkers, 1 do
                local trigger = nearbyTriggers[i] --[[@as {Distance:number, Trigger:ECTriggerInfo}]]
                if trigger == nil then break end
                allNearbyMarkers[trigger.Trigger.MapKey] = trigger.Trigger
            end
        end
    end
    self:ClearDistantMarkers(allPlayerPositions)
    self:CreateNewMarkers(allNearbyMarkers)
end

---@param playerPositions vec3[]
function TeleportManager:ClearDistantMarkers(playerPositions)
    if Ext.IsClient() or not self.Ready then return end

    for _, playerPosition in ipairs(playerPositions) do
        for triggerMapKey, markerGuid in pairs(self.MarkerMap) do
            local markerEntity = Ext.Entity.Get(markerGuid)
            local position = markerEntity and markerEntity.Transform and markerEntity.Transform.Transform.Translate
            if position ~= nil then
                local dist = Ext.Math.Distance(playerPosition, position)
                if dist > self.DetectionDistance then
                    ECDebug("Deleting: %s", markerGuid)
                    Osi.PROC_Poof(markerGuid)
                    Ext.OnNextTick(function()
                        Osi.RequestDelete(markerGuid)
                    end)
                    -- Osi.RequestDeleteTemporary(markerGuid)
                    self.MarkerMap[triggerMapKey] = nil
                else
                    -- ECDebug("Distance was: %s", dist)
                end
            else
                ECWarn("Couldn't get uuid to delete Teleport Marker entity.")
            end
        end
    end
end

---@param allNearbyMarkers table<Guid, ECTriggerInfo>
function TeleportManager:CreateNewMarkers(allNearbyMarkers)
    for mapKey, trigger in pairs(allNearbyMarkers) do
        if self.MarkerMap[mapKey] == nil then
            -- don't already have this marker spawned in the world, spawn it now
            local marker = self:CreateMarker(trigger.Position[1], trigger.Position[2], trigger.Position[3])
            if marker then
                self.MarkerMap[mapKey] = marker
            else
                ECWarn("No marker entity created...?")
            end
        end
    end
end

---@param x number
---@param y number
---@param z number
---@return Guid? newMarker markerUuid
function TeleportManager:CreateMarker(x,y,z)
    if Ext.IsClient() or not self.Ready then return end
    local spawnFinishID = "TPMarker"..Helpers.Format:CreateUUID()

    -- -- listen for this event to finish before requesting creation
    -- local unreg
    -- unreg = Ext.Osiris.RegisterListener("EntityEvent", 2, "after", function(object, event)
    --     if event == spawnFinishID then
    --         -- does this even work?
    --         local newMarkerEntity = Ext.Entity.Get(object)
    --         if newMarkerEntity ~= nil then
    --             --gottem?
    --             ECDebug("It work delayed? %s", Helpers.Loca:GetDisplayName(newMarkerEntity))
    --             Osi.ApplyStatus(object, "LOW_CAZADORSPALACE_SARCOPHAGUS_BEAM_001",-1, 1, object)
    --             Osi.SetImmortal(object, 1)
    --             Osi.SetCanPickUp(object, 0)
    --         end
    --         if unreg then
    --             Ext.Osiris.UnregisterListener(unreg)
    --         end
    --     end
    -- end)

    local newMarker
    newMarker = Osi.CreateAt(self.MarkerObjTemplate, x,y,z, 1,0,spawnFinishID) --[[@as Guid]]
    -- this might work or probably delayed...? probably go with EntityEvent listener approach first
    if newMarker ~= nil then
        local newEntity = Ext.Entity.Get(newMarker) --[[@as EntityHandle]]
        if newEntity ~= nil then
            -- ECDebug("It work immediately? %s", Helpers.Loca:GetDisplayName(newEntity))
            Ext.OnNextTick(function (e)
                Osi.PROC_Foop(newMarker)
                Osi.ApplyStatus(newMarker, "LOW_CAZADORSPALACE_SARCOPHAGUS_BEAM_001",-1, 1, newMarker)
                -- Osi.SetImmortal(newMarker, 1)
                -- Osi.SetCanPickUp(newMarker, 0)
            end)
            ECPrint("Spawned marker: %s", newMarker)
        end
        return newMarker
    end
end

function TeleportManager:LoadAllTriggers()
    local triggerFile = "Mods/EasyCheat/ScriptExtender/Lua/Shared/Data/AllTriggersSortedPatch7.json"
    local contents = Ext.IO.LoadFile(triggerFile, "data")
    if contents ~= nil then
        self.TriggerTable = Ext.Json.Parse(contents)
        -- ECDebug("TPTable Loaded: %d triggers available", #TPTable) -- 10394 triggers available (patch 6), 23841 triggers available (patch 7)
        table.sort(self.TriggerTable, function(a, b) return a.LevelName < b.LevelName end)
        -- Grab all Levels by Name
        local levelNames = {}
        for i, trigger in ipairs(self.TriggerTable) do
            -- parse position to number format
            local x,y,z = table.unpack(trigger.Transform.Position:split(" "))
            x = tonumber(x)
            y = tonumber(y)
            z = tonumber(z)
            if x and y and z then
                trigger.Position = {x, y, z}
            end
            -- add to internal map
            if self.TriggersByLevelName[trigger.LevelName] == nil then
                self.TriggersByLevelName[trigger.LevelName] = {}
            end
            table.insert(self.TriggersByLevelName[trigger.LevelName], trigger)

            -- Gather unique levelNames, essentially table.Contains
            local found = false
            for _, k in ipairs(levelNames) do
                if k == trigger.LevelName then found = true end
            end
            if not found then
                -- this is a new level name, add it to the list
                levelNames[#levelNames + 1] = trigger.LevelName
            end
        end
        ECDebug("TeleportManager: Total LevelNames: %d", #levelNames)
        -- ECDump(levelNames)
        return levelNames
    else
        ECWarn("TeleportManager: Failed to load TP triggers.")
    end
end