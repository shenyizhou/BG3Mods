---@type ExtuiWindow
SidekickWindow = nil
---@type ExtuiWindow
SettingsWindow = nil

---@module "Sidekick_Editor"
local EditorTabModule = Ext.Require("Client/Modules/Sidekick_Editor.lua")
---@module "Sidekick_Party"
local PartyTabModule = Ext.Require("Client/Modules/Sidekick_Party.lua")
---@module "Sidekick_Spawner"
local SpawnerTabModule = Ext.Require("Client/Modules/Sidekick_Spawner.lua")
---@module "Sidekick_Settings"
local SettingsModule = Ext.Require("Client/Modules/Sidekick_Settings.lua")

-- HACK safety backup generation, in case MCM window fails on client?

---@param e EclLuaGameStateChangedEvent
Ext.Events.GameStateChanged:Subscribe(function(e)
    if e.FromState == Ext.Enums.ClientGameState.PrepareRunning and e.ToState == Ext.Enums.ClientGameState.Running then
        Helpers.Timer:OnTime(2000, function()
            GenerateSidekickWindow()
        end)
    end
end)
-- local test = Ext.Require("Client/Sidekick_Editor.lua")
-- ECDumpS(test)

--FIXME doesn't prevent double subscriptions due to cringe copypasta
local TPMouseSubscriptionID = nil
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
local function AddTeleportShortcuts(treeParent)
    local tpText = treeParent:AddText(Ext.Loca.GetTranslatedString("hf701fb2f5db44749bbfc55885336a2874723","Quick Teleport"))
    tpText:Tooltip():AddText("\t"..Ext.Loca.GetTranslatedString("h65b333ea89364ed3bbe5efcbb2af1a4bfe9d","Teleport on Right-click"))
    local teleportToggle = treeParent:AddCheckbox("", false)
    teleportToggle:Tooltip():AddText("\t"..Ext.Loca.GetTranslatedString("h65b333ea89364ed3bbe5efcbb2af1a4bfe9d","Teleport on Right-click"))
    teleportToggle.SameLine = true
    treeParent.UserData.TeleportToggle = teleportToggle

    -- FIXME cringe copypasta
    teleportToggle.OnChange = function(c)
        -- link both teleportToggles
        if TeleportTab and TeleportTab.UserData and TeleportTab.UserData.TeleportToggle then
            TeleportTab.UserData.TeleportToggle.Checked = c.Checked
        end
        if SidekickWindow and SidekickWindow.UserData and SidekickWindow.UserData.TeleportToggle then
            SidekickWindow.UserData.TeleportToggle.Checked = c.Checked
        end
        if c.Checked then
            TPMouseSubscriptionID = Ext.Events.MouseButtonInput:Subscribe(function(e)
                if e.Button == 1 and e.Pressed and e.Clicks >= 2 then
                    if e.CanPreventAction then e:PreventAction() end
                    local entity = Helpers.Object:GetHostEntity()
                    if entity == nil then return end
                    if entity.CanTravel.ErrorFlags & Ext.Enums.TravelErrorFlags.Dialog == Ext.Enums.TravelErrorFlags.Dialog then return end
                    local picker = Ext.UI.GetPickingHelper(1)
                    if picker.Inner ~= nil and picker.Inner.Position ~= nil then
                        if RidiculousPosition(picker.Inner.Position) then return end
                        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({
                            Operation = CheatManager.Cheats["Teleport"].Name,
                            Args = {
                                LevelName = entity.Level.LevelName,
                                Position = picker.Inner.Position,
                            }
                        }))
                    end
                end
            end)
        else
            if TPMouseSubscriptionID ~= nil then
                Ext.Events.MouseButtonInput:Unsubscribe(TPMouseSubscriptionID)
                TPMouseSubscriptionID = nil
            end
        end
    end

    local immortaltoggle = CheatManager.Cheats.Immortality.ClientUI(treeParent) --[[@as ExtuiButton]]
    -- FIXME annoying wrap
    immortaltoggle.UserData = {
        OldOnClick = immortaltoggle.OnClick,
    }
    immortaltoggle.OnClick = function(b)
        local ent = Helpers.Object:GetHostEntity()
        if ent ~= nil and ent.Uuid ~= nil then
            b.UserData.Target = ent.Uuid.EntityUuid
            b.UserData.OldOnClick(b)
        end
    end
end

function GenerateSidekickWindow()
    if SidekickWindow ~= nil then return end

    SidekickWindow = Ext.IMGUI.NewWindow(Ext.Loca.GetTranslatedString("hde674d509d9c436f9022b516240dba9b6b81", "EasyCheat Sidekick"))
    SidekickWindow.Open = false
    SidekickWindow.Closeable = true
    SidekickWindow.AlwaysAutoResize = LocalSettings:GetOr(true, ECSettings.SidekickAutoResize)
    Imgui.NewStyling(SidekickWindow)
    if SettingsModule then
        SettingsWindow = SettingsModule.GenerateSettingsWindow()
    end

    local viewportMinConstraints = {250, 850}
    SidekickWindow:SetStyle("WindowMinSize", viewportMinConstraints[1], viewportMinConstraints[2])
    local viewportMaxConstraints = Ext.IMGUI.GetViewportSize()
    viewportMaxConstraints[1] = math.floor(viewportMaxConstraints[1] / 3) -- 1/3 of width, max?
    viewportMaxConstraints[2] = math.floor(viewportMaxConstraints[2] *0.9) -- 9/10 of height, max?
    SidekickWindow:SetSizeConstraints(viewportMinConstraints,viewportMaxConstraints)

    -- SidekickWindow.AlwaysAutoResize = SidekickWindow.AlwaysAutoResize or true

    SidekickWindow.UserData = {
        Disabled = not Ext.Net.IsHost()
    }
    local hostDisableWarning = Imgui.SetChunkySeparator(SidekickWindow:AddSeparatorText(Ext.Loca.GetTranslatedString("h0251709af8c54e3cb2506edb1bacd0313gc3","Disabled by Host")))
    hostDisableWarning:SetColor("Text", Imgui.Colors.DarkOrange)
    SidekickWindow.UserData.WarningText = hostDisableWarning
    hostDisableWarning.Visible = false
    local skGroup = SidekickWindow:AddGroup("SK_MainGroup")
    SidekickWindow.UserData.MainGroup = skGroup
    skGroup.UserData = {}

    SidekickWindow.OnClose = function(w)
        if w and w.UserData and w.UserData.Closed then
            w.UserData.Closed(w)
        end
    end
    SidekickWindow.UserData.HostOnlyToggled = function(w, value)
        -- if we're not the host, sidekick only enabled if host-only mode is off
        if not Ext.Net.IsHost() then
            if value then
                -- true = Host-only mode is enabled
                w.UserData.Disable(w)
            else
                -- false = Host-only mode is disabled
                w.UserData.Enable(w)
            end
        else
            -- Update menu item for host while we're here
            SidekickWindow.UserData.HostOnlySetting.Shortcut = value and Ext.Loca.GetTranslatedString("h301ab7631a9c47b09e415c7955bad85ag932","enabled") or Ext.Loca.GetTranslatedString("h6ec95f1fe12641698656af90a00773a228g7","disabled")
        end
    end
    SidekickWindow.UserData.Disable = function(w)
        w.UserData.WarningText.Visible = true
        w.UserData.MainGroup.Visible = false
    end
    SidekickWindow.UserData.Enable = function(w)
        w.UserData.WarningText.Visible = false
        w.UserData.MainGroup.Visible = true
    end
    
    local mainMenu = SidekickWindow:AddMainMenu()
    SidekickWindow.UserData.MainMenu = mainMenu
    local mainMenuFile = mainMenu:AddMenu(Ext.Loca.GetTranslatedString("h678f8a2de87f4518a78941f413d1647dadd4", "File")) --[[@as ExtuiMenu]]
    SidekickWindow.UserData.MainMenuFile = mainMenuFile
    local mainMenuSettings = mainMenu:AddMenu(Ext.Loca.GetTranslatedString("h91710e59527a41b9a290a7a8f3aa0cc14839", "Settings")) --[[@as ExtuiMenu]]
    SidekickWindow.UserData.MainMenuSettings = mainMenuSettings
    local mainMenuInfo = mainMenu:AddMenu(Ext.Loca.GetTranslatedString("hbd5463e3dd6147d5bc9dc617d5a5e6ff696f", "Info")) --[[@as ExtuiMenu]]
    SidekickWindow.UserData.MainMenuInfo = mainMenuInfo
    mainMenuInfo.Visible = false -- don't have anything to show yet

    local skOpenCloseShortcut = "Alt+R"
    local skOpenCloseSettings = LocalSettings:Get(ECSettings.OpenCloseSidekick) --[[@as Keybinding]]
    if skOpenCloseSettings ~= nil then
        skOpenCloseShortcut = ""
        if skOpenCloseSettings.Modifiers ~= nil and skOpenCloseSettings.Modifiers[1] ~= nil and skOpenCloseSettings.Modifiers[1] ~= "NONE" then
            skOpenCloseShortcut = string.format("%s+", skOpenCloseSettings.Modifiers[1])
        end
        skOpenCloseShortcut = skOpenCloseShortcut..skOpenCloseSettings.ScanCode
    end
    local openClose = mainMenuFile:AddItem(Ext.Loca.GetTranslatedString("h7bbe2ff752be4d1fb6d57a340c73a5dbee8c","Open/Close"), skOpenCloseShortcut)
    SidekickWindow.UserData.OpenCloseItem = openClose
    openClose.OnClick = function (_)
        SidekickWindow.Open = false
    end
    local autoResizeSetting = mainMenuSettings:AddItem(Ext.Loca.GetTranslatedString("h12e1698fdcdc4653b84c2e68ad51d93e12d6","Auto-resize")) -- TODO localization
    autoResizeSetting.Shortcut = SidekickWindow.AlwaysAutoResize and Ext.Loca.GetTranslatedString("h301ab7631a9c47b09e415c7955bad85ag932","enabled") or Ext.Loca.GetTranslatedString("h6ec95f1fe12641698656af90a00773a228g7","disabled")
    
    local hostOnlySetting = mainMenuSettings:AddItem(Ext.Loca.GetTranslatedString("hcfda5719ad264af9ab9d2d423da11e95d24g", "Host-only mode"))
    hostOnlySetting.Shortcut = HostOnlyMode and Ext.Loca.GetTranslatedString("h301ab7631a9c47b09e415c7955bad85ag932","enabled") or Ext.Loca.GetTranslatedString("h6ec95f1fe12641698656af90a00773a228g7","disabled")
    SidekickWindow.UserData.HostOnlySetting = hostOnlySetting
    hostOnlySetting.Visible = Ext.Net.IsHost() -- Only visible to host

    
    Imgui.SetChunkySeparator(mainMenuSettings:AddSeparator())
    local openSettingsSetting = mainMenuSettings:AddItem(Ext.Loca.GetTranslatedString("h592451dabd9a402091c990e3f4a653482aeb", "Advanced Settings..."))
    openSettingsSetting.OnClick = function(_)
        if SettingsWindow ~= nil then
            SettingsWindow.Open = true
        end
    end

    autoResizeSetting.OnClick = function(mi)
        SidekickWindow.AlwaysAutoResize = not SidekickWindow.AlwaysAutoResize
        mi.Shortcut = SidekickWindow.AlwaysAutoResize and Ext.Loca.GetTranslatedString("h301ab7631a9c47b09e415c7955bad85ag932","enabled") or Ext.Loca.GetTranslatedString("h6ec95f1fe12641698656af90a00773a228g7","disabled")
        LocalSettings:AddOrChange(ECSettings.SidekickAutoResize, SidekickWindow.AlwaysAutoResize)
    end
    hostOnlySetting.OnClick = function(_)
        if HostOnlyMode == nil then return end
        Ext.Net.PostMessageToServer(ECChannels.RequestToggleHostOnly, Ext.Json.Stringify({ Value = not HostOnlyMode }))
    end

    AddTeleportShortcuts(skGroup)
    Imgui.SetChunkySeparator(skGroup:AddSeparator())

    local sktabbar = skGroup:AddTabBar("ECSidekickTabbar")
    SidekickWindow.UserData.MainTabBar = sktabbar
    local partyTab = sktabbar:AddTabItem(Ext.Loca.GetTranslatedString("h763097546bb74651af905a5007869a0d75b4","Party"))
    SidekickWindow.UserData.PartyTab = partyTab
    local spawnerTab = sktabbar:AddTabItem(Ext.Loca.GetTranslatedString("h6d84bd60b2dd46b9881363b8c7b3c849c878", "Spawner"))
    SidekickWindow.UserData.SpawnerTab = spawnerTab
    local editorTab = sktabbar:AddTabItem(Ext.Loca.GetTranslatedString("ha6fb8a0b177c4d90a0f520ceae7657a2388a","Editor"))
    SidekickWindow.UserData.EditorTab = editorTab
    -- editorTab.Visible = false -- stashed still in the works

    -- Responsible for creating a Regenerate() in partyTab.UserData
    PartyTabModule.GeneratePartyTab(partyTab)
    SidekickWindow.UserData.RegenerateUI = function()
        if SidekickWindow == nil or SidekickWindow.UserData == nil then return end
        local ptab = SidekickWindow.UserData.PartyTab
        if ptab and ptab.UserData and ptab.UserData.Regenerate then
            ptab.UserData.Regenerate()
        end
    end

    SpawnerTabModule.GenerateSpawnerTab(spawnerTab)
    EditorTabModule.GenerateEditorTab(editorTab)
end