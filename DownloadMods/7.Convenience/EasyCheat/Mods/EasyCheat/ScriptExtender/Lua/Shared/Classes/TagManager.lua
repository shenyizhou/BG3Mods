---@class ECTagManager
---@field AllTags table<ECTag>
---@field AllTagsMap table<string, ECTag>
---@field AllTagsNameMap table<string, ECTag>
---@field HasPopulated boolean
ECTagManager = _Class:Create("ECTagManager", nil, {
    AllTags = {},
    AllTagsMap = {}, -- uuid-indexed mapping
    AllTagsNameMap = {}, -- name-indexed mapping
    HasPopulated = false,
})

---Gives ECTag by name or id
---@param statName string
---@return ECTag|nil
function ECTagManager:GetTagByString(statName)
    local tag = self.AllTagsMap[statName]
    if tag == nil then tag = self.AllTagsNameMap[statName] end
    return tag
end

---Returns matching tag names given a search text
---@param search string|nil
---@param filterTable table<function> Filter format of StatSearchFilter
---@return table<string>
function ECTagManager:GetMatchingTagStrings(search, filterTable)
    if not search or search == "" then return {} end
    if filterTable == nil or table.isEmpty(filterTable) then return {} end
    search = search:lower()
    local matches = {}
    for _,tag in ipairs(self.AllTags) do
        local found = false
        for _,filter in pairs(filterTable) do
            if filter(tag, search) then
                found = true
                break
            end
        end
        if found then
            table.insert(matches, tag.TagName)
        end
    end
    return matches
end

---Returns matching tags based on given search text
---@param search string|nil
---@return table<ECTag>
function ECTagManager:GetMatchingTags(search)
    return {}
end

function ECTagManager:Populate()
    if self.HasPopulated then return end

    for _,entry in pairs(Ext.StaticData.GetAll("Tag")) do
        local res = Ext.StaticData.Get(entry, "Tag") --[[@as ResourceTag]]
        if res ~= nil and self.AllTagsMap[entry] == nil then
            local tag = ECTagDef:New{
                TagName = res.Name, -- should be same as entry
                TagUuid = entry, -- should be same as ResourceUUID
                DisplayName = res.DisplayName:Get() or ("["..res.Name.."]") or "[No display name]",
                DisplayDescription = res.DisplayDescription:Get() or "[No description]",
                Icon = res.Icon,
                IconFlaggedUnknown = res.Icon == "" or res.Icon == nil,
            }
            table.insert(self.AllTags, tag)
            self.AllTagsMap[entry] = tag
            self.AllTagsNameMap[tag.TagName] = tag
        end
    end

    self.HasPopulated = true
    ECPrint("TagManager populated with %d tags.", #self.AllTags)
end

Ext.Events.SessionLoaded:Subscribe(function()
    ECTagManager:Populate()
end)
Ext.Events.ResetCompleted:Subscribe(function()
    ECTagManager:Populate()
end)