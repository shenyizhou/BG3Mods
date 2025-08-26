-- Database 'DB_RegionSafeSpot' (STRING, TRIGGER):
-- 	('WLD_Main_A', DOS2_StartPoint_000__000__000_b41c4f85-a580-cf6e-a4b9-9084e084452c)
-- 	('CRE_Main_A', StartPoint_000__000_fff434fb-523d-4975-9cfa-783d22471ee9)
-- 	('SCL_Main_A', StartPoint_000_f968a8d3-b06d-4fc2-acf1-1e650e35e52d)
-- 	('INT_Main_A', StartPoint_480ae5ee-9a76-4411-bfcf-771480379928)
-- 	('BGO_Main_A', StartPoint_000__000_5178cfe4-9f84-a0d8-de48-30a2f9d706f0)
-- 	('CTY_Main_A', StartPoint_000__000_517be014-1b08-40b5-9ea7-011aa40edf0d)
-- 	('END_Main', StartPoint_004_0674afda-bf24-47ff-889f-5dc81b59ca61)
-- 	('EPI_Main_A', StartPoint_006_fc45ef99-8cf0-4fd9-ba87-ba364b198584)
-- 	('IRN_Main_A', StartPoint_000__000_3b6520df-91f5-41e1-9ed5-2bc5d3d01902)
-- 	('TUT_Avernus_C', S_TUT_StartPoint_001_45c9c4f9-0f81-ee38-9d45-bdefc07761d9)

local TeleportGroup = nil
local TPMouseSubscriptionID = nil
---@type ExtuiBulletText
local PlayerPositionText = nil
local PlayerPositionTickHandle = nil
local TPTable = {}
---@type ExtuiTree
local FavoritesTree
local function RidiculousPosition(p)
    local epsilon = 0.00000001
    local max = 10000
    local x, y, z = table.unpack(p)
    if math.abs(x) < epsilon and math.abs(y) < epsilon and math.abs(z) < epsilon then
        return true
    end
    if math.abs(x) > max or math.abs(y) > max or math.abs(z) > max then
        return true
    end
    return false
end
local function LoadAllTriggers()
    -- local triggerFile = "Mods/EasyCheat/ScriptExtender/Lua/Shared/Data/AllTriggers.json"
    local descriptor = "Patch 7"
    local triggerFile = "Mods/EasyCheat/ScriptExtender/Lua/Shared/Data/AllTriggersSortedPatch7.json"
    if Ext.Utils.Version() < 20 then
        -- patch 6 triggers
        descriptor = "Patch 6"
        triggerFile = "Mods/EasyCheat/ScriptExtender/Lua/Shared/Data/AllTriggersSortedPatch6.json"
    end
    local contents = Ext.IO.LoadFile(triggerFile, "data")
    if contents ~= nil then
        TPTable = Ext.Json.Parse(contents)
        -- 10394 triggers available (patch 6), 23841 triggers available (patch 7)
        ECPrint(descriptor.." Teleport Triggers Loaded: %d triggers available", #TPTable)
        table.sort(TPTable, function(a, b) return a.LevelName < b.LevelName end)
        -- Grab all Levels by Name
        local levelNames = {}
        for i, v in ipairs(TPTable) do
            local found = false
            for j, k in ipairs(levelNames) do
                if k == v.LevelName then found = true end
            end
            if not found then levelNames[#levelNames + 1] = v.LevelName end
        end
        ECPrint("Total Teleport LevelNames: %d", #levelNames)
        return levelNames
    else
        --ECWarn("Failed to load TP triggers.")
    end
end
--- Sends the Teleport message to server
---@param act nil|"Act0"|"Act1"|"Act1b"|"Act2"|"Act2b"|"Act3"|"Act3b"|"Act3c"
---@param name string|nil "Arbitrary name"
---@param levelName string|nil "TUT_Avernus_C"|"WLD_Main_A"|etc.
---@param trigger string|nil TriggerUUID
---@param position vec3|nil {x,y,z}
local function DoTeleport(act, name, levelName, trigger, position)
    Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({
        Operation = CheatManager.Cheats["Teleport"].Name,
        Args = {
            Act = act,
            Name = name,
            LevelName = levelName,
            Trigger = trigger,
            Position = position,
            BringLinked = FavoritesTree.UserData.LinkedCheck.Checked,
            BringFollowers = FavoritesTree.UserData.FollowersCheck.Checked,
            BringSummons = FavoritesTree.UserData.SummonsCheck.Checked,
        }
    }))
end

--- Generates the teleporter tab
---@param treeParent ExtuiTreeParent
function TeleportMenu(treeParent)
    TeleportTab = treeParent
    if not TeleportTab.UserData then TeleportTab.UserData = {} end
    -- common styles:
    treeParent:SetStyle("WindowPadding", 15, 15)
    treeParent:SetStyle("PopupBorderSize", 2)
    treeParent:SetColor("BorderShadow", { 0, 0, 0, 0.4 })
    treeParent:SetColor("Border", Imgui.Colors.Tan)

    local acknowledgeCheckbox = treeParent:AddCheckbox(
        Ext.Loca.GetTranslatedString("h006a0690b2f04edc90ac1b4970ed445d0451"), false)
    acknowledgeCheckbox:SetColor("Text", Imgui.Colors.Red)
    TeleportGroup = treeParent:AddGroup("TeleportGroup")
    TeleportGroup.Visible = false
    TeleportGroup.UserData = {
        LevelCombo = nil
    }
    acknowledgeCheckbox.OnChange = function(c)
        TeleportGroup.Visible = c.Checked
        if CurrentCharacter ~= nil and CurrentCharacter.Level ~= nil and TeleportGroup.UserData.LevelCombo ~= nil then
            local levelCombo = TeleportGroup.UserData.LevelCombo
            local i = table.indexOf(levelCombo.Options, CurrentCharacter.Level.LevelName)
            if i ~= nil then
                levelCombo.SelectedIndex = i - 1
                levelCombo:OnChange()
            end
        end
    end

    TeleportGroup:AddText(Ext.Loca.GetTranslatedString("h65b333ea89364ed3bbe5efcbb2af1a4bfe9d", "Teleport on double-click"))
    local chk = TeleportGroup:AddCheckbox("", false)
    TeleportGroup.UserData.TeleportCheck = chk
    chk.SameLine = true
    local immortaltoggle = CheatManager.Cheats.Immortality.ClientUI(TeleportGroup) --[[@as ExtuiButton]]
    -- FIXME annoying wrap
    immortaltoggle.UserData = {
        OldOnClick = immortaltoggle.OnClick,
    }
    TeleportTab.UserData.TeleportToggle = chk
    TeleportTab.UserData.ImmortalityButton = immortaltoggle
    immortaltoggle.OnClick = function(b)
        local ent = Helpers.Object:GetHostEntity()
        if ent ~= nil and ent.Uuid ~= nil then
            b.UserData.Target = ent.Uuid.EntityUuid
            b.UserData.OldOnClick(b)
        end
    end
    immortaltoggle.SameLine = true
    TeleportGroup:AddText("Bring:").Visible = false
    local bringLinkedChk = TeleportGroup:AddCheckbox("Linked Chars", false)
    bringLinkedChk.SameLine = true
    bringLinkedChk.Visible = false
    local bringFollowersChk = TeleportGroup:AddCheckbox("Followers", false)
    bringFollowersChk.SameLine = true
    bringFollowersChk.Visible = false
    local bringSummonsChk = TeleportGroup:AddCheckbox("Summons", false)
    bringSummonsChk.SameLine = true
    bringSummonsChk.Visible = false

    chk.OnChange = function(c)
        -- link both teleportToggles
        if TeleportGroup and TeleportGroup.UserData and TeleportGroup.UserData.TeleportCheck then
            TeleportGroup.UserData.TeleportCheck.Checked = c.Checked
        end
        if SidekickWindow and SidekickWindow.UserData and SidekickWindow.UserData.TeleportToggle then
            SidekickWindow.UserData.TeleportToggle.Checked = c.Checked
        end
        if c.Checked then
            TPMouseSubscriptionID = Ext.Events.MouseButtonInput:Subscribe(function(e)
                if e.Button == 1 and e.Pressed and e.Clicks >= 2 then
                    if e.CanPreventAction then e:PreventAction() end
                    local entity = Helpers.Object:GetHostEntity()
                    if entity == nil then return end
                    if entity.CanTravel.ErrorFlags & Ext.Enums.TravelErrorFlags.Dialog == Ext.Enums.TravelErrorFlags.Dialog then return end
                    local picker = Ext.UI.GetPickingHelper(1)
                    if picker.Inner ~= nil and picker.Inner.Position ~= nil then
                        --ECDump(picker)
                        -- ECWarn("Teleporting to {%f, %f, %f}", table.unpack(picker.Inner.Position1))
                        -- if picker.Inner.Position0 ~= nil then
                        --     ECWarn("Also avaiable Pos0: {%f, %f, %f}", table.unpack(picker.Inner.Position0))
                        -- end
                        -- if picker.Inner.Position2 ~= nil then
                        --     ECWarn("Also avaiable Pos2: {%f, %f, %f}", table.unpack(picker.Inner.Position2))
                        -- end
                        if RidiculousPosition(picker.Inner.Position) then return end
                        DoTeleport(nil, nil, entity.Level.LevelName, nil, picker.Inner.Position)
                    end
                end
            end)
        else
            if TPMouseSubscriptionID ~= nil then
                Ext.Events.MouseButtonInput:Unsubscribe(TPMouseSubscriptionID)
                TPMouseSubscriptionID = nil
            end
        end
    end

    local mapLevelText = TeleportGroup:AddBulletText(Ext.Loca.GetTranslatedString(
        "hd25455803a204c7ebe29d11a012f7a7094ef"))
    PlayerPositionText = TeleportGroup:AddBulletText(Ext.Loca.GetTranslatedString(
        "h5055099c3314468a831e30b4a7d2c7ce7ebd"))
    PlayerPositionText.UserData = {
        MapLevelText = mapLevelText,
    }
    PlayerPositionTickHandle = Ext.Events.Tick:Subscribe(function(e)
        if CurrentCharacter ~= nil and CurrentCharacter.Level ~= nil and CurrentCharacter.Transform ~= nil then
            local pos = CurrentCharacter.Transform.Transform.Translate
            --local rot = CurrentCharacter.Bound.Bound.RotationQuat
            PlayerPositionText.Label = string.format(
                Ext.Loca.GetTranslatedString("h24195f2fb2154c9e834f24a5ced8816365e5") .. "\n\t{ %.8f, %.8f, %.8f}",
                table.unpack(pos))
            -- PlayerPositionText.Label = string.format("Current Player Position:\n\t{ %.8f, %.8f, %.8f}\n\t{ %.6f, %.6f, %.6f, %.6f}",
            --     pos[1], pos[2], pos[3], table.unpack(rot))
            PlayerPositionText.UserData.MapLevelText.Label = string.format(
                Ext.Loca.GetTranslatedString("hd25455803a204c7ebe29d11a012f7a7094ef") .. " %s",
                CurrentCharacter.Level.LevelName)
        else
            PlayerPositionText.Label = Ext.Loca.GetTranslatedString("h5055099c3314468a831e30b4a7d2c7ce7ebd")
            PlayerPositionText.UserData.MapLevelText.Label = Ext.Loca.GetTranslatedString(
                "hc16dd30df16d4d48b9cf11e89e74fdc11906")
        end
    end)

    --local cb = ImguiCombo:New{ ImguiComboHandle = TeleportGroup:AddCombo("Level")}
    local lcb = TeleportGroup:AddCombo(Ext.Loca.GetTranslatedString("h750103a17f0747178885100677cba4c1ce55"))
    TeleportGroup.UserData.LevelCombo = lcb
    TeleportGroup:AddSeparator()
    TeleportGroup:AddDummy(5,5)

    -- Filter the trigger combo box based on the search input
    local triggerFilterInput = TeleportGroup:AddInputText(Ext.Loca.GetTranslatedString("h20da017a36a643bd9a990c9c014c3cac5f5a"))
    triggerFilterInput.IDContext = "TPTriggerSearchInput"
    -- triggerFilterInput.SameLine = true
    triggerFilterInput.SizeHint = { 180, 36 }

    --- Filter triggers based on search text
    --- @param triggerGroup ExtuiGroup The group containing the trigger combo
    --- @param currentLevel string The current level selected
    --- @param searchText string The search text
    local function filterTriggersComboOptions(triggerGroup, currentLevel, searchText)
        local filteredTriggers = {}
        for _, trigger in ipairs(TPTable) do
            if string.find(trigger.Name:lower(), searchText) and trigger.LevelName == currentLevel then
                table.insert(filteredTriggers, trigger.Name)
            end
        end

        if #filteredTriggers == 0 then
            table.insert(filteredTriggers, Ext.Loca.GetTranslatedString("hee94f6612bf44d7880debc599126f27ae2dc"))
        end
        table.sort(filteredTriggers)
        -- table.sort(filteredTriggers, function(a, b) return a.LevelName < b.LevelName end)

        triggerGroup.UserData.TriggerCombo.Options = filteredTriggers
        triggerGroup.UserData.TriggerCombo.SelectedIndex = 0
        triggerGroup.UserData.TriggerCombo:OnChange()
    end

    triggerFilterInput.OnChange = function(s)
        local searchText = s.Text:lower()
        filterTriggersComboOptions(TeleportGroup, lcb.Options[lcb.SelectedIndex + 1], searchText)
    end

    local tcb = TeleportGroup:AddCombo(Ext.Loca.GetTranslatedString("hb38bb0ca1b24445db81c04a6c2c7678088gd"))
    TeleportGroup.UserData.TriggerCombo = tcb

    local triggerInfo = TeleportGroup:AddText(Ext.Loca.GetTranslatedString("hfe13b8e863624b45b0bdb661234286b161fg"))
    triggerInfo:SetColor("Text", Imgui.Colors.Green)
    triggerInfo.IDContext = "TPGroupTriggerInfo1"
    local triggerInfo2 = TeleportGroup:AddText("")
    triggerInfo2:SetColor("Text", Imgui.Colors.Tan)
    triggerInfo2.IDContext = "TPGroupTriggerInfo2"
    local tpbutton1 = TeleportGroup:AddButton(Ext.Loca.GetTranslatedString("h080341f51a0441acad302b3b541a4a446gg0"))
    local tpbutton2 = TeleportGroup:AddButton(Ext.Loca.GetTranslatedString("h931e7f87a1544a00866d42ae536bff11418g"))
    tpbutton2.SameLine = true
    tpbutton1:Tooltip():AddText("\t" .. Ext.Loca.GetTranslatedString("hcd5269af6c1042408c26a140888b75729870"))
    local tpt = tpbutton2:Tooltip()
    tpt:AddText("\t" .. wrap(Ext.Loca.GetTranslatedString("h5d47f03edfac465cbeb26a390365eac9eb2d"), 60))
    tpt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("h18d99bf70b854803bb544d66e8bed302f5b4"), 60)):SetColor("Text",
        Imgui.Colors.Neutral)
    local annoyingtable = TeleportGroup:AddTable("AnnoyingTableForFavoriteButton", 1)
    annoyingtable.SameLine = true
    annoyingtable.SizingFixedFit = true
    annoyingtable.NoPadInnerX = true
    annoyingtable.NoPadOuterX = true
    annoyingtable:SetStyle("CellPadding", 0)
    local annoyingcell = annoyingtable:AddRow():AddCell()
    local favbutton = annoyingcell:AddImageButton("FavoriteButton", "levelUp_hp_h3", { 28, 28 })
    favbutton.SameLine = true
    favbutton:Tooltip():AddText("\t" .. Ext.Loca.GetTranslatedString("h596940ffcd894dd29ccbc68af0ac9bbbf52c"))
    lcb.Options = LoadAllTriggers()
    lcb.UserData = {
        TriggerCombo = tcb,
        TeleportButton1 = tpbutton1,
        TeleportButton2 = tpbutton2,
    }
    tcb.UserData = {
        TriggerInfo = triggerInfo,
        TriggerInfo2 = triggerInfo2,
        CurrentTPTriggers = {},
        TeleportButton1 = tpbutton1,
        TeleportButton2 = tpbutton2,
    }
    tpbutton1.UserData = {
        TriggerCombo = tcb,
    }
    tpbutton2.UserData = {
        TriggerCombo = tcb,
    }
    lcb.OnChange = function(combo)
        local currentTPTriggers = {}
        local newOptions = {}
        local countOf = {}
        local selectedLevel = combo.Options[combo.SelectedIndex + 1]
        -- Init currentTPTriggers
        for i, v in ipairs(TPTable) do
            if v.LevelName == selectedLevel then
                currentTPTriggers[#currentTPTriggers + 1] = v
            end
        end
        -- Sort currentTPTriggers
        table.sort(currentTPTriggers, function(a, b) return a.Name < b.Name end)
        -- Generate newOptions after sorting
        for i, v in ipairs(currentTPTriggers) do
            if countOf[v.Name] == nil then
                countOf[v.Name] = 0
                newOptions[i] = v.Name
            else
                countOf[v.Name] = countOf[v.Name] + 1
                newOptions[i] = string.format("%s (%d)", v.Name, countOf[v.Name])
            end
        end
        combo.Label = string.format(Ext.Loca.GetTranslatedString("h1ac34cd5a50a4ab1b128205679608694ec3f"), #newOptions)
        combo.UserData.TriggerCombo.Options = newOptions
        combo.UserData.TriggerCombo.UserData.CurrentTPTriggers = currentTPTriggers
        combo.UserData.TriggerCombo.SelectedIndex = -1

        -- Update triggers based on search input given the new level
        filterTriggersComboOptions(TeleportGroup, selectedLevel, triggerFilterInput.Text:lower())
    end

    tcb.OnChange = function(combo)
        local selectedTrigger = combo.UserData.CurrentTPTriggers[combo.SelectedIndex + 1]
        -- ECDebug("New Selected Trigger:")
        -- ECDump(selectedTrigger)
        combo.UserData.TriggerInfo.Label = string.format(
            Ext.Loca.GetTranslatedString("h43b94e5ff53f497aa8b150b78c8e6568bc89"), selectedTrigger.LevelName)
        combo.UserData.TriggerInfo2.Label = string.format(
            "\t%s\n\t%s\n\t" .. Ext.Loca.GetTranslatedString("h4a242405d9c3451c892a0565544586976711") .. " <%s>",
            selectedTrigger.MapKey, selectedTrigger.Name, selectedTrigger.Transform.Position)
    end
    tpbutton1.OnClick = function(button)
        local tcombo = button.UserData.TriggerCombo
        local selectedTrigger = tcombo.UserData.CurrentTPTriggers[tcombo.SelectedIndex + 1]
        if selectedTrigger ~= nil then
            local x, y, z = table.unpack(selectedTrigger.Transform.Position:split(" "))
            x = tonumber(x)
            y = tonumber(y)
            z = tonumber(z)
            DoTeleport(nil, selectedTrigger.Name, selectedTrigger.LevelName, nil, { x, y, z })
        end
    end
    tpbutton2.OnClick = function(button2)
        local tcombo = button2.UserData.TriggerCombo
        local selectedTrigger = tcombo.UserData.CurrentTPTriggers[tcombo.SelectedIndex + 1]
        if selectedTrigger ~= nil then
            DoTeleport(nil, selectedTrigger.Name, selectedTrigger.LevelName, selectedTrigger.MapKey, nil)
        end
    end
    -- TODO: Favorites tree
    local triggerFavorites = Favorite.CreateFromFileOrFresh("Triggers", "FavoriteTriggers")
    FavoritesTree = TeleportGroup:AddTree(Ext.Loca.GetTranslatedString("hfe0367950a754b5e8e5dd3223ab201e21739"))
    FavoritesTree.DefaultOpen = true
    favbutton.UserData = {
        ButtonCell = annoyingcell,
        TriggerCombo = tcb,
        TriggerFavorites = triggerFavorites,
    }
    favbutton.OnClick = FavButtonHandler
    FavoritesTree.UserData = {
        TriggerFavorites = triggerFavorites,
        LinkedCheck = bringLinkedChk,
        FollowersCheck = bringFollowersChk,
        SummonsCheck = bringSummonsChk,
    }
    RegenerateFavoritesTree()
    -- TODO: End combat/force peace, and end dialogue buttons

    -- local tree = TeleportGroup:AddTree("Moxi's TeleportNodes")
    -- for k, v in pairs(Teleports.Regions.Act1.Locations) do
    --     AddTeleportButton(tree, v.Act, v.Uuid, v.Name)
    -- end
    local wp = TeleportGroup:AddTree(Ext.Loca.GetTranslatedString("h7f162a839eaf413c8d8117488d631448f0f6"))
    for k, v in pairs(Teleports.Waypoints) do
        local count = 0
        for _, _ in pairs(v) do count = count + 1 end -- dictionaries smh
        local w = wp:AddTree(string.format(Ext.Loca.GetTranslatedString("h15bbf968a6214cab8f29a650d83ba5ab3462"), k,
            count))
        for i, j in pairs(v) do
            AddTeleportButton(w, k, j, i)
        end
    end
end

function RegenerateFavoritesTree()
    local favs = FavoritesTree.UserData.TriggerFavorites --[[@as ECFavorite]]
    for _, child in pairs(FavoritesTree.Children) do child:Destroy() end -- kill the kids, yikes
    if favs:Count() == 0 then return end
    local favtable = FavoritesTree:AddTable("FavoriteTable", 3)
    favtable:SetColor("TableRowBg", { 0.05, 0.29, 0.38, 1.00 })
    favtable:SetColor("TableRowBgAlt", { 0.20, 0.13, 0.25, 1.00 })
    favtable.Size = { 600, 400 }
    if favs:Count() > 5 then favtable.ScrollY = true else favtable.ScrollY = false end
    favtable.SizingFixedFit = true
    favtable.NoHostExtendX = true
    favtable.Borders = true
    favtable.RowBg = true
    --favtable.Reorderable = true
    for k, v in pairs(favs.Data) do
        local r = favtable:AddRow()
        local bcell = r:AddCell()
        local bt = bcell:AddButton("T")
        bt.IDContext = "bt" .. v.MapKey
        bt:Tooltip():AddText("\t" .. Ext.Loca.GetTranslatedString("h931e7f87a1544a00866d42ae536bff11418g"))
        local bp = bcell:AddButton("P")
        bp.IDContext = "bp" .. v.MapKey
        local b = bcell:AddImageButton("FavButton" .. v.MapKey, "levelUp_hp_h2", { 18, 18 })
        b.UserData = {
            Trigger = v,
            TriggerFavorites = favs,
            ButtonCell = bcell,
        }
        b.OnClick = MiniFavButtonHandler
        b:Tooltip():AddText("\t" .. Ext.Loca.GetTranslatedString("h5087913ccab441a680aea73be93083e68dd2"))
        bp:Tooltip():AddText("\t" .. Ext.Loca.GetTranslatedString("h080341f51a0441acad302b3b541a4a446gg0"))
        bt.UserData = {
            Trigger = v,
            TriggerFavorites = favs,
            ButtonCell = bcell,
        }
        bp.UserData = {
            Trigger = v,
            TriggerFavorites = favs,
            ButtonCell = bcell,
        }
        bt:SetStyle("FramePadding", 0, 0)
        bp:SetStyle("FramePadding", 0, 0)
        -- bt:SetStyle("ButtonTextAlign", -2, -2)
        -- bp:SetStyle("ButtonTextAlign", -2, -2)
        bt.Size = { 24, 24 }
        bp.Size = { 24, 24 }
        bt.OnClick = function(buttont)
            DoTeleport(nil, buttont.UserData.Trigger.Name, buttont.UserData.Trigger.LevelName,
                buttont.UserData.Trigger.MapKey, nil)
        end
        bp.OnClick = function(buttonp)
            -- Position Teleport
            local trig = buttonp.UserData.Trigger
            local x, y, z = table.unpack(trig.Transform.Position:split(" "))
            x = tonumber(x)
            y = tonumber(y)
            z = tonumber(z)
            DoTeleport(nil, trig.Name, trig.LevelName, nil, { x, y, z })
        end
        local namecell = r:AddCell()
        namecell:Tooltip():AddText("\t" .. v.MapKey)
        --namecell.ItemWidth = 14
        local nt = namecell:AddText(wrap(v.Name, 30))
        --nt.ItemWidth = 14
        local pt = namecell:AddText(v.Transform.Position)
        pt:SetColor("Text", Imgui.Colors.NeutralColor)

        r:AddCell():AddText(v.LevelName):Tooltip():AddText("\t" .. v.MapKey)
    end
    FavoritesTree.Label = string.format(Ext.Loca.GetTranslatedString("h2ebb2c47f8864250a2dbc58135533ecf0ff5"),
        favs:Count())
end

function AddTeleportButton(treeParent, act, location, name)
    local telebutton = treeParent:AddButton(act .. ": " .. name)
    telebutton.UserData = {
        Location = location
    }
    telebutton.OnClick = function()
        DoTeleport(act, name, nil, location, nil)

        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({
            Operation = CheatManager.Cheats["Teleport"].Name,
            Args = { Act = act, Trigger = location }
        }))
    end
end

function MiniFavButtonHandler(button)
    local trigger = button.UserData.Trigger
    local toggledOn = button.UserData.TriggerFavorites:ToggleFavorite(trigger.MapKey, trigger)
    local cell = button.UserData.ButtonCell --[[@as ExtuiTableCell]]
    local newb
    if toggledOn then
        newb = cell:AddImageButton("FavButton" .. trigger.MapKey, "levelUp_hp_h2", { 18, 18 })
    else
        newb = cell:AddImageButton("FavButton" .. trigger.MapKey, "levelUp_hp_h3", { 18, 18 })
    end
    newb.UserData = {
        Trigger = trigger,
        TriggerFavorites = button.UserData.TriggerFavorites,
        ButtonCell = cell,
    }
    newb.OnClick = MiniFavButtonHandler
    newb.UserData.TriggerFavorites:SaveToFile("FavoriteTriggers")
    button:Destroy()
end

function FavButtonHandler(button)
    local trigger = button.UserData.TriggerCombo.UserData.CurrentTPTriggers
        [button.UserData.TriggerCombo.SelectedIndex + 1]
    if not trigger then return end
    local toggledOn = button.UserData.TriggerFavorites:ToggleFavorite(trigger.MapKey, trigger)
    local cell = button.UserData.ButtonCell
    local newb
    if toggledOn then
        newb = cell:AddImageButton("FavButton" .. trigger.MapKey, "levelUp_hp_h2", { 28, 28 })
    else
        newb = cell:AddImageButton("FavButton" .. trigger.MapKey, "levelUp_hp_h3", { 28, 28 })
    end
    newb.UserData = {
        TriggerCombo = button.UserData.TriggerCombo,
        Trigger = trigger,
        TriggerFavorites = button.UserData.TriggerFavorites,
        ButtonCell = cell,
    }
    newb.OnClick = FavButtonHandler
    newb.UserData.TriggerFavorites:SaveToFile("FavoriteTriggers")
    button:Destroy()
    RegenerateFavoritesTree()
end
