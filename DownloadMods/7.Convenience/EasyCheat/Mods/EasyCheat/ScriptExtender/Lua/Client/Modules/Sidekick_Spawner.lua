local module = {}

---@param treeParent ExtuiTabItem
function module.GenerateSpawnerTab(treeParent)

    treeParent:AddText(Ext.Loca.GetTranslatedString("hddea501eb8634f0393463e4dce0b67c62bgf"))
    local search = treeParent:AddInputText("")
    search.UserData = {
        SearchIndex = 1,
        SearchMatches = {},
    }
    search.IDContext = "SearchInput"
    search.SameLine = true
    search.SizeHint = { 180, 36}

    -- Rarity slider
    treeParent:AddText(Ext.Loca.GetTranslatedString("h7cf6afeeaaea4d57bb122250056d4ef1f04a"))
    local raritySlider = treeParent:AddSliderInt("", 0, 0, 5)
    local rarityText = treeParent:AddText(Ext.Loca.GetTranslatedString("h0fd6e53e2d0a444dac2076e4c02f2171761a"))
    rarityText:SetColor("Text", Imgui.RarityColors.Default)
    rarityText.SameLine = true
    raritySlider.SameLine = true
    raritySlider.AlwaysClamp = true
    raritySlider.NoInput = true
    raritySlider.ItemWidth = 100
    raritySlider.UserData = {
        Text = rarityText,
        Values = {
            [0] = Ext.Loca.GetTranslatedString("h0fd6e53e2d0a444dac2076e4c02f2171761a"), -- Any
            [1] = Ext.Loca.GetTranslatedString("hbe83a775295d455fbe6cd0618bccdd3736ac"), -- Common
            [2] = Ext.Loca.GetTranslatedString("h06e168a8860f43bbb9b68cc3950657b14c16"), -- Uncommon
            [3] = Ext.Loca.GetTranslatedString("h0d74176fbc6a4b25ae68214d075af67e1ca3"), -- Rare
            [4] = Ext.Loca.GetTranslatedString("hffe27d31da314364a1ecc40bf197623959f2"), -- Very Rare
            [5] = Ext.Loca.GetTranslatedString("h767f8d82d7484337acbe527c1cca1c22c133"), -- Legendary
        }
    }
    raritySlider.OnChange = function(s)
        s.UserData.Text.Label = s.UserData.Values[s.Value[1]]
        s.UserData.Text:SetColor("Text", Imgui.RarityColors[s.Value[1]])
        search:OnChange()
    end
    search.UserData.RaritySlider = raritySlider
    -- Valid visual checkbox
    treeParent:AddText(Ext.Loca.GetTranslatedString("ha64c552a71a843a0add532b9437ac561g024"))
    local validVisualCheckbox = treeParent:AddCheckbox("", false)
    validVisualCheckbox.SameLine = true
    validVisualCheckbox:Tooltip():AddText(Ext.Loca.GetTranslatedString("hec0c99badad34c73a2be8b8b3097f3ce405d"))
    validVisualCheckbox.OnChange = function(c)
        if not search or not search.UserData then return end
        if c.Checked then
            search.UserData.VisualFilterRace = CurrentCharacterEquipmentRace
        else
            search.UserData.VisualFilterRace = nil
        end
        search:OnChange()
    end

    Imgui.SetChunkySeparator(treeParent:AddSeparatorText(Ext.Loca.GetTranslatedString("h58243d49b4dd4ce2a4ed268f8acf520d2845", "Results")))
    local searchResultGroup = treeParent:AddGroup("SKSearchResultGroup")
    search.UserData.SearchResultGroup = searchResultGroup

    ---@param row ExtuiTableRow
    local function AddItemCell(row)
        local c = row:AddCell()
        c:AddImage("Item_ARM_Padded_3", {64, 64})
        local t = c:AddText("Placeholder text that should clip")
        --fakeclip
        t.Label = string.sub(t.Label, 1, 8)
        return c
    end


    --#region Search Navigation
    local searchBackwardButton = searchResultGroup:AddButton("<<")
    searchBackwardButton:SetStyle("ButtonTextAlign", 0, 0)
    local searchForwardButton = searchResultGroup:AddButton(">>")
    searchForwardButton.SameLine = true

    local scrollTableResultText = searchResultGroup:AddText(string.format(Ext.Loca.GetTranslatedString("he75d40a1afb74856aa252fcdf45edd0370fe"), 0, 0))
    search.UserData.ResultText = scrollTableResultText
    scrollTableResultText.SameLine = true
    scrollTableResultText.IDContext = "scrollTableResultText"
    local backToTopButton = searchResultGroup:AddButton(Ext.Loca.GetTranslatedString("ha9a4474e05494c3a96b551af1ab90dc716d1"))
    -- backToTopButton.SameLine = true
    backToTopButton.Visible = false
    searchBackwardButton.UserData = { BackToTop = backToTopButton, Search = search }
    searchForwardButton.UserData = { BackToTop = backToTopButton, Search = search }
    scrollTableResultText.UserData = { BackToTop = backToTopButton, Search = search }
    searchBackwardButton.OnClick = function(b)
        local s = b.UserData.Search
        if s == nil then return end
        s.UserData.SearchIndex = math.max(s.UserData.SearchIndex - 12, 1)
        s.UserData.RegenerateItemTable(s)
        
        if b.UserData and b.UserData.BackToTop then
            b.UserData.BackToTop.Visible = false
        end
    end
    searchForwardButton.OnClick = function(b)
        local s = b.UserData.Search
        if s == nil or s.UserData.SearchIndex == nil or s.UserData.SearchIndex +12 >= #s.UserData.SearchMatches then return end
        s.UserData.SearchIndex = math.min(s.UserData.SearchIndex + 12, #s.UserData.SearchMatches)
        s.UserData.RegenerateItemTable(s)
    end
    backToTopButton.OnClick = function(b)
        local s = b.UserData.Search
        if s == nil then return end
        s.UserData.SearchIndex = 1
        s.UserData.RegenerateItemTable(s)
        b.Visible = false
    end
    --#endregion Search Navigation
    
    local itemTable = searchResultGroup:AddTable("SKSearchTable", 3)
    search.UserData.ItemTable = itemTable
    itemTable.UserData = {
        Cells = {}
    }
    local tableRow = itemTable:AddRow()
    -- itemTable.RowBg = true
    -- itemTable.Borders = true
    itemTable.Size = {300, 400}
    itemTable:AddColumn("", nil, 5) -- proportional
    itemTable:AddColumn("", nil, 5) -- proportional
    itemTable:AddColumn("", nil, 5) -- proportional
    itemTable.SizingStretchSame = true
    itemTable.NoHostExtendX = true
    itemTable.NoClip = true
    for i = 1, 12, 1 do
        local cell = AddItemCell(tableRow)
        itemTable.UserData.Cells[i] = cell
    end
    
    searchResultGroup.Visible = false
    local noResultsWarning = treeParent:AddText(Ext.Loca.GetTranslatedString("h80396c92074b46dcb04c2e9dad2102139f00", "No results found."))
    noResultsWarning.Visible = false
    search.UserData.NoResultsWarning = noResultsWarning

    -- ---@param tooltip ExtuiTooltip
    -- ---@param item ECItem
    -- local function DoItemToolTip(tooltip, item)
    -- end

    ---@param popup ExtuiPopup
    ---@param item ECItem
    local function HandleItemPopup(popup, item)
        if popup.UserData == nil then
            local rarityColor = item:GetColorByRarity()
            local previewButton
            if item.Slot ~= nil then
                previewButton = popup:AddImageButton("", "ico_concentration", {36,36})
                previewButton.OnClick = function(_)
                    Ext.Net.PostMessageToServer(ECChannels.RequestPreviewItem, Ext.Json.Stringify({
                        TemplateId = item.TemplateId,
                        Character = CurrentCharacterID, -- cringe --TODO --FIXME --SENDHELP
                    }))
                end
            end

            popup:AddText(item.DisplayName).SameLine = true
            local rarityLabel = popup:AddText("["..item.Rarity.."]")
            rarityLabel.SameLine = true
            rarityLabel:SetColor("Text", rarityColor)
            popup:AddSeparator()
            popup:SetColor("PopupBg", Helpers.Color:NormalizedLerp({0,0,0,.95}, rarityColor, 15))
            local qtyTable = popup:AddTable(popup.IDContext.."QtyTbl", 2)
            -- qtyTable.Borders = true
            local qtyTableRow = qtyTable:AddRow()
            local qtyTableCell = qtyTableRow:AddCell()
            local spawnCell = qtyTableRow:AddCell()
            local qtyResetButton = qtyTableCell:AddButton("R")
            qtyResetButton.SameLine = true
            Imgui.SetPopupStyle(qtyResetButton:Tooltip()):AddText("\t"..Ext.Loca.GetTranslatedString("hd3a163633a234a72ba3508f3092e64ad4e5a"))
            local qtyDecMoreButton = qtyTableCell:AddButton("-5")
            qtyDecMoreButton.SameLine = true
            local qtyDecButton = qtyTableCell:AddButton("-1")
            qtyDecButton.SameLine = true
            local qtySpawnSlider = qtyTableCell:AddDragInt("", 1,1,100)
            qtySpawnSlider.SameLine = true
            qtySpawnSlider.AlwaysClamp = true
            qtySpawnSlider.ItemWidth = 110
            qtySpawnSlider.Logarithmic = true
            local qtyIncButton = qtyTableCell:AddButton("+1")
            qtyIncButton.SameLine = true
            local qtyIncMoreButton = qtyTableCell:AddButton("+5")
            qtyIncMoreButton.SameLine = true
            
            
            local spawnButton = spawnCell:AddButton(Ext.Loca.GetTranslatedString("h21b6e59df42348a9a203476c760f73aa5469"))
            spawnButton.SameLine = true
            spawnButton:SetStyle("FrameRounding", 5)
            qtyTableCell.UserData = {
                DragSlider = qtySpawnSlider,
                SpawnButton = spawnButton,
            }
            spawnButton.UserData = {
                DragSlider = qtySpawnSlider,
            }
            spawnButton.OnClick = function(b)
                if b.UserData == nil or b.UserData.DragSlider == nil then return end
                Ext.Net.PostMessageToServer(ECChannels.SpawnItem, Ext.Json.Stringify({
                    ItemToSpawn = item.TemplateId,
                    Amount = b.UserData.DragSlider.Value[1],
                }))
            end
            
            qtyResetButton.OnClick = function(b)
                --if b.ParentElement == nil or b.ParentElement.UserData == nil then return end
                local slider = b.ParentElement.UserData.DragSlider
                slider.Value = { slider.Min[1], slider.Value[2], slider.Value[3], slider.Value[4] }
                if slider.OnChange then slider:OnChange() end
            end
            qtyDecMoreButton.OnClick = function(b)
                --if b.ParentElement == nil or b.ParentElement.UserData == nil then return end
                local slider = b.ParentElement.UserData.DragSlider
                slider.Value = { math.max(slider.Min[1], slider.Value[1] - 5), slider.Value[2], slider.Value[3], slider.Value[4] }
                if slider.OnChange then slider:OnChange() end
            end
            qtyDecButton.OnClick = function(b)
                --if b.ParentElement == nil or b.ParentElement.UserData == nil then return end
                local slider = b.ParentElement.UserData.DragSlider
                slider.Value = { math.max(slider.Min[1], slider.Value[1] - 1), slider.Value[2], slider.Value[3], slider.Value[4] }
                if slider.OnChange then slider:OnChange() end
            end
            qtyIncMoreButton.OnClick = function(b)
                --if b.ParentElement == nil or b.ParentElement.UserData == nil then return end
                local slider = b.ParentElement.UserData.DragSlider
                -- UX special case, 1->5
                if slider.Value[1] == 1 then
                    slider.Value = { 5, slider.Value[2], slider.Value[3], slider.Value[4]}
                else
                    slider.Value = { math.min(slider.Max[1], slider.Value[1] + 5), slider.Value[2], slider.Value[3], slider.Value[4] }
                end
                if slider.OnChange then slider:OnChange() end
            end
            qtyIncButton.OnClick = function(b)
                --if b.ParentElement == nil or b.ParentElement.UserData == nil then return end
                local slider = b.ParentElement.UserData.DragSlider
                slider.Value = { math.min(slider.Max[1], slider.Value[1] + 1), slider.Value[2], slider.Value[3], slider.Value[4] }
                if slider.OnChange then slider:OnChange() end
            end


            -- Assign some userdata to track, and prevent popup generating again
            popup.UserData = {
                PreviewButton = previewButton,
                Item = item,
            }
        end
    end

    ---@param cell ExtuiTableCell
    ---@param item ECItem
    local function RegenerateItemCell(cell, item)
        Imgui.ClearChildren(cell)
        local imtbl = cell:AddTable("SKTC"..cell.IDContext, 1)
        imtbl:SetStyle("FrameBorderSize", 3)
        imtbl:SetColor("Border", item:GetColorByRarity())
        local c = imtbl:AddRow():AddCell()
        if item.Icon ~= nil and item.Icon ~= "" then
            ---@type ExtuiImage|ExtuiImageButton
            local tryicon
            local iconName = item.IconFlaggedUnknown and "Item_Unknown" or item.Icon or "Item_Unknown"

            -- Check valid icon, flag as unknown for next checks if it fails
            tryicon = c:AddImageButton("SK"..item.Name, iconName, {64, 64})
            if tryicon.Image.Icon == "" then
                item.IconFlaggedUnknown = true
                tryicon:Destroy()
                iconName = "Item_Unknown"
                tryicon = c:AddImageButton("SK"..item.Name, iconName, {64, 64})
            end

            tryicon.Background = {0,0,0,0.7}
            DoItemToolTip(tryicon:Tooltip(), item)

            local popup = cell:AddPopup("SK_Popup"..item.Name)
            Imgui.SetPopupStyle(popup)
            tryicon.UserData = {
                Popup = popup,
                Item = item,
            }
            tryicon.OnClick = function(b)
                local pop = b.UserData.Popup
                HandleItemPopup(pop, b.UserData.Item)
                pop:Open()
            end
        end
        local itemNameText = cell:AddText(item.DisplayName)
        itemNameText.Label = string.sub(itemNameText.Label, 1, 8)
    end

    ---@param s ExtuiInputText
    search.UserData.RegenerateItemTable = function(s)
        if s == nil then return ECWarn("Attempted to regenerate item table without search field.") end
        local index = s.UserData.SearchIndex

        for _, v in ipairs(s.UserData.ItemTable.UserData.Cells) do
            local currentItem
            if not s.UserData.SearchMatches[index] then
                v.Visible = false
            else
                currentItem = ItemManager:GetItemByString(s.UserData.SearchMatches[index])
            end
            if not currentItem then
                v.Visible = false
            else
                -- Valid item to display
                v.Visible = true
                RegenerateItemCell(v, currentItem)
            end

            index = index + 1
        end
        local locaString = Ext.Loca.GetTranslatedString("h644169d7399443df8df5eb82e2b24b6387b6", "Items").." %s-%s "
        locaString = locaString..Ext.Loca.GetTranslatedString("h9458a0ed093c4f408383b9374becf33e3e4b", "of").." %s "
        locaString = locaString..Ext.Loca.GetTranslatedString("hc945765052e1466da4129a25915f510e6518", "total")
        s.UserData.ResultText.Label = string.format(locaString, s.UserData.SearchIndex, math.min(s.UserData.SearchIndex+12, #s.UserData.SearchMatches), #s.UserData.SearchMatches)
    end
    search.OnChange = function(s)
        local matches = ItemManager:GetMatchingItemStrings(s.Text, "AllItems", nil, s.UserData.VisualFilterRace, s.UserData.RaritySlider.Value[1])
        
        if #matches == 0 then
            s.UserData.SearchResultGroup.Visible = false
            s.UserData.NoResultsWarning.Visible = true
        else
            s.UserData.SearchResultGroup.Visible = true
            s.UserData.NoResultsWarning.Visible = false
            s.UserData.SearchMatches = matches or {}
            s.UserData.SearchIndex = 1
            s.UserData.RegenerateItemTable(s)
        end
    end
end
return module