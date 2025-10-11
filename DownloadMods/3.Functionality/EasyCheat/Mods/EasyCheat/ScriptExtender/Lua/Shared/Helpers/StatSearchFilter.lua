
StatSearchFilter = {}

---Fuzzy-ish search with no scoring
---@param str string String to search inside
---@param searchTerms string 
---@return boolean found
local function fuzzyishSearch(str, searchTerms)
    local function normalize(s)
        return s:gsub("%s+", ""):lower() -- Remove spaces and convert to lowercase
    end
    local normalizedStr = normalize(str)
    local words = {}
    for word in searchTerms:gmatch("%S+") do
        table.insert(words, normalize(word))
    end
    for _, word in ipairs(words) do
        if not string.find(normalizedStr, word, 1, true) then
            return false
        end
    end
    return true
end

---For uncomplicated string-fields mostly
---@param name string String to search inside
---@param stat ECStat|ECTag Curated Stat representation
---@param search string
---@return boolean found
local function simpleSearch(name, stat, search)
    return stat[name] ~= nil and fuzzyishSearch(stat[name], search)
end

local function simpleStringTableSearch(name, stat, search)
    for _,prop in ipairs(stat[name]) do
        if fuzzyishSearch(prop, search) then
            return true
        end
    end
    return false
end

--#region Common: ECStat

---@param stat ECStat
---@param searchString string
---@return boolean
function StatSearchFilter.Name(stat, searchString) return simpleSearch("Name", stat, searchString) end

---@param stat ECStat
---@param searchString string
---@return boolean
function StatSearchFilter.DisplayName(stat, searchString) return simpleSearch("DisplayName", stat, searchString) end

---@param stat ECStat
---@param searchString string
---@return boolean
function StatSearchFilter.Description(stat, searchString) return simpleSearch("Description", stat, searchString) end
--#endregion Common: ECStat

--#region ECStatSpell-Specific

---@param stat ECStatSpell
---@param searchString string
---@return boolean
function StatSearchFilter.SpellType(stat, searchString) return simpleSearch("SpellType", stat, searchString) end

---@param stat ECStatSpell
---@param searchString string
---@return boolean
function StatSearchFilter.SpellSchool(stat, searchString) return simpleSearch("SpellSchool", stat, searchString) end

---@param stat ECStatSpell
---@param searchString string
---@return boolean
function StatSearchFilter.SpellFlags(stat, searchString)
    return simpleStringTableSearch("SpellFlags", stat, searchString)
end
--#endregion ECStatSpell-Specific

--#region ECStatPassive-Specific

---@param stat ECStatPassive
---@param searchString string
---@return boolean
function StatSearchFilter.Conditions(stat, searchString) return simpleSearch("Conditions", stat, searchString) end

---@param stat ECStatPassive
---@param searchString string
---@return boolean
function StatSearchFilter.Properties(stat, searchString) return simpleSearch("Properties", stat, searchString) end
--#endregion ECStatPassive-Specific

--#region ECStatStatus-Specific

---@param stat ECStatStatus
---@param searchString string
---@return boolean
function StatSearchFilter.StatusType(stat, searchString) return simpleSearch("StatusType", stat, searchString) end
---@param stat ECStatStatus
---@param searchString string
---@return boolean
function StatSearchFilter.StackId(stat, searchString) return simpleSearch("StatusType", stat, searchString) end
---@param stat ECStatStatus
---@param searchString string
---@return boolean
function StatSearchFilter.StatusPropertyFlags(stat, searchString)
    return simpleStringTableSearch("StatusPropertyFlags", stat, searchString)
end
---@param stat ECStatStatus
---@param searchString string
---@return boolean
function StatSearchFilter.StatusGroups(stat, searchString)
    return simpleStringTableSearch("StatusGroups", stat, searchString)
end
---@param stat ECStatStatus
---@param searchString string
---@return boolean
function StatSearchFilter.Passives(stat, searchString)
    return simpleStringTableSearch("Passives", stat, searchString)
end
--#endregion ECStatStatus-Specific

---@param stat ECTag
---@param searchString string
---@return boolean
function StatSearchFilter.TagUuid(stat, searchString) return simpleSearch("TagUuid", stat, searchString) end

--#region Shared

---@param stat ECStatPassive|ECStatStatus
---@param searchString string
---@return boolean
function StatSearchFilter.Boosts(stat, searchString) return simpleSearch("Boosts", stat, searchString) end

--#endregion Shared