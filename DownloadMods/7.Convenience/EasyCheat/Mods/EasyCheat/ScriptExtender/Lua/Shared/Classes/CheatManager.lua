---@class ECCheatManager:MetaClass
---@field UserTargetEntitiesMap Guid[]
---@field Cheats table<string, EasyCheat> All available cheats, unsorted
---@field SortedGeneral EasyCheat[]
---@field SortedSliders EasyCheat[]
---@field SortedGlobals EasyCheat[]
---@field SortedGlobalSliders EasyCheat[]
---@field SortedStatSpells EasyCheat[]
---@field SortedElixirs EasyCheat[]
---@field SortedResource EasyCheat[]
ECCheatManager = _Class:Create("ECCheatManager", nil, {
    UserTargetEntitiesMap = {},
    Cheats = {},
    SortedGeneral = {},
    SortedSliders = {},
    SortedGlobals = {},
    SortedGlobalSliders = {},
    SortedStatSpells = {},
    SortedElixirs = {},
    SortedResource = {}
})

function ECCheatManager:Init()
    -- sort Cheats table
    for k, v in pairs(self.Cheats) do
        if v.Group == "General" then
            self.SortedGeneral[v.Order] = v
        end
        if v.Group == "Sliders" then
            self.SortedSliders[v.Order] = v
        end
        if v.Group == "StatSpells" then
            self.SortedStatSpells[v.Order] = v
        end
        if v.Group == "Globals" then
            self.SortedGlobals[v.Order] = v
        end
        if v.Group == "GlobalSliders" then
            self.SortedGlobalSliders[v.Order] = v
        end
        if v.Group == "Elixir" then
            self.SortedElixirs[v.Order] = v
        end
        if v.Group == "Resources" then
            self.SortedResource[v.Order] = v
        end
    end
end

function ECCheatManager:RequestHostOnlyToggle(userid, value)
    if userid ~= 65537 then
        return ECWarn("Only the server host can toggle cheats %s, attempted by User %s (%d)", value and "on" or "off", Osi.GetUserName(userid), userid)
    end
    local vars = Helpers.ModVars:Get(ModuleUUID)
    vars.HostOnlyCheats = value and 1 or 0
    --local mcmserveronly = Mods.BG3MCM.MCMAPI:GetSettingValue("ec_HostOnlyToggle", ModuleUUID)
    --ECWarn("HostOnlyCheats toggled to %s", tostring(value))
    Ext.Net.BroadcastMessage(ECChannels.HostOnlyToggled, Ext.Json.Stringify({ Value = value }))
end

--- Global CheatManager, --FIXME: Localize scope
CheatManager = ECCheatManager:New{
    Cheats = {
        ["LevelUp"]             = EasyCheat:New{ Group = "General",     Enabled = true, Order = 1,     Name = "LevelUp",               },
        ["Revive"]              = EasyCheat:New{ Group = "General",     Enabled = true, Order = 2,     Name = "Revive",                },
        ["Respec"]              = EasyCheat:New{ Group = "General",     Enabled = true, Order = 3,     Name = "Respec",                },
        ["Mirror"]              = EasyCheat:New{ Group = "General",     Enabled = true, Order = 4,     Name = "Mirror",                },
        ["RestLong"]            = EasyCheat:New{ Group = "General",     Enabled = true, Order = 5,     Name = "RestLong",              },
        ["RestShort"]           = EasyCheat:New{ Group = "General",     Enabled = true, Order = 6,     Name = "RestShort",             },
        ["TeleportCamp"]        = EasyCheat:New{ Group = "General",     Enabled = true, Order = 7,     Name = "TeleportCamp",          },
        ["Immortality"]         = EasyCheat:New{ Group = "General",     Enabled = true, Order = 8,     Name = "Immortality",           },
        ["BreakOath"]           = EasyCheat:New{ Group = "General",     Enabled = true, Order = 9,     Name = "BreakOath",             },
        ["RestoreOath"]         = EasyCheat:New{ Group = "General",     Enabled = true, Order = 10,    Name = "RestoreOath",           },
        ["DisableFallDamage"]   = EasyCheat:New{ Group = "General",     Enabled = true, Order = 11,    Name = "DisableFallDamage"      }, -- perm featherfall
        -- ["IncreaseCarry"]       = EasyCheat:New{ Group = "General",     Enabled = false, Order = 12,    Name = "IncreaseCarry"          }, -- disabled, need global version

        ["GiveGold"]            = EasyCheat:New{ Group = "Sliders",     Enabled = true, Order = 1,    Name = "GiveGold",              },
        ["GiveExperience"]      = EasyCheat:New{ Group = "Sliders",     Enabled = true, Order = 2,    Name = "GiveExperience",        },
        ["GiveTadpole"]         = EasyCheat:New{ Group = "GlobalSliders",   Enabled = true, Order = 1,    Name = "GiveTadpole",           },
        ["GiveInspiration"]     = EasyCheat:New{ Group = "GlobalSliders",   Enabled = true, Order = 2,    Name = "GiveInspiration",       },
        ["StayClean"]           = EasyCheat:New{ Group = "Globals",     Enabled = true, Order = 1,     Name = "StayClean",             }, -- disable dirtying
        ["GlobalCarry"]         = EasyCheat:New{ Group = "Globals",     Enabled = false, Order = 2,     Name = "GlobalCarry",             }, -- increase carry capacity extradata
        ["DisableFog"]          = EasyCheat:New{ Group = "Globals",     Enabled = true, Order = 3,     Name = "DisableFog",             }, -- disable fog of war

        ["UnlockStoryControls"] = EasyCheat:New{ Group = "StatSpells",     Enabled = true, Order = 1,     Name = "UnlockStoryControls"            }, -- add interrupts for critting dialog rolls
        ["UnlockKill"]          = EasyCheat:New{ Group = "StatSpells",     Enabled = true, Order = 2,     Name = "UnlockKill"            }, -- add interrupts for failing dialog rolls
        ["UnlockProtection"]    = EasyCheat:New{ Group = "StatSpells",     Enabled = true, Order = 3,     Name = "UnlockProtection"  }, -- gives protection from stupidity

        ["ElixirBloodlust"]     = EasyCheat:New{ Group = "Elixir",     Order = 1,     Name = "BuffElixir_Bloodlust"   },
        ["ElixirHillGiant"]     = EasyCheat:New{ Group = "Elixir",     Order = 2,     Name = "BuffElixir_HillGiant"   },
        ["ElixirCloudGiant"]    = EasyCheat:New{ Group = "Elixir",     Order = 3,     Name = "BuffElixir_CloudGiant"  },
        ["ElixirViciousness"]   = EasyCheat:New{ Group = "Elixir",     Order = 4,     Name = "BuffElixir_Viciousness" },

        ["ChangeSpell"]         = EasyCheat:New{ Group = "Generic",     Enabled = true, Order = 1,     Name = "ChangeSpell"           },
        ["ChangePassive"]       = EasyCheat:New{ Group = "Generic",     Enabled = true, Order = 2,     Name = "ChangePassive"         },
        ["ChangeResource"]      = EasyCheat:New{ Group = "Generic",     Enabled = true, Order = 3,     Name = "ChangeResource"        },
        ["ChangeApproval"]      = EasyCheat:New{ Group = "Generic",     Enabled = true, Order = 4,     Name = "ChangeApproval"        },
        ["ChangeRelationship"]  = EasyCheat:New{ Group = "Generic",     Enabled = true, Order = 5,     Name = "ChangeRelationship"    },
        ["Teleport"]            = EasyCheat:New{ Group = "Generic",     Enabled = true, Order = 6,     Name = "Teleport"              },
    }
}

local function CheatCheck(userid, failmessage)
    if Ext.IsClient() then ECWarn("Cheat attempted outside server code, who are you?") return end

    local vars = Helpers.ModVars:Get(ModuleUUID)
    if vars.HostOnlyCheats == 1 and userid ~= 65537 then
        return ECWarn(failmessage, Osi.GetUserName(userid), userid)
    end
end

---Server: Spawn item to current character of userid
---@param userid UserId
---@param itemtospawn string Item
---@param amount number
function CheatManager:SpawnItem(userid, itemtospawn, amount)
    CheatCheck(userid, "Only the server host can spawn items, attempted by User %s (%d)")
    local character = Osi.GetCurrentCharacter(userid)
    local entity = Ext.Entity.Get(character)
    --ECDump(entity)
    local name = entity.CustomName
    if name == nil then name = entity.Uuid.EntityUuid else name = entity.CustomName.Name end
    ECPrint("Adding item %s to %s(%s)", itemtospawn, name, userid)
    Osi.TemplateAddTo(itemtospawn, character, amount, 1)
end
function CheatManager:UpdateTargetEntities(userid, entitylist)
    self.UserTargetEntitiesMap[userid] = { entitylist }
end
---Server: EasyCheat processor
---@param userid UserId
---@param cheat string String matching an EasyCheat
---@param args table Table of any necessary args to pass to individual EasyCheat for processing
function CheatManager:ProcessCheat(userid, cheat, args)
    CheatCheck(userid, "Only the server host can cheat, attempted by User %s (%d)")

    local c = CheatManager.Cheats[cheat] --[[@as EasyCheat]]
    --ECPrint("Processing cheat for Userid: %d", userid)
    --ECDump(self.UserTargetEntitiesMap)
    if c ~= nil then
--        ECDump(self.UserTargetEntitiesMap[userid])
        if c.Name == "Teleport" then
            -- Teleport special case, fix later?
            -- only teleport userid's current character, not target entities
            local char = Osi.GetCurrentCharacter(userid) --[[@as Character]]
            if char ~= nil then
                c:Process(char, args)
            end
        elseif c.Group == "Globals" then
            -- Global cheats should only be toggled once, not for all/single target entities
            ECPrint("Processing Global cheat [%s] for user: %d, %s", c.Name, userid, Helpers.Loca:GetDisplayName(Osi.GetCurrentCharacter(userid)))
            c:Process(Osi.GetHostCharacter() --[[@as Character]], args)
        else
            if args ~= nil and args.Target ~= nil then
                ECPrint("Processing Cheat [%s] for user: %d, %s (%s)", c.Name, userid, Helpers.Loca:GetDisplayName(args.Target), args.Target)
                c:Process(args.Target, args)
            else
                for _, e in ipairs(self.UserTargetEntitiesMap[userid]) do
                    for _, f in ipairs(e) do
                        ECPrint("Processing Cheat [%s] for user: %d, %s (%s)", c.Name, userid, Helpers.Loca:GetDisplayName(f), f)
                        c:Process(f, args)
                    end
                end
            end
        end
    else
        ECWarn("Cheat not implemented: %s", cheat)
    end
end
---Client: Generates the UI for this cheat
---@param treeParent ExtuiTreeParent
function CheatManager:GenerateMainUITable(treeParent)
    if Ext.IsServer() then ECWarn("Err, no generating UI on server code plz") return end
    
    local maintable = treeParent:AddTable("Main Cheats", 3)
    maintable.IDContext = string.format("%sMainCheatstable", treeParent.IDContext)
    maintable.Borders = true
    maintable.BordersH = true
    maintable.BordersV = true
    maintable.BordersInnerV = true
    maintable.BordersOuterV = false
    maintable.SizingStretchSame = true
    --maintable.NoClip = true
    --maintable.Resizable = true
    --maintable.PadOuterX = true
    maintable.RowBg = true
    --maintable.PreciseWidths = true
    --ECDump(maintable)
    local currentrow = maintable:AddRow()
    local currentcell
    local everythird = 0
    for i, cheat in ipairs(self.SortedGeneral) do
        if cheat.ClientUI ~= nil and cheat.Enabled then
            if everythird ~= 0 and everythird % 3 == 0 then currentrow = maintable:AddRow() end
            currentcell = currentrow:AddCell()
            currentcell.IDContext = string.format("%sCell%s", maintable.IDContext, i)
            cheat:GenerateUI(currentcell)
            everythird = everythird + 1
        end
    end
    local slidertable = treeParent:AddTable("SliderCheats", 2)
    slidertable.SizingStretchProp = true
    for i, cheat in ipairs(self.SortedSliders) do
        if cheat.ClientUI ~= nil and cheat.Enabled then
            cheat:GenerateUI(slidertable:AddRow())
        end
    end

    Imgui.SetChunkySeparator(treeParent:AddSeparatorText("Cheat Spells"))
    local statSpellWarning = treeParent:AddImage("tutorial_warning_yellow", {48, 48})
    local tt = Imgui.SetPopupStyle(statSpellWarning:Tooltip())
    tt:AddText("\t"..wrap(Ext.Loca.GetTranslatedString("hc3fccdae4d82418a9f9f2895f923fb4ed1ag"), 60))
    tt:AddBulletText(wrap(Ext.Loca.GetTranslatedString("h9e68bbaedb974b16ace0a43d49f90c65f7f3"), 55))
    local cheatSpellTable = treeParent:AddTable("CheatSpellsTable", 3)
    cheatSpellTable.SizingStretchProp = true
    cheatSpellTable.SameLine = true
    local cstr = cheatSpellTable:AddRow()
    for i, cheat in ipairs(self.SortedStatSpells) do
        if cheat.ClientUI ~= nil and cheat.Enabled then
            cheat:GenerateUI(cstr:AddCell())
        end
    end
    
    Imgui.SetChunkySeparator(treeParent:AddSeparatorText(Ext.Loca.GetTranslatedString("h6790ef1a9e094934b8efb5b9b60af7594977")))
    local globalSliderTable = treeParent:AddTable("GlobalSliderCheats", 2)
    globalSliderTable.SizingStretchProp = true
    for i, cheat in ipairs(self.SortedGlobalSliders) do
        if cheat.ClientUI ~= nil and cheat.Enabled then
            cheat:GenerateUI(globalSliderTable:AddRow())
        end
    end
    local globalButtonTable = treeParent:AddTable("GlobalButtonCheats", 2)
    globalButtonTable.SizingStretchProp = true
    local gbtRow = globalButtonTable:AddRow()
    for i, cheat in ipairs(self.SortedGlobals) do
        if cheat.ClientUI ~= nil and cheat.Enabled then
            cheat:GenerateUI(gbtRow:AddCell())
        end
    end
end