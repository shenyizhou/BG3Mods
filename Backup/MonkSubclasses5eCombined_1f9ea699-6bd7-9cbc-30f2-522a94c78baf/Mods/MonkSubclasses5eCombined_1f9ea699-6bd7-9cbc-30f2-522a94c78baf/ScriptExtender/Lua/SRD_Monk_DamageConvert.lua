
---Change Attack Ability to Wisdom
function swapUnarmedModifier(entity, ability)
	local statusEntity = Ext.Entity.Get(entity);
	if(statusEntity.Stats.UnarmedAttackAbility ~= ability) then
		statusEntity.Stats.UnarmedAttackAbility = ability;
		statusEntity:Replicate("Stats")

		if (Debug) then
			Ext.Utils.PrintWarning("Making Unarmed Attacks with ", statusEntity.Stats.UnarmedAttackAbility)
		end

	end
end

local function SetUnarmedDamageType(entity, event)
	local entityUuid = entity.Uuid.EntityUuid
    if Osi.HasActiveStatus(entityUuid, "DRACONIC_STRIKE_ACID") == 1 then
        event.Functor.DamageType = "Acid"
    elseif Osi.HasActiveStatus(entityUuid, "DRACONIC_STRIKE_COLD") == 1 then
        event.Functor.DamageType = "Cold"
    elseif Osi.HasActiveStatus(entityUuid, "DRACONIC_STRIKE_FIRE") == 1 then
        event.Functor.DamageType = "Fire"
    elseif Osi.HasActiveStatus(entityUuid, "DRACONIC_STRIKE_LIGHTNING") == 1 then
        event.Functor.DamageType = "Lightning"
    elseif Osi.HasActiveStatus(entityUuid, "DRACONIC_STRIKE_POISON") == 1 then
        event.Functor.DamageType = "Poison"
	elseif Osi.HasActiveStatus(entityUuid, "USING_ASTRAL_ARMS") == 1 then
        event.Functor.DamageType = "Force"
    end
end

---Change Unarmed Damage type for Special Monk Attacks
Ext.Events.DealDamage:Subscribe(function(e)
    local caster = e.Caster
    local weaponType = e.Functor.WeaponType
    local hasDraconicDisciple = false
	local hasAstralArms = false
	
    if caster ~= nil and caster.Stats ~= nil then 
		local casterUuid = caster.Uuid.EntityUuid
        hasDraconicDisciple = caster.ServerCharacter ~= nil and Osi.HasPassive(casterUuid, "DraconicStrike_AD") == 1 and (Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_ACID") == 1 or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_COLD") == 1 
			or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_FIRE") == 1 or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_LIGHTNING") == 1 or Osi.HasActiveStatus(casterUuid, "DRACONIC_STRIKE_POISON") == 1)
		hasAstralArms = caster.ServerCharacter ~= nil and Osi.HasPassive(casterUuid, "AstralSelfArmsUnlock") == 1 and Osi.HasActiveStatus(casterUuid, "USING_ASTRAL_ARMS") == 1
					
		if (Debug) then
			print('OriginalWeaponType: ', e.Functor.WeaponType)
			print('OriginalSpellDamage: ', e.SpellId.SpellProto.DamageType)
		end
	end

	if e.Hit.ConditionRolls[1] ~= nil then 
		if not hasDraconicDisciple and not hasAstralArms and weaponType == "UnarmedDamage" and e.Hit.ConditionRolls[1].Roll.Roll.RollType == "MeleeUnarmedAttack" then 
			e.Functor.DamageType = e.SpellId.SpellProto.DamageType or "Bludgeoning"
		end
		
		if (hasDraconicDisciple or hasAstralArms) and weaponType == "UnarmedDamage" and e.Hit.ConditionRolls[1].Roll.Roll.RollType == "MeleeUnarmedAttack" then 
			SetUnarmedDamageType(caster, e)
		end
	end
	
end)

--Remove Draconic Strike statuses after levelups where the Passives change, in case they are toggled on when they get removed
Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function(character)
    SRD_DelayedCall(500, function ()
		if Osi.HasActiveStatus(character, "DRACONIC_STRIKE_ACID") ~= 0 and Osi.GetLevel(character) == 11 then 
			Osi.RemoveStatus(character, "DRACONIC_STRIKE_ACID")
		end
		if Osi.HasActiveStatus(character, "DRACONIC_STRIKE_COLD") ~= 0 and Osi.GetLevel(character) == 11 then 
			Osi.RemoveStatus(character, "DRACONIC_STRIKE_COLD")
		end
		if Osi.HasActiveStatus(character, "DRACONIC_STRIKE_FIRE") ~= 0 and Osi.GetLevel(character) == 11 then 
			Osi.RemoveStatus(character, "DRACONIC_STRIKE_FIRE")
		end
		if Osi.HasActiveStatus(character, "DRACONIC_STRIKE_LIGHTNING") ~= 0 and Osi.GetLevel(character) == 11 then 
			Osi.RemoveStatus(character, "DRACONIC_STRIKE_LIGHTNING")
		end
		if Osi.HasActiveStatus(character, "DRACONIC_STRIKE_POISON") ~= 0 and Osi.GetLevel(character) == 11 then 
			Osi.RemoveStatus(character, "DRACONIC_STRIKE_POISON")
		end
    end)
end)

---Check if the Monk's Wisdom is higher and deactivate MonkWeaponAttackOverride
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, _)
	if (status == "USING_ASTRAL_ARMS") and (Osi.GetAbility(object, "Wisdom") > Osi.GetAbility(object, "Strength")) and (Osi.GetAbility(object, "Wisdom") > Osi.GetAbility(object, "Dexterity")) then
		swapUnarmedModifier(object, "Wisdom")
		Osi.ApplyStatus(object, "WISDOM_ATTACK_OVERRIDE", -1)
	end
end)

---Reset back to original Unarmed Ability Modifier and activate MonkWeaponAttackOverride
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, _)
	if (status == "USING_ASTRAL_ARMS") then
		swapUnarmedModifier(object, "Strength")
	end
end)

---Rerun the check on save game load because it gets reset 
Ext.Osiris.RegisterListener("LevelLoaded", 1, "after", function(level)
	for i,v in ipairs(Osi.DB_PartyMembers:Get(nil)) do
		local character = string.sub(v[1],-36)
		if(Osi.HasActiveStatus(character, "USING_ASTRAL_ARMS") == 1) and (Osi.GetAbility(character, "Wisdom") > Osi.GetAbility(character, "Strength")) and (Osi.GetAbility(character, "Wisdom") > Osi.GetAbility(character, "Dexterity")) then
			swapUnarmedModifier(character, "Wisdom")
		end
	end
end)

