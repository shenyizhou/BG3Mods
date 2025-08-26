---@type ExtuiGroup
PartyGroup = nil
local PartyTable
PartyTableData = {}

---@type ExtuiGroup
CampGroup = nil
local CampTable

---@type ExtuiGroup
UnrecruitedGroup = nil
local ShowWatch = false

--- Generates the party tab
---@param treeParent ExtuiTreeParent
function PartyMenu(treeParent)
    PartyTab = treeParent
    treeParent:SetStyle("SeparatorTextBorderSize", 10)
    treeParent:SetStyle("SeparatorTextAlign", 0.5, 0.4)
    treeParent:SetStyle("SeparatorTextPadding", 0, 0)
    --treeParent:SetStyle("CellPadding", 1, 1)
    PartyGroup = treeParent:AddGroup("MainPartyGroup")
    local summonInfoIcon = PartyGroup:AddImage("tutorial_warning_yellow", {64, 64})
    Imgui.SetPopupStyle(summonInfoIcon:Tooltip()):AddText("\t"..wrap(Ext.Loca.GetTranslatedString("h98ca0a577a844938979cd7bd91c0a36d00ac"), 60))
    local currentPartyText = PartyGroup:AddSeparatorText(Ext.Loca.GetTranslatedString("h6ba7a8b5e7ed425785b94f7322d42eb0g5d5"))
    PartyTable = PartyGroup:AddTable("CurrentPartyTable", 4)
    --PartyTable.Borders = true
    PartyTable.SizingStretchSame = true
    PartyTable.NoHostExtendX = true
    --PartyTable.PreciseWidths = true
    --PartyTable.NoKeepColumnsVisible = true
    PartyGroup.UserData = {
        MainTable = PartyTable,
        RegenerateUI = RegeneratePartyUI,
    }
    RegeneratePartyUI()
    CampGroup = treeParent:AddGroup("CampGroup")
    local campGroupText = CampGroup:AddSeparatorText(Ext.Loca.GetTranslatedString("hbc293561784c4eb581c4fce9c58adb388932"))
    CampTable = CampGroup:AddTable("CampTable", 5)
    CampGroup.UserData = {
        MainTable = CampTable,
        RegenerateUI = RegenerateCampUI,
    }
    RegenerateCampUI()
    UnrecruitedGroup = treeParent:AddTree(Ext.Loca.GetTranslatedString("h8920680be4b14fa18a4c157db9a0b09522b9"))
    UnrecruitedGroup:SetOpen(true, "FirstUseEver")
    local unrecruitedWarningText = UnrecruitedGroup:AddText(wrap(Ext.Loca.GetTranslatedString("hd54a352f324f4bd592935f4a45a7820c5gf1"), 60))
    unrecruitedWarningText:SetColor("Text", Imgui.Colors.Gold)
    UnrecruitedTable = UnrecruitedGroup:AddTable("Unrecruited", 5)
    UnrecruitedGroup.UserData = {
        MainTable = UnrecruitedTable,
        RegenerateUI = RegenerateUnrecruitedUI,
    }
    UnrecruitedTable.NoHostExtendX = true
    UnrecruitedTable.Borders = false
    RegenerateUnrecruitedUI()
end
function RegeneratePartyUI()
    if PartyTable == nil then return end
    for _,child in pairs(PartyTable.Children) do child:Destroy() end -- kill the kids, yikes
    
    local cellcount = 0
    local currentRow = PartyTable:AddRow()
    local partyMembers = {}
    local currentParty = Helpers.Object:GetCurrentParty()
    if currentParty == nil then return end

    for i,v in ipairs(currentParty) do
        if Helpers.Character:IsAvatar(v) or Helpers.Character:IsNonGenericOrigin(v) then
            local e = Ext.Entity.Get(v)
            if e ~= nil and Helpers.Loca:GetDisplayName(e) ~= nil then
                table.insert(partyMembers, e)
            end
        end
    end

    table.sort(partyMembers, function(a,b)
        return Helpers.Loca:GetDisplayName(a) < Helpers.Loca:GetDisplayName(b)
    end)
    -- the old avatar switcharoo
    local avatars = {}
    for i = 1, #partyMembers, 1 do
        if Helpers.Character:IsAvatar(partyMembers[i]) then
            table.insert(avatars, table.remove(partyMembers, i))
        end
    end
    for i = #avatars, 1, -1 do
        table.insert(partyMembers,1,table.remove(avatars,i))
    end

    GeneratePartyCell(currentRow:AddCell())
    for i,v in ipairs(partyMembers) do
        -- if cellcount ~= 0 and cellcount % 4 == 0 then
        --     currentRow = PartyTable:AddRow()
        -- end
        GenerateCharacterCell(currentRow:AddCell(), v, true)
        cellcount = cellcount + 1
    end
end
function RegenerateCampUI()
    if CampTable == nil then return end
    for _,child in pairs(CampTable.Children) do child:Destroy() end -- kill the kids, yikes

    local currentRow = CampTable:AddRow()
    local cellcount = 0
    local nonpartyCampMembers = {}
    local sortCount = 1
    for k,v in pairs(Ext.Entity.GetAllEntitiesWithComponent("CampPresence")) do
        if not Helpers.Character:IsPartyMember(v) and Helpers.Character:IsRecruitedOrigin(v) then
            nonpartyCampMembers[sortCount] = v
            sortCount = sortCount + 1
        end
    end
    table.sort(nonpartyCampMembers, function(a,b)
        return Helpers.Loca:GetDisplayName(a) < Helpers.Loca:GetDisplayName(b)
    end)
    for i,v in ipairs(nonpartyCampMembers) do
        if cellcount ~= 0 and cellcount % 5 == 0 then currentRow = CampTable:AddRow() end
        local c = currentRow:AddCell()
        GenerateCampCharacterCell(c, v)
        cellcount = cellcount + 1
    end
end

function RegenerateUnrecruitedUI()
    if UnrecruitedTable == nil then return end
    for _,child in pairs(UnrecruitedTable.Children) do child:Destroy() end -- kill the kids, yikes
    
    local unrecruited = {}

    local sortCount = 1
    -- Extra annoying, unrecruited likely won't have DisplayName components
    for k,v in pairs(Data.Origins) do
        if not Helpers.Character:IsRecruitedOrigin(v.Uuid) then
            unrecruited[sortCount] = {
                Name = k,
                Uuid = v.Uuid,
                DisplayName = Ext.Loca.GetTranslatedString(v.DisplayHandle),
            }
            sortCount = sortCount + 1
        end
    end
    --ECDebug("Number of unrecruited: %d", #unrecruited)
    -- Are there even any more origins to display?
    if table.isEmpty(unrecruited) then
        UnrecruitedGroup.Visible = false
        return
    end
    
    table.sort(unrecruited, function(a,b)
        return a.DisplayName < b.DisplayName
    end)

    local count = 0
    local row = UnrecruitedTable:AddRow()
    for i, v in ipairs(unrecruited) do
        if count ~= 0 and count % 5 == 0 then row = UnrecruitedTable:AddRow() end
        local cell = row:AddCell()
        GenerateUnrecruitedCell(cell, v.Uuid, v.Name, v.DisplayName)
        count = count + 1
    end
end
function GenerateUnrecruitedCell(cell, entityUuid, name, dname)
    cell.UserData = {
        Name = name,
        DisplayName = dname,
        Entity = entityUuid,
    }
    
    local icon = "EC_Portrait_"..name
    local button = cell:AddImageButton("UR"..name, icon, {48, 48})
    if button.Image.Icon == "" then
        cell.Children[1]:Destroy()
        button = cell:AddImageButton("UR"..name, "EC_Portrait_Generic", {48, 48})
    end
    local popup = cell:AddPopup("PopupUR"..name)
    Imgui.SetPopupStyle(popup)
    button.UserData = {
        Popup = popup,
        Name = dname,
        DisplayName = dname,
        Entity = entityUuid,
    }
    button.OnClick = function(b)
        local pop = b.UserData.Popup
        HandleRecruitPopup(pop, b.UserData.Entity, b.UserData.DisplayName)
        pop:Open()
    end
end
function GenerateCampCharacterCell(cell, entity)
    local dname = Helpers.Loca:GetDisplayName(entity)
    local icon = entity.Origin ~= nil and "EC_Portrait_"..entity.Origin.Origin or "EC_Portrait_Generic"
    if icon == "EC_Portrait_DarkUrge" or icon == "EC_Portrait_Alfira" then icon = "EC_Portrait_Generic" end

    local button = cell:AddImageButton(dname, icon, {64, 64})
    if button.Image.Icon == "" then
        -- shouldn't be necessary anymore? hmm
        button:Destroy()
        button = cell:AddImageButton(dname, "EC_Portrait_Generic", {64, 64})
    end
    local popup = cell:AddPopup("Popup"..dname)
    Imgui.SetPopupStyle(popup)
    button.UserData = {
        Popup = popup
    }
    button.OnClick = function(b)
        local pop = b.UserData.Popup
        HandleCampClickMenu(pop, entity)
        pop:Open()
    end
    
end


---Generates a character row in a ExtuiTable
---@param partyGroup ExtuiGroup|ExtuiTableCell
---@param entity EntityHandle
---@param showHealth boolean
function GenerateCharacterCell(partyGroup, entity, showHealth)
    local dname = Helpers.Loca:GetDisplayName(entity) or "Unknown"
    local charGroup = partyGroup:AddGroup(dname.."Group")
    
    local icon = entity.Origin ~= nil and "EC_Portrait_"..entity.Origin.Origin or "EC_Portrait_Generic"
    if icon == "EC_Portrait_DarkUrge" or icon == "EC_Portrait_Alfira" then icon = "EC_Portrait_Generic" end
    -- EC_Portrait_DarkUrge no such thing
    
    local button = charGroup:AddImageButton(dname, icon, {96, 96})
    if button.Image.Icon == "" then
        charGroup.Children[1]:Destroy()
        button = charGroup:AddImageButton(dname, "EC_Portrait_Generic", {96, 96})
    end
    
    local popup = partyGroup:AddPopup("Popup"..dname)
    Imgui.SetPopupStyle(popup)
    button.UserData = {
        Popup = popup
    }
    
    local healthText = charGroup:AddText(string.format(Ext.Loca.GetTranslatedString("h7afeb6ef331a4648a34aa591d5b1623b8fb4").." %d/%d%s", entity.Health.Hp, entity.Health.MaxHp, entity.Health.TemporaryHp > 0 and string.format("(+%d)", entity.Health.TemporaryHp) or ""))

    healthText.Visible = showHealth
    button.OnClick = function(b)
        local pop = b.UserData.Popup
        HandleClickMenu(pop, entity)
        pop:Open()
        if entity ~= nil then
            healthText.Label = string.format(Ext.Loca.GetTranslatedString("h7afeb6ef331a4648a34aa591d5b1623b8fb4").." %d/%d%s", entity.Health.Hp, entity.Health.MaxHp, entity.Health.TemporaryHp > 0 and string.format("(+%d)", entity.Health.TemporaryHp) or "")
        end
    end
    
    local charColor = Helpers.Character:IsControlledCharacter(entity) and Imgui.Colors.Olive
        or Helpers.Character:IsAvatar(entity) and Imgui.Colors.SlateBlue or Imgui.Colors.DeepSkyBlue

    charGroup:AddSeparatorText(dname):SetColor("Text", charColor)
    local watchGroup = charGroup:AddGroup("WatchGroup"..dname)
    local watchstagedtext = watchGroup:AddText("Is Staged? ")
    local watchstagedtext2 = watchGroup:AddText("False")
    watchstagedtext2:SetColor("Text", Imgui.Colors.Red)
    watchstagedtext2.SameLine = true
    local watchindialogtext = watchGroup:AddText("In Dialog? ")
    local watchindialogtext2 = watchGroup:AddText("False")
    watchindialogtext2:SetColor("Text", Imgui.Colors.Red)
    watchindialogtext2.SameLine = true
    local watchincombattext = watchGroup:AddText("In Combat? ")
    local watchincombattext2 = watchGroup:AddText("False")
    watchincombattext2:SetColor("Text", Imgui.Colors.Red)
    watchincombattext2.SameLine = true
    watchGroup.Visible = ShowWatch
    charGroup.UserData = {
        WatchGroup = watchGroup,
    }
    
    PartyTableData[entity.Uuid.EntityUuid] = {
        Entity = entity,
        Uuid = entity.Uuid.EntityUuid,
        Icon = entity.GameObjectVisual.Icon,
        CharGroup = charGroup,
        Button = button,
    }
    -- local abilityscorestree = c2:AddTree("Ability Scores")
    -- local spellslottree = c2:AddTree("Spell Slots")
end

--- Generates the group party image button
---@param partyGroup ExtuiGroup|ExtuiTableCell
function GeneratePartyCell(partyGroup)
    
    local button = partyGroup:AddImageButton("Party", "ico_d20", {96, 96})
    
    local popup = partyGroup:AddPopup("PopupParty")
    Imgui.SetPopupStyle(popup)
    button.UserData = {
        Popup = popup
    }
    local gen = popup:AddMenu(Ext.Loca.GetTranslatedString("h8b0b9abc6a19406ca1694e02ca9d0c553f32")) --[[@as ExtuiMenu]]
    
    local function CreateChangeSubmenu(parent, label, change)
        local s = parent:AddItem(label)
        s.UserData = {
            Character = "Party",
            Change = change,
        }
        s.OnClick = function(b)
            Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
                Change = b.UserData.Change,
                Character = b.UserData.Character,
            }))
        end
        return s
    end

    local revive = CreateChangeSubmenu(gen, Ext.Loca.GetTranslatedString("hd99f3235a1a74b41a0b4329b8093aed0003d"), "Revive")
    local shortrest = CreateChangeSubmenu(gen, Ext.Loca.GetTranslatedString("h77b55a70ef14462a83b687e3c68b68dc5a69"), "ShortRest")
    local longrest = CreateChangeSubmenu(gen, Ext.Loca.GetTranslatedString("ha1391197610f4eb7afdb3a2d9108d2d32b32"), "LongRest")
    local summon = CreateChangeSubmenu(gen, Ext.Loca.GetTranslatedString("hffc045f9f84b477aac59b7afdd90c8e6d14g"), "Summon")
    local ttc = CreateChangeSubmenu(gen, Ext.Loca.GetTranslatedString("h42d0e2ecd6c54c49a1a21b8e03b5f98ea5f1"), "TeleportToCamp")
    local unstick = CreateChangeSubmenu(gen, Ext.Loca.GetTranslatedString("hacb5b4eb2b4742ddb907e63c60a50c9ad029"), "Unstick")
    unstick:Tooltip():AddText("\t"..wrap(Ext.Loca.GetTranslatedString("h94e76704c8524a89bfd561e4e2672a4d442e"), 60))
    local applydbuffs = gen:AddItem(Ext.Loca.GetTranslatedString("h980e76301968408480d119a3274a03c6af9g","Apply Daily Buffs"))
    applydbuffs.OnClick = function(_)
        Ext.Net.PostMessageToServer(ECChannels.ApplyDailyBuffs, "")
    end
    local stayclean = gen:AddItem(Ext.Loca.GetTranslatedString("h48a6885e2e4d4a5d9d2d90227a3129baded9", "Toggle Stay Clean"))
    stayclean.OnClick = function(_)
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats["StayClean"].Name}))
    end

    button.OnClick = function(b)
        local pop = b.UserData.Popup
        pop:Open()
    end

    partyGroup:AddSeparatorText("Party"):SetColor("Text", Imgui.Colors.PaleVioletRed)
end

local function GetApproval(entity)
    if entity == nil or entity.ApprovalRatings == nil then return end
    local n = 0
    for k, v in pairs(entity.ApprovalRatings.Ratings) do
        if k.Uuid.EntityUuid == Helpers.Object:GetGuid(CurrentCharacterID) then
            n = v
            break
        end
    end
    return n
end
local function GetApprovalString(entity)
    return string.format(Ext.Loca.GetTranslatedString("h08589eac1f8c42869f24bd9180626384ae73").."%d", GetApproval(entity))
end

---@param element ExtuiStyledRenderable
---@param approval integer
---@param guicolorkey GuiColor?
local function SetApprovalColor(element, approval, guicolorkey)
    guicolorkey = guicolorkey or "FrameBg"
    local approvalColors = {
        [-50] = Imgui.Colors.DarkRed,           -- Very Low
        [-20] = Imgui.Colors.FireBrick,       -- Low
        [20]  = Imgui.Colors.Tan,       -- Neutral
        [40]  = Imgui.Colors.BG3Blue,       -- Medium
        [60]  = Imgui.Colors.SlateBlue,      -- High
        [80]  = Imgui.Colors.Olive,     -- Very High
        --[100]
    }
    local mid = 100*((approval +50)/150)
    local color = Helpers.Color:NormalizedLerp(Imgui.Colors.DarkRed, Imgui.Colors.Olive, mid)
    element:SetColor(guicolorkey, color)
end

local function CreateApprovalMenu(parent, entity)
    local approval = parent:AddMenu(Ext.Loca.GetTranslatedString("h5ea9887ac2994538885a1763e4f954378b1e")) --[[@as ExtuiMenu]]
    approval.UserData = {}
    if entity ~= nil and entity.ApprovalRatings ~= nil then
        local appcurrent = approval:AddText(GetApprovalString(entity))
        approval.UserData.Entity = entity
        approval.UserData.Text = appcurrent
        approval.UserData.UpdateApproval = function(a)
            if a == nil or a.UserData == nil or a.UserData.Entity == nil or a.UserData.Text == nil then return end
            a.UserData.Text.Label = GetApprovalString(a.UserData.Entity)
        end
    end
    approval.OnActivate = function()
        if approval.UserData.UpdateApproval ~= nil then
            approval.UserData.UpdateApproval(approval)
        end
    end
    local appslideButton = approval:AddButton(Ext.Loca.GetTranslatedString("ha712d3a46ab54343883a95d4c5909846f549"))
    local appsliderDec = approval:AddButton("<<")
    appsliderDec.SameLine = true
    local currentApprovalNumber = GetApproval(entity) or 0
    local appslider = approval:AddSliderInt("", currentApprovalNumber, -50, 100)
    SetApprovalColor(appslider, currentApprovalNumber)
    appslider.OnChange = function(s)
        SetApprovalColor(s, s.Value[1])
    end
    local appsliderInc = approval:AddButton(">>")
    appsliderDec.UserData = { Slider = appslider }
    appsliderInc.UserData = { Slider = appslider }
    appsliderDec.OnClick = function(b)
        local slider = b.UserData.Slider
        slider.Value = { math.max(slider.Value[1] - 10, slider.Min[1]), slider.Value[2], slider.Value[3], slider.Value[4]}
        slider:OnChange()
    end
    appsliderInc.OnClick = function(b)
        local slider = b.UserData.Slider
        slider.Value = { math.min(slider.Value[1] + 10, slider.Max[1]), slider.Value[2], slider.Value[3], slider.Value[4]}
        slider:OnChange()
    end
    appsliderInc.SameLine = true
    appslider.AlwaysClamp = true
    appslider.SameLine = true
    appslider.ItemWidth = 150
    appslideButton.UserData = {
        ApprovalMenu = approval,
        Slider = appslider,
        Character = entity.Uuid.EntityUuid,
        Change = "ApprovalSet",
    }
    appslideButton.OnClick = function(b)
        Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
            Change = b.UserData.Change,
            Character = b.UserData.Character,
            Args = { Amount = b.UserData.Slider.Value[1]}
        }))
        -- Assume approval changes for now
        Helpers.Timer:OnTime(1000, function()
            if b.UserData.ApprovalMenu ~= nil then
                local app = b.UserData.ApprovalMenu
                app.UserData.UpdateApproval(app)
            end
        end)
    end
    local function CreateApprovalShortcut(parentMenu, e, amount)
        local shortcut = parentMenu:AddItem(Ext.Loca.GetTranslatedString("h6924a416fc664a8f9e107357cb9a17ec2g98").." "..tostring(amount))
        shortcut.UserData = {
            Change = "ApprovalSet",
            Character = e.Uuid.EntityUuid,
            ApprovalMenu = parentMenu,
            Amount = amount,
        }
        shortcut.OnClick = function(b)
            Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
                Change = b.UserData.Change,
                Character = b.UserData.Character,
                Args = { Amount = b.UserData.Amount }
            }))
            -- Assume approval changes for now
            Helpers.Timer:OnTime(1000, function()
                if b.UserData.ApprovalMenu ~= nil then
                    local app = b.UserData.ApprovalMenu
                    app.UserData.UpdateApproval(app)
                end
            end)
        end
    end

    -- Set to 0 approval
    CreateApprovalShortcut(approval, entity, 0)
    -- Set to 100 approval
    CreateApprovalShortcut(approval, entity, 100)

    return approval
end

local function CreateRelationshipMenu(parent, entity)
    local relation = parent:AddMenu(Ext.Loca.GetTranslatedString("ha84a6f0ba1df4d9cbe0117c2d1ceb0bc39cc")) --[[@as ExtuiMenu]]
    local relationStatusText = relation:AddText(Ext.Loca.GetTranslatedString("h23e64eac387840649c47ff626432007dbe08"))
    local relatestart   = relation:AddItem(Ext.Loca.GetTranslatedString("h3bab2cd949b3421780ecc5bb3cf455977485")) -- Pre-relationship
    local relatedate    = relation:AddItem(Ext.Loca.GetTranslatedString("h2d3f0a70dc4c42ba8aca72cf323080d4f873")) -- Date
    local relatebreakup = relation:AddItem(Ext.Loca.GetTranslatedString("h3d76e9e25d9c4b5bb6f796f54ec112792ea7")) -- Break up
    relation.UserData = {
        Character = entity.Uuid.EntityUuid,
        StatusText = relationStatusText,
        Elements = {
            relatestart,
            relatedate,
            relatebreakup,
        }
    }
    for i, v in ipairs(relation.UserData.Elements) do
        v.UserData = { Character = entity.Uuid.EntityUuid }
        v.OnClick = function(b)
            Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
                Change = b.UserData.Change,
                Character = b.UserData.Character,
            }))
        end
    end
    relatestart.UserData.Change = "StartRelationship"
    relatedate.UserData.Change = "StartDating"
    relatebreakup.UserData.Change = "BreakUp"
    relation.OnActivate = function(m)
        if m == nil or m.UserData == nil then return end
        --ECDebug("Relationshipmenu activated: %s", Helpers.Loca:GetDisplayName(m.UserData.Character))
        local listener = m.UserData.relationshipStatusListener
        if listener ~= nil then
            -- Unsubscribe from any old/pending listens
            Ext.Events.NetMessage:Unsubscribe(listener)
        end
        m.UserData.relationshipStatusListener = Ext.Events.NetMessage:Subscribe(function (e)
            -- FIXME jank safety check
            local success, value = pcall(function() return m == nil or m.UserData == nil end)
            if not success then return end

            if value then
                return
            end
            local data = Ext.Json.Parse(e.Payload)
            if e.Channel == ECChannels.RelationshipStatusResponse and data.Character == m.UserData.Character then
                --ECDebug("Received relationship update.")
                local t = m.UserData.StatusText
                if table.isEmpty(data.RelationshipData) then
                    -- No relationship data
                    t.Label = Ext.Loca.GetTranslatedString("haff8880254c94553b1f67e68d70d06eb323g")
                elseif data.RelationshipData.Dating ~= nil then
                    local target = Ext.Entity.Get(data.RelationshipData.Dating)
                    if target ~= nil then
                        t.Label = string.format(Ext.Loca.GetTranslatedString("h3097d6c900e242dc962e60ff3c4e3d95e86a").." %s", Helpers.Loca:GetDisplayName(target))
                    end
                elseif data.RelationshipData.Partner ~= nil then
                    local target = Ext.Entity.Get(data.RelationshipData.Partner)
                    if target ~= nil then
                        t.Label = string.format(Ext.Loca.GetTranslatedString("hf84cfe854e2c4f468dccce60ac18e7d68cd3").." %s", Helpers.Loca:GetDisplayName(target))
                    end
                elseif data.RelationshipData.PartnerSecondary ~= nil then
                    local target = Ext.Entity.Get(data.RelationshipData.PartnerSecondary)
                    if target ~= nil then
                        t.Label = string.format(Ext.Loca.GetTranslatedString("h3bff31aef7364d9c84885c92b121f98a8bdf").."%s", Helpers.Loca:GetDisplayName(target))
                    end
                end
                Ext.Events.NetMessage:Unsubscribe(m.UserData.relationshipStatusListener)
                m.UserData.relationshipStatusListener = nil
            end
        end)
        Ext.Net.PostMessageToServer(ECChannels.RequestRelationshipStatus, Ext.Json.Stringify({
            Character = m.UserData.Character
        }))
    end
    return relation
end

---comment
---@param popup ExtuiPopup
---@param entity EntityHandle
function HandleClickMenu(popup, entity)
    if popup.UserData == nil then
        popup.UserData = {
            Character = entity.Uuid.EntityUuid
        }
        local gen = popup:AddMenu(Ext.Loca.GetTranslatedString("h8b0b9abc6a19406ca1694e02ca9d0c553f32")) --[[@as ExtuiMenu]]
        local approval = CreateApprovalMenu(popup, entity)
        local relation = CreateRelationshipMenu(popup, entity)
        local dismiss = popup:AddButton(Ext.Loca.GetTranslatedString("h3b2487012eaa465786229a08a438e0e49e42"))
        dismiss.OnClick = function(b)
            Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
                Change = "DismissToCamp",
                Character = b.ParentElement.UserData.Character,
            }))
        end
        
        local function CreateChangeSubmenu(parent, e, label, change)
            local s = parent:AddItem(label)
            s.UserData = {
                Character = e.Uuid.EntityUuid,
                Change = change,
            }
            s.OnClick = function(b)
                Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
                    Change = b.UserData.Change,
                    Character = b.UserData.Character,
                }))
            end
            return s
        end

        local revive = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("hd99f3235a1a74b41a0b4329b8093aed0003d"), "Revive")
        local shortrest = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("h77b55a70ef14462a83b687e3c68b68dc5a69"), "ShortRest")
        local longrest = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("ha1391197610f4eb7afdb3a2d9108d2d32b32"), "LongRest")
        local tpme = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("he30412580e2c4116bcd9ca41ef993a3fd7c2"), "TeleportMeTo")
        local summon = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("hffc045f9f84b477aac59b7afdd90c8e6d14g"), "Summon")
        local ttc = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("h42d0e2ecd6c54c49a1a21b8e03b5f98ea5f1"), "TeleportToCamp")
        local unstick = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("hacb5b4eb2b4742ddb907e63c60a50c9ad029"), "Unstick")
        local respec = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("h420512726cbe49f7bd53a64e95b4ed7f4e20"), "Respec")
        local mirror = CreateChangeSubmenu(gen, entity, Ext.Loca.GetTranslatedString("h76f092e8d5eb4f49a512b3030206b2f48a8c"), "Mirror")
        unstick:Tooltip():AddText("\t"..wrap(Ext.Loca.GetTranslatedString("h94e76704c8524a89bfd561e4e2672a4d442e"), 60))
        local applydbuffs = gen:AddItem(Ext.Loca.GetTranslatedString("h980e76301968408480d119a3274a03c6af9g","Apply Daily Buffs"))
        applydbuffs.OnClick = function(_)
            Ext.Net.PostMessageToServer(ECChannels.ApplyDailyBuffs, Ext.Json.Stringify({
                Character = entity.Uuid.EntityUuid
            }))
        end
        popup.UserData.Elements = {
            gen         = gen,
            approval    = approval,
            relation    = relation,
            dismiss     = dismiss,
            --submenus and items
            revive      = revive,
            shortrest   = shortrest,
            longrest    = longrest,
            summon      = summon,
            ttc         = ttc,
            tpme        = tpme,
            unstick     = unstick,
            respec      = respec,
            mirror      = mirror,
        }
        
    end
    -- Update visibility here, after popup elements have been created
    
    -- Can't dismiss or date avatars, no approval
    popup.UserData.Elements.dismiss.Visible = not Helpers.Character:IsAvatar(entity)
    popup.UserData.Elements.approval.Visible = not Helpers.Character:IsAvatar(entity)

    local relation = popup.UserData.Elements.relation
    relation.Visible = not Helpers.Character:IsAvatar(entity)
    if relation.Visible then
        -- not an Avatar, but may be unromanceable origin
        local check = Data.OriginDataByUuid[entity.Uuid.EntityUuid]
        if check ~= nil then
            -- disable the relationship menu for non-romanceable origins
            relation.Visible = check.LoverFlag ~= nil
            if check.LoverFlag ~= nil then
                -- enable/disable menuitems based on available flags
                relation.UserData.Elements[1].Disabled = check.RelationshipFlag == nil
                relation.UserData.Elements[2].Disabled = check.LoverFlag == nil
                relation.UserData.Elements[3].Disabled = check.ClearLoverFlags == nil
                relation:OnActivate()
            end
        else
            popup.UserData.Relation.Visible = false
        end
    end
    
    -- Only revive dead people
    popup.UserData.Elements.revive.Enabled = Helpers.Character:IsDead(entity)
end

---comment
---@param popup ExtuiPopup
---@param entity EntityHandle
function HandleCampClickMenu(popup, entity)
    if popup.UserData == nil then
        local dname = Helpers.Loca:GetDisplayName(entity) or "Unknown"
        if dname ~= nil then
            Imgui.SetChunkySeparator(popup):AddSeparatorText(dname):SetColor("Text", Imgui.Colors.DarkOrange)
        end
        local approval = CreateApprovalMenu(popup, entity)
        local relation = CreateRelationshipMenu(popup, entity)
        local addToParty = popup:AddButton(Ext.Loca.GetTranslatedString("h361f5c1078464a3482df897a9f4a1c0965e2"))
        addToParty.UserData = {
            Change = "AddToParty",
            Character = entity.Uuid.EntityUuid,
        }
        addToParty.OnClick = function(b)
            Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
                Change = b.UserData.Change,
                Character = b.UserData.Character,
            }))
        end
        popup.UserData = {
            -- all controls in menu
            Character = entity.Uuid.EntityUuid,
            Approval = approval,
            Relation = relation,
            AddToParty = addToParty,
        }
    end
    -- Update visibility, handle activation if needed
    local check = Data.OriginDataByUuid[entity.Uuid.EntityUuid]
    if check ~= nil then
        -- disable the relationship menu for non-romanceable origins
        popup.UserData.Relation.Visible = check.LoverFlag ~= nil
        if check.LoverFlag ~= nil then
            -- enable/disable menuitems based on available flags
            popup.UserData.Relation.UserData.Elements[1].Disabled = check.RelationshipFlag == nil
            popup.UserData.Relation.UserData.Elements[2].Disabled = check.LoverFlag == nil
            popup.UserData.Relation.UserData.Elements[3].Disabled = check.ClearLoverFlags == nil
            popup.UserData.Relation:OnActivate()
        end
    else
        popup.UserData.Relation.Visible = false
    end
end

function HandleRecruitPopup(popup, entityUuid, dname)
    if popup.UserData == nil then
        --local summon = gen:AddItem("Summon")
        if dname ~= nil then
            Imgui.SetChunkySeparator(popup):AddSeparatorText(dname):SetColor("Text", Imgui.Colors.DarkOrange)
        end
        local recruit = popup:AddButton(Ext.Loca.GetTranslatedString("h62779109746043aa8f0c869adabad40c60b0")) -- Companion
        recruit.UserData = {
            Character = entityUuid,
            Change = "RecruitAsCompanion",
        }
        local recruitToCamp = popup:AddButton(Ext.Loca.GetTranslatedString("ha315a5c38639428eb78e8a56021d761e47aa")) -- To Camp
        recruitToCamp.UserData = {
            Character = entityUuid,
            Change = "RecruitToCamp",
        }
        local recruitAsAvatar = popup:AddButton(Ext.Loca.GetTranslatedString("h9292d7afc5b44eefb203068b05ca942306fa")) -- Avatar
        recruitAsAvatar.UserData = {
            Character = entityUuid,
            Change = "RecruitAsAvatar",
        }
        popup.UserData = {
            --summon      = summon,
            recruit     = recruit,
            recruitAsAvatar = recruitAsAvatar,
            recruitToCamp = recruitToCamp,
        }
        local function doChange(e)
            if e.UserData ~= nil and e.UserData.Change ~= nil then
                Ext.Net.PostMessageToServer(ECChannels.RequestCharacterChange, Ext.Json.Stringify({
                    Change = e.UserData.Change,
                    Character = e.UserData.Character,
                }))
            end
        end

        recruit.OnClick = doChange
        recruitToCamp.OnClick = doChange
        recruitAsAvatar.OnClick = doChange
    end
end