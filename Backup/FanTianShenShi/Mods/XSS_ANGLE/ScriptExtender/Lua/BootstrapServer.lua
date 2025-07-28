-- Listener Usingspellontarget  
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function (caster, target, name, _, _, _, _)
    if name == 'XSS_Polymorph_Deva_Player' then
        if IsTagged(target, '890b5a2a-e773-48df-b191-c887d87bec16') == 1 then
            Transform(caster,target,'0b4bbfad-2577-435e-afd0-7d3a254d4ffb')
            Ext.Utils.Print("BEAST")--debug
        else
            Transform(caster,target,'3cf3f400-4c43-4e92-93b0-295dccb7c5b6')
            Ext.Utils.Print("humanoid")--debug
        end
        --AddSpell(caster, 'Target_Polymorph_CANCLE_Deva_Player', 1)
    elseif name == 'XSS_Polymorph_CANCLE_Deva_Player' then
        RemoveTransforms(caster)
        Ext.Utils.Print("XSS_Polymorph_CANCLE_Deva_Player")--debug
    end
end)



-- Listener statsusapplied
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function (Object, Status, Causee, StoryActionID)
    if Status == 'PolymorphDeva_REMOVED'  then 
        RemoveTransforms(Object)
        Ext.Utils.Print("PolymorphDeva_REMOVED")--debug
    elseif Status == 'DevaPlayer_JustMoment_KILL'  then
        UseSpell(Object, 'Shout_DevaPlayer_JustMoment_Attack', Object)
    end
end)

