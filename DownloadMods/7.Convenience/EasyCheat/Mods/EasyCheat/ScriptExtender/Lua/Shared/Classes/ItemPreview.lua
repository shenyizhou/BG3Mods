
---@class ECItemPreviewData
---@field CountdownHandle integer?
---@field PreviewItemID ITEM?
---@field OriginalEquippedItemID ITEM?
ItemPreview = {}

ItemPreviewManager = {
    PreviewListener = {}
}
function ItemPreviewManager.PreviewItem(characterId, itemId)
    -- Get rid of previous preview items, if any exist, and cancel any existing timers
    -- ItemPreviewManager.ClearPreviewItem(characterId)

    -- Spawn the new preview item
    -- ECDebug("Spawning item %s for %s", itemId, characterId)
    local charId,itemToListenFor
    charId = characterId
    itemToListenFor = itemId
    if ItemPreviewManager.PreviewListener[charId] ~= nil then
        -- TODO already listening for a previewed item, how'd you spam so fast?

    end
    local handle
    handle = Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(objectTemplate, object2, inventoryHolder, addType)
        local templateGuid = Helpers.Format:Guid(objectTemplate)
        if templateGuid == itemToListenFor then
            local item = Ext.Entity.Get(object2)
            -- if item == nil then ECWarn("Something very wrong.") end
            if item.Equipable == nil then
                -- this item isn't equippable, bail
                Osi.RequestDelete(object2)
            else
                ItemPreviewManager.DoItemPreview(itemToListenFor, charId)
            end

            -- cleanup
            Ext.Osiris.UnregisterListener(handle)
            ItemPreviewManager.PreviewListener[charId] = nil
        end
    end)
    ItemPreviewManager.PreviewListener[charId] = handle

    Osi.TemplateAddTo(itemId, characterId, 1, 0)
    Helpers.Timer:OnTicks(6, function()
    end)
end

function ItemPreviewManager.DoItemPreview(itemId, charId)
    local characterId
    characterId = charId
    local item = Helpers.Inventory:GetItemTemplateInInventory(itemId, characterId)

    if item ~= nil then
        local entity = Ext.Entity.Get(characterId)
        if entity == nil then return ECWarn("ItemPreviewManager cannot find given characterId: %s", characterId) end
        -- ECPrint("Character %s is previewing item: %s", Helpers.Loca:GetDisplayName(entity), Helpers.Loca:GetDisplayName(item))

        local itemPreviewVars = entity.Vars[UserVarIDs.ItemPreview] --[[@as ECItemPreviewData]]
        local previewItemInstanceId = Helpers.Object:GetGuid(item)
        -- ECDebug("Instance: %s (%s)", previewItemInstanceId, Helpers.Loca:GetDisplayName(item))

        -- If preview item is for different armor set, make it visible
        ItemPreviewManager.HandleArmorSetSwap(characterId, item)

        -- locate item, if any, equipped to this new preview item's slot
        local previousEquippedItem = Helpers.Inventory:GetEquippedItem(entity, tostring(item.Equipable.Slot))

        -- ECDebug("Equipping %s to %s", Helpers.Loca:GetDisplayName(previewItemInstanceId), Helpers.Loca:GetDisplayName(characterId))
        -- Equip preview item
        Osi.Equip(characterId, previewItemInstanceId, 1, 0, 1)
        -- Set ItemPreviewData on character
        if itemPreviewVars == nil then
            -- first time previewing, hard set
            itemPreviewVars = {
                PreviewItemID = previewItemInstanceId
            }
            if previousEquippedItem ~= nil then
                local guid = Helpers.Object:GetGuid(previousEquippedItem)
                itemPreviewVars.OriginalEquippedItemID = guid
            end
        else
            -- not first time, already have preview data. Clear previous preview and timer, don't erase original item
            ItemPreviewManager.ClearPreviewItem(characterId)
            itemPreviewVars.PreviewItemID = previewItemInstanceId

            -- if we're previewing item of different slot than last time, equip the old item and cleanup
            ItemPreviewManager.HandleIfSlotIsDifferent(characterId, item)

            -- if previousEquippedItem ~= nil then
            --     local guid = Helpers.Object:GetGuid(previousEquippedItem)
            --     itemPreviewVars.OriginalEquippedItemID = guid
            -- end
        end
        -- Set timer to remove preview after 10-30sec
        local handle
        handle = Helpers.Timer:OnTime(15000, function()
            ItemPreviewManager.RestoreOriginalItem(characterId, true)
        end)
        -- Ext.OnNextTick(function()
        --     local e
        --     e = Ext.Entity.Get(characterId)
        --     if e ~= nil and e.Vars[UserVarIDs.ItemPreview] ~= nil then
        --         e.Vars[UserVarIDs.ItemPreview].CountdownHandle = handle -- just stop being nil, fffff upvalues
        --     end
        -- end)
        itemPreviewVars.CountdownHandle = handle -- just stop being nil, fffff upvalues
        
        entity.Vars[UserVarIDs.ItemPreview] = itemPreviewVars -- dirty probably not necessary
    else
        -- return ECWarn("Failed to preview item %s, for %s", itemId, Helpers.Loca:GetDisplayName(entity))
    end
end
function ItemPreviewManager.HandleArmorSetSwap(characterId, item)
    if item.Equipable.Slot == "VanityBody" or item.Equipable.Slot == "VanityBoots" then
        Osi.SetArmourSet(characterId, 1)
    else
        Osi.SetArmourSet(characterId, 0)
    end
end
function ItemPreviewManager.HandleIfSlotIsDifferent(characterId, newPreviewItem)
    local entity
    entity = Ext.Entity.Get(characterId)
    if entity == nil then return ECWarn("ItemPreviewManager cannot find given characterId: %s", characterId) end

    local vars = entity.Vars[UserVarIDs.ItemPreview] --[[@as ECItemPreviewData]]
    -- ECDebug("============")
    if vars ~= nil and vars.OriginalEquippedItemID ~= nil then
        local oldItem = Ext.Entity.Get(vars.OriginalEquippedItemID)
        if oldItem ~= nil then
            -- ECDebug("Old: %s, New: %s", oldItem.Equipable.Slot, newPreviewItem.Equipable.Slot)
            if oldItem.Equipable.Slot ~= newPreviewItem.Equipable.Slot then
                -- slot mismatch, equip old item
                Ext.OnNextTick(function()
                    -- ECPrint("Re-equipping old slot: %s (%s)", Helpers.Loca:GetDisplayName(oldItem), Helpers.Loca:GetDisplayName(characterId))
                    Osi.Equip(characterId, oldItem.Uuid.EntityUuid, 1, 0, 0)
                end)

                -- Store item at new location as original
                local newOriginalItem = Helpers.Inventory:GetEquippedItem(entity, tostring(newPreviewItem.Equipable.Slot))
                if newOriginalItem ~= nil then
                    local guid = Helpers.Object:GetGuid(newOriginalItem)
                    vars.OriginalEquippedItemID = guid
                    entity.Vars[UserVarIDs.ItemPreview] = vars
                end
            else
                -- same slot, good to go
            end
        else
            -- FIXME some closure bullshit happening
            -- ECWarn("Had an old item, but couldn't get it: %s", vars.OriginalEquippedItemID)
        end
    end
end

--- At the end of a preview timer, clears previous item and resets previewData
---@param characterId Guid
---@param finished boolean|nil
function ItemPreviewManager.RestoreOriginalItem(characterId, finished)
    local entity
    entity = Ext.Entity.Get(characterId)
    if entity == nil then return ECWarn("ItemPreviewManager cannot find given characterId: %s", characterId) end

    -- collect involved items
    local previewItem,originalItem
    previewItem,originalItem = ItemPreviewManager.GetPreviewItems(characterId)
    if originalItem ~= nil then
        -- ECDebug("Equipping original item: %s", Helpers.Loca:GetDisplayName(originalItem))
        -- Had an item previously equipped, re-equip
        Osi.Equip(characterId, Helpers.Object:GetGuid(originalItem), 1, 0, 0)
    else
        -- ECDebug("No previous items to equip:")
        -- ECDumpS(entity.Vars[UserVarIDs.ItemPreview])
    end
    ItemPreviewManager.ClearPreviewItem(characterId, previewItem, finished)

    entity.Vars[UserVarIDs.ItemPreview] = nil
end

--- Clears previous previewItem (if any) from entity's inventory and uservars
---@param characterId Guid Character
---@param previewItem EntityHandle|nil preview item entity
---@param finished boolean|nil only true if entity's preview timer is finished
function ItemPreviewManager.ClearPreviewItem(characterId, previewItem, finished)
    local entity
    entity = Ext.Entity.Get(characterId)
    if entity == nil then return ECWarn("ItemPreviewManager cannot find given characterId: %s", characterId) end
    previewItem = previewItem or ItemPreviewManager.GetPreviewItems(characterId)

    if previewItem ~= nil then
        -- Item still exists, request deletion
        Osi.RequestDelete(Helpers.Object:GetGuid(previewItem))
    end
    -- Clear preview data
    local previewData
    previewData = entity.Vars[UserVarIDs.ItemPreview] --[[@as ECItemPreviewData]]
    if previewData and previewData.PreviewItemID ~= nil then
        previewData.PreviewItemID = nil
        if not finished and previewData.CountdownHandle ~= nil then
            pcall(function()
                Ext.Events.Tick:Unsubscribe(previewData.CountdownHandle)
                previewData.CountdownHandle = nil
            end)
        end
    end
end

---Gets ECItemPreviewData entities
---@param characterId Guid Character
---@return EntityHandle|nil PreviewItem
---@return EntityHandle|nil OriginalEquippedItem
function ItemPreviewManager.GetPreviewItems(characterId)
    local entity
    entity = Ext.Entity.Get(characterId)
    if entity == nil then return ECWarn("ItemPreviewManager cannot find given characterId: %s", characterId) end
    if not entity then return ECWarn("ItemPreviewManager was given non-existent entity.") end

    local previewData
    previewData = entity.Vars[UserVarIDs.ItemPreview] --[[@as ECItemPreviewData]]
    if previewData ~= nil then
        -- Previewing something
        local previewItem
        local originalItemID
        local previousItem
        previewItem = Ext.Entity.Get(previewData.PreviewItemID)
        originalItemID = previewData.OriginalEquippedItemID
        -- ECDumpS(previewData)

        if originalItemID ~= nil then
            -- FIXME more closure magic bullshit causing problems
            -- ECDebug("There's definitely previous equipped item data: %s (%s)", Helpers.Loca:GetDisplayName(originalItemID), originalItemID)
            previousItem = Ext.Entity.Get(originalItemID)
            return previewItem,previousItem
        end
        return previewItem
    end
end