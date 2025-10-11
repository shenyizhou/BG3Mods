---@class ECStatStatusManager
---@field AllStatuses table<ECStatStatus>
---@field AllStatusesMap table<string, ECStatStatus>
---@field HasPopulated boolean
ECStatusManager = _Class:Create("ECStatStatusManager", nil, {
    AllStatuses = {},
    AllStatusesMap = {}, -- name-indexed mapping
    HasPopulated = false,
})

---Gives ECStatStatus by name
---@param statName string
---@return ECStatStatus|nil
function ECStatusManager:GetStatusByString(statName)
    return self.AllStatusesMap[statName]
end

---Returns matching status names given a search text
---@param search string|nil
---@param filterTable table<function> Filter format of StatSearchFilter
---@return table<string>
function ECStatusManager:GetMatchingStatusStrings(search, filterTable)
    if not search or search == "" then return {} end
    if filterTable == nil or table.isEmpty(filterTable) then return {} end
    search = search:lower()
    local matches = {}
    for _,statStatus in ipairs(self.AllStatuses) do
        local found = false
        for _,filter in pairs(filterTable) do
            if filter(statStatus, search) then
                found = true
                break
            end
        end
        if found then
            table.insert(matches, statStatus.Name)
        end
    end
    return matches
end

---Returns matching statuses based on given search text
---@param search string|nil
---@return table<ECStatStatus>
function ECStatusManager:GetMatchingStatuses(search)
    return {}
end

---Parses a dynamic stat found at runtime on demand, DOES NOT add to database, for safety in case it poof/change?
---TODO change logic to ParseStat
---@param statName string
---@return ECStatStatus|nil
function ECStatusManager:ParseDynamicStat(statName)
    local stat = Ext.Stats.Get(statName) --[[@as StatusData]]
    if stat ~= nil then
        local status = ECStatStatusDef:New{
            -- Basic
            Name = stat.Name, -- should be same as entry
            ModId = stat.ModId,
            OriginalModId = stat.OriginalModId,
            DisplayName = Ext.Loca.GetTranslatedString(stat.DisplayName),
            Icon = string.gsub(stat.Icon, " ","") == "" and "Item_Unknown" or stat.Icon == "unknown" and "Item_Unknown" or stat.Icon,
            IconFlaggedUnknown = string.gsub(stat.Icon, " ","") == "" or stat.Icon == "unknown" or stat.Icon == nil,
            Description = Ext.Loca.GetTranslatedString(stat.Description),
            Using = stat.Using,
            -- StatusSpecific
            StatusType = stat.StatusType,
            Boosts = stat.Boosts,
            StackId = stat.StackId,
            Passives = stat.Passives,
            StatusPropertyFlags = stat.StatusPropertyFlags,
            StatusGroups = stat.StatusGroups,
            AuraRadius = stat.AuraRadius,
        }
        return status
    end
end

function ECStatusManager:Populate()
    if self.HasPopulated then return end

    for _,entry in pairs(Ext.Stats.GetStats("StatusData")) do
        local stat = Ext.Stats.Get(entry) --[[@as StatusData]]
        if stat ~= nil and self.AllStatusesMap[entry] == nil then
            local status = ECStatStatusDef:New{
                -- Basic
                Name = stat.Name, -- should be same as entry
                ModId = stat.ModId,
                OriginalModId = stat.OriginalModId,
                DisplayName = Ext.Loca.GetTranslatedString(stat.DisplayName),
                Icon = string.gsub(stat.Icon, " ","") == "" and "Item_Unknown" or stat.Icon == "unknown" and "Item_Unknown" or stat.Icon,
                IconFlaggedUnknown = string.gsub(stat.Icon, " ","") == "" or stat.Icon == "unknown" or stat.Icon == nil,
                Description = Ext.Loca.GetTranslatedString(stat.Description),
                Using = stat.Using,
                -- StatusSpecific
                StatusType = stat.StatusType,
                Boosts = stat.Boosts,
                StackId = stat.StackId,
                Passives = stat.Passives,
                StatusPropertyFlags = stat.StatusPropertyFlags,
                StatusGroups = stat.StatusGroups,
                AuraRadius = stat.AuraRadius,
            }
            table.insert(self.AllStatuses, status)
            self.AllStatusesMap[entry] = status
        end
    end

    self.HasPopulated = true
    ECPrint("StatusManager populated with %d statuses.", #self.AllStatuses)
    -- if Ext.IsClient() then ECDumpS(self.AllStatuses[80]) end
end

Ext.Events.SessionLoaded:Subscribe(function()
    ECStatusManager:Populate()
end)
Ext.Events.ResetCompleted:Subscribe(function()
    ECStatusManager:Populate()
end)