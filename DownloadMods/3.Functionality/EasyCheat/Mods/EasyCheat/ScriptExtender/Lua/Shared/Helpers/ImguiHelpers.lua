ImguiHelpers = {}
---Creates a custom intslider+buttoncombo
---@param tablerow ExtuiTableRow
---@param label string Button Label
---@param vec3 table<integer,integer,integer> Vec3(initial, min, max)
---@param step integer step value to increase/decrease slider
---@return ExtuiButton Button
---@return ExtuiSliderInt IntSlider
function ImguiHelpers:CreateIntSlider(tablerow, label, vec3, step, type)
    local context = string.format("%s%sRow", tablerow.IDContext, label:gsub(" ", ""))
    local leftcell = tablerow:AddCell()
    local rightcell = tablerow:AddCell()
    local finalizebutton = leftcell:AddButton(label)

    if type == "Gold" then
        local goldicon = leftcell:AddImage("ico_tab_wares_active", {36, 36})
        --goldicon.Size = { 20, 20}
        goldicon.SameLine = true
        -- Gold: Item_LOOT_COINS_Gold_Pile_Big_A.DDS
        -- LongRest: ico_longRest_d
        -- Tadpoles: Item_LOOT_Druid_Autopsy_Set_Tadpole.DDS
    end
    if type == "Exp" then
        local expicon = leftcell:AddImage("ico_skills", {36, 36})
        --expicon.Size = {20, 20}
        expicon.SameLine = true
    end
    if type == "Tadpole" then
        local tadicon = leftcell:AddImage("ico_illithid_active_d", {36, 36})
        --tadicon.Size = {20, 20}
        tadicon.SameLine = true
    end
    if type == "Inspiration" then
        local inspicon = leftcell:AddImage("ico_resource_inspirationPoint", {36, 36})
        --tadicon.Size = {20, 20}
        inspicon.SameLine = true
    end

    local intsliderreset = rightcell:AddButton("R")
    intsliderreset.SameLine = true
    local intsliderminus = rightcell:AddButton("-")
    intsliderminus.SameLine = true
    local intslider = rightcell:AddSliderInt("", vec3[1], vec3[2], vec3[3])
    intslider.SameLine = true
    --intslider.Logarithmic = true
    local intsliderplus = rightcell:AddButton("+")
    intsliderplus.SameLine = true

    intsliderreset.IDContext = string.format("%s%sreset", rightcell.IDContext, label:gsub(" ", ""))
    intsliderreset:Tooltip():AddText(string.format(Ext.Loca.GetTranslatedString("h61030b069e384bd9924ca2b8e2e21a7e7gf2").." %d", vec3[1]))
    intsliderminus.IDContext = string.format("%s%sminus", rightcell.IDContext, label:gsub(" ", ""))
    intsliderminus:Tooltip():AddText(string.format("-%d", step))
    intslider.IDContext = string.format("%s%sslider", rightcell.IDContext, label:gsub(" ", ""))
    intslider:Tooltip():AddText(Ext.Loca.GetTranslatedString("h9eb491ab7a224456be8225f4b8a36cf4f4af"))
    intsliderplus.IDContext = string.format("%s%splus", rightcell.IDContext, label:gsub(" ", ""))
    intsliderplus:Tooltip():AddText(string.format("+%d", step))

    intsliderreset.OnClick = function()
        intslider.Value = { vec3[1], vec3[2], vec3[3], 0 }
    end
    intsliderplus.OnClick = function()
        intslider.Value = { intslider.Value[1] + step, intslider.Value[2], intslider.Value[3], intslider.Value[4]}
    end
    intsliderminus.OnClick = function()
        intslider.Value = { intslider.Value[1] - step, intslider.Value[2], intslider.Value[3], intslider.Value[4]}
    end

    return finalizebutton, intslider
end

---For simple one-click button operations
---@param treeParent ExtuiTreeParent TreeParent
---@param label string Button Label
---@param cheatname string Cheat Name/index
---@return ExtuiStyledRenderable Button 
function ImguiHelpers:CreateSimpleClickCheat(treeParent, label, cheatname, statusmessage)
    local context = string.format("%s%sbutton", treeParent.IDContext, label:gsub(" ", ""))
    local button = treeParent:AddButton(label)
    button.IDContext = context
    button.OnClick = function(b)
        local target
        if b.UserData ~= nil and b.UserData.Target ~= nil then
            target = b.UserData.Target
        end
        Ext.Net.PostMessageToServer(ECChannels.DoCheat, Ext.Json.Stringify({ Operation = CheatManager.Cheats[cheatname].Name, Args = { Target = target }}))
        StatusNotify:NewStatus(statusmessage, 1, StatusNotify.DefaultFadeTime)
    end
    return button
end

---Dumps an entity, up to 10 separate files before overwriting
---@param entity EntityHandle
function ImguiHelpers.DumpEntity(entity)
    if entity == nil then
        if Ext.IsServer() then entity = Ext.Entity.Get(Osi.GetHostCharacter()--[[@as CHARACTER]])
        else entity = Ext.Entity.GetAllEntitiesWithComponent("ClientControl")[1] end
    end
    if type(entity) == "string" then
        entity = Ext.Entity.Get(entity)
    end
    if entity == nil then return ECWarn("Can't find entity to dump: %s", entity or "empty") end
    local context = Ext.IsServer() and "S" or "C"
    local success,dname = pcall(function() return Helpers.Loca:GetDisplayName(entity) or (entity.Uuid and entity.Uuid.EntityUuid) or "Unknown" end)
    local name = string.format("_Dumps/[%s_Entity]%s", context, dname or "Unknown")
    local warn = false
    if Ext.IO.LoadFile(name.."_0.json") ~= nil then -- already have file named this
        for i = 1, 10, 1 do
            local test = string.format("%s_%d", name, i)
            if Ext.IO.LoadFile(test..".json") == nil then -- good to go
                local data

                if pcall(function() return entity.GetAllComponents ~= nil end) then
                    data = entity:GetAllComponents()
                else
                    data = entity
                end
                Ext.IO.SaveFile(test..".json", Ext.DumpExport(data) or "No dumpable data available.")
                return
            end
        end
        warn = true
    end
    if warn then ECWarn("Overwriting a previous dump of this entity to %s", name) end
    local d
    if entity.GetAllComponents ~= nil then
        d = Ext.DumpExport(entity:GetAllComponents())
    else
        d = Ext.DumpExport(entity)
    end
    Ext.IO.SaveFile(name.."_0.json", d or "No dumpable data available.")
end

Dumpies = ImguiHelpers.DumpEntity

Imgui = {}
function Imgui.ScaleFactor()
    -- testing monitor for development is 1440p
    return Ext.IMGUI.GetViewportSize()[2] / 1440
end
function Imgui.ClearChildren(el)
    if el == nil then return end
    for _, v in pairs(el.Children) do
        if v.UserData ~= nil and v.UserData.SafeKeep ~= nil then
            v.UserData.SafeKeep()
        else
            v:Destroy()
        end
    end
end
Imgui.RarityColors = {
    Default     = {0.30, 0.30, 0.30, 1},
    Common      = {1.00, 1.00, 1.00, 1},
    Uncommon    = {0.00, 0.66, 0.00, 1},
    Rare        = {0.20, 0.80, 1.00, 1},
    VeryRare    = {0.82, 0.00, 0.49, 1},
    Legendary   = {0.92, 0.78, 0.03, 1},
}
Imgui.RarityColors[0]   = Imgui.RarityColors.Default
Imgui.RarityColors[1]   = Imgui.RarityColors.Common
Imgui.RarityColors[2]   = Imgui.RarityColors.Uncommon
Imgui.RarityColors[3]   = Imgui.RarityColors.Rare
Imgui.RarityColors[4]   = Imgui.RarityColors.VeryRare
Imgui.RarityColors[5]   = Imgui.RarityColors.Legendary

Imgui.ThemeColor = {
    ["Accent1"] = "#463257",
    ["Accent2"] = "#95724B",
    ["Highlight"] = "#8C0000",
    ["Header"] = "#913535",
    ["MainHover"] = "#0d9c3f",
    ["MainActive"] = "#1E8146",
    ["MainText"] = "#DBCAAE",
    ["Main"] = "#F1D099",
    ["MainActive2"] = "#523c28",
    ["Grey"] = "#696969",
    ["DarkGrey"] = "#505050",
    ["Black1"] = "#242424",
    ["Black2"] = "#0c0c0c",
}
function Imgui.NewStyling(el)
    if el == nil then return end
    -- local themeColor = {
    --     ["Accent1"] = "#32213F",
    --     ["Accent2"] = "#95724B",
    --     ["Highlight"] = "#8C0000",
    --     ["Header"] = "#913535",
    --     ["MainHover"] = "#1FCCEC",
    --     ["MainActive"] = "#0D4961",
    --     ["MainText"] = "#DBCAAE",
    --     ["Main"] = "#F1D099",
    --     ["MainActive2"] = "#523c28",
    --     ["Black1"] = "#242424",
    --     ["Black2"] = "#0c0c0c",
    -- }
    local color = {
        ["Border"]                = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["BorderShadow"]          = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black1, 0.78),
        ["Button"]                = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Main, 0.14),
        ["ButtonActive"]          = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive, 1.00),
        ["ButtonHovered"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainHover, 0.86),
        ["CheckMark"]             = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainHover, 1.00),
        ["ChildBg"]               = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, 0.88),
        ["DragDropTarget"]        = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainHover, 0.78),
        ["FrameBg"]               = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, 1.00), -- also checkboxes, scrollbars
        ["FrameBgActive"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["FrameBgHovered"]        = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 0.78),
        ["Header"]                = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Header, 0.76),
        ["HeaderActive"]          = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["HeaderHovered"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 0.86),
        ["MenuBarBg"]             = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black1, 0.87),
        ["ModalWindowDimBg"]      = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, 0.73),
        ["NavHighlight"]          = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Highlight, 0.78),
        ["NavWindowingDimBg"]     = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black1, 0.78),
        ["NavWindowingHighlight"] = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Highlight, 0.78),
        ["PlotHistogram"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainText, 0.63),
        ["PlotHistogramHovered"]  = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1.00),
        ["PlotLines"]             = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainText, 0.63),
        ["PlotLinesHovered"]      = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1.00),
        ["PopupBg"]               = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, 0.95), -- also tooltips
        ["ResizeGrip"]            = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Main, 0.04),
        ["ResizeGripActive"]      = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["ResizeGripHovered"]     = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 0.78),
        ["ScrollbarBg"]           = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, 1.00),
        ["ScrollbarGrab"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 1.00),
        ["ScrollbarGrabActive"]   = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["ScrollbarGrabHovered"]  = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainHover, 0.78),
        ["Separator"]             = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, 1.00),
        ["SeparatorActive"]       = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["SeparatorHovered"]      = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 0.78),
        ["SliderGrab"]            = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Main, 0.14),
        ["SliderGrabActive"]      = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["Tab"]                   = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Header, 0.78),
        ["TabActive"]             = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive, 0.78),
        ["TabHovered"]            = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainHover, 0.78),
        ["TableBorderLight"]      = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent2, 0.78),
        ["TableBorderStrong"]     = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Accent1, 0.78),
        ["TableHeaderBg"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Header, 0.67),
        ["TableRowBg"]            = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.DarkGrey, 0.53),
        ["TableRowBgAlt"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Grey, 0.63),
        ["TabUnfocused"]          = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black2, 0.78),
        ["TabUnfocusedActive"]    = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black2, 0.78),
        ["Text"]                  = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainText, 0.78),
        ["TextDisabled"]          = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainText, 0.28),
        ["TextSelectedBg"]        = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Header, 0.43),
        ["TitleBg"]               = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black1, 1.00),
        ["TitleBgActive"]         = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.MainActive2, 1.00),
        ["TitleBgCollapsed"]      = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black2, 0.85),
        ["WindowBg"]              = Helpers.Color:HexToNormalizedRGBA(Imgui.ThemeColor.Black1, 0.95),
    }
    for k, v in pairs(color) do
        el:SetColor(k, v)
    end
    local style = {
        --["Alpha"]                   = 1.0,
        ["ButtonTextAlign"]         = {0.5, 0.5}, -- vec2?
        ["CellPadding"]             = {4.0, 4.0}, -- vec2?
        --["ChildBorderSize"]         = 2.0,
        ["ChildRounding"]           = 4.0,
        ["DisabledAlpha"]           = 0.7,
        --["FrameBorderSize"]         = 1.0,
        ["FramePadding"]            = {4.0, 4.0}, -- vec2?
        ["FrameRounding"]           = 20.0,
        ["GrabMinSize"]             = 16.0,
        ["GrabRounding"]            = 4.0,
        ["IndentSpacing"]           = 21.0,
        ["ItemInnerSpacing"]        = {4.0, 4.0}, -- vec2?
        ["ItemSpacing"]             = {8.0, 8.0}, -- vec2?
        --["PopupBorderSize"]         = 1.0,
        ["PopupRounding"]           = 2.0,
        ["ScrollbarRounding"]       = 9.0,
        ["ScrollbarSize"]           = 20.0,
        --["SelectableTextAlign"]     = {0.0, 0.0}, -- vec2?
        ["SeparatorTextAlign"]      = {0.5, 0.5}, -- vec2?
        ["SeparatorTextBorderSize"] = 4.0,
        ["SeparatorTextPadding"]    = {5.0, 3}, -- vec2?
        ["TabBarBorderSize"]        = 3.0,
        ["TabRounding"]             = 20.0,
        ["WindowBorderSize"]        = 2.0,
        -- ["WindowMinSize"]           = {250.0, 850.0}, -- vec2? panel-size
        ["WindowPadding"]           = { 10, 8}, -- vec2? (10,8 better?)
        ["WindowRounding"]          = 20.0,
        ["WindowTitleAlign"]        = {0.5, 0.5}, -- vec2?
    }
    for k, v in pairs(style) do
        if type(v) == "table" then
            el:SetStyle(k, v[1], v[2])
        else
            el:SetStyle(k, v)
        end
    end
end

Imgui.Colors = {
    FailColor       = Helpers.Color:HexToNormalizedRGBA("#FF0000", 1),
    SuccessColor    = Helpers.Color:HexToNormalizedRGBA("#00FF00", 1),
    NeutralColor    = Helpers.Color:HexToNormalizedRGBA("#b2b2b2", 1),
    Red             = Helpers.Color:HexToNormalizedRGBA("#FF0000", 1),
    Green           = Helpers.Color:HexToNormalizedRGBA("#00FF00", 1),
    Neutral         = Helpers.Color:HexToNormalizedRGBA("#b2b2b2", 1),
    Blue            = Helpers.Color:HexToNormalizedRGBA("#1cb2db", 1),
    BG3Green        = Helpers.Color:HexToNormalizedRGBA("#A0B056", 1),
    BG3Blue         = Helpers.Color:HexToNormalizedRGBA("#0c4961", 1),
    BG3Brown        = Helpers.Color:HexToNormalizedRGBA("#523c28", 1),
    Tan             = Helpers.Color:HexToNormalizedRGBA("#99724c", 1),
    SkyBlue         = Helpers.Color:HexToNormalizedRGBA("#1FCCEC", 1),
    RealSkyBlue     = Helpers.Color:HexToNormalizedRGBA("#87CEEB", 1),
    DeepSkyBlue     = Helpers.Color:HexToNormalizedRGBA("#00BFFF", 1),
    Cyan            = Helpers.Color:HexToNormalizedRGBA("#00FFFF", 1),
    Aqua            = Helpers.Color:HexToNormalizedRGBA("#00FFFF", 1),
    DodgerBlue      = Helpers.Color:HexToNormalizedRGBA("#1E90FF", 1),
    Magenta         = Helpers.Color:HexToNormalizedRGBA("#FF00FF", 1),
    Purple          = Helpers.Color:HexToNormalizedRGBA("#800080", 1),
    Lavender        = Helpers.Color:HexToNormalizedRGBA("#E6E6FA", 1),
    SlateBlue       = Helpers.Color:HexToNormalizedRGBA("#6A5ACD", 1),
    MediumPurple    = Helpers.Color:HexToNormalizedRGBA("#9370DB", 1),
    DarkPurple      = Helpers.Color:HexToNormalizedRGBA("#331f3f", 1),
    Yellow          = Helpers.Color:HexToNormalizedRGBA("#FFFF00", 1),
    Gold            = Helpers.Color:HexToNormalizedRGBA("#FFD700", 1),
    Sienna          = Helpers.Color:HexToNormalizedRGBA("#A0522D", 1),
    LightGreen      = Helpers.Color:HexToNormalizedRGBA("#90EE90", 1),
    MediumSeaGreen  = Helpers.Color:HexToNormalizedRGBA("#3CB371", 1),
    Olive           = Helpers.Color:HexToNormalizedRGBA("#6B8E23", 1),
    MediumAquamarine= Helpers.Color:HexToNormalizedRGBA("#66CDAA", 1),
    Aquamarine      = Helpers.Color:HexToNormalizedRGBA("#7FFFD4", 1),
    Orange          = Helpers.Color:HexToNormalizedRGBA("#FFA500", 1),
    DarkOrange      = Helpers.Color:HexToNormalizedRGBA("#FF8C00", 1),
    OrangeRed       = Helpers.Color:HexToNormalizedRGBA("#FF4500", 1),
    Coral           = Helpers.Color:HexToNormalizedRGBA("#FF7F50", 1),
    Pink            = Helpers.Color:HexToNormalizedRGBA("#FFC0CB", 1),
    LightPink       = Helpers.Color:HexToNormalizedRGBA("#FFEDFA", 1),
    HotPink         = Helpers.Color:HexToNormalizedRGBA("#FF69B4", 1),
    DeepPink        = Helpers.Color:HexToNormalizedRGBA("#FF1493", 1),
    PaleVioletRed   = Helpers.Color:HexToNormalizedRGBA("#DB7093", 1),
    Crimson         = Helpers.Color:HexToNormalizedRGBA("#DC143C", 1),
    FireBrick       = Helpers.Color:HexToNormalizedRGBA("#B22222", 1),
    DarkRed         = Helpers.Color:HexToNormalizedRGBA("#8C0000", 1),
    --Lights/Whites
    White           = Helpers.Color:HexToNormalizedRGBA("#FFFFFF", 1),
    Snow            = Helpers.Color:HexToNormalizedRGBA("#FFFAFA", 1),
    HoneyDew        = Helpers.Color:HexToNormalizedRGBA("#F0FFF0", 1),
    Mint            = Helpers.Color:HexToNormalizedRGBA("#F5FFFA", 1),
    Azure           = Helpers.Color:HexToNormalizedRGBA("#F0FFFF", 1),
    AliceBlue       = Helpers.Color:HexToNormalizedRGBA("#F0F8FF", 1),
    LightGray       = Helpers.Color:HexToNormalizedRGBA("#D3D3D3", 1),
    Silver          = Helpers.Color:HexToNormalizedRGBA("#C0C0C0", 1),
    Gray            = Helpers.Color:HexToNormalizedRGBA("#A9A9A9", 1),
    MediumGray      = Helpers.Color:HexToNormalizedRGBA("#808080", 1),
    DarkGray        = Helpers.Color:HexToNormalizedRGBA("#696969", 1),
    Black           = Helpers.Color:HexToNormalizedRGBA("#000000", 1),
}

---Sets common style vars for popup
---@param popup ExtuiPopup|ExtuiTooltip
---@return ExtuiPopup|ExtuiTooltip
function Imgui.SetPopupStyle(popup)
    popup:SetColor("PopupBg", {0.18, 0.15, 0.15, 1.00})
    popup:SetStyle("PopupBorderSize", 2)
    popup:SetColor("BorderShadow", {0,0,0,0.4})
    popup:SetColor("Border", Imgui.Colors.Tan)
    popup:SetStyle("WindowPadding", 15, 15)
    return popup
end
---Sets common style vars for a chunky separator text
---@generic T 
---@param e `T`|ExtuiStyledRenderable
---@return T
function Imgui.SetChunkySeparator(e)
    e:SetStyle("SeparatorTextBorderSize", 10)
    e:SetStyle("SeparatorTextAlign", 0.5, 0.4)
    e:SetStyle("SeparatorTextPadding", 0, 0)
    return e
end

---@param tooltip ExtuiTooltip
---@param contentFunc? fun(tooltip:ExtuiTooltip):ExtuiTooltip
---@return ExtuiTooltip|nil
function Imgui.CreateSimpleTooltip(tooltip, contentFunc)
    Imgui.SetPopupStyle(tooltip)
    if contentFunc then
        contentFunc(tooltip)
    end
    return tooltip
end
---Sets up imgui table with common defaults
---@param t ExtuiTable
---@param borders boolean true|false
---@param rowBg boolean true|false Alternating row colors
---@param sizingString nil|"SizingFixedFit"|"SizingFixedSame"|"SizingStretchProp"|"SizingStretchSame" sizing options
---@param noClip boolean NoClip setting
---@param noHostExtendX boolean Whether or not table behaves, seemingly
---@return ExtuiTable
function Imgui.SetupTable(t, borders, rowBg, sizingString, noClip, noHostExtendX)
    t.Borders = borders or false
    t.RowBg = rowBg or false
    local sizings = {
        ["SizingFixedFit"] = true,
        ["SizingFixedSame"] = true,
        ["SizingStretchProp"] = true,
        ["SizingStretchSame"] = true,
    }
    if sizingString ~= nil and sizings[sizingString] then
        t[sizingString] = true
    end
    t.NoClip = noClip or false
    t.NoHostExtendX = noHostExtendX or false
    return t
end

---@class ImguiCombo
---@field Parent ExtuiCombo
Imgui.Combo = {}
---Gets the selected option
---@param combo ExtuiCombo
---@return string
function Imgui.Combo.GetSelected(combo)
    return combo.Options[combo.SelectedIndex+1]
end