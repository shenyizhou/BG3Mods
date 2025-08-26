
---@class ECSearchableSpellUI:ECSearchableStatUI
SearchableSpellUI = _Class:Create("ECSearchableSpellUI", "ECSearchableStatUI", {
    StatName = "Spell",
    SearchHint = Ext.Loca.GetTranslatedString("hb09c633388854d448b0167c6b4307cb1b16a", "fire"),
})

-- Spell-specific override
---@param pop ExtuiPopup
---@param s ExtuiInputText
function SearchableSpellUI:CreateFilterSettings(pop, s)
    s.UserData.FilterCheckboxes = {
        Name            = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h4bf3afafd37c4224be8e9543f03b421b8bd5", "Name"), true),
        DisplayName     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h58714a3d2d95403f8483061a2a267f61de99", "Display Name"), true),
        SpellType       = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h9cc85faf3c81483aaa32fd02ab37a54ba999", "Spell Type"), true),
        SpellFlags      = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h2addca0d959e48a7a3dc91734a505b9d04da", "Spell Flags"), true),
        SpellSchool     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h963150e110264f52be0ff9d2a05df28edffc", "Spell School"), true),
        Description     = pop:AddCheckbox(Ext.Loca.GetTranslatedString("h38cc28b1d53e4cc4951f278ff660ee5ad618", "Description"), true),
    }
    local upcastLabel = pop:AddText(Ext.Loca.GetTranslatedString("h0d916b9643c5444ea3058e92d40eba17g487", "Include upcasts?"))
    upcastLabel:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))
    local upcastChk = pop:AddCheckbox("")
    upcastChk.IDContext = s.IDContext.."UpcastCheck"
    upcastChk.SameLine = true
    s.UserData.FilterCheckboxes.Upcast = upcastChk

    local function searchChanged(_) s:OnChange() end
    s.UserData.FilterCheckboxes.Name.OnChange = searchChanged
    s.UserData.FilterCheckboxes.DisplayName.OnChange = searchChanged
    s.UserData.FilterCheckboxes.SpellType.OnChange = searchChanged
    s.UserData.FilterCheckboxes.SpellFlags.OnChange = searchChanged
    s.UserData.FilterCheckboxes.SpellSchool.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Description.OnChange = searchChanged
    s.UserData.FilterCheckboxes.Upcast.OnChange = searchChanged
    pop.UserData = {}
end

-- Spell-specific override
---@param searchInput ExtuiInputText
---@return table<string>
function SearchableSpellUI:GetStatMatches(searchInput)
    local f = searchInput.UserData.FilterCheckboxes
    local matches = ECSpellManager:GetMatchingSpellStrings(searchInput.Text, {
        f.Name.Checked and StatSearchFilter.Name or nil,
        f.DisplayName.Checked and StatSearchFilter.DisplayName or nil,
        f.SpellType.Checked and StatSearchFilter.SpellType or nil,
        f.SpellSchool.Checked and StatSearchFilter.SpellSchool or nil,
        f.Description.Checked and StatSearchFilter.Description or nil,
        f.SpellFlags.Checked and StatSearchFilter.SpellFlags or nil,
    }, f.Upcast.Checked)
    local locaString = Ext.Loca.GetTranslatedString("h015a0692b7234fae86c89f1ac4f62c898b97", "Spell Search").." (%d "
    locaString = locaString..Ext.Loca.GetTranslatedString("hbd813e026c7c42a0b977bbe04a72602c4903", "matches")..")"
    searchInput.UserData.LabelText.Label = string.format(locaString, #matches)
    return matches or {}
end

-- Spell-specific override
---@param childWindow ExtuiChildWindow
---@param statName string
function SearchableSpellUI:DisplayStatByName(childWindow, statName)
    local spell = ECSpellManager:GetSpellByString(statName)
    if spell == nil then return end

    local spellIcon
    if not spell.IconFlaggedUnknown then
        spellIcon = childWindow:AddImage(spell.Icon, {64, 64})
        if spellIcon.ImageData.Icon == "" then
            spell.IconFlaggedUnknown = true
            spellIcon:Destroy()
            spellIcon = childWindow:AddImage("Item_Unknown", {64, 64})
        end
    else
        spellIcon = childWindow:AddImage("Item_Unknown", {64, 64})
    end
    -- spellIcon.SameLine = true
    local flagsTT = Imgui.CreateSimpleTooltip(spellIcon:Tooltip(), function(t)
        Imgui.SetChunkySeparator(t:AddSeparatorText(Ext.Loca.GetTranslatedString("hf53479dc7096414b9e524a152ce9b186ead3","Flags")))
        for i, v in ipairs(spell.SpellFlags) do
            t:AddBulletText(v)
        end
        return t
    end)
    local learnButton = childWindow:AddButton(Ext.Loca.GetTranslatedString("hf48c59d3be46497e84127fd903976bd895a9", "Learn"))
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
                Character = CharacterInterface_UI.CurrentCharacterUuid, -- hmm
                Change = "LearnSpell",
                Args = {
                    Spell = spell.Name
                }
            }))
            
            -- Regenerate a little later, spell should've settled by then
            Helpers.Timer:OnTime(500, function()
                if self.RegenerateUI then
                    self.RegenerateUI()
                end
            end)
        end
    end
    local titleDisplay = Imgui.SetChunkySeparator(childWindow:AddSeparatorText(spell.DisplayName))
    titleDisplay:SetStyle("SeparatorTextPadding", 0, 20)
    titleDisplay:SetStyle("SeparatorTextAlign", 0.25, 0.5)
    titleDisplay.SameLine = true
    if spell.UpcastIDs then
        local upcastIcon = childWindow:AddImage("ico_concertina", {40,40})
        upcastIcon.SameLine = true
        upcastIcon.PositionOffset = {-5, 14}
        Imgui.CreateSimpleTooltip(upcastIcon:Tooltip(), function(t)
            Imgui.SetChunkySeparator(t:AddSeparatorText(Ext.Loca.GetTranslatedString("h0e604abf0e8f47cf938e16c67d0729b3acaa", "Upcast Versions")))
            for _, v in ipairs(spell.UpcastIDs) do
                t:AddBulletText(v)
            end
            return t
        end)
    elseif spell.RootSpellID:gsub(" ", "") ~= "" then
        local rootspellIcon = childWindow:AddImage("ico_levelUp_d", {40,40})
        rootspellIcon.SameLine = true
        rootspellIcon.PositionOffset = {-5, 14}
        Imgui.CreateSimpleTooltip(rootspellIcon:Tooltip(), function(t)
            Imgui.SetChunkySeparator(t:AddSeparatorText(Ext.Loca.GetTranslatedString("h0285e6f05f8944cbb882bc4f0efd32e49f47", "Root Spell ID")))
            t:AddText(spell.RootSpellID)
            return t
        end)
    end

    local spellName
    if Ext.Utils.Version() >= 20 then
        spellName = childWindow:AddText(spell.Name)
        spellName.TextWrapPos = 435
    else
        spellName = childWindow:AddText(wrap(spell.Name, 60))
    end
    spellName:SetColor("Text", Imgui.Colors.Azure)

    local spellInfoTable = Imgui.SetupTable(childWindow:AddTable("SpellInfoTable", 2), false, false, "SizingFixedFit", false, false)
    local r = spellInfoTable:AddRow()
    local function MakeInfoRow(label1, val1, label2, val2)
        local c1 = r:AddCell()
        c1:AddText(label1)
        local v1 = c1:AddText(val1)
        v1.SameLine = true
        v1:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))

        local c2 = r:AddCell()
        c2:AddText(label2)
        local v2 = c2:AddText(tostring(val2))
        v2.SameLine = true
        v2:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))
    end

    local locaNone = Ext.Loca.GetTranslatedString("h00d346068d224a6f952bb25c66fd3b32g6c9", "None")
    MakeInfoRow(Ext.Loca.GetTranslatedString("h5c2703cc56454e3fab32cd1f4be8885080d2","Cooldown:"), spell.Cooldown or locaNone,
        Ext.Loca.GetTranslatedString("hc36e59b1c7514c7e945fbf16dcd7e498g0b9","Level:"), spell.Level or "0")
    MakeInfoRow(Ext.Loca.GetTranslatedString("h1a7202a1ef1f48a4865b6f1073ce79b59f74", "Spell School:"), spell.SpellSchool or locaNone,
        Ext.Loca.GetTranslatedString("hfd10514f87e24ee28afcfef4fb0e65f056dc","Shape:"), spell.Shape or locaNone)
    childWindow:AddText(Ext.Loca.GetTranslatedString("h1246ead50fd9437597fd8e7f67c2029d2geg", "Use Costs:"))
    local useCostDisplay = childWindow:AddText(spell.UseCosts or Ext.Loca.GetTranslatedString("hc86af83da94a4351a61691c1fa771f94094d", "Unknown"))
    useCostDisplay.SameLine = true
    useCostDisplay:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1))

    Imgui.CreateSimpleTooltip(useCostDisplay:Tooltip(), function(t)
        Imgui.SetChunkySeparator(t:AddSeparatorText(Ext.Loca.GetTranslatedString("h1246ead50fd9437597fd8e7f67c2029d2geg", "Use Costs:")))
        if not spell.UseCosts or type(spell.UseCosts) ~= "string" or string.gsub(spell.UseCosts," ", "") == "" then
            t:AddBulletText(locaNone)
            return t
        end

        local split = string.split(spell.UseCosts, ";")
        for i, v in ipairs(split) do
            if v ~= "" then
                t:AddBulletText(v)
            end
        end
        return t
    end)
    local spellInfoDescChild = childWindow:AddChildWindow("SpellInfoDescChild")

    --spellInfoDescChild.Size = {500, 20}
    -- spellInfoDescChild.AlwaysAutoResize = true
    -- spellInfoDescChild.NoScrollbar = true
    spellInfoDescChild.AutoResizeY = true
    spellInfoDescChild.ResizeY = true
    
    -- spellInfoDescChild.ChildAlwaysAutoResize = true
    spellInfoDescChild.AlwaysUseWindowPadding = true
    spellInfoDescChild:SetColor("ChildBg", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.DarkGrey, .5))
    if Ext.Utils.Version() >= 20 then
        local desc = spellInfoDescChild:AddText(StatBS:StripLSTags(spell.Description))
        desc.PositionOffset = {15,15}
        desc.TextWrapPos = 425
    else
        local desc = spellInfoDescChild:AddText(wrap(StatBS:StripLSTags(spell.Description), 60))
        desc.PositionOffset = {15,15}
    end

    childWindow.UserData.AddButton = learnButton
end