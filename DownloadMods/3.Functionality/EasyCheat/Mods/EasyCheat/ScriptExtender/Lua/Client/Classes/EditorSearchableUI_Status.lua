
---@class ECSearchableStatusUI:ECSearchableStatUI
SearchableStatusUI = _Class:Create("ECSearchableStatusUI", "ECSearchableStatUI", {
    StatName = "Status",
    SearchHint = Ext.Loca.GetTranslatedString("h255808fdb9f844f3b2c4d854b957c4534aec", "sneak"),
})

-- Status-specific override
---@param pop ExtuiPopup
---@param s ExtuiInputText
function SearchableStatusUI:CreateFilterSettings(pop, s)
    s.UserData.FilterCheckboxes = {
        Name            = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h4bf3afafd37c4224be8e9543f03b421b8bd5", "Name"), true),
        DisplayName     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h58714a3d2d95403f8483061a2a267f61de99", "Display Name"), true),
        Uuid            = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h2c0336edebac47cbaa84e6f43eb613c525g4", "Uuid"), true),
        Description     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h38cc28b1d53e4cc4951f278ff660ee5ad618", "Description"), true),
    }

    local function searchChanged(_) s:OnChange() end
    s.UserData.FilterCheckboxes.Name.OnChange = searchChanged
    s.UserData.FilterCheckboxes.DisplayName.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Uuid.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Description.OnChange = searchChanged
    pop.UserData = {}
end

-- Status-specific override
---@param searchInput ExtuiInputText
---@return table<string>
function SearchableStatusUI:GetStatMatches(searchInput)
    local f = searchInput.UserData.FilterCheckboxes
    local matches = ECStatusManager:GetMatchingStatusStrings(searchInput.Text, {
        f.Name.Checked and StatSearchFilter.Name or nil,
        f.DisplayName.Checked and StatSearchFilter.DisplayName or nil,
        f.Uuid.Checked and StatSearchFilter.Uuid or nil,
        f.Description.Checked and StatSearchFilter.Description or nil,
    })
    local locaString = Ext.Loca.GetTranslatedString("h9e6005e3abb14bd3a47276ac33e63ac67bf5", "Status Search").." (%d "
    locaString = locaString..Ext.Loca.GetTranslatedString("hbd813e026c7c42a0b977bbe04a72602c4903", "matches")..")"
    searchInput.UserData.LabelText.Label = string.format(locaString, #matches)
    return matches or {}
end

-- Status-specific override
---@param childWindow ExtuiChildWindow
---@param statName string
function SearchableStatusUI:DisplayStatByName(childWindow, statName)
    local status = ECStatusManager:GetStatusByString(statName)
    if status == nil then return end

    local statusIcon
    if not status.IconFlaggedUnknown then
        statusIcon = childWindow:AddImage(status.Icon, {64, 64})
        if statusIcon.ImageData.Icon == "" then
            status.IconFlaggedUnknown = true
            statusIcon:Destroy()
            statusIcon = childWindow:AddImage("Item_Unknown", {64, 64})
        end
    else
        statusIcon = childWindow:AddImage("Item_Unknown", {64, 64})
    end

    local locaNone = Ext.Loca.GetTranslatedString("h00d346068d224a6f952bb25c66fd3b32g6c9", "None")
    Imgui.CreateSimpleTooltip(statusIcon:Tooltip(), function(t)
        Imgui.SetChunkySeparator(t:AddSeparatorText(Ext.Loca.GetTranslatedString("hfc3b981c3671439fbc59122d126871ba48eb", "StatusGroups")))
        if table.isEmpty(status.StatusGroups) then
            t:AddBulletText(locaNone)
        else
            for _, v in ipairs(status.StatusGroups) do
                t:AddBulletText(v)
            end
        end
        Imgui.SetChunkySeparator(t:AddSeparatorText(Ext.Loca.GetTranslatedString("hf382258ebc4844129f24904a3319bb487872", "StatusPropertyFlags")))
        if table.isEmpty(status.StatusPropertyFlags) then
            t:AddBulletText(locaNone)
        else
            for _, v in ipairs(status.StatusPropertyFlags) do
                t:AddBulletText(v)
            end
        end
        return t
    end)
    local learnButton = childWindow:AddButton(Ext.Loca.GetTranslatedString("h7163716531fa456886a95f5f1876c044bff2","Add"))
    learnButton.UserData = {}
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
        learnButton.OnClick = function(_)
            Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                Character = CharacterInterface_UI.CurrentCharacterUuid,
                Change = "AddStatus",
                Args = {
                    Status = status.Name
                }
            }))
            
            -- Regenerate a little later, status should've settled by then
            Helpers.Timer:OnTime(500, function()
                if self.RegenerateUI then
                    self.RegenerateUI()
                end
            end)
        end
    end
    local titleDisplay = Imgui.SetChunkySeparator(childWindow:AddSeparatorText(status.DisplayName))
    titleDisplay:SetStyle("SeparatorTextPadding", 0, 20)
    titleDisplay:SetStyle("SeparatorTextAlign", 0.25, 0.5)
    titleDisplay.SameLine = true

    local statusName
    if Ext.Utils.Version() >= 20 then
        statusName = childWindow:AddText(status.Name)
        statusName.TextWrapPos = 435
    else
        statusName = childWindow:AddText(wrap(status.Name, 60))
    end
    statusName:SetColor("Text", Imgui.Colors.Azure)

    local statusInfoTable = Imgui.SetupTable(childWindow:AddTable("StatusInfoTable", 2), false, false, "SizingFixedFit", false, false)
    local r = statusInfoTable:AddRow()
    local function MakeInfoRow(label1, val1)
        r:AddCell():AddText(label1)

        local t = r:AddCell():AddText(val1 or "")
        t:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))
        return t
    end

    local stackIdText = MakeInfoRow(Ext.Loca.GetTranslatedString("hf58f15840f0d48d0a61a8a0f3a9b1736bg93", "StackID"), status.StackId == "" and locaNone or status.StackId == nil and locaNone or status.StackId)
    local boostsText = MakeInfoRow(Ext.Loca.GetTranslatedString("h511afa5c85214d3383781325d05a8f4e25ca", "Boosts"), status.Boosts == "" and locaNone or status.Boosts == nil and locaNone or status.Boosts)
    local passivesText = MakeInfoRow(Ext.Loca.GetTranslatedString("h931080faa3ab46059ecdcd725fa390c219d7", "Passives"), status.Passives == "" and locaNone or status.Passives == nil and locaNone or status.Passives)
    Imgui.CreateSimpleTooltip(boostsText:Tooltip(), function(t)
        StatBS:PresentStat(status.Boosts, "Boosts", t)
        return t
    end)
    Imgui.CreateSimpleTooltip(passivesText:Tooltip(), function(t)
        StatBS:PresentStat(status.Passives, "Passives", t)
        return t
    end)
    local statusInfoDescChild = childWindow:AddChildWindow("StatusInfoDescChild")

    --statusInfoDescChild.Size = {500, 20}
    -- statusInfoDescChild.AlwaysAutoResize = true
    -- statusInfoDescChild.NoScrollbar = true
    statusInfoDescChild.AutoResizeY = true
    statusInfoDescChild.ResizeY = true
    
    -- statusInfoDescChild.ChildAlwaysAutoResize = true
    statusInfoDescChild.AlwaysUseWindowPadding = true
    statusInfoDescChild:SetColor("ChildBg", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.DarkGrey, .5))
    if Ext.Utils.Version() >= 20 then
        local desc = statusInfoDescChild:AddText(StatBS:StripLSTags(status.Description))
        desc.PositionOffset = {15,15}
        desc.TextWrapPos = 425
    else
        local desc = statusInfoDescChild:AddText(wrap(StatBS:StripLSTags(status.Description), 60))
        desc.PositionOffset = {15,15}
    end

    childWindow.UserData.AddButton = learnButton
end