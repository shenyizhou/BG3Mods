---@class EasyCheat: MetaClass
---@field Name string
---@field Group string menu group
---@field Order integer sorting order within group
---@field ClientUI function defines UI code on client
---@field ServerCode function defines server code to process cheat
---@field Enabled boolean
EasyCheat = _Class:Create("EasyCheat", nil, {
    Name = "BaseCheat",     -- cheat name
    Order = 0,
    Group = "Generic",
    Enabled = false,
    ClientUI = nil,         -- UI code
    ServerCode = nil,       -- server code
})
--function EasyCheat:Init() ECWarn("EasyCheat Init called!") end

---Client: Individual Cheat UI
---@param treeParent ImguiHandle
function EasyCheat:GenerateUI(treeParent) if self.ClientUI then self.ClientUI(treeParent) end end

---Server: Individual cheat processing
---@param entity Character character to use cheats on
---@param args table table of any necessary cheat args
function EasyCheat:Process(entity, args) if self.ServerCode then self.ServerCode(entity, args) end end