Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, isEditorMode)
    local squadies = Osi.DB_PartOfTheTeam:Get(nil)
    for _,k in pairs(squadies) do
        AddSpell(k[1], "Shout_ActionToBonusAction", 1, 1)
        AddSpell(k[1], "Shout_BonusActionToAction", 1, 1)
        AddSpell(k[1], "Target_Demoralize", 1, 1)
    end
end)
