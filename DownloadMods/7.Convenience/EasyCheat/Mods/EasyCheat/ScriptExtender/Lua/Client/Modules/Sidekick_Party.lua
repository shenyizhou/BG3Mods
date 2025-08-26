local module = {}

--- Responsible for defining a Regenerate() function, in response to party changes
---@param treeParent ExtuiTabItem
function module.GeneratePartyTab(treeParent  )
    local function RegeneratePartyUI(group)
        Imgui.ClearChildren(group)
        local partyTable = group:AddTable("SKPartyTable", 2)
        partyTable.SizingStretchSame = true
        partyTable.NoHostExtendX = true

        local currentRow = partyTable:AddRow()
        local partyMembers = {}
        local currentParty = Helpers.Object:GetCurrentParty()
        if currentParty == nil then return end
    
        for i,v in ipairs(currentParty) do
            if Helpers.Character:IsAvatar(v) or Helpers.Character:IsNonGenericOrigin(v) then
                local e = Ext.Entity.Get(v)
                if e ~= nil and Helpers.Loca:GetDisplayName(e) ~= nil then
                    table.insert(partyMembers, e)
                end
            end
        end
    
        table.sort(partyMembers, function(a,b)
            return Helpers.Loca:GetDisplayName(a) < Helpers.Loca:GetDisplayName(b)
        end)
        -- the old avatar switcharoo
        local avatars = {}
        for i = 1, #partyMembers, 1 do
            if Helpers.Character:IsAvatar(partyMembers[i]) then
                table.insert(avatars, table.remove(partyMembers, i))
            end
        end
        for i = #avatars, 1, -1 do
            table.insert(partyMembers,1,table.remove(avatars,i))
        end
    
        GeneratePartyCell(currentRow:AddCell())
        for i,v in ipairs(partyMembers) do
            GenerateCharacterCell(currentRow:AddCell(), v, false)
        end
    end
    local function RegenerateCampUI(group)
        Imgui.ClearChildren(group)
        local campTable = group:AddTable("SKCampTable", 3)
        campTable.SizingStretchSame = true
        campTable.NoHostExtendX = true

        local currentRow = campTable:AddRow()
        local nonpartyCampMembers = {}
        local sortCount = 1
        for k,v in pairs(Ext.Entity.GetAllEntitiesWithComponent("CampPresence")) do
            if not Helpers.Character:IsPartyMember(v) and Helpers.Character:IsRecruitedOrigin(v) then
                nonpartyCampMembers[sortCount] = v
                sortCount = sortCount + 1
            end
        end
        table.sort(nonpartyCampMembers, function(a,b)
            return Helpers.Loca:GetDisplayName(a) < Helpers.Loca:GetDisplayName(b)
        end)
        for i,v in ipairs(nonpartyCampMembers) do
            GenerateCampCharacterCell(currentRow:AddCell(), v)
        end
    end

    local partyGroup = treeParent:AddGroup("SKPartyUI")
    Imgui.SetChunkySeparator(treeParent:AddSeparatorText(Ext.Loca.GetTranslatedString("h51207ce8968f465393df9d69d6d825d3db9f", "Camp Companions")))
    local campGroup = treeParent:AddGroup("SKCampUI")
    local function Regenerate()
        RegeneratePartyUI(partyGroup)
        RegenerateCampUI(campGroup)
    end
    treeParent.UserData = {
        PartyGroup = partyGroup,
        Regenerate = Regenerate,
    }
    Regenerate()
end

return module