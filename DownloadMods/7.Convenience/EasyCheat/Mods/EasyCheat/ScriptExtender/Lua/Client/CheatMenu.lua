---@type ExtuiCheckbox
local hostOnlyCheckbox = nil
---@type ExtuiCombo
local targetCombo
--TODO for the love of pizza please abstract this imgui combobox garbage later
local Party = {}
CurrentCharacterID = nil
---@type string RaceUuid
CurrentCharacterEquipmentRace = nil
---@type ExtuiTabItem
PartyTab = nil
---@type ExtuiTabItem
TeleportTab = nil
---@type ExtuiTabItem
DailyBuffTab = nil


local targetTracker = {
    availableTargets = {},
    selectedTargetMap = {
        [Ext.Loca.GetTranslatedString("hbbaa2084c76f40ed9b435418399e433bgc16")] = {},
    }
}
local function openCloseSidekick()
    if SidekickWindow ~= nil and SidekickWindow.UserData ~= nil then
        if SidekickWindow.Open then
            SidekickWindow.Open = false
            SidekickWindow.Visible = false
            if SidekickWindow.UserData.Closed then
                SidekickWindow.UserData.Closed(SidekickWindow)
            end
        else
            SidekickWindow.Open = true
            SidekickWindow.Visible = true
            if SidekickWindow.UserData.Opened then
                SidekickWindow.UserData.Opened(SidekickWindow)
            end
        end
    end
end

---Listens for Party Updates pushed from server
---@param _ string Channel optional
---@param payload string payload optional
Ext.RegisterNetListener(ECChannels.PartyChanged, function(_, payload)
    local p = Ext.Json.Parse(payload)
    Party = p.PartyMembers
    -- ECDebug("Received party update from server")
    -- ECDump(Party)
    
    -- need to refresh after a couple ticks so party is finished updating
    if StatusNotify ~= nil then StatusNotify:NewStatus(Ext.Loca.GetTranslatedString("hdcd216afd45542c0a5995c3e9c32ee83e634"), 0, StatusNotify.DefaultFadeTime) end
    Helpers.Timer:OnTicks(3, RefreshAvailableEntities)
end) -- FIXME make sure targetCombo updates properly

-- 2 seconds after gaining control for the first time
local initialJoin
initialJoin = Ext.Events.SessionLoaded:Subscribe(function(_)
    Helpers.Timer:OnTime(2000, RefreshAvailableEntities)
    Ext.Events.SessionLoaded:Unsubscribe(initialJoin)
end)

Ext.RegisterNetListener(ECChannels.CharacterChanged, function(_, payload)
    local p = Ext.Json.Parse(payload)
    CurrentCharacterID = p.Entity
    CurrentCharacter = Ext.Entity.Get(p.Entity)
    Ext.Timer.WaitFor(4000, function()
        -- Build EqRace table
        local rt
        local parentuuid
        if CurrentCharacter ~= nil and CurrentCharacter.GameObjectVisual ~= nil then
            parentuuid = CurrentCharacter.GameObjectVisual.RootTemplateId
            rt = Ext.Template.GetRootTemplate(parentuuid) --[[@as CharacterTemplate]]
            if rt ~= nil then
                CurrentCharacterEquipmentRace = rt.EquipmentRace
            end
        else
            -- TODO: Request party updates until CurrentCharacter ~= nil?
            Ext.Net.PostMessageToServer(ECChannels.RequestPartyUpdate, Ext.Json.Stringify({ Count = p.Count ~= nil and p.Count or 1 }))
            --ECWarn("CurrentCharacter was nil, savegame was slow to start? Count: %s", p.Count ~= nil and p.Count or 1)
        end
        if StatusNotify ~= nil then StatusNotify:NewStatus("Changed Characters", 0, StatusNotify.DefaultFadeTime) end
    end)
end)

---Listens for Host-only setting change from host
---@param _ string Channel optional
---@param payload string payload optional
Ext.RegisterNetListener(ECChannels.HostOnlyToggled, function(_, payload, _)
    local p = Ext.Json.Parse(payload)
    HostOnlyMode = p.Value

    if SidekickWindow and SidekickWindow.UserData and SidekickWindow.UserData.HostOnlyToggled then
        SidekickWindow.UserData.HostOnlyToggled(SidekickWindow, HostOnlyMode)
    end
    if not Ext.Net.IsHost() then
        -- this is not the host's local client
        -- no hostOnlyCheckbox necessary, non-hosts can't affect
        hostOnlyCheckbox.Visible = false
        for _, v in ipairs(hostOnlyCheckbox.UserData.LinkedElements) do
            v.Visible = false
        end
        -- show cheats if enabled
        if ItemSpawnerTab then ItemSpawnerTab.Visible = not HostOnlyMode end
        if PartyTab then PartyTab.Visible = not HostOnlyMode end
        if TeleportTab then TeleportTab.Visible = not HostOnlyMode end
        -- if DailyBuffTab then DailyBuffTab.Visible = not HostOnlyMode end -- Only host can set daily buffs?
        -- Show feedback for when host-only mode is enabled
        for _,v in ipairs(hostOnlyCheckbox.UserData.ClientWarningElements) do
            v.Visible = HostOnlyMode
        end
        if CheatGroup ~= nil then CheatGroup.Visible = not HostOnlyMode end
        if StatusNotify ~= nil and HostOnlyMode then
            StatusNotify:NewStatus(Ext.Loca.GetTranslatedString("hfdfe1cebd5184b648c8a49be1c08dcf30dd1"), -1)
        else
            StatusNotify:NewStatus("")
        end
    else
        if hostOnlyCheckbox then
            -- this is local host's client, always show cheats
            hostOnlyCheckbox.Visible = true
            
            for _,v in ipairs(hostOnlyCheckbox.UserData.ClientWarningElements) do
                -- host needs no warnings
                v.Visible = false
            end
        end
        if ItemSpawnerTab then ItemSpawnerTab.Visible = true end
        if PartyTab then PartyTab.Visible = true end
        if TeleportTab then TeleportTab.Visible = true end
        if DailyBuffTab then DailyBuffTab.Visible = true end
        if CheatGroup ~= nil then CheatGroup.Visible = true end
        if StatusNotify ~= nil then
            if HostOnlyMode then
                StatusNotify:NewStatus(Ext.Loca.GetTranslatedString("h3e1a3b62ee3f415ca53c9e402aeac12b21a2"), 1, StatusNotify.DefaultFadeTime)
            else
                StatusNotify:NewStatus(Ext.Loca.GetTranslatedString("hdd744381c1d3428bb96369019033ea1fb3c9"), -1, StatusNotify.DefaultFadeTime)
            end
        end
    end
    if hostOnlyCheckbox then -- lazy
        hostOnlyCheckbox.Checked = HostOnlyMode
    end
end)

function RefreshAvailableEntities()
    local currentCharacter = Helpers.Object:GetHostEntity()
    local currentguid = Helpers.Object:GetGuid(currentCharacter)
    
    targetTracker.availableTargets = {}
    targetTracker.selectedTargetMap[Ext.Loca.GetTranslatedString("hbbaa2084c76f40ed9b435418399e433bgc16")] = Party
    table.insert(targetTracker.availableTargets, Ext.Loca.GetTranslatedString("hbbaa2084c76f40ed9b435418399e433bgc16"))
    
    for _, v in pairs(Party) do
        local g = Ext.Entity.Get(v)
        if g ~= nil then
            if v == currentguid then
                local name = g.CustomName
                if name ~= nil then name = g.CustomName.Name else name = Helpers.Loca:GetDisplayName(g) end
                targetTracker.selectedTargetMap[string.format(Ext.Loca.GetTranslatedString("h4beeeaed144c44f5a773532a416bbdf10f87").."%s", name)] = { v }
                table.insert(targetTracker.availableTargets, string.format(Ext.Loca.GetTranslatedString("h4beeeaed144c44f5a773532a416bbdf10f87").."%s", name))
            else
                local name = g.CustomName
                if name ~= nil then name = g.CustomName.Name else name = Helpers.Loca:GetDisplayName(g) end
                targetTracker.selectedTargetMap[string.format("- %s", name)] = { v }
                table.insert(targetTracker.availableTargets, string.format("- %s", name))
            end
        else --ECWarn("Who is this? %s", v)
        end
    end
    if targetCombo ~= nil then
        targetCombo.Options = targetTracker.availableTargets
        targetCombo.SelectedIndex = 1
        Ext.Net.PostMessageToServer(ECChannels.UpdateTargetEntities, Ext.Json.Stringify({ TargetEntities = targetTracker.selectedTargetMap[targetCombo.Options[targetCombo.SelectedIndex +1]] }))
    end
    -- Regenerate some entity UI's after 5 ticks
    Helpers.Timer:OnTicks(5, function()
        if PartyGroup ~= nil and PartyGroup.UserData ~= nil then
            PartyGroup.UserData.RegenerateUI()
        end
        if UnrecruitedGroup ~= nil and UnrecruitedGroup.UserData ~= nil then

            UnrecruitedGroup.UserData.RegenerateUI()
        end
        if CampGroup ~= nil and CampGroup.UserData ~= nil then
            CampGroup.UserData.RegenerateUI()
        end
        if SidekickWindow ~= nil and SidekickWindow.UserData ~= nil then
            SidekickWindow.UserData.RegenerateUI()
        end
    end)
end

---The Main Cheat Menu
---@param treeParent ExtuiTreeParent
function CheatMenu(treeParent)
    if CheatMenuTab ~= nil then return end -- stop infinite UI repopulation
    CheatMenuTab = treeParent
    -- -- HACK take this out before release
    -- CheatMenuTab.ParentElement.ParentElement.ParentElement.ParentElement:SetStyle("SeparatorTextPadding", 0,0)
    --ECDumpS(CheatMenuTab.ParentElement.ParentElement)
    -- Force reuse MCM tab since breaking IDContext
    --treeParent.IDContext = treeParent.IDContext:match("(.+)_").."_easycheat-settings"
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, Ext.Loca.GetTranslatedString("h95ebb44583ca4fa4b2600ca6a48b837b5242"), ItemSpawnerMenu)
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, Ext.Loca.GetTranslatedString("h763097546bb74651af905a5007869a0d75b4"), PartyMenu)
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, Ext.Loca.GetTranslatedString("h6d11f3d4fe7749fc8912b0e844cf890e1725"), TeleportMenu)
    
    -- Only host can set daily buffs maybe?
    if Ext.Net.IsHost() then
        Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, Ext.Loca.GetTranslatedString("h28873292bd984039856dabff4c25459a8d9d"), DailyBuffMenu)
    end
    if GenerateSidekickWindow ~= nil then
        GenerateSidekickWindow()
    end

    local hostonlyimg = treeParent:AddImage("ico_host", {36, 36})
    hostOnlyCheckbox = treeParent:AddCheckbox(Ext.Loca.GetTranslatedString("h0ce2f6d5gbbbbg41aega584g74552b4d3ae0"))
    local nonhostwarningtext = treeParent:AddText(wrap(Ext.Loca.GetTranslatedString("hfc6a501f925d4fc19445f752d7e11c96g974"), 60))
    local nonhostwarningtext2 = treeParent:AddText(wrap(Ext.Loca.GetTranslatedString("h03783f9e0b46458dadccfa9c7ad996725bba"), 60))
    nonhostwarningtext:SetColor("Text", Imgui.Colors.FailColor)
    hostOnlyCheckbox.IDContext = "ECHostOnlyCheckbox"
    hostOnlyCheckbox.SameLine = true
    hostOnlyCheckbox.UserData = {
        LinkedElements = {
            hostonlyimg
        },
        ClientWarningElements = {
            nonhostwarningtext,
            nonhostwarningtext2,
        }
    }
    hostOnlyCheckbox.OnChange = function (c)
        Ext.Net.PostMessageToServer(ECChannels.RequestToggleHostOnly, Ext.Json.Stringify({ Value = c.Checked }))
    end
    
    local vars = Helpers.ModVars:Get(ModuleUUID)
    hostOnlyCheckbox.Checked = vars.HostOnlyCheats == 1
    --ECDump(hostOnlyCheckbox)
    treeParent:AddDummy(60,1).SameLine = true
    local sidekickButton = treeParent:AddButton(Ext.Loca.GetTranslatedString("ha965e481a9754dfe8f0616b7f9a6ae2f1e55","Open Sidekick"))
    sidekickButton:SetStyle("FrameRounding", 30)
    sidekickButton:SetStyle("FramePadding", 15, 5)
    sidekickButton:SetColor("Button", Imgui.Colors.BG3Blue)
    sidekickButton.SameLine = true
    sidekickButton.OnClick = openCloseSidekick
    treeParent:AddSeparator()
    local notification = treeParent:AddText("")

    notification.IDContext = "ECNotify"

    StatusNotify = ImguiStatus:New{ ImguiTextHandle = notification}


    CheatGroup = treeParent:AddGroup("")
    CheatGroup.IDContext = "CheatGroup"

    CheatGroup:AddText(Ext.Loca.GetTranslatedString("h75e85ce7d08a4f439730b81e66a7b481e7f2", "Target Entity"))
    targetCombo = CheatGroup:AddCombo("")
    targetCombo.IDContext = "TargetEntityCombo"
    targetCombo.Options = targetTracker.availableTargets
    targetCombo.SelectedIndex = 1
    targetCombo.WidthFitPreview = true
    targetCombo.HeightLarge = true
    targetCombo.SameLine = true
    local refreshbutton = CheatGroup:AddButton(Ext.Loca.GetTranslatedString("h6ff8fdfae95c4bedb72be4e043b41b60f401"))
    refreshbutton.SameLine = true

    local mcmwindow = Mods.BG3MCM.MCM_WINDOW
    local mcmbutton = CheatGroup:AddButton(Ext.Loca.GetTranslatedString("h4e96f8ad2a8642bf817d739544c277c16a7g"))
    mcmbutton:Tooltip():AddText(Ext.Loca.GetTranslatedString("he8c355a5687147178eea9936fa18512be856"))
    mcmbutton.SameLine = true
    mcmbutton.OnClick = function() ChangeColorsAndStyle(mcmwindow) end -- HACK hax haha-ha

    targetCombo.OnActivate = function()
        targetCombo.Options = targetTracker.availableTargets
    end
    
    refreshbutton.OnClick = function()
        Ext.Net.PostMessageToServer(ECChannels.RequestPartyUpdate, Ext.Json.Stringify({}))
    end
    targetCombo.OnChange = function ()
        Ext.Net.PostMessageToServer(ECChannels.UpdateTargetEntities, Ext.Json.Stringify({ TargetEntities = targetTracker.selectedTargetMap[targetCombo.Options[targetCombo.SelectedIndex +1]] }))
    end

    -- FIXME The main magic, delegate UI across files, *disgusting*
    CheatManager:GenerateMainUITable(CheatGroup)
end