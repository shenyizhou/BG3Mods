Debug = false

-- Cloud Rune redirect
local cloudruneRedirectAttacker = ""
local cloudruneRedirectSpell = ""
local originalAttackTarget = ""

Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spell, spellType, spellElement, storyActionID)
    if Osi.HasActiveStatus(target, "CLOUD_RUNE_TARGET") == 1 or Osi.HasPassive(target, "CloudRune") == 1 then
        cloudruneRedirectAttacker = caster
        cloudruneRedirectSpell = spell
        originalAttackTarget = target
    end
end)

Ext.Osiris.RegisterListener("ReactionInterruptUsed", 3, "after", function(object, reactionInterruptPrototypeId, isAutoTriggered)
    if reactionInterruptPrototypeId == "Interrupt_InvokeCloudRune" then
        local caster = cloudruneRedirectAttacker
        local spell = cloudruneRedirectSpell
        local target = originalAttackTarget
        local targetTable = {}
		
		if (Debug) then
			_P('-------------------------------------------------------------')
			_P('-- Spell is')
			_D(spell)
			_P('-- Caster is')
			_D(caster)		
			_P('-- Original Target is')
			_D(target)
			_P('\n\n\n')
		end
		
        for _, character in pairs (Ext.Entity.GetAllEntitiesWithComponent("ServerCharacter")) do
            local characterUuid = character.Uuid.EntityUuid
            if Osi.HasActiveStatus(characterUuid, "CLOUD_RUNE_TARGET") == 1 and characterUuid ~= string.sub(target, -36) and characterUuid ~= string.sub(caster, -36) and characterUuid ~= string.sub(object, -36) and Osi.IsAlly(object, characterUuid) ~= 1 then
				
				if (Debug) then
					_P('-------------------------------------------------------------')
					_P('-- Found new taarget')
					_D(characterUuid)
					_P('\n\n\n')
				end
				
				table.insert(targetTable, characterUuid)
            end
        end

        local newTarget = 1 + Osi.Random(#targetTable)
        if targetTable[newTarget] ~= nil then
		
			if (Debug) then
				_P('-------------------------------------------------------------')
				_P('-- New Target is')
				_D(targetTable[newTarget])
				_P('\n\n\n')
			end
			
            RKDelayedCall(1800, function() Osi.UseSpell(caster, spell, targetTable[newTarget])
			end)
			RKDelayedCall(2800, function() Osi.RemoveStatus(caster, "CLOUD_RUNE_SOURCE")
			end)
        end
    end
end)

-- Clear Missing Runes on Levelup
Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function(character)
    RKDelayedCall(500, function ()

		if Osi.IsTagged(character, "b6bf78ce-50fc-474b-8650-ffe54e292fdb") ~= 0 then 
			if Osi.HasActiveStatus(character, "CLOUD_RUNE_UNLOCK") ~= 0 and Osi.HasSpell(character, "Shout_InscribeCloudRune") == 0 then 
				Osi.RemoveStatus(character, "CLOUD_RUNE_UNLOCK")
			end
			if Osi.HasActiveStatus(character, "FIRE_RUNE_UNLOCK") ~= 0 and Osi.HasSpell(character, "Shout_InscribeFireRune") == 0 then 
				Osi.RemoveStatus(character, "FIRE_RUNE_UNLOCK")
			end
			if Osi.HasActiveStatus(character, "FROST_RUNE_UNLOCK") ~= 0 and Osi.HasSpell(character, "Shout_InscribeFrostRune") == 0 then 
				Osi.RemoveStatus(character, "FROST_RUNE_UNLOCK")
			end
			if Osi.HasActiveStatus(character, "STONE_RUNE_UNLOCK") ~= 0 and Osi.HasSpell(character, "Shout_InscribeStoneRune") == 0 then 
				Osi.RemoveStatus(character, "STONE_RUNE_UNLOCK")
			end		
			if Osi.HasActiveStatus(character, "HILL_RUNE_UNLOCK") ~= 0 and Osi.HasSpell(character, "Shout_InscribeHillRune") == 0 then 
				Osi.RemoveStatus(character, "HILL_RUNE_UNLOCK")
			end	
			if Osi.HasActiveStatus(character, "STORM_RUNE_UNLOCK") ~= 0 and Osi.HasSpell(character, "Shout_InscribeStormRune") == 0 then 
				Osi.RemoveStatus(character, "STORM_RUNE_UNLOCK")
			end	
		end
		
    end)
end)

function RKDelayedCall(msDelay, func)
    local startTime = Ext.Utils.MonotonicTime()
    local handlerId;
    handlerId = Ext.Events.Tick:Subscribe(function()
        if (Ext.Utils.MonotonicTime() - startTime > msDelay) then
            Ext.Events.Tick:Unsubscribe(handlerId)
            func()
        end
    end) 
end