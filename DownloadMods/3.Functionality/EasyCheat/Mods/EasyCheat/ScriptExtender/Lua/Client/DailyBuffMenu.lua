--- Called on delay, and after receiving response from netchannel
---@param treeParent ExtuiTreeParent
---@param dailyBuffs table
local function GenerateDailyBuffTable(treeParent, dailyBuffs)
    if not dailyBuffs then
        return ECWarn("Didn't receive daily buffs from server.") -- bail
    end
    
    local vfxCheck = treeParent:AddCheckbox(Ext.Loca.GetTranslatedString("hb4c152c45304415296e3bedc3cc5780990fg"), dailyBuffs.DisableVFX)
    Imgui.SetPopupStyle(vfxCheck:Tooltip()):AddText("\t"..Ext.Loca.GetTranslatedString("h6ce32cd31b8140c6ae2b41a9b5d81db1feg0"))
    treeParent:AddDummy(40,30).SameLine = true
    local sfxCheck = treeParent:AddCheckbox(Ext.Loca.GetTranslatedString("h93725a45a28b4670bf70361391c23640776c"), dailyBuffs.DisableSFX)
    Imgui.SetPopupStyle(sfxCheck:Tooltip()):AddText("\t"..Ext.Loca.GetTranslatedString("h6ce32cd31b8140c6ae2b41a9b5d81db1feg0"))
    sfxCheck.SameLine = true
    
    local enableCheckbox = treeParent:AddCheckbox(Ext.Loca.GetTranslatedString("h3e8684303b34481993c185e36381bb5e646g"), dailyBuffs.Apply)
    local applyNowButton = treeParent:AddButton(Ext.Loca.GetTranslatedString("h1c08bba4506e44ac8a8699c10e5e5c655g34"))
    -- TODO replace with fancy new NetChannel eventually
    applyNowButton.SameLine = true
    applyNowButton.OnClick = function(_)
        Ext.Net.PostMessageToServer(ECChannels.ApplyDailyBuffs, "")
    end

    enableCheckbox.OnChange = function(chk)
        Ext.Net.PostMessageToServer(ECChannels.ChangeDailyBuffs, Ext.Json.Stringify({ Apply = chk.Checked }))
    end

    vfxCheck.OnChange = function(chk)
        Ext.Net.PostMessageToServer(ECChannels.ChangeDailyBuffs, Ext.Json.Stringify({ DisableVFX = chk.Checked }))
    end
    sfxCheck.OnChange = function(chk)
        Ext.Net.PostMessageToServer(ECChannels.ChangeDailyBuffs, Ext.Json.Stringify({ DisableSFX = chk.Checked }))
    end
    treeParent:AddSeparator()

    local dbt = treeParent:AddTable("DailyBuffTable", 10)
    dbt.SizingFixedFit = true
    dbt.RowBg = true
    dbt.BordersInnerV = true
    dbt.PadOuterX = true

    local headerRow = dbt:AddRow()
    headerRow.Headers = true
    headerRow:AddCell():AddText(Ext.Loca.GetTranslatedString("hdc971ca4b1134d62adf9df53fa96d95f16a4"))
    local columnCheckboxes = {}
    local rowCheckboxes = {}
    local function changeCheckboxes(checkboxes, checked)
        if checkboxes then
            for _,checkbox in ipairs(checkboxes) do
                if checkbox.Checked ~= checked then
                    checkbox.Checked = checked
                    checkbox:OnChange()
                end
            end
        end
    end
    local function makeColumn(label, level, locaHandle)
        local cell = headerRow:AddCell()
        local sel = cell:AddSelectable(label)
        local popup = Imgui.SetPopupStyle(cell:AddPopup((label or "").."selectablePopup")) --[[@as ExtuiPopup]]
        local menu = popup:AddMenu(Ext.Loca.GetTranslatedString("h750103a17f0747178885100677cba4c1ce55", "Level").." "..label)
        Imgui.SetPopupStyle(sel:Tooltip()):AddText(Ext.Loca.GetTranslatedString(locaHandle))
        sel.UserData = {
            Level = level
        }
        local deselectMenuItem = menu:AddItem(Ext.Loca.GetTranslatedString("h9dc06bc4a320467eadd824d44847f906b3e2", "Deselect Column"))
        local selectMenuItem = menu:AddItem(Ext.Loca.GetTranslatedString("h1aa34de0260e449e9a713c8847319bddbf1c", "Select Column"))
        sel.OnClick = function()
            sel.Selected = false
            popup:Open()
        end
        deselectMenuItem.OnClick = function()
            changeCheckboxes(columnCheckboxes[sel.UserData.Level], false)
        end
        selectMenuItem.OnClick = function()
            changeCheckboxes(columnCheckboxes[sel.UserData.Level], true)
        end
    end
    local function makeRow(locaHandle, statusName, startRow)
        local locaText = Ext.Loca.GetTranslatedString(locaHandle)
        local row = dbt:AddRow()
        local c = row:AddCell()
        local sel = c:AddSelectable(locaText)
        local popup = Imgui.SetPopupStyle(c:AddPopup(statusName.."selectablePopup")) --[[@as ExtuiPopup]]
        local menu = popup:AddMenu(locaText)
        sel.UserData = {
            StatusName = statusName,
        }
        local deselectMenuItem = menu:AddItem(Ext.Loca.GetTranslatedString("hae468dfe8b76446484b812a05c98ecf6b297", "Deselect Row"))
        local selectMenuItem = menu:AddItem(Ext.Loca.GetTranslatedString("h40f9c800691f4f398771fedf2607ff19c54d", "Select Row"))
        sel.OnClick = function()
            sel.Selected = false
            popup:Open()
        end
        row.UserData = {
            LabelCell = c,
            LabelText = sel,
            StatusName = statusName,
        }
        startRow = startRow or 1
        rowCheckboxes[statusName] = {}
        for i = 1, 9, 1 do
            columnCheckboxes[i] = columnCheckboxes[i] or {}
            if i >= startRow then
                local b = dailyBuffs.Buffs[statusName]
                local initial
                local requestChange = false
                if b ~= nil then
                    initial = b[tostring(i)]
                else
                    -- new spell?
                    if dailyBuffs.Upcasting[statusName] then
                        --it's an upcast
                        initial = dailyBuffs.Upcasting[statusName][tostring(i)] ~= nil
                    else
                        -- new spell, initial as true
                        initial = true
                        requestChange = true -- Quick hack to trigger change in server's daily buffs when new status is added
                    end
                end
    
                local chk = row:AddCell():AddCheckbox("", initial)
                row.UserData["Checkbox"..i] = chk
                chk.UserData = {
                    Level = i, -- 1 = 1, 2 = 3, 3 = 5, 4 = 7, 5 = 9..
                    StatusName = row.UserData.StatusName,
                }
                chk.IDContext = "ChkDB"..row.UserData.StatusName..i
                -- cringe AID specific stuff
                if chk.UserData.StatusName == "AID" then
                    if chk.UserData.Level > 2 then
                        -- AID_3, AID_4, etc.
                        chk.UserData.UpcastStatus = chk.UserData.StatusName.."_"..chk.UserData.Level
                    else
                        -- AID is second level, so AID_2 is just AID
                        chk.UserData.UpcastStatus = "AID"
                    end
                end
                -- ECPrint("Generated %s (Level %d) %s", chk.UserData.StatusName, chk.UserData.Level, chk.UserData.UpcastStatus or "")
                chk.OnChange = function(checkbox)
                    -- Send update to server
                    local msg = Ext.Json.Stringify({
                        Status = checkbox.UserData.StatusName,
                        Level = checkbox.UserData.Level,
                        NewValue = checkbox.Checked,
                        UpcastStatus = checkbox.UserData.UpcastStatus,
                    })
                    -- ECPrint("Checkbox %s (Level %d) %s", checkbox.UserData.StatusName, checkbox.UserData.Level, checkbox.UserData.UpcastStatus or "")
                    -- ECPrint(msg)
                    Ext.Net.PostMessageToServer(ECChannels.ChangeDailyBuffs, msg)
                end
                table.insert(rowCheckboxes[statusName], chk)
                table.insert(columnCheckboxes[i], chk)
                if requestChange then chk:OnChange() end
            else
                row:AddCell() -- empty
            end
        end
        selectMenuItem.OnClick = function()
            changeCheckboxes(rowCheckboxes[statusName], true)
        end
        deselectMenuItem.OnClick = function()
            changeCheckboxes(rowCheckboxes[statusName], false)
        end
    end
    makeColumn("1+", 1, "he1e820b829ff42edb065fc666ec8832efe9f")
    makeColumn("3+", 2, "hf580427b28ef4e9ca5c529fe3ea3772da4ff")
    makeColumn("5+", 3, "h98d777d044f149bf9d681f0051eabc08e052")
    makeColumn("7+", 4, "h7bfc3bbeffeb4d9abd9eb9dbe60e4c3e0gd3")
    makeColumn("9+", 5, "hbb5b07ce7ca8499a94d8b7beb8d7b46c8bec")
    makeColumn("11+", 6, "h5d8a5695833148b4a07e884e3f72840222b3")
    makeColumn("13+", 7, "h89c4ee8546ed460bb6855c54b6fde0942126")
    makeColumn("15+", 8, "hdb2112d6ce2e41e2b2f91f2c985cdbc4e8ga")
    makeColumn("17+", 9, "h2f978ff2746342c8b39ccdd69aec33d2c99b")
    
    makeRow("h80351be74bfd4d1997aa33b6c5dedba6def9", "EC_FEATHER_FALL")
    makeRow("hf667fe265277416ea1171e83fa0135fcf210", "DARKVISION")
    makeRow("h58b1c09583b0432d8c24e671164fb88bdbf1", "GUIDANCE")
    makeRow("h7921ebd438424bb48e694b5826a97fd8636e", "LONGSTRIDER")
    makeRow("ha99b15075e524caa9cc7fb49c38230364c9f", "LONG_JUMP")
    makeRow("he08b7147eff44fa0b68cb4fb8a2f57880075", "MAGE_ARMOR")
    makeRow("h06e44fa591cf4705ab9266a202175648e3e4", "PETPAL")
    makeRow("h75474d7c00434a759e6f48f35f726249cd64", "DETECT_THOUGHTS", 2)
    makeRow("h03c98629ee07490f8da8b66adcf45bcdc384", "PROTECTION_FROM_POISON", 2)
    makeRow("ha4d0ce1a3fab441cadc6819829c578e97f5a", "ALCH_ELIXIR_BLOODLUST", 2)
    makeRow("h01a7bbcbfdd94828b43b578917586df9g5de", "FREEDOM_OF_MOVEMENT", 4)
    makeRow("h6905628160e34004ba92af9911e30c07aa6a", "DEATH_WARD", 4)
    makeRow("h3c4fb945c65748db9301b8667339bf853gfg", "HEROES_FEAST", 6)
    makeRow("hf8ea228ed2b9491f81dd7272dd87ffb9e98c", "AID", 2)

    --TODO add searchable custom statuses to apply daily
    -- local searchInput = SearchableStatusUI:CreateSearchableUI(treeParent)
    -- if searchInput ~= nil and searchInput.UserData ~= nil then
    --     searchInput.UserData.Rebind = function(b)
    --         ECDebug("Overriding add button.")
    --         -- empty for now
    --     end
    -- end
end

--- Generates the DailyBuffMenu tab after delay, so modvars are setup and synced
---@param treeParent ExtuiTreeParent
function DailyBuffMenu(treeParent)
    DailyBuffTab = treeParent

    Helpers.Timer:OnTicks(10, function()
        DailyBuffNetChannel:RequestToServer({Request = "Get"}, function(reply)
            GenerateDailyBuffTable(treeParent, reply and reply.DailyBuffs)
        end)
    end)
end