---@class ECStatPassiveManager
---@field AllPassives table<ECStatPassive>
---@field AllPassivesMap table<string, ECStatPassive>
---@field HasPopulated boolean
ECPassiveManager = _Class:Create("ECStatPassiveManager", nil, {
    AllPassives = {},
    AllPassivesMap = {}, -- name-indexed mapping
    HasPopulated = false,
})

---Gives ECStatPassive by name
---@param statName string
---@return ECStatPassive|nil
function ECPassiveManager:GetPassiveByString(statName)
    return self.AllPassivesMap[statName]
end

---Returns matching passive names given a search text
---@param search string|nil
---@param filterTable table<function> Filter format of StatSearchFilter
---@return table<string>
function ECPassiveManager:GetMatchingPassiveStrings(search, filterTable)
    if not search or search == "" then return {} end
    if filterTable == nil or table.isEmpty(filterTable) then return {} end
    search = search:lower()
    local matches = {}
    for _,statPassive in ipairs(self.AllPassives) do
        local found = false
        for _,filter in pairs(filterTable) do
            if filter(statPassive, search) then
                found = true
                break
            end
        end
        if found then
            table.insert(matches, statPassive.Name)
        end
    end
    return matches
end

---Returns matching passives based on given search text
---@param search string|nil
---@return table<ECStatPassive>
function ECPassiveManager:GetMatchingPassives(search)
    return {}
end

function ECPassiveManager:Populate()
    if self.HasPopulated then return end

    for _,entry in pairs(Ext.Stats.GetStats("PassiveData")) do
        local stat = Ext.Stats.Get(entry) --[[@as PassiveData]]
        if stat ~= nil and self.AllPassivesMap[entry] == nil then
            local status = ECStatPassiveDef:New{
                -- Basic
                Name = stat.Name, -- should be same as entry
                ModId = stat.ModId,
                OriginalModId = stat.OriginalModId,
                DisplayName = Ext.Loca.GetTranslatedString(stat.DisplayName),
                Icon = string.gsub(stat.Icon, " ","") == "" and "Item_Unknown" or stat.Icon == "unknown" and "Item_Unknown" or stat.Icon,
                IconFlaggedUnknown = string.gsub(stat.Icon, " ","") == "" or stat.Icon == "unknown" or stat.Icon == nil,
                Description = Ext.Loca.GetTranslatedString(stat.Description),
                Using = stat.Using,
                -- PassiveSpecific
                Boosts = stat.Boosts,
                Conditions = stat.Conditions,
                Properties = stat.Properties,
            }
            table.insert(self.AllPassives, status)
            self.AllPassivesMap[entry] = status
        end
    end

    self.HasPopulated = true
    ECPrint("PassiveManager populated with %d passives.", #self.AllPassives)
    -- if Ext.IsClient() then ECDumpS(self.AllPassives[200]) end
end

Ext.Events.SessionLoaded:Subscribe(function()
    ECPassiveManager:Populate()
end)
Ext.Events.ResetCompleted:Subscribe(function()
    ECPassiveManager:Populate()
end)