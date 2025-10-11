
---@class ECSearchableTagUI:ECSearchableStatUI
SearchableTagUI = _Class:Create("ECSearchableTagUI", "ECSearchableStatUI", {
    StatName = "Tag",
    SearchHint = Ext.Loca.GetTranslatedString("h0d7a70fb94e8402386b0f13db85de865e5d2", "cleric")
})

-- Tag-specific override
---@param pop ExtuiPopup
---@param s ExtuiInputText
function SearchableTagUI:CreateFilterSettings(pop, s)
    s.UserData.FilterCheckboxes = {
        Name            = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h4bf3afafd37c4224be8e9543f03b421b8bd5", "Name"), true),
        DisplayName     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h58714a3d2d95403f8483061a2a267f61de99", "Display Name"), true),
        TagUuid         = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h2c0336edebac47cbaa84e6f43eb613c525g4", "Uuid"), true),
        Description     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h38cc28b1d53e4cc4951f278ff660ee5ad618", "Description"), true),
    }

    local function searchChanged(_) s:OnChange() end
    s.UserData.FilterCheckboxes.Name.OnChange = searchChanged
    s.UserData.FilterCheckboxes.DisplayName.OnChange = searchChanged
    s.UserData.FilterCheckboxes.TagUuid.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Description.OnChange = searchChanged
    pop.UserData = {}
end

-- Tag-specific override
---@param searchInput ExtuiInputText
---@return table<string>
function SearchableTagUI:GetStatMatches(searchInput)
    local f = searchInput.UserData.FilterCheckboxes
    local matches = ECTagManager:GetMatchingTagStrings(searchInput.Text, {
        f.Name.Checked and StatSearchFilter.Name or nil,
        f.DisplayName.Checked and StatSearchFilter.DisplayName or nil,
        f.TagUuid.Checked and StatSearchFilter.TagUuid or nil,
        f.Description.Checked and StatSearchFilter.Description or nil,
    })
    local locaString = Ext.Loca.GetTranslatedString("h83bd3a33dfbf4e188acfc1937988784a7979", "Tag Search").." (%d "
    locaString = locaString..Ext.Loca.GetTranslatedString("hbd813e026c7c42a0b977bbe04a72602c4903", "matches")..")"
    searchInput.UserData.LabelText.Label = string.format(locaString, #matches)
    return matches or {}
end

-- Tag-specific override
---@param childWindow ExtuiChildWindow
---@param statName string
function SearchableTagUI:DisplayStatByName(childWindow, statName)
    local tag = ECTagManager:GetTagByString(statName)
    if tag == nil then return end

    local tagIcon
    if not tag.IconFlaggedUnknown then
        tagIcon = childWindow:AddImage(tag.Icon, {64, 64})
        if tagIcon.ImageData.Icon == "" then
            tag.IconFlaggedUnknown = true
            tagIcon:Destroy()
            tagIcon = childWindow:AddImage("Item_Unknown", {64, 64})
        end
    else
        tagIcon = childWindow:AddImage("Item_Unknown", {64, 64})
    end

    local addButton = childWindow:AddButton(Ext.Loca.GetTranslatedString("h7163716531fa456886a95f5f1876c044bff2","Add"))
    addButton.SameLine = true
    addButton.PositionOffset = {0,15}
    addButton:SetStyle("FrameRounding", 5)
    addButton:SetColor("Button", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive, 1))
    
    local rebindAddButton = false
    if childWindow.UserData.SearchInput ~= nil then
        local search = childWindow.UserData.SearchInput
        if search ~= nil and search.UserData ~= nil and search.UserData.Rebind ~= nil then
            addButton.OnClick = search.UserData.Rebind
            rebindAddButton = true
        end
    end
    if not rebindAddButton then
        addButton.OnClick = function(_)
            Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                Character = CharacterInterface_UI.CurrentCharacterUuid,
                Change = "SetTag",
                Args = {
                    Tag = tag.TagUuid,
                }
            }))
            
            -- Regenerate a little later, tag should've settled by then
            Helpers.Timer:OnTime(1000, function()
                if self.RegenerateUI then
                    self.RegenerateUI()
                end
            end)
        end
    end
    local titleDisplay = Imgui.SetChunkySeparator(childWindow:AddSeparatorText(tag.DisplayName))
    titleDisplay:SetStyle("SeparatorTextPadding", 0, 20)
    titleDisplay:SetStyle("SeparatorTextAlign", 0.25, 0.5)
    titleDisplay.SameLine = true

    local tagName
    if Ext.Utils.Version() >= 20 then
        tagName = childWindow:AddText(tag.TagName)
        tagName.TextWrapPos = 435
    else
        tagName = childWindow:AddText(wrap(tag.TagName, 60))
    end
    tagName:SetColor("Text", Imgui.Colors.Azure)

    local tagInfoTable = Imgui.SetupTable(childWindow:AddTable("TagInfoTable", 2), false, false, "SizingFixedFit", false, false)
    local r = tagInfoTable:AddRow()
    local function MakeInfoRow(label1, val1)
        r:AddCell():AddText(label1)

        local t = r:AddCell():AddText(val1 or "")
        t:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))
        return t
    end

    MakeInfoRow(Ext.Loca.GetTranslatedString("h9deabc1139194709adc64a28f22e96b577g2","Name:"), tag.DisplayName)
    MakeInfoRow(Ext.Loca.GetTranslatedString("h4795456ca1fd496d8833acfb09d2bd090b26", "Tag ID:"), tag.TagUuid)

    local tagInfoDescChild = childWindow:AddChildWindow("TagInfoDescChild")

    --tagInfoDescChild.Size = {500, 20}
    -- tagInfoDescChild.AlwaysAutoResize = true
    -- tagInfoDescChild.NoScrollbar = true
    tagInfoDescChild.AutoResizeY = true
    tagInfoDescChild.ResizeY = true
    
    -- tagInfoDescChild.ChildAlwaysAutoResize = true
    tagInfoDescChild.AlwaysUseWindowPadding = true
    tagInfoDescChild:SetColor("ChildBg", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.DarkGrey, .5))

    if Ext.Utils.Version() >= 20 then
        local desc = tagInfoDescChild:AddText(StatBS:StripLSTags(tag.DisplayDescription))
        desc.PositionOffset = {15,15}
        desc.TextWrapPos = 425
    else
        local desc = tagInfoDescChild:AddText(wrap(StatBS:StripLSTags(tag.DisplayDescription), 60))
        desc.PositionOffset = {15,15}
    end

    childWindow.UserData.AddButton = addButton
end