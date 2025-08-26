
---@class ECSearchablePassiveUI:ECSearchableStatUI
SearchablePassiveUI = _Class:Create("ECSearchablePassiveUI", "ECSearchableStatUI", {
    StatName = "Passive",
    SearchHint = Ext.Loca.GetTranslatedString("h244848af30da4aa4add5b301786fce5ca321", "warcast")
})

-- Passive-specific override
---@param pop ExtuiPopup
---@param s ExtuiInputText
function SearchablePassiveUI:CreateFilterSettings(pop, s)
    s.UserData.FilterCheckboxes = {
        Name            = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h4bf3afafd37c4224be8e9543f03b421b8bd5", "Name"), true),
        DisplayName     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h58714a3d2d95403f8483061a2a267f61de99", "Display Name"), true),
        Boosts          = pop:AddCheckbox(Ext.Loca.GetTranslatedString("hebc2103553854b8bbabe9355978c4270acgd", "Boosts"), true),
        Conditions      = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h76a8e3508e2541ac972d494d741cae4507d3", "Conditions"), true),
        Description     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h38cc28b1d53e4cc4951f278ff660ee5ad618", "Description"), true),
    }

    local function searchChanged(chk) s:OnChange() end
    s.UserData.FilterCheckboxes.Name.OnChange = searchChanged
    s.UserData.FilterCheckboxes.DisplayName.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Boosts.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Conditions.OnChange = searchChanged
    -- s.UserData.FilterCheckboxes.Properties.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Description.OnChange = searchChanged
    pop.UserData = {}
end

-- Passive-specific override
---@param searchInput ExtuiInputText
---@return table<string>
function SearchablePassiveUI:GetStatMatches(searchInput)
    local f = searchInput.UserData.FilterCheckboxes
    local matches = ECPassiveManager:GetMatchingPassiveStrings(searchInput.Text, {
        f.Name.Checked and StatSearchFilter.Name or nil,
        f.DisplayName.Checked and StatSearchFilter.DisplayName or nil,
        f.Boosts.Checked and StatSearchFilter.Boosts or nil,
        f.Conditions.Checked and StatSearchFilter.Conditions or nil,
        -- f.Properties.Checked and StatSearchFilter.Properties or nil,
        f.Description.Checked and StatSearchFilter.Description or nil,
    })
    local locaString = Ext.Loca.GetTranslatedString("haeac05e1a9104a9ebe70f598fa5e8b222c4d", "Passive Search").." (%d "
    locaString = locaString..Ext.Loca.GetTranslatedString("hbd813e026c7c42a0b977bbe04a72602c4903", "matches")..")"
    searchInput.UserData.LabelText.Label = string.format(locaString, #matches)
    return matches or {}
end

-- Passive-specific override
---@param childWindow ExtuiChildWindow
---@param statName string
function SearchablePassiveUI:DisplayStatByName(childWindow, statName)
    local passive = ECPassiveManager:GetPassiveByString(statName)
    if passive == nil then return end

    local passiveIcon
    if not passive.IconFlaggedUnknown then
        passiveIcon = childWindow:AddImage(passive.Icon, {64, 64})
        if passiveIcon.ImageData.Icon == "" then
            passive.IconFlaggedUnknown = true
            passiveIcon:Destroy()
            passiveIcon = childWindow:AddImage("Item_Unknown", {64, 64})
        end
    else
        passiveIcon = childWindow:AddImage("Item_Unknown", {64, 64})
    end

    Imgui.CreateSimpleTooltip(passiveIcon:Tooltip(), function(t)
        Imgui.SetChunkySeparator(t:AddSeparatorText(Ext.Loca.GetTranslatedString("ha0d46d81b9a94fa7b9679022c20341c5d032", "Properties")))
        if table.isEmpty(passive.Properties) then
            t:AddBulletText("None")
        else
            for _, v in ipairs(passive.Properties) do
                t:AddBulletText(v)
            end
        end
        return t
    end)
    local learnButton = childWindow:AddButton(Ext.Loca.GetTranslatedString("h7163716531fa456886a95f5f1876c044bff2", "Add"))
    learnButton.SameLine = true
    learnButton.PositionOffset = {0,15}
    learnButton:SetStyle("FrameRounding", 5)
    learnButton:SetColor("Button", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive, 1))
    
    local rebindAddButton = false
    if childWindow.UserData.SearchInput ~= nil then
        local search = childWindow.UserData.SearchInput
        if search ~= nil and search.UserData ~= nil and search.UserData.Rebind ~= nil then
            learnButton.OnClick = search.UserData.Rebind
            rebindAddButton = true
        end
    end
    if not rebindAddButton then
        learnButton.OnClick = function(b)
            Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                Character = CharacterInterface_UI.CurrentCharacterUuid,
                Change = "AddPassive",
                Args = {
                    Passive = passive.Name
                }
            }))
            
            -- Regenerate a little later, passive should've settled by then
            Helpers.Timer:OnTime(500, function()
                if self.RegenerateUI then
                    self.RegenerateUI()
                end
            end)
        end
    end
    local titleDisplay = Imgui.SetChunkySeparator(childWindow:AddSeparatorText(passive.DisplayName))
    titleDisplay:SetStyle("SeparatorTextPadding", 0, 20)
    titleDisplay:SetStyle("SeparatorTextAlign", 0.25, 0.5)
    titleDisplay.SameLine = true

    local passiveName
    if Ext.Utils.Version() >= 20 then
        passiveName = childWindow:AddText(passive.Name)
        passiveName.TextWrapPos = 435
    else
        passiveName = childWindow:AddText(wrap(passive.Name, 70))
    end
    passiveName:SetColor("Text", Imgui.Colors.Azure)

    local passiveInfoTable = Imgui.SetupTable(childWindow:AddTable("PassiveInfoTable", 2), false, false, "SizingFixedFit", false, false)
    local r = passiveInfoTable:AddRow()
    local function MakeInfoRow(label1, val1)
        r:AddCell():AddText(label1)

        local t = r:AddCell():AddText(val1 or "")
        t:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))
        return t
    end
    local locaNone = Ext.Loca.GetTranslatedString("h00d346068d224a6f952bb25c66fd3b32g6c9", "None")
    local boostsText = MakeInfoRow(Ext.Loca.GetTranslatedString("hebc2103553854b8bbabe9355978c4270acgd", "Boosts"), passive.Boosts == "" and locaNone or passive.Boosts == nil and locaNone or passive.Boosts)
    local conditionsText = MakeInfoRow(Ext.Loca.GetTranslatedString("h76a8e3508e2541ac972d494d741cae4507d3", "Conditions"), passive.Conditions == "" and locaNone or passive.Conditions == nil and locaNone or passive.Conditions)
    Imgui.CreateSimpleTooltip(boostsText:Tooltip(), function(t)
        if Ext.Utils.Version() >= 20 then
            t:AddText(passive.Boosts).TextWrapPos = 450
        else
            t:AddText(wrap(passive.Boosts,60))
        end
        return t
    end)
    Imgui.CreateSimpleTooltip(conditionsText:Tooltip(), function(t)
        if Ext.Utils.Version() >= 20 then
            t:AddText(passive.Conditions).TextWrapPos = 450
        else
            t:AddText(wrap(passive.Conditions, 60))
        end
        return t
    end)
    local passiveInfoDescChild = childWindow:AddChildWindow("PassiveInfoDescChild")

    passiveInfoDescChild.AutoResizeY = true
    passiveInfoDescChild.ResizeY = true
    
    passiveInfoDescChild.AlwaysUseWindowPadding = true
    passiveInfoDescChild:SetColor("ChildBg", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.DarkGrey, .5))

    if Ext.Utils.Version() >= 20 then
        local desc = passiveInfoDescChild:AddText(StatBS:StripLSTags(passive.Description))
        desc.PositionOffset = {15,15}
        desc.TextWrapPos = 425
    else
        local desc = passiveInfoDescChild:AddText(wrap(StatBS:StripLSTags(passive.Description), 60))
        desc.PositionOffset = {15,15}
    end

    childWindow.UserData.AddButton = learnButton
end