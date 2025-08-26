---@class ECStatSpellManager
---@field AllSpells table<integer, ECStatSpell>
---@field AllSpellStrings table<integer, string>
---@field AllSpellsMap table<string, ECStatSpell>
---@field HasPopulated boolean
ECSpellManager = _Class:Create("ECStatSpellManager", nil, {
    AllSpells = {},
    AllSpellStrings = {},
    AllSpellsMap = {}, -- name-indexed mapping
    HasPopulated = false,
})

---Gives ECStatSpell by name
---@param statName string
---@return ECStatSpell|nil
function ECSpellManager:GetSpellByString(statName)
    return self.AllSpellsMap[statName]
end

---Returns matching status names given a search text
---@param search string|nil
---@param filterTable table<function>
---@param includeUpcasts boolean
---@return table<string>
function ECSpellManager:GetMatchingSpellStrings(search, filterTable, includeUpcasts)
    if not search or search == "" then return {} end -- return self.AllSpellStrings instead?
    if filterTable == nil or table.isEmpty(filterTable) then return {} end
    search = search:lower()
    local matches = {}
    -- ECDebug("Searching %s in %d spells", search, #self.AllSpells)
    for _,statSpell in ipairs(self.AllSpells) do
        -- includeUpcasts meaning ALL spells including upcasts, otherwise ignore upcast subspells
        if includeUpcasts or statSpell.RootSpellID == nil or statSpell.RootSpellID:gsub(" ", "") == "" then
            local found = false
            for _,filter in pairs(filterTable) do
                if filter(statSpell, search) then
                    found = true
                    break
                end
            end
            if found then
                table.insert(matches, statSpell.Name)
            end
        end
    end
    -- ECDebug("Found %d matches", #matches)
    return matches
end

---Returns matching statuses based on given search text
---@param search string|nil
---@return table<ECStatSpell>
function ECSpellManager:GetMatchingSpells(search)
    return {}
end

function ECSpellManager:Populate()
    if self.HasPopulated then return end

    for _,entry in pairs(Ext.Stats.GetStats("SpellData")) do
        local stat = Ext.Stats.Get(entry) --[[@as SpellData]]
        if stat ~= nil and self.AllSpellsMap[entry] == nil then
            local spell = ECStatSpellDef:New{
                -- Basic
                Name = stat.Name, -- should be same as entry
                ModId = stat.ModId,
                OriginalModId = stat.OriginalModId,
                DisplayName = Ext.Loca.GetTranslatedString(stat.DisplayName),
                Icon = string.gsub(stat.Icon, " ","") == "" and "Item_Unknown" or stat.Icon == "unknown" and "Item_Unknown" or stat.Icon,
                IconFlaggedUnknown = string.gsub(stat.Icon, " ","") == "" or stat.Icon == "unknown" or stat.Icon == nil,
                Description = Ext.Loca.GetTranslatedString(stat.Description),
                Using = stat.Using,
                -- SpellSpecific
                SpellType = stat.SpellType,
                -- SpellProperties = stat.SpellProperties ~= nil and Ext.Types.Serialize(stat.SpellProperties) or {},
                SpellFlags = stat.SpellFlags,
                SpellSchool = stat.SpellSchool,
                SpellSuccess = stat.SpellSuccess,
                ContainerSpells = stat.ContainerSpells,
                Level = stat.Level,
                Shape = string.gsub(stat.Shape," ","") == "" and "None" or stat.Shape,
                TargetRadius = stat.TargetRadius,
                Cooldown = stat.Cooldown,
                UseCosts = stat.UseCosts,
                RitualCosts = stat.RitualCosts,
                RootSpellID = stat.RootSpellID,
            }
            table.insert(self.AllSpells, spell)
            table.insert(self.AllSpellStrings, entry)
            self.AllSpellsMap[entry] = spell
        end
    end
    -- Parse extra stuff after DB's are filled
    for i,spell in pairs(self.AllSpells) do
        if spell.RootSpellID and spell.RootSpellID:gsub(" ","") ~= "" then
            -- Likely an upcast?
            local root = self.AllSpellsMap[spell.RootSpellID]
            if root ~= nil then
                -- found the root, add this spell id to its upcast ID's
                if root.UpcastIDs == nil then root.UpcastIDs = {} end -- first upcast found
                table.insert(root.UpcastIDs, spell.Name)
                table.sort(root.UpcastIDs)
            end
        end
    end

    self.HasPopulated = true
    ECPrint("SpellManager populated with %d spells.", #self.AllSpells)
end

Ext.Events.SessionLoaded:Subscribe(function()
    ECSpellManager:Populate()
end)
Ext.Events.ResetCompleted:Subscribe(function()
    ECSpellManager:Populate()
    -- if Ext.IsClient() then ECDump(ECSpellManager.AllSpells[330]) end
end)