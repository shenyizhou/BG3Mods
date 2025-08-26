---@class ECFavorite: MetaClass
---@field Name string
---@field Data table<any> associative table
Favorite = _Class:Create("ECFavorite", nil, {})

function Favorite:__tostring() return string.format("%s Data, %d entries", self.Name, self:Count()) end

function Favorite:Init()
    self.Name = self.Name or "Generic"
    self.Data = self.Data or {}
end

---Saves the favorite data to a given fileName within a subfolder of
--- %localappdata%/Larian Studios/Baldur's Gate 3/Script Extender
--- Resulting file is "<folder>/<fileName>.json"
---@param fileName string|nil   Default: "<ModName>_Favorites"
---@param folder string|nil     Default: "<ModName>"
function Favorite:SaveToFile(fileName, folder)
    local modinfo = Ext.Mod.GetMod(ModuleUUID).Info
    local save = Ext.DumpExport(self.Data)
    folder = folder or modinfo.Name
    fileName = fileName or self.Name.."_Favorites"
    local path = folder.."/"..fileName..".json"
    if save ~= nil then
        Ext.IO.SaveFile(path, save)
        --ECDebug("Saved Favorites to: %s", fileName)
    else
        ECWarn("Favorites have invalid data, failed to save: %s", self.Data)
    end
end

---Creates a new Favorite with a given name, from a given fileName and/or folder
--- Expected path format is "<folder>/<fileName>.json"
---@param name string|nil       Default: "Generic"
---@param fileName string|nil   Default: "Generic_Favorites"
---@param folder string|nil     Default: "<ModName>"
---@return ECFavorite|nil
function Favorite.CreateFromFile(name, fileName, folder)
    local modinfo = Ext.Mod.GetMod(ModuleUUID).Info
    folder = folder or modinfo.Name
    fileName = fileName or "Generic_Favorites"
    local path = folder.."/"..fileName..".json"
    local contents = Ext.IO.LoadFile(path)
    if contents ~= nil then
        local success, data = pcall(Ext.Json.Parse, contents)
        if not success then
            return ECWarn("Couldn't parse favorites: %s", path)
        end
        
        return Favorite:New{Name = name, Data = data}
    else
        return --ECWarn("Couldn't create favorites from file: %s", path)
    end
end

---Same as CreateFromFile, but returns a new generic instance instead of nil, in case of failure to read from fileName
---@param name string|nil       Default: "Generic"
---@param fileName string|nil   Default: "Generic_Favorites"
---@param folder string|nil     Default: "<ModName>"
---@return ECFavorite
function Favorite.CreateFromFileOrFresh(name, fileName, folder)
    local inst = Favorite.CreateFromFile(name, fileName, folder)
    if inst ~= nil then
        return inst
    else return Favorite:New() end
end

function Favorite:Count()
    local count = 0
    for _ in pairs(self.Data) do count = count + 1 end
    return count
end

function Favorite:AddFavorite(key, data)
    if self.Data[key] == nil then
        self.Data[key] = data
    else
        -- already exists
    end
end
function Favorite:RemoveFavorite(key)
    self.Data[key] = nil
end
--- Same as AddFavorite except toggles and returns boolean, true == added | false == removed
---@param key string
---@param data any
---@return boolean addedOrRemoved true == added | false == removed
function Favorite:ToggleFavorite(key, data)
    if self.Data[key] == nil then
        self.Data[key] = data
        return true
    else
        self.Data[key] = nil
        return false
    end
end