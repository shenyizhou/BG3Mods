
local entityEdits = {
    ["LearnSpell"] = function(e, host, args)
        if args == nil or args.Spell == nil or args.Spell == "" then return ECWarn("Requested spell learn, but no spell given to learn.") end
        ECPrint("EntityEdit[%s]: Attempting to add spell [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Spell)
        Osi.AddSpell(e, args.Spell, 1, 1)
    end,
    ["RemoveSpell"] = function(e, host, args)
        if args == nil or args.Spell == nil or args.Spell == "" then return ECWarn("Requested spell remove, but no spell given to remove.") end
        ECPrint("EntityEdit[%s]: Attempting to remove spell [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Spell)
        Osi.RemoveSpell(e, args.Spell, 1)
    end,
    ["ChangeSpellModifier"] = function(e, host, args)
        if args == nil or args.Spell == nil or args.Spell == "" then return ECWarn("Requested spell modifier change, but no modifier given to change.") end
        ECPrint("EntityEdit[%s]: Changing spell [%s] spellcasting modifier to %s", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Spell, args.Modifier)
        Helpers.SpellBook:ChangeSpellModifier(e, args.Spell, args.SourceType, args.Modifier)
    end,
    ["AddStatus"] = function(e, host, args)
        if args == nil or args.Status == nil or args.Status == "" then return ECWarn("Requested adding status, but no status given to add.") end
        ECPrint("EntityEdit[%s]: Attempting to add status [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Status)
        Osi.ApplyStatus(e, args.Status, -1) -- TODO allow duration
    end,
    ["RemoveStatus"] = function(e, host, args)
        if args == nil or args.Status == nil or args.Status == "" then return ECWarn("Requested removing status, but no status given to remove.") end
        ECPrint("EntityEdit[%s]: Attempting to remove status [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Status)
        Osi.RemoveStatus(e, args.Status, "")
    end,
    ["AddPassive"] = function(e, host, args)
        if args == nil or args.Passive == nil or args.Passive == "" then return ECWarn("Requested adding passive, but no passive given to add.") end
        ECPrint("EntityEdit[%s]: Attempting to add passive [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Passive)
        Osi.AddPassive(e, args.Passive)
    end,
    ["RemovePassive"] = function(e, host, args)
        if args == nil or args.Passive == nil or args.Passive == "" then return ECWarn("Requested removing passive, but no passive given to remove.") end
        ECPrint("EntityEdit[%s]: Attempting to remove passive [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Passive)
        Osi.RemovePassive(e, args.Passive)
    end,
    ["SetTag"] = function(e, host, args)
        if args == nil or args.Tag == nil or args.Tag == "" then return ECWarn("Requested adding tag, but no tag given to add.") end
        ECPrint("EntityEdit[%s]: Attempting to add tag [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Tag)
        Osi.SetTag(e, args.Tag)
    end,
    ["ClearTag"] = function(e, host, args)
        if args == nil or args.Tag == nil or args.Tag == "" then return ECWarn("Requested removing tag, but no tag given to remove.") end
        ECPrint("EntityEdit[%s]: Attempting to remove tag [%s]", Helpers.Loca:GetDisplayName(e) or "Unknown", args.Tag)
        Osi.ClearTag(e, args.Tag)
    end,
}

Ext.RegisterNetListener(ECChannels.RequestEntityEdit, function(_, payload, user)
    local u = Helpers.Format.PeerToUserID(user)
    local p = Ext.Json.Parse(payload)
    local change = p.Change
    local entityUuid = p.Character
    local a = p.Args
    --ECDebug("Requested Character change [%s] to %s", change, entityUuid)

    local callingCharacter = Osi.GetCurrentCharacter(u) or Osi.GetHostCharacter() -- wow this feels gross
    if callingCharacter == nil then return ECWarn("Couldn't perform character change, no valid entity provided.") end

    if entityEdits[change] then
        entityEdits[change](entityUuid, callingCharacter, a)
    else
        ECWarn("EntityEdit: Invalid change type requested.")
    end
end)