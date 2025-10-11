---@type ExtuiCombo|nil
local ItemFilterCombo = nil
---@type boolean|nil
local ItemVanillaFilter = nil
---@type string|nil
local ItemValidVisualFilter = nil
---@type ExtuiText|nil
local ItemFilterResultText = nil
---@type ExtuiText|nil
local ScrollTableResultText = nil
---@type ExtuiTable|nil
local ItemInfoTable = nil
---@type ExtuiText|nil
local iteminfoNameText
---@type ExtuiBulletText|nil
local iteminfoStatNameText
---@type ExtuiImageButton|nil
local iteminfoPreviewButton
---@type ExtuiTableCell|nil
local iteminfoIconCell
---@type ExtuiImage|nil
local iteminfoIcon
---@type ExtuiText|nil
local iteminfoIDText
---@type ExtuiGroup
local SearchGroup
---@type ExtuiButton|nil
local SearchForwardButton
---@type ExtuiButton|nil
local SearchBackwardButton
local ItemInfoNodes = {
    Rows = {},
    CellMaps = {},
}
-- FIXME yikes localization for id's
local itemspawner = {
    itemtypeHandles = {
        "h08097669ed974622a9580c554f4bf8d5cff3",
        "hc3facc1a37c5485fa50c9c671e6f544b3a95",
        "h81420a86077e45e8bf6d5cf2144ca4d2cg2d",
        "hd83aa9b0eab648ae86d11975db46c72ac468",
        "h9985bee3dc7c4829babfe73d5d4bf141f919",
        "hfd30a1e0f42c47c0926e0c8de7b046b70d4c",
        "hf8f09d34a6ee40a3a90bc4725714ff5fc6c8",
        "hf45a2f99a4ea4fe8874f5853448cce234966",
        "hdab7a61774524501bd3220848079c64799bf",
        "h5ab5f0e688a4492d9cf1568834be0e84444g",
        "h7b967fd568c64e619f7f4d4dae7197a77866",
        "h3cab671713c24bdc932e9119217c4195b9ed",
        "hcae754a185ec43afb7b5aa6188d68750b851",
        "h0ecb4ae7c4c44bacbbb28ec7bad1c3c75bd7",
        "h4de8bb86bbb145259105e5c03486101829e7",
        "h05006a9857cc4d279bf1587527e0bcc9776c",
        "he2224dcc306b4f12b6366f201f10a41923fa",
        "h60569764b72449e899e73a42f62cd0f3ae83",
        "hb299316669674db6957dffed6867e531cd81",
        "hc2d51ac4f1fd416281276970c904a1c1a2f6",
        "h91d75c6c1aef49c094fcdb15e45f189d9366",
        "h3c8fa6a99d004efca6db4632b889f6d0455b",
        "h0acdef257d5643919031951a9cc26efe037b",
    },
    itemtypes = {
        "AllItems",
        "Armor:Helmet",
        "Armor:Cloak",
        "Armor:Body",
        "Armor:Gloves",
        "Armor:Boots",
        "Armor:Ring",
        "Armor:Amulet",
        "Clothes:VanityBody",
        "Clothes:VanityBoots",
        "Clothes:Underwear",
        "Weapon",
        "Shield",
        "Instrument",
        "Potions",
        "Scrolls",
        "Arrows",
        "Throwables",
        "Misc:General",
        "Misc:Books",
        "Misc:Dye",
        "Misc:Food",
        "Misc:Alchemy",
    },
    itemtypemap = {
        ["AllItems"] = "AllItems",
        ["Armor:Helmet"] = "Helmet",
        ["Armor:Cloak"] = "Cloak",
        ["Armor:Body"] = "Breast",
        ["Armor:Gloves"] = "Gloves",
        ["Armor:Boots"] = "Boots",
        ["Armor:Ring"] = "Ring",
        ["Armor:Amulet"] = "Amulet",
        ["Clothes:VanityBody"] = "VanityBody",
        ["Clothes:VanityBoots"] = "VanityBoots",
        ["Clothes:Underwear"] = "Underwear",
        ["Weapon"] = "Weapon",
        ["Shield"] = "Shield",
        ["Instrument"] = "Instrument",
        ["Potions"] = "Potion",
        ["Scrolls"] = "Scroll",
        ["Arrows"] = "Arrows",
        ["Throwables"] = "Throwables",
        ["Misc:General"] = "Misc",
        ["Misc:Books"] = "Books",
        ["Misc:Dye"] = "Dye",
        ["Misc:Food"] = "Food",
        ["Misc:Alchemy"] = "Alchemy",
    },
    selectedType = "AllItems",
    selectedItem = nil
}
-- FIXME yikes just yikes
function itemspawner:getTranslatedItemTypes()
    local translated = {}
    for i, v in ipairs(self.itemtypeHandles) do
        translated[i] = Ext.Loca.GetTranslatedString(v)
    end
    return translated
end

---Adds tooltips for items
---@param tooltip ExtuiTooltip
---@param item ECItem
function DoItemToolTip(tooltip, item)
    tooltip:SetColor("PopupBg", {0.18, 0.15, 0.15, 1.00})
    tooltip:SetStyle("WindowPadding", 15, 15)
    tooltip:SetStyle("PopupBorderSize", 2)
    tooltip:SetColor("BorderShadow", {0,0,0,0.4})
    tooltip:SetColor("Border", Imgui.Colors.Tan)
    local mod = Ext.Mod.GetMod(item.ModId)
    local modinfo = {}
    if mod ~= nil then -- item modid and/or GetMod return can be nil, good times
        modinfo = mod.Info
    else
        modinfo.Name = "Unknown"
        modinfo.Author = "Unknown"
    end
    -- Icon StatName
    tooltip:AddImage(item.Icon, {32, 32}).Border = item:GetColorByRarity()
    tooltip:AddText(item.Name).SameLine = true

    -- ModName ModAuthor
    -- limit modauthor
    local author = modinfo.Author:sub(1, 27)..(modinfo.Author:len() > 27 and "..." or "")
    local modinfotext = string.format(Ext.Loca.GetTranslatedString("h023c739ab4f546fc8a057a88f8c7e44dea83").." \"%s\" by %s", modinfo.Name, author == "" and "Larian" or author)
    -- ModID
    tooltip:AddText(string.format(modinfotext.."\n"..Ext.Loca.GetTranslatedString("habe66c7e6f9741ff8aad2b3470850233ac86").." %s", item.ModId))

    -- DisplayName [Story] [Unique]
    tooltip:AddText(item.DisplayName):SetColor("Text", item:GetColorByRarity())
    if item.StoryItem then
        local si = tooltip:AddText(Ext.Loca.GetTranslatedString("h283b0c7ff7764a69863b7ada461d997fec70"))
        si.SameLine = true
        si:SetColor("Text", {1.00, 0.35, 0.00, 1.00})
    end

    local vitem = tooltip:AddText(item.IsVanilla and Ext.Loca.GetTranslatedString("h2df081fd305b4c448d52ee060017d9ff531a") or Ext.Loca.GetTranslatedString("h6b1c457f91904a3e8be5df36e79da150fd74"))
    vitem.SameLine = true
    vitem:SetColor("Text", item.IsVanilla and Imgui.Colors.Neutral or Imgui.Colors.Red)
    -- tl;dr ALL items are unique, neat
    -- if item.Unique then
    --     local uitem = tooltip:AddText("[Unique]")
    --     uitem.SameLine = true
    --     uitem:SetColor("Text", {0.00, 0.44, 1.00, 1.00})
    -- end

    if CurrentCharacterEquipmentRace ~= nil and CurrentCharacterID ~= nil and Ext.Enums.StatsItemSlot[item.Slot] ~= nil then
        local eqrText
        if item:HasValidVisualsForRace(CurrentCharacterEquipmentRace) then
            eqrText = tooltip:AddText(Ext.Loca.GetTranslatedString("h8510499fc8e349d2ad786b06f8a26cbc1bcd"))
            eqrText:SetColor("Text", Imgui.Colors.SuccessColor)
        else
            eqrText = tooltip:AddText(Ext.Loca.GetTranslatedString("h191a91078a734385aae05338380469a4abg4"))
            eqrText:SetColor("Text", Imgui.Colors.FailColor)
        end
        local charname = Helpers.Loca:GetDisplayName(Ext.Entity.Get(CurrentCharacterID)) or "Unknown"
        local ctext = tooltip:AddText(charname)
        ctext.SameLine = true
    end

    if item.DefaultBoosts ~= nil and item.DefaultBoosts ~= "" then
        StatBS:PresentStat(item.DefaultBoosts, Ext.Loca.GetTranslatedString("h308d7323fca747aaacdb9be9869bb184aa09"), tooltip)
    end
    if item.Boosts ~= nil and item.Boosts ~= "" then
        StatBS:PresentStat(item.Boosts, Ext.Loca.GetTranslatedString("h511afa5c85214d3383781325d05a8f4e25ca"), tooltip)
    end
    if item.PassivesOnEquip ~= nil and item.PassivesOnEquip ~= "" then
        StatBS:PresentStat(item.PassivesOnEquip, Ext.Loca.GetTranslatedString("h931080faa3ab46059ecdcd725fa390c219d7"), tooltip)
    end
    -- -- DefaultBoosts
    -- if item.DefaultBoosts ~= nil and item.DefaultBoosts ~= "" then
    --     local b = StatBS:SplitStatString(item.DefaultBoosts) or {}
    --     local boosttext = "DefaultBoosts: "
    --     for i,v in ipairs(b) do
    --         v = StatBS:CheckForCriticalHitBoost(v)
    --         local c = StatBS:CheckForStatConditional(v)
    --         boosttext = boosttext.."\n\t- "..(c ~= nil and c or v)
    --     end
    --     tooltip:AddText(wrap(boosttext, 70))
    -- end
    -- -- Boosts
    -- if item.Boosts ~= nil and item.Boosts ~= "" then
    --     local b = StatBS:SplitStatString(item.Boosts) or {}
    --     local boosttext = "Boosts: "
    --     for i,v in ipairs(b) do
    --         v = StatBS:CheckForCriticalHitBoost(v)
    --         local c = StatBS:CheckForStatConditional(v)
    --         boosttext = boosttext.."\n\t- "..(c ~= nil and c or v)
    --     end
    --     tooltip:AddText(wrap(boosttext, 70))
    -- end
    -- -- Passives
    -- if item.PassivesOnEquip ~= nil and item.PassivesOnEquip ~= "" then
    --     local p = StatBS:SplitStatString(item.PassivesOnEquip) or {}
    --     local passivetext = "Passives: "
    --     for i,v in ipairs(p) do
    --         local passive = Ext.Stats.Get(v) --[[@as PassiveData]]
    --         if passive ~= nil then
    --             if not StatBS:CheckPassiveContains(passive.Properties, "IsHidden") then
    --                 local parsed = StatBS:ReplaceDescParams(StatBS:StripLSTags(Ext.Loca.GetTranslatedString(passive.Description)), passive)
    --                 passivetext = passivetext.."\n\t"..
    --                     StatBS:StripLSTags(Ext.Loca.GetTranslatedString(passive.DisplayName)).."\n\t\t- "..
    --                     wrap(parsed, 50)
    --             end
    --         end
    --     end
    --     tooltip:AddText(passivetext)
    -- end
    -- Description
    tooltip:AddText(wrap(item.Description, 60, 10)):SetColor("Text", {0.66, 0.66, 0.66, 0.66})
    --ECDump(item.Stats)
    --ECDump(tooltip)
end

local function RefreshItemInfo()
    local selected = itemspawner.selectedItem
    if selected ~= nil and ItemInfoTable ~= nil then
        iteminfoNameText.Label = selected.DisplayName
        iteminfoStatNameText.Label = selected.Name
        iteminfoIDText.Label = selected.TemplateId
        iteminfoPreviewButton.OnClick = function(_)
            -- ECDebug("Requesting item preview (%s) for %s", itemspawner.selectedItem.TemplateId, CurrentCharacterID)
            Ext.Net.PostMessageToServer(ECChannels.RequestPreviewItem, Ext.Json.Stringify({
                TemplateId = itemspawner.selectedItem.TemplateId,
                Character = CurrentCharacterID, -- cringe --TODO --FIXME --SENDHELP
            }))
        end

        if selected.Icon ~= nil and selected.Icon ~= "" then
            ---@type ExtuiImage
            local tryicon
            if selected.IconFlaggedUnknown then
                tryicon = ItemInfoTable.UserData.IconCell:AddImage("Item_Unknown", {64, 64})
            else
                tryicon = ItemInfoTable.UserData.IconCell:AddImage(selected.Icon, {64, 64})
                if tryicon.ImageData.Icon == "" then
                    selected.IconFlaggedUnknown = true
                    tryicon:Destroy()
                    tryicon = ItemInfoTable.UserData.IconCell:AddImage("Item_Unknown", {64, 64})
                else
                    DoItemToolTip(tryicon:Tooltip(), selected)
                end
            end
            if iteminfoIcon ~= nil then
                iteminfoIcon:Destroy()
                iteminfoIcon = tryicon
                iteminfoIcon.Border = selected:GetColorByRarity()
            end
        end

        -- Refresh additional item rows after selection
        if ItemFilterCombo ~= nil then
            local icount = math.min(10, #ItemFilterCombo.Options - ItemFilterCombo.SelectedIndex)
            for i = 1, 10, 1 do
                if i <= icount then
                    UpdateItemScrollRow(i, ItemManager:GetItemByString(ItemFilterCombo.Options[ItemFilterCombo.SelectedIndex+1+i]))
                else
                    UpdateItemScrollRow(i, nil)
                end
            end
        end
    end
end

---comment
---@param parentTable ExtuiTable
---@param index integer
---@return ExtuiTableRow
function AddItemScrollRow(parentTable, index)
    local cellmap = {}
    local row = parentTable:AddRow()
    row.IDContext = string.format("NextItemsRow%d", index)
    ItemInfoNodes.Rows[index] = row
    local c1 = row:AddCell()
    c1.IDContext = string.format("NIR%dc1", index)
    local c1a = row:AddCell()
    c1a.IDContext = c1.IDContext.."Preview"
    local c2 = row:AddCell()
    c2.IDContext = string.format("NIR%dc2", index)
    local c3 = row:AddCell()
    c3.IDContext = string.format("NIR%dc3", index)
    -- local c4 = row:AddCell()
    -- c4.IDContext = string.format("NIR%dc4", index)
    cellmap[1] = c1
    cellmap[2] = c2
    cellmap[3] = c3
    cellmap[4] = c1a
    ItemInfoNodes.CellMaps[row.IDContext] = cellmap

    -- Add item content
    local c1b = c1:AddButton(">")
    c1b.IDContext = string.format("NIR%dbutton", index)
    local c1preview = c1a:AddImageButton("", "ico_concentration", {32,32})
    c1preview.IDContext = c1b.IDContext.."Preview"

    local icon = c2:AddImage("Item_ARM_Padded_3", {32, 32})
    icon.IDContext = string.format("NICicon%d", index)
    icon.Border = {1, 1, 1, 1}

    local c2t = c3:AddText("ItemDisplayName")
    c2t.IDContext = string.format("NIR%ddisplay", index)
    -- local c3t = c4:AddText("ItemName")
    -- c3t.IDContext = string.format("NIR%dname", index)

    return row
end
local function indexof(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end
function UpdateItemScrollRow(index, item)
    local row = ItemInfoNodes.Rows[index]
    -- nil item = hide row
    if item == nil then row.Visible = false return end
    -- Update item info
    local c1 = ItemInfoNodes.CellMaps[row.IDContext][1]
    local c2 = ItemInfoNodes.CellMaps[row.IDContext][2]
    local c3 = ItemInfoNodes.CellMaps[row.IDContext][3]
    local c4 = ItemInfoNodes.CellMaps[row.IDContext][4]

    c1.Children[1].OnClick = function()
        itemspawner.selectedItem = item
        if ItemFilterCombo ~= nil then
            local newindex = indexof(ItemFilterCombo.Options, item.DisplayName)
            if newindex ~= nil then
                ItemFilterCombo.SelectedIndex = newindex - 1
                ItemFilterCombo:OnChange()
            end
        end
    end
    if item ~= nil then
        if item.Icon ~= nil and item.Icon ~= "" then
            local tryicon
            if item.IconFlaggedUnknown then
                tryicon = c2:AddImage("Item_Unknown", {32, 32})
            else
                tryicon = c2:AddImage(item.Icon, {32, 32})
                if tryicon.ImageData.Icon == "" then
                    item.IconFlaggedUnknown = true
                    tryicon:Destroy()
                    tryicon = c2:AddImage("Item_Unknown", {32, 32})
                    --ECPrint("Setting to unknown in row: %s", item.Icon)
                else
                    DoItemToolTip(tryicon:Tooltip(), item)
                end
            end
            local idc = c2.Children[1].IDContext
            tryicon.Border = item:GetColorByRarity()
            c2.Children[1]:Destroy()
            tryicon.IDContext = idc
        end
        c3.Children[1].Label = item.DisplayName
        if c4 ~= nil and c4.Children[1] ~= nil then
            local button = c4.Children[1] --[[@as ExtuiButton]] -- cringe plz rewrite everything --TODO --FIXME --SENDHELP
            if item.Slot ~= nil then
                button.Disabled = false
                button:SetColor("Button", Imgui.Colors.BG3Brown)
                button.OnClick = function(_)
                    Ext.Net.PostMessageToServer(ECChannels.RequestPreviewItem, Ext.Json.Stringify({
                        TemplateId = item.TemplateId,
                        Character = CurrentCharacterID, -- cringe --TODO --FIXME --SENDHELP
                    }))
                end
            else
                button.Disabled = true
                button:SetColor("Button", Helpers.Color:NormalizedLerp(Imgui.Colors.BG3Brown, Imgui.Colors.Black, 70))
            end
        end
        --c4.Children[1].Label = item.Name
    end
    row.Visible = true
end

---comment
---@param treeParent ExtuiTreeParent
function ItemSpawnerMenu(treeParent)
    if ItemSpawnerTab ~= nil then return end -- stop infinite UI repopulation
    ItemSpawnerTab = treeParent
    --ECDump(ItemSpawnerTab)
    --treeParent.OnActivate = function () Mods.BG3MCM.MCM_WINDOW.AlwaysAutoResize = true end
    local notification = treeParent:AddText("")
    notification.IDContext = "ECNotifySpawner"

    SpawnNotify = ImguiStatus:New{ ImguiTextHandle = notification}

    treeParent:AddText(Ext.Loca.GetTranslatedString("h560364f7de0f4e328fe31e6cc370c7bdg913", "Item Type"))
    local iscombo = treeParent:AddCombo("")

    local searchlabel = treeParent:AddText(Ext.Loca.GetTranslatedString("hddea501eb8634f0393463e4dce0b67c62bgf"))
    searchlabel.SameLine = true
    local search = treeParent:AddInputText("")
    search.IDContext = "SearchInput"
    search.SameLine = true
    search.SizeHint = { 180, 36}

    treeParent:AddText(Ext.Loca.GetTranslatedString("h9757266c7fce457bacdd094744db0887054e", "Vanilla/Modded"))
    local optionRadio1 = treeParent:AddRadioButton(Ext.Loca.GetTranslatedString("h00b8afd4c96c4242a3ba59755572e53egb44"), true)
    optionRadio1.IDContext = "optionfilter1"
    optionRadio1.SameLine = true
    local optionRadio2 = treeParent:AddRadioButton(Ext.Loca.GetTranslatedString("hd7541dc7090f4ae78f4678e823a61d7acg45"), false)
    optionRadio2.IDContext = "optionfilter2"
    optionRadio2.SameLine = true
    local optionRadio3 = treeParent:AddRadioButton(Ext.Loca.GetTranslatedString("hb3a25de9914c4e7f882f7aaf30e5e0dc6e47"), false)
    optionRadio3.IDContext = "optionfilter3"
    optionRadio3.SameLine = true
    optionRadio1.OnChange = function(_)
        ItemVanillaFilter = nil
        optionRadio1.Active = true
        optionRadio2.Active = false
        optionRadio3.Active = false
        iscombo:OnChange()
        -- both modded/vanilla
        SpawnNotify:NewStatus(Ext.Loca.GetTranslatedString("h0aac44108df34982b085252026e1892fc277"), 0, SpawnNotify.DefaultFadeTime)
    end
    optionRadio2.OnChange = function(_)
        ItemVanillaFilter = true
        optionRadio1.Active = false
        optionRadio2.Active = true
        optionRadio3.Active = false
        iscombo:OnChange()
        -- vanilla only
        SpawnNotify:NewStatus(Ext.Loca.GetTranslatedString("hca6394f8f9af4d4fa21ec25a863bf507d3cd"), 0, SpawnNotify.DefaultFadeTime)
    end
    optionRadio3.OnChange = function(_)
        ItemVanillaFilter = false
        optionRadio1.Active = false
        optionRadio2.Active = false
        optionRadio3.Active = true
        iscombo:OnChange()
        -- modded only
        SpawnNotify:NewStatus(Ext.Loca.GetTranslatedString("h6fda18fea97b421d8279314d649229e75e08"), 0, SpawnNotify.DefaultFadeTime)
    end
    -- Rarity slider
    treeParent:AddText(Ext.Loca.GetTranslatedString("h7cf6afeeaaea4d57bb122250056d4ef1f04a"))
    local raritySlider = treeParent:AddSliderInt("", 0, 0, 5)
    local rarityText = treeParent:AddText(Ext.Loca.GetTranslatedString("h0fd6e53e2d0a444dac2076e4c02f2171761a"))
    rarityText:SetColor("Text", Imgui.RarityColors.Default)
    rarityText.SameLine = true
    raritySlider.SameLine = true
    raritySlider.AlwaysClamp = true
    raritySlider.NoInput = true
    raritySlider.ItemWidth = 150
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
        iscombo:OnChange()
        SpawnNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("h16c37ab0888842f6aebde21000bc9e747gg6").." %s", s.UserData.Text.Label), 0, SpawnNotify.DefaultFadeTime)
    end

    treeParent:AddText(Ext.Loca.GetTranslatedString("ha64c552a71a843a0add532b9437ac561g024"))
    local validVisualCheckbox = treeParent:AddCheckbox("", false)
    validVisualCheckbox.SameLine = true
    validVisualCheckbox:Tooltip():AddText(Ext.Loca.GetTranslatedString("hec0c99badad34c73a2be8b8b3097f3ce405d"))
    validVisualCheckbox.OnChange = function(c)
        if c.Checked then
            ItemValidVisualFilter = CurrentCharacterEquipmentRace
        else
            ItemValidVisualFilter = nil
        end
        iscombo:OnChange()
    end

    SearchGroup = treeParent:AddGroup("SearchGroup")
    --local subcombolabel = itemspawning:AddText("Filtered Items")
    ItemFilterCombo = SearchGroup:AddCombo("")
    ItemFilterCombo.IDContext = "ItemTypeSubCombo"
    ItemFilterCombo:Tooltip():AddText(Ext.Loca.GetTranslatedString("h284116a1f8394fbc9344b13bdca815ffab4a"))
    ItemFilterResultText = SearchGroup:AddText(string.format(Ext.Loca.GetTranslatedString("he75d40a1afb74856aa252fcdf45edd0370fe"), 0, #ItemFilterCombo.Options))
    ItemFilterResultText.IDContext = "ItemFilterResultText"
    ItemFilterResultText.SameLine = true
    --subcombo.SameLine = true
    
    ItemInfoTable = SearchGroup:AddTable("ItemInfo", 1)
    ItemInfoTable.Borders = true
    ItemInfoTable.SizingStretchSame = true
    local r = ItemInfoTable:AddRow()
    iteminfoIconCell = r:AddCell()
    iteminfoNameText = iteminfoIconCell:AddText(Ext.Loca.GetTranslatedString("h55cd1af4118548b7a7f45d93a49067e3bb85"))
    iteminfoPreviewButton = iteminfoIconCell:AddImageButton("", "ico_concentration", {36, 36})
    Imgui.SetPopupStyle(iteminfoPreviewButton:Tooltip()):AddText("\t"..Ext.Loca.GetTranslatedString("hb6cb8c179db14439ab309a5bca14f0c3df7f"))
    iteminfoStatNameText = iteminfoIconCell:AddBulletText(Ext.Loca.GetTranslatedString("h48fd5f32d3e94c0e8e8366e725f8bcaf5ab7"))
    iteminfoStatNameText.SameLine = true
    local itemInfoSubtable = iteminfoIconCell:AddTable("ItemInfoSubtable", 2)
    --itemInfoSubtable.Borders = true
    itemInfoSubtable.SizingStretchProp = true
    itemInfoSubtable.NoClip = true
    local subtr = itemInfoSubtable:AddRow()
    local iconCell = subtr:AddCell()
    local spawnCell = subtr:AddCell()
    
    iteminfoIcon = iconCell:AddImage("Item_ARM_Padded_3", {80, 80})
    iteminfoIDText = spawnCell:AddText("")
    ItemInfoTable.UserData = {
        ItemInfoCell = iteminfoIconCell,
        ItemInfoNameText = iteminfoNameText,
        ItemInfoStatNameText = iteminfoStatNameText,
        ItemInfoIDText = iteminfoIDText,
        ItemInfoIcon = iteminfoIcon,
        IconCell = iconCell,
    }

    local isbutton = spawnCell:AddButton(Ext.Loca.GetTranslatedString("h21b6e59df42348a9a203476c760f73aa5469"))
    local qtyResetButton = spawnCell:AddButton("R")
    qtyResetButton.SameLine = true
    Imgui.SetPopupStyle(qtyResetButton:Tooltip()):AddText("\t"..Ext.Loca.GetTranslatedString("hd3a163633a234a72ba3508f3092e64ad4e5a"))
    local qtyDecMoreButton = spawnCell:AddButton("-5")
    qtyDecMoreButton.SameLine = true
    local qtyDecButton = spawnCell:AddButton("-1")
    qtyDecButton.SameLine = true
    local qtySpawnSlider = spawnCell:AddDragInt("", 1,1,100)
    qtySpawnSlider.SameLine = true
    qtySpawnSlider.AlwaysClamp = true
    qtySpawnSlider.ItemWidth = 110
    qtySpawnSlider.Logarithmic = true
    local qtyIncButton = spawnCell:AddButton("+1")
    qtyIncButton.SameLine = true
    local qtyIncMoreButton = spawnCell:AddButton("+5")
    qtyIncMoreButton.SameLine = true
    spawnCell.UserData = {
        DragSlider = qtySpawnSlider,
        SpawnButton = isbutton,
    }
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

    SearchGroup:AddSpacing()
    local backToTopButton = SearchGroup:AddButton(Ext.Loca.GetTranslatedString("ha9a4474e05494c3a96b551af1ab90dc716d1"))
    backToTopButton.SameLine = true
    backToTopButton.Visible = false
    SearchBackwardButton = SearchGroup:AddButton("<<")
    SearchBackwardButton:SetStyle("ButtonTextAlign", 0, 0)
    SearchBackwardButton.SameLine = true
    SearchBackwardButton.Visible = false
    SearchForwardButton = SearchGroup:AddButton(">>")
    ScrollTableResultText = SearchGroup:AddText(string.format(Ext.Loca.GetTranslatedString("he75d40a1afb74856aa252fcdf45edd0370fe"), 0, #ItemFilterCombo.Options))
    ScrollTableResultText.SameLine = true
    ScrollTableResultText.IDContext = "ScrollTableResultText"
    SearchBackwardButton.UserData = {
        BackToTop = backToTopButton
    }
    SearchForwardButton.UserData = {
        BackToTop = backToTopButton
    }
    SearchBackwardButton.OnClick = function(b)
        local newindex = math.max(ItemFilterCombo.SelectedIndex - 10, 0)
        itemspawner.selectedItem = ItemFilterCombo.Options[newindex]
        ItemFilterCombo.SelectedIndex = newindex
        ItemFilterCombo:OnChange()
        if b.UserData and b.UserData.BackToTop then
            b.UserData.BackToTop.Visible = false
        end
    end
    SearchForwardButton.OnClick = function(_)
        local newindex = math.min(ItemFilterCombo.SelectedIndex + 10, #ItemFilterCombo.Options-1)
        itemspawner.selectedItem = ItemFilterCombo.Options[newindex]
        ItemFilterCombo.SelectedIndex = newindex
        ItemFilterCombo:OnChange()
    end
    SearchForwardButton.SameLine = true
    SearchForwardButton.Visible = false
    backToTopButton.OnClick = function(b)
        itemspawner.selectedItem = ItemFilterCombo.Options[0]
        ItemFilterCombo.SelectedIndex = 0
        ItemFilterCombo:OnChange()
        b.Visible = false
    end
    ScrollTableResultText.UserData = {
        BackToTop = backToTopButton,
    }

    -- new scrollNodes
    local scrolltable = SearchGroup:AddTable("NextItems", 4)
    scrolltable.SizingFixedFit = true
    for i = 1, 10, 1 do
        local row = AddItemScrollRow(scrolltable, i)
        row.Visible = false
    end

    iscombo.IDContext = "ItemTypeCombo"
    iscombo.SameLine = true
    iscombo.SelectedIndex = 0
    iscombo.WidthFitPreview = true
    iscombo.Options = itemspawner:getTranslatedItemTypes()
    ItemFilterCombo.WidthFitPreview = true
    ItemFilterCombo.Options = ItemManager:GetItemStringsOfType(itemspawner.selectedType, ItemVanillaFilter, ItemValidVisualFilter, raritySlider.Value[1])
    iscombo.OnChange = function()
        itemspawner.selectedType = itemspawner.itemtypemap[iscombo.Options[iscombo.SelectedIndex+1]]
        ItemFilterCombo.Options = ItemManager:GetItemStringsOfType(itemspawner.selectedType, ItemVanillaFilter, ItemValidVisualFilter, raritySlider.Value[1])
        ItemFilterCombo.SelectedIndex = 0
        ItemFilterCombo:OnChange()
        SpawnNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("he7cc6ac9dd53401fa5c344fd548ab5cb83e5"), itemspawner:getTranslatedItemTypes()[iscombo.SelectedIndex+1]), 0, SpawnNotify.DefaultFadeTime)
        if search.Text ~= "" then
            search:OnChange()
        end
    end
    ItemFilterCombo.OnChange = function (_)
        itemspawner.selectedItem = ItemManager:GetItemByString(ItemFilterCombo.Options[ItemFilterCombo.SelectedIndex+1])
        if itemspawner.selectedItem ~= nil then
            RefreshItemInfo()
        end
        ItemFilterResultText.Label = string.format(Ext.Loca.GetTranslatedString("he75d40a1afb74856aa252fcdf45edd0370fe"), ItemFilterCombo.SelectedIndex + 1, #ItemFilterCombo.Options)
        ScrollTableResultText.Label = string.format(Ext.Loca.GetTranslatedString("h30000f45b2a04740b5d462b71a1a0e2509af"), math.min(ItemFilterCombo.SelectedIndex + 2, #ItemFilterCombo.Options),
            math.min(#ItemFilterCombo.Options, ItemFilterCombo.SelectedIndex+12), #ItemFilterCombo.Options)
        if ItemFilterCombo.SelectedIndex +2 > #ItemFilterCombo.Options then
            -- end of the list
            ScrollTableResultText.Label = Ext.Loca.GetTranslatedString("hc7fc3ea6bc574b4f86a93ca81ba64c46cc76")
            ScrollTableResultText.UserData.BackToTop.Visible = true
        end
        SearchForwardButton.Visible = true
        SearchBackwardButton.Visible = true
        ScrollTableResultText.Visible = true
        ItemInfoTable.Visible = true
    end
    isbutton.UserData = {
        QtySlider = qtySpawnSlider,
    }
    isbutton.OnClick = function(b)
        if b.UserData == nil or b.UserData.QtySlider == nil then return end
        SpawnNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("heea450d058614ef3a1912053e8f44c5806a6"), itemspawner.selectedItem.TemplateId), 1, SpawnNotify.DefaultFadeTime)
        --TODO: Check for valid template to spawn before posting
        Ext.Net.PostMessageToServer(ECChannels.SpawnItem, Ext.Json.Stringify({
            ItemToSpawn = itemspawner.selectedItem.TemplateId,
            Amount = b.UserData.QtySlider.Value[1]
        }))
    end

    search.UserData = {
        RaritySlider = raritySlider,
    }
    search.OnChange = function(s)
        --iscombo.SelectedIndex = 0
        --ECDebug(search.Text)
        local matches = ItemManager:GetMatchingItemStrings(s.Text, itemspawner.selectedType, ItemVanillaFilter, ItemValidVisualFilter, s.UserData.RaritySlider.Value[1])
        --ECDebug("Search newvalue: %s (%d matches)", newvalue.Text, #matches)
        if #matches == 0 then
            --ECDebug("Can't find search input (%d): %s", #matches, newvalue.Text)
            SearchGroup.Visible = false
            SpawnNotify:NewStatus(Ext.Loca.GetTranslatedString("he15c11925a934cae91a56c21698ebb806cge"), -1, SpawnNotify.DefaultFadeTime)
        else
            ItemFilterCombo.Options = matches or {}
            SpawnNotify:NewStatus(string.format(Ext.Loca.GetTranslatedString("h6dd61332d8364bd090d8b775319859173dg6"), s.Text, iscombo.Options[iscombo.SelectedIndex+1]), 0, SpawnNotify.DefaultFadeTime)
            SearchGroup.Visible = true
            ItemFilterCombo.SelectedIndex = 0
            ItemFilterCombo:OnChange()
        end
    end
    ScrollTableResultText.Visible = false
    ItemInfoTable.Visible = false
end