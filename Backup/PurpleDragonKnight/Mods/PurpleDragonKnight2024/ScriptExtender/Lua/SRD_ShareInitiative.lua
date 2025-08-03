
function SRD_ShareInitiative(owner, summon)
	if (Debug) then
		print("SRD_ShareInitiative: " .. owner .. ", " .. summon)
	end
	
	local ownerCombat = Osi.CombatGetGuidFor(owner)
	local summonCombat = Osi.CombatGetGuidFor(summon)
	
	if (Debug) then
		print("SRD_ShareInitiative: CombatGUID: owner " .. (ownerCombat or 'nil') .. " summon " .. (summonCombat or 'nil'))
	end 
	
	if not ownerCombat or ownerCombat ~= summonCombat then
		return
	end

	local ownerEntity = Ext.Entity.Get(owner)
	local summonEntity = Ext.Entity.Get(summon)
	local ownerRoll = ownerEntity.CombatParticipant.InitiativeRoll
	local summonRoll = summonEntity.CombatParticipant.InitiativeRoll
	
	if (Debug) then
		print("SRD_ShareInitiative: Initiative rolls: owner " .. ownerRoll .. " summon " .. summonRoll)
	end
	
	if ownerRoll ~= summonRoll then
		print("Adjusting initiative roll from " .. summonRoll .. " to " .. ownerRoll .. " for " .. summon)
		summonEntity.CombatParticipant.InitiativeRoll = ownerRoll
		summonEntity:Replicate("CombatParticipant")
	end
end
