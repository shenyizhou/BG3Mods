local module = {}

local characterUuid ---@type CHARACTER|nil

---@param entity EntityHandle
function module.OnCharacterChanged(entity)
    characterUuid = Helpers.Object:GetGuid(entity)
end

---@param boostTab ExtuiTabItem
function module.GenerateBoostTab(boostTab)
boostTab:AddText("is a boose craffer")
end
return module