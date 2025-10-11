---@class ECSearchableStatUI:MetaClass
---@field StatName string
---@field CurrentCharacterUuid CHARACTER
---@field SearchHint string
---@field RegenerateUI function|nil
SearchableStatUI = _Class:Create("ECSearchableStatUI", nil,{
    SearchHint = Ext.Loca.GetTranslatedString("hd071105d95154708b5d15c80a12af92a6377", "hint")
})

--#region Required overrides

---@param pop ExtuiPopup
---@param s ExtuiInputText
function SearchableStatUI:CreateFilterSettings(pop, s) end

---@param searchInput ExtuiInputText
---@return table<string>
function SearchableStatUI:GetStatMatches(searchInput) return {} end

---@param childWindow ExtuiChildWindow
---@param statName string
function SearchableStatUI:DisplayStatByName(childWindow, statName) end
--#endregion Required overrides


-- Generic with all the common styling
---@param statTab ExtuiTabItem|ExtuiTreeParent
function SearchableStatUI:CreateSearchableUI(statTab)
    local entity = Helpers.Character:GetLocalControlledEntity()
    if entity == nil then return end
    --TODO characterUuid needs to be set on tab and acquired on demand?
    local search = statTab:AddInputText("")
    local searchLabel = statTab:AddText(self.StatName.." "..Ext.Loca.GetTranslatedString("h248989664dac475993555e27ab37cff0bfb6","Search"))
    searchLabel.SameLine = true
    search.UserData = {
        LabelText = searchLabel,
    }
    search.Hint = self.SearchHint
    search.SizeHint = { 180, 36}
    -- search.AutoSelectAll = true
    -- search.DisplayEmptyRefVal = false
    -- search.EscapeClearsAll = true
    -- search.ParseEmptyRefVal = false
    -- search.EnterReturnsTrue = true
    local resultDropdown = statTab:AddCombo("")
    resultDropdown.IDContext = self.StatName.."SearchResultCombo"
    resultDropdown.ItemWidth = 350
    resultDropdown.UserData = { Search = search }

    --- #region Filter settings
    local filterSettingsButton = statTab:AddImageButton(search.IDContext..self.StatName.."FilterSettings", "ico_edit_h", {24, 24})
    filterSettingsButton.SameLine = true
    local filterSettingsPopup = Imgui.SetPopupStyle(statTab:AddPopup(search.IDContext.."FilterPopup")) --[[@as ExtuiPopup]]
    search.UserData.Popup = filterSettingsPopup
    filterSettingsButton.UserData = {
        Popup = filterSettingsPopup,
        Search = search,
    }
    Imgui.SetChunkySeparator(filterSettingsPopup:AddSeparatorText(Ext.Loca.GetTranslatedString("hfe3200e02dd940ae80ac1aa73052b44f997g", "Search Settings")))
    local searchPopTxt = filterSettingsPopup:AddText(Ext.Loca.GetTranslatedString("h07dda1ae797a4ec7ab89a5c14967bd27da07", "Search within:"))
    searchPopTxt:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))

    -- define stat-specific search settings
    self:CreateFilterSettings(filterSettingsPopup, search)

    filterSettingsButton.OnClick = function(b)
        local pop = b.UserData.Popup
        pop:Open()
    end
    ---#endregion Filter settings
    local resultsGroup = statTab:AddGroup("SearchResultsGroup")
    search.UserData.ResultsGroup = resultsGroup
    resultsGroup.Visible = false
    --- #region Navigation
    local searchBackwardButton = resultsGroup:AddButton("<<")
    searchBackwardButton:SetStyle("ButtonTextAlign", 0, 0)
    local searchForwardButton = resultsGroup:AddButton(">>")
    searchForwardButton.SameLine = true
    local resultsText = resultsGroup:AddText("0 of 0 total") -- context placeholder
    resultsText.SameLine = true
    resultDropdown.UserData.ResultsText = resultsText
    searchBackwardButton.UserData = { Combo = resultDropdown }
    searchForwardButton.UserData = { Combo = resultDropdown }
    searchBackwardButton.OnClick = function(b)
        local c = b.UserData.Combo
        if c == nil then return end
        c.SelectedIndex = math.max(c.SelectedIndex - 1, 0)
        c:OnChange()
    end
    searchForwardButton.OnClick = function(b)
        local c = b.UserData.Combo
        if c == nil then return end
        c.SelectedIndex = math.min(c.SelectedIndex + 1, #c.Options - 1)
        c:OnChange()
    end
    --- #endregion Navigation

    local statInfoChildWin = resultsGroup:AddChildWindow(self.StatName.."InfoWindow")
    statInfoChildWin:SetColor("ChildBg", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, .2))
    statInfoChildWin:SetStyle("ChildRounding", 30)
    statInfoChildWin.Size = {450, 360}
    statInfoChildWin.AlwaysAutoResize = true
    statInfoChildWin.AlwaysUseWindowPadding = true
    statInfoChildWin.UserData = {
        SearchInput = search
    }
    statInfoChildWin.UserData.Regenerate = function(childWin, s)
        Imgui.ClearChildren(childWin)
        self:DisplayStatByName(childWin, s)
    end

    ---@param c ExtuiCombo
    resultDropdown.OnChange = function(c)
        local results = c.UserData ~= nil and c.UserData.ResultsText --[[@as ExtuiText|nil]]
        if results ~= nil then
            local locaString = "%d "..Ext.Loca.GetTranslatedString("h9458a0ed093c4f408383b9374becf33e3e4b", "of").." %d "
            locaString = locaString..Ext.Loca.GetTranslatedString("hc945765052e1466da4129a25915f510e6518", "total")
            results.Label = string.format(locaString, c.SelectedIndex+1, #c.Options)
        end

        -- clear and display new info
        statInfoChildWin.UserData.Regenerate(statInfoChildWin, Imgui.Combo.GetSelected(c))
    end

    ---@param s ExtuiInputText
    search.OnChange = function(s)
        local matches = self:GetStatMatches(s)
        if #matches == 0 then
            -- no results
            s.UserData.ResultsGroup.Visible = false
            resultDropdown.SelectedIndex = 0
            resultDropdown.Options = {}
        else
            -- results, what do?
            table.sort(matches)
            resultDropdown.SelectedIndex = 0
            resultDropdown.Options = matches
            if resultDropdown.OnChange ~= nil then
                resultDropdown:OnChange()
            end
            s.UserData.ResultsGroup.Visible = true
        end
    end

    search.UserData.Regenerate = function(searchSelf, statName)
        if searchSelf == nil or searchSelf.UserData == nil then return end
        local infoChildWindow = searchSelf.UserData.InfoChildWindow
        if infoChildWindow == nil or infoChildWindow.UserData == nil or infoChildWindow.UserData.Regenerate == nil then return end
        infoChildWindow.UserData.Regenerate(infoChildWindow, statName)
    end

    return search
    -- return InputText with
    --      - UserData.Regenerate(searchSelf:ExtuiInputText, statName:string)
    --      - UserData.InfoChildWindow  ExtuiChildWindow
    --      - UserData.AddButton        ExtuiButton
    --      - UserData.ResultsGroup     ExtuiGroup
    --      - UserData.LabelText        ExtuiText
    --      - UserData.Popup            ExtuiPopup      filterSettingsPopup
    -- InputText can have UserData.Rebind function set, to rebind functionality of the AddButton
end