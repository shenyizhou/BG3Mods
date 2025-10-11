local module = {}

local characterUuid ---@type CHARACTER|nil
local settingsWindow ---@type ExtuiWindow|nil
local keybindSK ---@type Keybinding

---@param entity EntityHandle
function module.OnCharacterChanged(entity)
    characterUuid = Helpers.Object:GetGuid(entity)
end

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
local function openCloseSidekickChanged()
    -- keybind changed, update shortcut
    if SidekickWindow ~= nil and SidekickWindow.UserData ~= nil and SidekickWindow.UserData.OpenCloseItem ~= nil then
        local newShortcut = ""
        local skOpenCloseSettings = LocalSettings:Get(ECSettings.OpenCloseSidekick) --[[@as Keybinding]]
        if skOpenCloseSettings ~= nil then
            if skOpenCloseSettings.Modifiers ~= nil and skOpenCloseSettings.Modifiers[1] ~= nil and skOpenCloseSettings.Modifiers[1] ~= "NONE" then
                newShortcut = string.format("%s+", skOpenCloseSettings.Modifiers[1])
            end
            newShortcut = newShortcut..skOpenCloseSettings.ScanCode
        end
        SidekickWindow.UserData.OpenCloseItem.Shortcut = newShortcut
    end
end
function module.GenerateSettingsWindow()
    settingsWindow = Ext.IMGUI.NewWindow(Ext.Loca.GetTranslatedString("haad7002464cb4a02bf1e00291102667ba0e3", "EasyCheat Settings"))
    settingsWindow.Open = false
    settingsWindow.Closeable = true
    -- settingsWindow.AlwaysAutoResize = true -- TODO need saved settings
    settingsWindow.AlwaysAutoResize = LocalSettings:GetOr(true, ECSettings.SettingsAutoResize)
    Imgui.NewStyling(settingsWindow)

    local viewportMinConstraints = {250, 850}
    settingsWindow:SetStyle("WindowMinSize", viewportMinConstraints[1], viewportMinConstraints[2])
    local viewportMaxConstraints = Ext.IMGUI.GetViewportSize()
    viewportMaxConstraints[1] = math.floor(viewportMaxConstraints[1] / 3) -- 1/3 of width, max?
    viewportMaxConstraints[2] = math.floor(viewportMaxConstraints[2] *0.9) -- 9/10 of height, max?
    settingsWindow:SetSizeConstraints(viewportMinConstraints,viewportMaxConstraints)

    local keybindingsGroup = settingsWindow:AddGroup("KeybindingsGroup")
    keybindingsGroup:AddText(Ext.Loca.GetTranslatedString("h93a76d4eb0404d50b2c8b841bb1f6c1c0e3c", "Open/Close Sidekick"))
    keybindSK = KeybindingManager:CreateAndDisplayKeybind(keybindingsGroup,
        "OpenCloseSidekick", "R", {"NONE"}, openCloseSidekick, openCloseSidekickChanged)

    keybindingsGroup:AddText(Ext.Loca.GetTranslatedString("haf4d9273f7e94f32869f1571e372c77c3fb8", "Toggle Immortality"))
    local imTog = KeybindingManager:CreateAndDisplayKeybind(keybindingsGroup,
        "ToggleImmortality", "NONE", {"NONE"}, function()
            ECPrint("Hotkey: ToggleImmortality")
            Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({
                Operation = CheatManager.Cheats.Immortality.Name,
                Args = {
                    Target = Helpers.Object:GetGuid(Helpers.Character:GetLocalControlledEntity()),
                }}))
        end)

    return settingsWindow
end
return module