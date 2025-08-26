---@class ECCharacterInterface:MetaClass
---@field CurrentCharacterUuid CHARACTER|nil
---@field SpellBookUITree ExtuiTree|nil
---@field PassiveUITree ExtuiTree|nil
---@field StatusUITree ExtuiTree|nil
---@field TagUITree ExtuiTree|nil
CharacterInterface_UI = _Class:Create("ECCharacterInterface", nil,{

})

---@param entity EntityHandle|nil
function CharacterInterface_UI:OnCharacterChanged(entity)
    if entity == nil then
        entity = Helpers.Character:GetLocalControlledEntity()
        if entity == nil then return end
        self.CurrentCharacterUuid = Helpers.Object:GetGuid(entity)
        if self.CurrentCharacterUuid == nil then return end -- currently controlled entity has no guid, bail
    end

    if self.SpellBookUITree then
        self:RegenerateSpellBookInfo(entity)
    end
    if self.PassiveUITree then
        self:RegeneratePassiveInfo(entity)
    end
    if self.StatusUITree then
        self:RegenerateStatusInfo(entity)
    end
    if self.TagUITree then
        self:RegenerateTagInfo(entity)
    end
end
---@param entity EntityHandle|nil
---@param el ExtuiStyledRenderable
---@return EntityHandle|nil
function CharacterInterface_UI:_characterCheckAndClear(entity, el)
    if entity == nil then
        entity = Helpers.Character:GetLocalControlledEntity()
        if entity == nil then return end -- bail if no entity available
    end
    self.CurrentCharacterUuid = Helpers.Object:GetGuid(entity)
    if self.CurrentCharacterUuid == nil then return end -- currently controlled entity has no guid, bail
    Imgui.ClearChildren(el)
    return entity -- ready
end
function CharacterInterface_UI:RegenerateSpellBookInfo(entity)
    if self.SpellBookUITree == nil then return end
    entity = self:_characterCheckAndClear(entity, self.SpellBookUITree)
    if entity == nil then return end
    self.SpellBookUITree.UserData = {
        SpellButtons = {}
    }
    local spellBookTreeChildWin = self.SpellBookUITree:AddChildWindow("SpellbookTest")
    spellBookTreeChildWin:SetStyle("FrameRounding", 5)
    spellBookTreeChildWin.Size = {420, 300}
    -- spellBookTreeChildWin.AlwaysAutoResize = true

    -- spellBookTreeChildWin.AutoResizeX = true
    -- spellBookTreeChildWin.NoScrollWithMouse = false
    self.SpellBookUITree.Label = "SpellBook"
    local spellBookTable = Imgui.SetupTable(spellBookTreeChildWin:AddTable("SpellBookTable", 3), true, true, "SizingStretchProp", false, false)
    -- spellBookTable.Size = {420, 360}
    if entity.SpellBook  ~= nil then
        local spellbook = Ext.Types.Serialize(entity.SpellBook) --[[@as SpellBookComponent]]
        if spellbook == nil then return ECWarn("Couldn't serialize SpellBook") end
        -- ECPrint("SpellBook: %d entries", #spellbook.Spells)
        self.SpellBookUITree.Label = string.format("SpellBook: %d entries", #spellbook.Spells)
        local headerRow = spellBookTable:AddRow()
        headerRow.Headers = true
        headerRow:AddCell():AddText("")
        headerRow:AddCell():AddText("SpellId")
        headerRow:AddCell():AddText("Modifier")
        spellBookTable:AddColumn("",nil, 3) -- proportional
        spellBookTable:AddColumn("SpellID", nil, 20)
        spellBookTable:AddColumn("Modifier", nil, 10)
        local row = spellBookTable:AddRow()
        for _, v in ipairs(spellbook.Spells) do
            local spellUnlearnButton = row:AddCell():AddImageButton("SpellBook"..v.Id.Prototype, "btn_close_h", {20, 20})
            Imgui.CreateSimpleTooltip(spellUnlearnButton:Tooltip(), function(t)
                t:AddText("\t".."Unlearn")
                return t
            end)
            spellUnlearnButton.UserData = { ID = v.Id.Prototype }
            spellUnlearnButton.OnClick = function(b)
                Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                    Character = self.CurrentCharacterUuid,
                    Change = "RemoveSpell",
                    Args = {
                        Spell = b.UserData.ID
                    }
                }))
                -- Regenerate a little later, spell should've settled by then
                Helpers.Timer:OnTime(500, function()
                    self:RegenerateSpellBookInfo()
                end)
            end
            self.SpellBookUITree.UserData.SpellButtons[v.Id.Prototype] = spellUnlearnButton
            
            local spellText = row:AddCell():AddText(v.Id.Prototype)
            spellText.ItemWidth = 40
            if v.Id.SourceType == "ActiveDefense" then
                spellText:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive, 1.0))
            elseif v.Id.SourceType == "SpellSet" then
                spellText:SetColor("Text", Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainText, 0.3))
                
            end
            local castingResource = Ext.StaticData.Get(v.PreferredCastingResource, "ActionResource")
            local castingResourceName = castingResource ~= nil and castingResource.DisplayName:Get() or v.PreferredCastingResource
            castingResourceName = castingResourceName == Helpers.Format.NullUuid and "None" or castingResourceName
            local progressionSource = Ext.StaticData.Get(v.Id.ProgressionSource, "ClassDescription") --[[@as ResourceClassDescription]]
            local progressionSourceName = progressionSource ~= nil and progressionSource.DisplayName:Get() or v.Id.ProgressionSource
            progressionSourceName = progressionSourceName == Helpers.Format.NullUuid and "None" or progressionSourceName
            local tt = Imgui.CreateSimpleTooltip(spellText:Tooltip(), function(t)
                t:AddSeparatorText(v.Id.Prototype)
                t:AddBulletText(string.format("SourceType: %s (Originator: %s)", v.Id.SourceType, v.Id.OriginatorPrototype))
                t:AddBulletText(string.format("PrepareType: %s", v.PrepareType))
                t:AddBulletText(string.format("SpellCastingAbility: %s", v.SpellCastingAbility))
                t:AddBulletText(string.format("PreferredCastingResource: %s", castingResourceName))
                t:AddBulletText(string.format("ProgressionSource: %s", progressionSourceName))
                return t
            end)
            local spellModifierDropdown = row:AddCell():AddCombo("")
            spellModifierDropdown.IDContext = spellUnlearnButton.IDContext.."Modifier"
            spellModifierDropdown.ItemWidth = 110
            spellModifierDropdown.NoArrowButton = true
            spellModifierDropdown.Options = {
                "None",
                "Strength",
                "Dexterity",
                "Constitution",
                "Intelligence",
                "Wisdom",
                "Charisma",
            }
            local index = table.indexOf(spellModifierDropdown.Options, v.SpellCastingAbility)
            index = index ~= nil and index-1 or 0
            spellModifierDropdown.SelectedIndex = index
            spellModifierDropdown.UserData = {
                ID = v.Id.Prototype,
                SourceType = v.Id.SourceType,
                Modifier = v.SpellCastingAbility
            }
            spellModifierDropdown.OnChange = function(c)
                local newModifier = Imgui.Combo.GetSelected(c)
                Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                    Character = self.CurrentCharacterUuid,
                    Change = "ChangeSpellModifier",
                    Args = {
                        Spell = c.UserData.ID,
                        SourceType = c.UserData.SourceType,
                        Modifier = newModifier,
                    }
                }))
                -- Regenerate a little later, spell should've settled by then
                Helpers.Timer:OnTime(500, function()
                    self:RegenerateSpellBookInfo()
                end)
            end
            -- ECDebug("ID: %s [%s] (SourceType: %s, %s)", v.Id.Prototype, v.Id.OriginatorPrototype, v.Id.SourceType, v.Id.ProgressionSource)
            -- _P(string.format("PrepareType: %s", v.PrepareType), string.format("SpellCastingAbility: %s", v.SpellCastingAbility), string.format("PreferredCastingResource: %s", v.PreferredCastingResource))
        end
        -- ECPrint("==============")
    end
end
function CharacterInterface_UI:RegeneratePassiveInfo(entity)
    if self.PassiveUITree == nil then return end
    entity = self:_characterCheckAndClear(entity, self.PassiveUITree)
    if entity == nil then return end
    self.PassiveUITree.UserData = {
        PassiveButtons = {}
    }

    local passiveTreeChildWin = self.PassiveUITree:AddChildWindow("PassiveTest")
    passiveTreeChildWin:SetStyle("FrameRounding", 5)
    passiveTreeChildWin.Size = {420, 300}

    self.PassiveUITree.Label = "Passives"
    local passiveTable = Imgui.SetupTable(passiveTreeChildWin:AddTable("PassiveTable", 2), true, true, "SizingStretchProp", false, false)
    if entity.PassiveContainer  ~= nil then
        local passiveContainer = Ext.Types.Serialize(entity.PassiveContainer) --[[@as PassiveContainerComponent]]
        if passiveContainer == nil then return ECWarn("Couldn't serialize PassiveContainer") end

        self.PassiveUITree.Label = string.format("Passives: %d entries", #passiveContainer.Passives)
        local headerRow = passiveTable:AddRow()
        headerRow.Headers = true
        headerRow:AddCell():AddText("")
        headerRow:AddCell():AddText("PassiveId")
        passiveTable:AddColumn("",nil, 2) -- proportional
        passiveTable:AddColumn("PassiveId", nil, 20)
        local row = passiveTable:AddRow()

        for _, pe in ipairs(passiveContainer.Passives) do
            local passive = pe.Passive --[[@as PassiveComponent]]
            if not passive then break end
            local passiveRemoveButton = row:AddCell():AddImageButton("Passive"..passive.PassiveId, "btn_close_h", {20, 20})
            Imgui.CreateSimpleTooltip(passiveRemoveButton:Tooltip(), function(t)
                t:AddText("\t".."Remove")
                return t
            end)
            passiveRemoveButton.UserData = { ID = passive.PassiveId}
            passiveRemoveButton.OnClick = function(b)
                Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                    Character = self.CurrentCharacterUuid,
                    Change = "RemovePassive",
                    Args = {
                        Passive = b.UserData.ID
                    }
                }))
                Helpers.Timer:OnTime(500, function()
                    self:RegeneratePassiveInfo()
                end)
            end
            self.PassiveUITree.UserData.PassiveButtons[passive.PassiveId] = passiveRemoveButton
                
            local passiveText = row:AddCell():AddText(passive.PassiveId)
            passiveText.ItemWidth = 80
                
            local tt = Imgui.CreateSimpleTooltip(passiveText:Tooltip(), function(t)
                    t:AddSeparatorText(passive.PassiveId)
                    t:AddBulletText(string.format("Type: %s", passive.Type))
                    t:AddBulletText(string.format("Disabled: %s", passive.Disabled))
                    t:AddBulletText(string.format("ToggledOn: %s", passive.ToggledOn))
                    t:AddBulletText(string.format("Source: %s", passive.Source or "null"))
                    t:AddBulletText(string.format("Item: %s", passive.Item or "none"))
                    return t
            end)
        end
    end
end

---@class QuickStatusData
---@field ID string Status Name
---@field Data ECStatStatus
---@field Lifetime number Duration
---@field Dynamic boolean Whether it was found in StatusManager or not, likely dynamic if true

---@param entity EntityHandle
---@return table<integer, QuickStatusData>
local function _gatherStatusTable(entity)
    local statusTable = {}
    if entity.StatusContainer ~= nil then 
        for status, name in pairs(entity.StatusContainer.Statuses) do
            local statData = ECStatusManager:GetStatusByString(name)
            local lifetime
            if pcall(function() return status.StatusLifetime.Lifetime end) then
                lifetime = status.StatusLifetime.Lifetime
            else
                lifetime = status.StatusLifetime.field_4
            end
            if statData ~= nil then
                table.insert(statusTable, {
                    ID = name,
                    Data = statData,
                    Lifetime = lifetime,
                })
            else
                -- Dynamic status, created at runtime?
                local dynStat = ECStatusManager:ParseDynamicStat(name)
                if dynStat ~= nil then
                    -- Found data, parsed by ECStatusManager
                    table.insert(statusTable, {
                        ID = name,
                        Data = dynStat,
                        Lifetime = lifetime,
                        Dynamic = true,
                    })
                end
            end
        end
    end
    return statusTable
end

function CharacterInterface_UI:RegenerateStatusInfo(entity)
    if self.StatusUITree == nil then return end
    entity = self:_characterCheckAndClear(entity, self.StatusUITree)
    if entity == nil then return end
    self.StatusUITree.UserData = {
        StatusButtons = {}
    }

    local statusTreeChildWin = self.StatusUITree:AddChildWindow("StatusTest")
    statusTreeChildWin:SetStyle("FrameRounding", 5)
    statusTreeChildWin.Size = {420, 300}

    self.StatusUITree.Label = "Statuses"
    local statusTable = Imgui.SetupTable(statusTreeChildWin:AddTable("StatusTable", 2), true, true, "SizingStretchProp", false, false)
    if entity.StatusContainer  ~= nil then
        local statusContainer = Ext.Types.Serialize(entity.StatusContainer) --[[@as StatusContainerComponent]]
        if statusContainer == nil then return ECWarn("Couldn't serialize StatusContainer") end

        self.StatusUITree.Label = string.format("Statuses: %d entries", table.count(statusContainer.Statuses))
        local headerRow = statusTable:AddRow()
        headerRow.Headers = true
        headerRow:AddCell():AddText("")
        headerRow:AddCell():AddText("Name")
        statusTable:AddColumn("",nil, 2) -- proportional
        statusTable:AddColumn("Name", nil, 20)
        local row = statusTable:AddRow()

        -- Statuses parsed slightly different than other things, because 1) StatusContainer cringe, 2) Runtime status creation is popular
        for _, st in ipairs(_gatherStatusTable(entity)) do
            local status = st.Data --[[@as ECStatStatus]]
            if not status then break end
            local statusRemoveButton = row:AddCell():AddImageButton("Status"..status.Name, "btn_close_h", {20, 20})
            Imgui.CreateSimpleTooltip(statusRemoveButton:Tooltip(), function(t)
                t:AddText("\t".."Remove")
                return t
            end)
            statusRemoveButton.UserData = { ID = status.Name}
            statusRemoveButton.OnClick = function(b)
                Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                    Character = self.CurrentCharacterUuid,
                    Change = "RemoveStatus",
                    Args = {
                        Status = b.UserData.ID
                    }
                }))
                Helpers.Timer:OnTime(500, function()
                    self:RegenerateStatusInfo()
                end)
            end
            self.StatusUITree.UserData.StatusButtons[status.Name] = statusRemoveButton
                
            local statusNameCell = row:AddCell()
            local statusText = statusNameCell:AddText(status.DisplayName)
            statusText.ItemWidth = 80
            if st.Dynamic then
                local specialIcon = statusNameCell:AddImage("ico_btn_load_d", {20, 20})
                specialIcon.SameLine = true
                Imgui.CreateSimpleTooltip(specialIcon:Tooltip(), function(t)
                    t:AddText("Dynamic status created at runtime.")
                    return t
                end)
            end
                
            Imgui.CreateSimpleTooltip(statusText:Tooltip(), function(t)
                if (Ext.Utils.Version()) >= 20 then
                    t.TextWrapPos = 450
                end
                t:AddSeparatorText(status.DisplayName)
                t:AddBulletText(string.format("Name: %s", status.Name))
                t:AddBulletText(string.format("StatusType: %s", status.StatusType))
                t:AddBulletText(string.format("StackId: %s", status.StackId))
                StatBS:PresentStat( status.Boosts, "Boosts", t)
                StatBS:PresentStat(status.Passives, "Passives", t)
                -- t:AddBulletText(string.format("Boosts: %s", status.Boosts == "" and "None" or status.Boosts == nil and "None" or status.Boosts)).TextWrapPos = 80
                -- t:AddBulletText(string.format("Passives: %s", status.Passives == "" and "None" or status.Passives == nil and "None" or status.Passives)).TextWrapPos = 80
                if status.AuraRadius and type(status.AuraRadius) == "number" and status.AuraRadius > 0 then
                    t:AddBulletText(string.format("Aura: %s", status.AuraRadius))
                end
                return t
            end)
        end
    end
end

function CharacterInterface_UI:RegenerateTagInfo(entity)
    if self.TagUITree == nil then return end
    entity = self:_characterCheckAndClear(entity, self.TagUITree)
    if entity == nil then return end
    self.TagUITree.UserData = {
        TagButtons = {}
    }

    local tagTreeChildWin = self.TagUITree:AddChildWindow("TagTest")
    tagTreeChildWin:SetStyle("FrameRounding", 5)
    tagTreeChildWin.Size = {420, 300}

    self.TagUITree.Label = "Tags"
    local tagTable = Imgui.SetupTable(tagTreeChildWin:AddTable("TagTable", 2), true, true, "SizingStretchProp", false, false)
    if entity.Tag  ~= nil then
        local tagComponent = Ext.Types.Serialize(entity.Tag) --[[@as TagComponent]]
        if tagComponent == nil then return ECWarn("Couldn't serialize Tag component") end

        self.TagUITree.Label = string.format("Tags: %d entries", #tagComponent.Tags)
        local headerRow = tagTable:AddRow()
        headerRow.Headers = true
        headerRow:AddCell():AddText("")
        headerRow:AddCell():AddText("Name")
        tagTable:AddColumn("",nil, 2) -- proportional
        tagTable:AddColumn("Name", nil, 20)
        local row = tagTable:AddRow()

        -- Tags parsed slightly different than other things, because 1) Tag cringe, 2) Runtime tag creation is popular
        for _, ti in ipairs(tagComponent.Tags) do
            local tag = ECTagManager:GetTagByString(ti) --[[@as ECTag]]
            if not tag then break end
            local tagRemoveButton = row:AddCell():AddImageButton("Tag"..tag.TagName, "btn_close_h", {20, 20})
            Imgui.CreateSimpleTooltip(tagRemoveButton:Tooltip(), function(t)
                t:AddText("\t".."Remove")
                return t
            end)
            tagRemoveButton.UserData = { ID = tag.TagUuid}
            tagRemoveButton.OnClick = function(b)
                Ext.Net.PostMessageToServer(ECChannels.RequestEntityEdit, Ext.Json.Stringify({
                    Character = self.CurrentCharacterUuid,
                    Change = "ClearTag",
                    Args = {
                        Tag = b.UserData.ID
                    }
                }))
                Helpers.Timer:OnTime(1000, function()
                    self:RegenerateTagInfo()
                end)
            end
            self.TagUITree.UserData.TagButtons[tag.TagUuid] = tagRemoveButton
                
            local tagNameCell = row:AddCell()
            local tagText = tagNameCell:AddText(tag.DisplayName)
            tagText.ItemWidth = 80
            -- if ti.Dynamic then
            --     local specialIcon = tagNameCell:AddImage("ico_btn_load_d", {20, 20})
            --     specialIcon.SameLine = true
            --     Imgui.CreateSimpleTooltip(specialIcon:Tooltip(), function(t)
            --         t:AddText("Dynamic tag created at runtime.")
            --         return t
            --     end)
            -- end
                
            Imgui.CreateSimpleTooltip(tagText:Tooltip(), function(t)
                    if Ext.Utils.Version() >= 20 then
                        t.TextWrapPos = 450
                    end
                    t:AddSeparatorText(tag.DisplayName)
                    t:AddBulletText(string.format("Name: %s", tag.TagName))
                    t:AddBulletText(string.format("ID: %s", tag.TagUuid))
                    return t
            end)
        end
    end
end