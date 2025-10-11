function MCMGet(settingID)
return Mods.BG3MCM.MCMAPI:GetSettingValue(settingID, ModuleUUID)
end

function S5E_Changes()

	local rogueprogression = Ext.StaticData.Get("16f00e7f-12f6-4cff-b610-4ee738b02d62","Progression")
	rogueprogression["PassivesAdded"] = rogueprogression["PassivesAdded"] .. ";S5E_SCAGtrips_SneakAttack"
	local lifeclericprogression = Ext.StaticData.Get("20ce2664-ba58-4291-be05-dca5b2c4293d","Progression")
	lifeclericprogression["PassivesAdded"] = lifeclericprogression["PassivesAdded"] .. ";S5E_SCAGtrips_DivineStrike_Life"
	local natureclericprogression = Ext.StaticData.Get("f5a8a6b4-8514-494d-bbe8-2a0196dc8efa","Progression")
	natureclericprogression["PassivesAdded"] = natureclericprogression["PassivesAdded"] .. ";S5E_SCAGtrips_DivineStrike_Nature"
	local tempestclericprogression = Ext.StaticData.Get("cf1e11e2-5561-49b7-9c6a-83edffcd0f09","Progression")
	tempestclericprogression["PassivesAdded"] = tempestclericprogression["PassivesAdded"] .. ";S5E_SCAGtrips_DivineStrike_Tempest"
	local trickeryclericprogression = Ext.StaticData.Get("f39b339b-e367-403b-b33e-8191eb8363e0","Progression")
	trickeryclericprogression.PassivesAdded = trickeryclericprogression.PassivesAdded .. ";S5E_SCAGtrips_DivineStrike_Trickery"
	local warclericprogression = Ext.StaticData.Get("bb079588-93de-40de-bf1f-2718b1e08512","Progression")
	warclericprogression["PassivesAdded"] = warclericprogression["PassivesAdded"] .. ";S5E_SCAGtrips_DivineStrike_War"
	local deathclericprogression = Ext.StaticData.Get("25d9e305-146b-45cf-947f-d7840f5905fc","Progression")
	if deathclericprogression ~= nil then
		deathclericprogression["PassivesAdded"] = deathclericprogression["PassivesAdded"] .. ";S5E_SCAGtrips_DivineStrike_Death"
	end

	local sneakAttack = Ext.Stats.Get("Interrupt_SneakAttack")
	local sneakAttackCritical = Ext.Stats.Get("Interrupt_SneakAttack_Critical")
	local intdscold = Ext.Stats.Get("Interrupt_DivineStrike_Cold")
	local intdscoldcrit = Ext.Stats.Get("Interrupt_DivineStrike_Cold_Critical")
	local intdsfire = Ext.Stats.Get("Interrupt_DivineStrike_Fire")
	local intdsfirecrit = Ext.Stats.Get("Interrupt_DivineStrike_Fire_Critical")
	local intdslightning = Ext.Stats.Get("Interrupt_DivineStrike_Lightning")
	local intdslightningcrit = Ext.Stats.Get("Interrupt_DivineStrike_Lightning_Critical")
	local intdspoison = Ext.Stats.Get("Interrupt_DivineStrike_Poison")
	local intdspoisoncrit = Ext.Stats.Get("Interrupt_DivineStrike_Poison_Critical")
	local intdsradiant = Ext.Stats.Get("Interrupt_DivineStrike_Radiant")
	local intdsradiantcrit = Ext.Stats.Get("Interrupt_DivineStrike_Radiant_Critical")
	local intdsthunder = Ext.Stats.Get("Interrupt_DivineStrike_Thunder")
	local intdsthundercrit = Ext.Stats.Get("Interrupt_DivineStrike_Thunder_Critical")
	local intdsmelee = Ext.Stats.Get("Interrupt_DivineStrike_MeleeWeapon")
	local intdsmeleecrit = Ext.Stats.Get("Interrupt_DivineStrike_MeleeWeapon_Critical")
	local intdsnecro = Ext.Stats.Get("Interrupt_DivineStrike_Necrotic")
	local intdsnecrocrit = Ext.Stats.Get("Interrupt_DivineStrike_Necrotic_Critical")
	sneakAttack.Conditions = "not SpellId('Target_BoomingBlade_SneakAttack') and not SpellId('Target_GreenFlameBlade_SneakAttack') and " .. sneakAttack.Conditions
	sneakAttackCritical.Conditions = "not SpellId('Target_BoomingBlade_SneakAttack') and not SpellId('Target_GreenFlameBlade_SneakAttack') and " .. sneakAttackCritical.Conditions
	intdscold.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Cold') and not SpellId('Target_GreenFlameBlade_DivineStrike_Cold') and " .. intdscold.Conditions
	intdscoldcrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Cold') and not SpellId('Target_GreenFlameBlade_DivineStrike_Cold') and " .. intdscoldcrit.Conditions
	intdsfire.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Fire') and not SpellId('Target_GreenFlameBlade_DivineStrike_Fire') and " .. intdsfire.Conditions
	intdsfirecrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Fire') and not SpellId('Target_GreenFlameBlade_DivineStrike_Fire') and " .. intdsfirecrit.Conditions
	intdslightning.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Lightning') and not SpellId('Target_GreenFlameBlade_DivineStrike_Lightning') and " .. intdslightning.Conditions
	intdslightningcrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Lightning') and not SpellId('Target_GreenFlameBlade_DivineStrike_Lightning') and " .. intdslightningcrit.Conditions
	intdspoison.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Poison') and not SpellId('Target_GreenFlameBlade_DivineStrike_Poison') and " .. intdspoison.Conditions
	intdspoisoncrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Poison') and not SpellId('Target_GreenFlameBlade_DivineStrike_Poison') and " .. intdspoisoncrit.Conditions
	intdsradiant.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Radiant') and not SpellId('Target_GreenFlameBlade_DivineStrike_Radiant') and " .. intdsradiant.Conditions
	intdsradiantcrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Radiant') and not SpellId('Target_GreenFlameBlade_DivineStrike_Radiant') and " .. intdsradiantcrit.Conditions
	intdsthunder.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Thunder') and not SpellId('Target_GreenFlameBlade_DivineStrike_Thunder') and " .. intdsthunder.Conditions
	intdsthundercrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Thunder') and not SpellId('Target_GreenFlameBlade_DivineStrike_Thunder') and " .. intdsthundercrit.Conditions
	intdsmelee.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_MeleeWeapon') and not SpellId('Target_GreenFlameBlade_DivineStrike_MeleeWeapon') and " .. intdsmelee.Conditions
	intdsmeleecrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_MeleeWeapon') and not SpellId('Target_GreenFlameBlade_DivineStrike_MeleeWeapon') and " .. intdsmeleecrit.Conditions
	intdsnecro.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Necrotic') and not SpellId('Target_GreenFlameBlade_DivineStrike_Necrotic') and " .. intdsmelee.Conditions
	intdsnecrocrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Necrotic') and not SpellId('Target_GreenFlameBlade_DivineStrike_Necrotic') and " .. intdsmeleecrit.Conditions

	local aoo = Ext.Stats.Get("Interrupt_AttackOfOpportunity")
	local pam = Ext.Stats.Get("Interrupt_PolearmMaster")
	local warc = Ext.Stats.Get("Interrupt_WarCaster")
	aoo.Conditions = "(not S5E_IsInvisibleSeen() or EXP_CanSeeInvisible()) and " .. aoo.Conditions
	pam.Conditions = "(not S5E_IsInvisibleSeen() or EXP_CanSeeInvisible()) and " .. pam.Conditions
	warc.Conditions = "(not S5E_IsInvisibleSeen() or EXP_CanSeeInvisible()) and " .. warc.Conditions

	local guidance = Ext.Stats.Get("Target_Guidance")
	local huntersMark = Ext.Stats.Get("Target_HuntersMark")
	local huntersMarkReapply = Ext.Stats.Get("Target_HuntersMark_Reapply")
	local trueStrike = Ext.Stats.Get("Target_TrueStrike")
	guidance.TargetConditions = guidance.TargetConditions .. " and not IsImmuneToStatus('GUIDANCE')"
	huntersMark.TargetConditions = huntersMark.TargetConditions .. " and not IsImmuneToStatus('HUNTERS_MARK')"
	huntersMarkReapply.TargetConditions = huntersMarkReapply.TargetConditions .. " and not IsImmuneToStatus('HUNTERS_MARK')"
	trueStrike.TargetConditions = trueStrike.TargetConditions .. " and not IsImmuneToStatus('TRUE_STRIKE')"

	local potentSpellcasting = Ext.Stats.Get("PotentSpellcasting")
	potentSpellcasting.Boosts = potentSpellcasting.Boosts .. ";IF(SpellId('Target_TollTheDead') or SpellId('Shout_WordOfRadiance')):DamageBonus(max(0, WisdomModifier))"

--[[	for _, name in pairs(Ext.Stats.GetStats("StatusData")) do
		local invisstatus = Ext.Stats.Get(name)
		if invisstatus.StatusType == "INVISIBLE" and string.find(invisstatus.Boosts, "Advantage") and invisstatus.Boosts ~= "IF(not CanSeeInvisible()):Disadvantage(AttackTarget); IF(not CanSeeInvisible(context.Target)):Advantage(AttackRoll);" and invisstatus.Boosts ~= "IF(not CanSeeInvisible()):Disadvantage(AttackTarget); IF(not CanSeeInvisible(context.Target)):Advantage(AttackRoll); Skill(Stealth, 10)" and invisstatus.Boosts ~= "IF(not CanSeeInvisible()):Disadvantage(AttackTarget); IF(not CanSeeInvisible(context.Target)):Advantage(AttackRoll); UnlockSpell(Target_MistyStep_Free)" and invisstatus.Boosts ~= "IF(not CanSeeInvisible()):Disadvantage(AttackTarget); IF(not CanSeeInvisible(context.Target)):Advantage(AttackRoll); Advantage(Skill, Stealth)" then
			invisstatus.Boosts = string.gsub(invisstatus.Boosts, "Advantage", "IF(not EXP_CanSeeInvisible(context.Target) and not IsElusive(context.Target)):Advantage")
			invisstatus.Boosts = invisstatus.Boosts .. ";IF(not EXP_CanSeeInvisible() and not IsElusive()):Disadvantage(AttackTarget)"
		end
	end--]]
	
	local recklessatk = Ext.Stats.Get("Interrupt_RecklessAttack")
	recklessatk.Conditions = recklessatk.Conditions .. " and not IsElusive(context.Target)"

	local mummymatk = Ext.Stats.Get("Target_Multiattack_Mummy")
	mummymatk.TargetConditions = "not Self() and not Dead() and HasStatus('SG_Frightened')"
	local fearray = Ext.Stats.Get("Target_FearRay_Spectator")
	fearray.TargetConditions = "Character() and Enemy() and not HasStatus('SG_Frightened')"
	local aotbhb = Ext.Stats.Get("AspectOfTheBeast_HoneyBadger")
	aotbhb.Conditions = "(HasStatus('SG_Poisoned', context.Source) or HasStatus('SG_Frightened', context.Source) or HasStatus('SG_Charmed', context.Source)) and RollDieAgainstDC(DiceType.d20,10) and not HasStatus('SG_Rage', context.Source)"
	local cloakeratk = Ext.Stats.Get("Target_Multiattack_Cloaker")
	cloakeratk.TargetConditions = "not Self() and not Dead() and HasStatus('SG_Frightened',context.Target)"
	local oskarscon = Ext.Stats.Get("Shout_LOW_OskarsBeloved_Visage_Confusion")
	oskarscon.TargetConditions = "not Self() and not Dead() and not Item() and not Tagged('UNDEAD') and Enemy() and not Tagged('OSKARSBELOVED_IMMUNITY') and not HasStatus('CONFUSION') and not HasStatus('SG_Frightened')"
	local oskarspos = Ext.Stats.Get("Target_LOW_OskarsBeloved_Possession")
	oskarspos.TargetConditions = "Character() and Enemy() and not Dead() and not HasStatus('SG_Frightened') and not HasStatus('CONFUSION') and not Tagged('OSKARSBELOVED_IMMUNITY') and not HasStatus('LOW_OSKARSBELOVED_UNNERVED')"
	local oskarsmummyatk = Ext.Stats.Get("Target_LOW_OskarsBeloved_Mummy_Multiattack")
	oskarsmummyatk.TargetConditions = "not Self() and not Dead() and HasStatus('SG_Frightened') and not Tagged('OSKARSBELOVED_IMMUNITY')"
	local oskarsmummyglare = Ext.Stats.Get("Target_LOW_OskarsBeloved_Mummy_Glare")
	oskarsmummyglare.TargetConditions = "Character() and IsCrowdControlled(context.Target) and not Tagged('OSKARSBELOVED_IMMUNITY') and not HasStatus('CONFUSION') and not HasStatus('SG_Frightened')"
	local hogdark = Ext.Stats.Get("Target_LOW_HouseOfGrief_ExploitFear_Darkness")
	hogdark.TargetConditions = "Tagged('ACT3_LOW_HOUSEOFGRIEF_VICTIM') and not HasStatus('SG_Frightened') and not Dead() and not HasStatus('CONTAGION_BLINDING_SICKNESS_3')"
	local hogdisease = Ext.Stats.Get("Target_LOW_HouseOfGrief_ExploitFear_Disease")
	hogdisease.TargetConditions = "Tagged('ACT3_LOW_HOUSEOFGRIEF_VICTIM') and not HasStatus('SG_Frightened') and not Dead() and not HasStatus('CONTAGION_FLESH_ROT_3')"
	local hogpowerless = Ext.Stats.Get("Target_LOW_HouseOfGrief_ExploitFear_Powerless")
	hogpowerless.TargetConditions = "Tagged('ACT3_LOW_HOUSEOFGRIEF_VICTIM') and not HasStatus('SG_Frightened') and not Dead() and not HasStatus('RAY_OF_ENFEEBLEMENT')"
	local hogbetray = Ext.Stats.Get("Target_LOW_HouseOfGrief_ExploitFear_Betrayal")
	hogbetray.AoEConditions = "Tagged('ACT3_LOW_HOUSEOFGRIEF_VICTIM') and not Dead() and not HasStatus('SG_Frightened')"
	local hogwolf = Ext.Stats.Get("Target_LOW_HouseOfGrief_ExploitFear_Wolf_2")
	hogwolf.TargetConditions = "Tagged('SHADOWHEART') and not HasStatus('SG_Frightened')"
	local hogspider = Ext.Stats.Get("Target_LOW_HouseOfGrief_ExploitFear_Spider_2")
	hogspider.TargetConditions = "Tagged('ACT3_LOW_HOUSEOFGRIEF_VICTIM') and not HasStatus('SG_Frightened')"

	local elementalaffinity = Ext.Stats.Get("ELEMENTALAFFINITY_FIRE_EXTRA_DAMAGE_TECHNICAL")
    local elementalgish = Ext.Stats.Get("MAG_ElementalGish_CantripBooster_Amulet_Passive")
    local charismacaster = Ext.Stats.Get("MAG_CharismaCaster_CantripBooster_Passive")
	local elementalinfusion = Ext.Stats.Get("MAG_ElementalGish_ElementalInfusion_Ring")
	local revgloves = Ext.Stats.Get("MAG_Thunder_Reverberation_Gloves_Passive")
	if string.find(elementalaffinity.Boosts, "IsSpell%(%) and IsDamageTypeFire%(%)") then
		elementalaffinity.Boosts = string.gsub(elementalaffinity.Boosts, "IsSpell%(%) and IsDamageTypeFire%(%)", "IsSpell() and IsDamageTypeFire() and not IsWeaponAttack()")
	end
    elementalaffinity.Boosts = elementalaffinity.Boosts .. ";IF(SpellDamageTypeIs(DamageType.Fire) and (SpellId('Target_GreenFlameBlade') or SpellId('Target_GreenFlameBlade_Default') or SpellId('Target_GreenFlameBlade_SneakAttack') or SpellId('Target_GreenFlameBlade_DivineStrike_Radiant') or SpellId('Target_GreenFlameBlade_DivineStrike_Cold') or SpellId('Target_GreenFlameBlade_DivineStrike_Fire') or SpellId('Target_GreenFlameBlade_DivineStrike_Lightning') or SpellId('Target_GreenFlameBlade_DivineStrike_Thunder') or SpellId('Target_GreenFlameBlade_DivineStrike_Poison') or SpellId('Target_GreenFlameBlade_DivineStrike_MeleeWeapon') or SpellId('Target_GreenFlameBlade_DivineStrike_Necrotic') or SpellId('Target_GreenFlameBlade_DivineStrike_Psychic')) and CharacterLevelGreaterThan(4)):CharacterWeaponDamage(max(0, CharismaModifier),Fire)"
	if string.find(elementalgish.Boosts, "IsCantrip%(%)") then
		elementalgish.Boosts = string.gsub(elementalgish.Boosts, "IsCantrip%(%)", "IsCantrip() and not IsWeaponAttack()")
	end
    elementalgish.Boosts = elementalgish.Boosts .. ";IF((SpellId('Target_GreenFlameBlade_Default') or SpellId('Target_GreenFlameBlade_SneakAttack') or SpellId('Target_GreenFlameBlade_DivineStrike_Radiant') or SpellId('Target_GreenFlameBlade_DivineStrike_Cold') or SpellId('Target_GreenFlameBlade_DivineStrike_Fire') or SpellId('Target_GreenFlameBlade_DivineStrike_Lightning') or SpellId('Target_GreenFlameBlade_DivineStrike_Thunder') or SpellId('Target_GreenFlameBlade_DivineStrike_Poison') or SpellId('Target_GreenFlameBlade_DivineStrike_MeleeWeapon') or SpellId('Target_GreenFlameBlade_DivineStrike_Necrotic') or SpellId('Target_GreenFlameBlade_DivineStrike_Psychic')) and CharacterLevelGreaterThan(4)):CharacterWeaponDamage(max(1, SpellCastingAbilityModifier),Fire);IF((SpellId('Target_BoomingBlade_Default') or SpellId('Target_BoomingBlade_SneakAttack') or SpellId('Target_BoomingBlade_DivineStrike_Radiant') or SpellId('Target_BoomingBlade_DivineStrike_Cold') or SpellId('Target_BoomingBlade_DivineStrike_Fire') or SpellId('Target_BoomingBlade_DivineStrike_Lightning') or SpellId('Target_BoomingBlade_DivineStrike_Thunder') or SpellId('Target_BoomingBlade_DivineStrike_Poison') or SpellId('Target_BoomingBlade_DivineStrike_MeleeWeapon') or SpellId('Target_BoomingBlade_DivineStrike_Necrotic') or SpellId('Target_BoomingBlade_DivineStrike_Psychic')) and CharacterLevelGreaterThan(4)):CharacterWeaponDamage(max(1, SpellCastingAbilityModifier),Thunder)"
	if string.find(charismacaster.Boosts, "IsCantrip%(%)") then
		charismacaster.Boosts = string.gsub(charismacaster.Boosts, "IsCantrip%(%)", "IsCantrip() and not IsWeaponAttack()")
	end
    charismacaster.Boosts = charismacaster.Boosts .. ";IF((SpellId('Target_GreenFlameBlade_Default') or SpellId('Target_GreenFlameBlade_SneakAttack') or SpellId('Target_GreenFlameBlade_DivineStrike_Radiant') or SpellId('Target_GreenFlameBlade_DivineStrike_Cold') or SpellId('Target_GreenFlameBlade_DivineStrike_Fire') or SpellId('Target_GreenFlameBlade_DivineStrike_Lightning') or SpellId('Target_GreenFlameBlade_DivineStrike_Thunder') or SpellId('Target_GreenFlameBlade_DivineStrike_Poison') or SpellId('Target_GreenFlameBlade_DivineStrike_MeleeWeapon') or SpellId('Target_GreenFlameBlade_DivineStrike_Necrotic') or SpellId('Target_GreenFlameBlade_DivineStrike_Psychic')) and CharacterLevelGreaterThan(4)):CharacterWeaponDamage(max(1, CharismaModifier),Fire);IF((SpellId('Target_BoomingBlade_Default') or SpellId('Target_BoomingBlade_SneakAttack') or SpellId('Target_BoomingBlade_DivineStrike_Radiant') or SpellId('Target_BoomingBlade_DivineStrike_Cold') or SpellId('Target_BoomingBlade_DivineStrike_Fire') or SpellId('Target_BoomingBlade_DivineStrike_Lightning') or SpellId('Target_BoomingBlade_DivineStrike_Thunder') or SpellId('Target_BoomingBlade_DivineStrike_Poison') or SpellId('Target_BoomingBlade_DivineStrike_MeleeWeapon') or SpellId('Target_BoomingBlade_DivineStrike_Necrotic') or SpellId('Target_BoomingBlade_DivineStrike_Psychic')) and CharacterLevelGreaterThan(4)):CharacterWeaponDamage(max(1, CharismaModifier),Thunder)"
    elementalinfusion.PassivesOnEquip = elementalinfusion.PassivesOnEquip .. ";S5E_ElementalGish_ElementalInfusion_Ring_Passive"
	revgloves.Conditions = revgloves.Conditions .. " or ((SpellId('Target_BoomingBlade_Default') or SpellId('Target_BoomingBlade_SneakAttack') or SpellId('Target_BoomingBlade_DivineStrike_Radiant') or SpellId('Target_BoomingBlade_DivineStrike_Cold') or SpellId('Target_BoomingBlade_DivineStrike_Fire') or SpellId('Target_BoomingBlade_DivineStrike_Lightning') or SpellId('Target_BoomingBlade_DivineStrike_Thunder') or SpellId('Target_BoomingBlade_DivineStrike_Poison') or SpellId('Target_BoomingBlade_DivineStrike_MeleeWeapon') or SpellId('Target_BoomingBlade_DivineStrike_Necrotic') or SpellId('Target_BoomingBlade_DivineStrike_Psychic')) and CharacterLevelGreaterThan(4))"

	local mhnp = Ext.Stats.Get("MAG_Heightened_Necromancy_Passive")
	if string.find(mhnp.Boosts, "HeightenedNecromancySpellCheck%(%)") then
		mhnp.Boosts = string.gsub(mhnp.Boosts, "HeightenedNecromancySpellCheck%(%)", "HeightenedNecromancySpellCheck() | HasStringInSpellRoll('SpellAutoResolveOnUndead')")
	end

-- SRD's Cleric Subclasses

	if Ext.Mod.IsModLoaded("a6474f89-8efc-443d-cc95-9cdf142f931e") then
		local dstwilightpassive = Ext.Stats.Get("Divine_Strike_Twilight_Toggle")
		dstwilightpassive.Boosts = dstwilightpassive.Boosts .. ";UnlockSpell(Target_BoomingBlade_DivineStrike_Radiant);UnlockSpell(Target_GreenFlameBlade_DivineStrike_Radiant)"
		local dsorderpassive = Ext.Stats.Get("Divine_Strike_Order_Toggle")
		dsorderpassive.Boosts = dsorderpassive.Boosts .. ";UnlockSpell(Target_BoomingBlade_DivineStrike_Psychic);UnlockSpell(Target_GreenFlameBlade_DivineStrike_Psychic)"
		local intsrddsradiant = Ext.Stats.Get("Interrupt_SRD_DivineStrike_Radiant")
		local intsrddsradiantcrit = Ext.Stats.Get("Interrupt_SRD_DivineStrike_Radiant_Critical")
		intsrddsradiant.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Radiant') and not SpellId('Target_GreenFlameBlade_DivineStrike_Radiant') and " .. intsrddsradiant.Conditions
		intsrddsradiantcrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Radiant') and not SpellId('Target_GreenFlameBlade_DivineStrike_Radiant') and " .. intsrddsradiantcrit.Conditions
		local intsrddspsychic = Ext.Stats.Get("Interrupt_SRD_DivineStrike_Psychic")
		local intsrddspsychiccrit = Ext.Stats.Get("Interrupt_SRD_DivineStrike_Psychic_Critical")
		intsrddspsychic.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Psychic') and not SpellId('Target_GreenFlameBlade_DivineStrike_Psychic') and " .. intsrddspsychic.Conditions
		intsrddspsychiccrit.Conditions = "not SpellId('Target_BoomingBlade_DivineStrike_Psychic') and not SpellId('Target_GreenFlameBlade_DivineStrike_Psychic') and " .. intsrddspsychiccrit.Conditions
	end

--[[   for _, name in pairs(Ext.Stats.GetStats("SpellData")) do
        local spell = Ext.Stats.Get(name)
		if spell.SpellType == "Target" and (spell.TargetRadius == "MeleeMainWeaponRange" or spell.TargetRadius == "1.5") then
			spell.TargetConditions = spell.TargetConditions .. " and not HasStatus('LEVITATE_PSION')"
		end
	end--]]
end

function S5E_SpareTheDying()
	local helpact = Ext.Stats.Get("Target_Help")
	helpact:SetRawAttribute("SpellProperties","RemoveStatus(SG_Helpable_Condition);RemoveStatus(BURNING);RemoveStatus(SG_Prone);RemoveStatus(SG_Restrained);RemoveStatus(PRONE);RemoveStatus(SLEEPING);RemoveStatus(SLEEP);RemoveStatus(ENSNARING_STRIKE);RemoveStatus(WEB);RemoveStatus(HYPNOTIC_PATTERN)")
	helpact:SetRawAttribute("SpellSuccess","IF(IsDowned()):ApplyStatus(S5E_STABILIZED,100,-1)")
	helpact.SpellRoll = "not IsDowned() or SkillCheck(Skill.Medicine,10)"
	helpact:Sync()
end

function S5E_SpareTheDyingRevert()
	if Ext.Mod.IsModLoaded("f19c68ed-70be-4c3d-b610-e94afc5c5103") then
		local helpact = Ext.Stats.Get("Target_Help")
		helpact:SetRawAttribute("SpellProperties","RemoveStatus(SG_Helpable_Condition);RemoveStatus(BURNING);RemoveStatus(SG_Prone);RemoveStatus(SG_Restrained);RemoveStatus(PRONE);RemoveStatus(SLEEPING);RemoveStatus(SLEEP);RemoveStatus(ENSNARING_STRIKE);RemoveStatus(WEB);RemoveStatus(HYPNOTIC_PATTERN)")
		helpact:SetRawAttribute("SpellSuccess","IF(IsDowned()):ApplyStatus(S5E_STABILIZED,100,-1)")
		helpact.SpellRoll = "not IsDowned() or SkillCheck(Skill.Medicine,10)"
		helpact:Sync()
	else
		local helpact = Ext.Stats.Get("Target_Help")
		helpact:SetRawAttribute("SpellProperties","RemoveStatus(SG_Sleeping);RemoveStatus(SG_Helpable_Condition);RemoveStatus(BURNING);RemoveStatus(SG_Prone);RemoveStatus(SG_Restrained);RemoveStatus(PRONE);RemoveStatus(SLEEPING);RemoveStatus(SLEEP);RemoveStatus(ENSNARING_STRIKE);RemoveStatus(WEB);IF(IsDowned()):RegainHitPoints(1);RemoveStatus(HYPNOTIC_PATTERN)")
		helpact:SetRawAttribute("SpellSuccess","")
		helpact.SpellRoll = ""
		helpact:Sync()
	end
end

function S5E_RaiseDead()
	local revivify = Ext.Stats.Get("Teleportation_Revivify")
	revivify.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivify.OriginTargetConditions
	revivify.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"
	local revivify4 = Ext.Stats.Get("Teleportation_Revivify_4")
	revivify4.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivify4.OriginTargetConditions
	revivify4.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"
	local revivify5 = Ext.Stats.Get("Teleportation_Revivify_5")
	revivify5.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivify5.OriginTargetConditions
	revivify5.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"
	local revivify6 = Ext.Stats.Get("Teleportation_Revivify_6")
	revivify6.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivify6.OriginTargetConditions
	revivify6.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"
	local revivifyscroll = Ext.Stats.Get("Teleportation_Revivify_Scroll")
	revivifyscroll.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivifyscroll.OriginTargetConditions
	revivifyscroll.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"

	Ext.Loca.UpdateTranslatedString("h2d014c36g7457g49f8ga0d5g748fb44cb940","Casting Revivify or Raise Dead can bring the creature back to life but Revivify can't if it has been dead for at least 10 turns.")

	local dst = Ext.Stats.Get("DeathSavingThrows")
	dst.Conditions = "StatusId('DYING')"
--	dst:SetRawAttribute("StatsFunctors", "IF(not HasAnyStatus({'DEAD_TECHNICAL_REMOVAL_STATUS','DEAD_TECHNICAL_REMOVAL_STATUS_2','DEAD_TECHNICAL_REMOVAL_STATUS_3','DEAD_TECHNICAL_REMOVAL_STATUS_4','DEAD_TECHNICAL_REMOVAL_STATUS_5','DEAD_TECHNICAL_REMOVAL_STATUS_6','DEAD_TECHNICAL_REMOVAL_STATUS_7','DEAD_TECHNICAL_REMOVAL_STATUS_8','DEAD_TECHNICAL_REMOVAL_STATUS_9','DEAD_TECHNICAL_REMOVAL_STATUS_10'},{},{},context.Source)):ApplyStatus(DEAD_TECHNICAL,100,10);IF(HasAnyStatus({'DEAD_TECHNICAL_REMOVAL_STATUS','DEAD_TECHNICAL_REMOVAL_STATUS_2','DEAD_TECHNICAL_REMOVAL_STATUS_3','DEAD_TECHNICAL_REMOVAL_STATUS_4','DEAD_TECHNICAL_REMOVAL_STATUS_5','DEAD_TECHNICAL_REMOVAL_STATUS_6','DEAD_TECHNICAL_REMOVAL_STATUS_7','DEAD_TECHNICAL_REMOVAL_STATUS_8','DEAD_TECHNICAL_REMOVAL_STATUS_9','DEAD_TECHNICAL_REMOVAL_STATUS_10'},{},{},context.Source)):ApplyStatus(DEAD_TECHNICAL_SECOND,100,10)")
	dst:SetRawAttribute("StatsFunctors", "IF(not HasAnyStatus({'DEAD_TECHNICAL_REMOVAL_STATUS','DEAD_TECHNICAL_REMOVAL_STATUS_2','DEAD_TECHNICAL_REMOVAL_STATUS_3','DEAD_TECHNICAL_REMOVAL_STATUS_4','DEAD_TECHNICAL_REMOVAL_STATUS_5','DEAD_TECHNICAL_REMOVAL_STATUS_6','DEAD_TECHNICAL_REMOVAL_STATUS_7','DEAD_TECHNICAL_REMOVAL_STATUS_8','DEAD_TECHNICAL_REMOVAL_STATUS_9','DEAD_TECHNICAL_REMOVAL_STATUS_10'},{},{},context.Source)):ApplyStatus(DEAD_TECHNICAL,100,10)")
	local flags = dst.StatsFunctorContext
	table.insert(flags, "OnStatusApplied")
	dst.StatsFunctorContext = flags

	if Ext.Mod.IsModLoaded("a2c4b0fc-e745-41df-81b7-fa53950d86a0") then
	local revivify7 = Ext.Stats.Get("Teleportation_Revivify_7")
	revivify7.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivify7.OriginTargetConditions
	revivify7.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"
	local revivify8 = Ext.Stats.Get("Teleportation_Revivify_8")
	revivify8.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivify8.OriginTargetConditions
	revivify8.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"
	local revivify9 = Ext.Stats.Get("Teleportation_Revivify_9")
	revivify9.OriginTargetConditions = "NotDeadLongerThanAMinute() and " .. revivify9.OriginTargetConditions
	revivify9.TooltipPermanentWarnings = "827eba69-f29d-4365-802a-2effbc26a6f8;1"
	else
		return
	end

	for _, name in pairs(Ext.Stats.GetStats("Character")) do
		local char = Ext.Stats.Get(name)
		if char ~= nil and string.find(char.Passives, "WeaponThrow") and string.find(char.Passives, "CombatStartAttack") then
			char.Passives = "S5E_NoInstantDeath;" .. char.Passives
		end
	end
end

function S5E_RaiseDeadRevert()
	local revivify = Ext.Stats.Get("Teleportation_Revivify")
	revivify.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivify.TooltipPermanentWarnings = ""
	local revivify4 = Ext.Stats.Get("Teleportation_Revivify_4")
	revivify4.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivify4.TooltipPermanentWarnings = ""
	local revivify5 = Ext.Stats.Get("Teleportation_Revivify_5")
	revivify5.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivify5.TooltipPermanentWarnings = ""
	local revivify6 = Ext.Stats.Get("Teleportation_Revivify_6")
	revivify6.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivify6.TooltipPermanentWarnings = ""
	local revivifyscroll = Ext.Stats.Get("Teleportation_Revivify_Scroll")
	revivifyscroll.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivifyscroll.TooltipPermanentWarnings = ""

	Ext.Loca.UpdateTranslatedString("h2d014c36g7457g49f8ga0d5g748fb44cb940","Casting Revivify can bring it back to life.")

	local dst = Ext.Stats.Get("DeathSavingThrows")
	dst.Conditions = ""
	dst:SetRawAttribute("StatsFunctors", "")

	if Ext.Mod.IsModLoaded("a2c4b0fc-e745-41df-81b7-fa53950d86a0") then
	local revivify7 = Ext.Stats.Get("Teleportation_Revivify_7")
	revivify7.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivify7.TooltipPermanentWarnings = ""
	local revivify8 = Ext.Stats.Get("Teleportation_Revivify_8")
	revivify8.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivify8.TooltipPermanentWarnings = ""
	local revivify9 = Ext.Stats.Get("Teleportation_Revivify_9")
	revivify9.OriginTargetConditions = "not Tagged('BLOCK_RESURRECTION') and not Self() and not Item() and (Dead() or IsDowned() or HasStatus('PETRIFIED')) and Tagged('PLAYABLE')"
	revivify9.TooltipPermanentWarnings = ""
	else
		return
	end
end

Spells = {  
	SpellList = "Spells",
}

local spellSniper = {
  "Target_BoomingBlade_5e",
  "Target_GreenFlameBlade",
  "Target_PrimalSavagery"
}
local ritualCaster = {
  "Target_Ceremony_Ritual",
  "Shout_DetectMagic_Ritual",
  "Target_UnseenServant_Ritual"
}
local bardCantrips = {
  "Target_Prestidigitation",
  "Shout_Thunderclap"
}
local bardSpells1stTCoE = {
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells1stOther = {
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells2ndTCoE = {
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells2ndOther = {
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells3rdTCoE = {
	"Shout_HealingWord_Mass",
	"Target_Slow",
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells3rdOther = {
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MotivationalSpeech",
	"Target_Nondetection",
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells4thTCoE = {
	"Target_PhantasmalKiller",
	"Shout_HealingWord_Mass",
	"Target_Slow",
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells4thOther = {
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MotivationalSpeech",
	"Target_Nondetection",
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells5thTCoE = {
	"Target_PhantasmalKiller",
	"Shout_HealingWord_Mass",
	"Target_Slow",
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells5thOther = {
	"Target_Mislead",
	"Target_RaiseDead",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MotivationalSpeech",
	"Target_Nondetection",
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells6thTCoE = {
	"Shout_HeroesFeast",
	"Target_PhantasmalKiller",
	"Shout_HealingWord_Mass",
	"Target_Slow",
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells6thOther = {
	"Target_TrueSeeing",
	"Target_Mislead",
	"Target_RaiseDead",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MotivationalSpeech",
	"Target_Nondetection",
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells7thTCoE = {
	"Shout_HeroesFeast",
	"Target_PhantasmalKiller",
	"Shout_HealingWord_Mass",
	"Target_Slow",
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells7thOther = {
	"Target_Regenerate",
	"Target_TrueSeeing",
	"Target_Mislead",
	"Target_RaiseDead",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MotivationalSpeech",
	"Target_Nondetection",
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells8thTCoE = {
	"Shout_HeroesFeast",
	"Target_PhantasmalKiller",
	"Shout_HealingWord_Mass",
	"Target_Slow",
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells8thOther = {
	"Target_DominateMonster",
	"Target_Feeblemind",
	"Target_MindBlank",
	"Target_Regenerate",
	"Target_TrueSeeing",
	"Target_Mislead",
	"Target_RaiseDead",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MotivationalSpeech",
	"Target_Nondetection",
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardSpells9thTCoE = {
	"Shout_HeroesFeast",
	"Target_PhantasmalKiller",
	"Shout_HealingWord_Mass",
	"Target_Slow",
	"Shout_Aid",
	"Target_EnlargeReduce",
	"Target_Knock",
	"Shout_MirrorImage",
	"Zone_ColorSpray",
	"Target_Command_Container"
}
local bardSpells9thOther = {
	"Target_Foresight",
	"Target_PowerWordHeal",
	"Target_PowerWordKill",
	"Target_DominateMonster",
	"Target_Feeblemind",
	"Target_MindBlank",
	"Target_Regenerate",
	"Target_TrueSeeing",
	"Target_Mislead",
	"Target_RaiseDead",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MotivationalSpeech",
	"Target_Nondetection",
	"Shout_BorrowedKnowledge",
	"Shout_KineticJaunt",
	"Target_NathairsMischief",
	"Shout_WardingWind",
	"Target_ZoneofTruth",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_UnseenServant"
}
local bardMagicalSecrets3rdTCoE = {
	"Shout_BeaconOfHope",
	"Target_BestowCurse",
	"Target_Smite_Blinding",
	"Shout_Blink",
	"Zone_ConjureBarrage",
	"Shout_CrusadersMantle",
	"Target_ElementalWeapon",
	"Zone_Fear",
	"Target_FeignDeath",
	"Target_GlyphOfWarding",
	"Target_HungerOfHadar",
	"Target_HypnoticPattern",
	"Projectile_LightningArrow",
	"Target_PlantGrowth",
	"Target_ProtectionFromEnergy",
	"Target_SpeakWithDead",
	"Target_StinkingCloud",
	"Target_VampiricTouch",
	"Projectile_AcidArrow",
	"Shout_Aid",
	"Target_Barkskin",
	"Target_Blindness",
	"Target_Smite_Branding_Container",
	"Target_CalmEmotions",
	"Target_CloudOfDaggers",
	"Target_CrownOfMadness",
	"Shout_DetectThoughts",
	"Target_EnhanceAbility",
	"Target_EnlargeReduce",
	"Target_Enthrall",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Zone_GustOfWind",
	"Target_HeatMetal",
	"Target_HoldPerson",
	"Target_Invisibility",
	"Target_Knock",
	"Target_LesserRestoration",
	"Target_MagicWeapon",
	"Shout_MirrorImage",
	"Target_Moonbeam",
	"Target_PhantasmalForce",
	"Shout_PrayerOfHealing",
	"Target_ProtectionFromPoison",
	"Shout_SeeInvisibility",
	"Target_Shatter",
	"Target_Silence",
	"Target_WardingBond",
	"Target_AnimalFriendship",
	"Shout_ArmsOfHadar",
	"Target_Bane",
	"Zone_BurningHands",
	"Target_CharmPerson",
	"Zone_ColorSpray",
	"Target_CreateDestroyWater",
	"Target_CureWounds",
	"Shout_DisguiseSelf",
	"Target_DissonantWhispers",
	"Projectile_EnsnaringStrike_Container",
	"Shout_ExpeditiousRetreat",
	"Target_FaerieFire",
	"Shout_FeatherFall",
	"Target_FindFamiliar",
	"Target_FogCloud",
	"Target_Goodberry",
	"Target_Grease",
	"Projectile_HailOfThorns",
	"Target_HealingWord",
	"Target_Heroism",
	"Target_HideousLaughter",
	"Target_HuntersMark",
	"Target_InflictWounds",
	"Target_Jump",
	"Target_Longstrider",
	"Target_MageArmor",
	"Target_ProtectionFromEvilAndGood",
	"Projectile_RayOfSickness",
	"Shout_Shield_Sorcerer",
	"Target_ShieldOfFaith",
	"Target_Sleep",
	"Target_Smite_Searing",
	"Target_Smite_Wrathful",
	"Shout_SpeakWithAnimals",
	"Zone_Thunderwave",
	"Projectile_WitchBolt",
	"Projectile_AcidSplash",
	"Shout_BladeWard",
	"Target_ChillTouch",
	"Target_DancingLights",
	"Target_Friends",
	"Target_Guidance",
	"Target_Light",
	"Target_MageHand",
	"Target_MinorIllusion",
	"Projectile_PoisonSpray",
	"Shout_ProduceFlame",
	"Target_Resistance",
	"Shout_Shillelagh",
	"Target_ShockingGrasp",
	"Shout_Thaumaturgy",
	"Target_ThornWhip",
	"Target_TrueStrike"
}
local bardMagicalSecrets3rdOther = {
	"Target_Antagonize",
	"Target_CreateFoodAndWater",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Target_HealingSpirit",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Target_WitherAndBloom",
	"Target_ZoneofTruth",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Target_Ceremony",
	"Target_ChaosBolt",
	"Shout_DetectEvilAndGood",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Shout_ZephyrStrike",
	"Target_BoomingBlade_5e",
	"Target_ControlFlames",
	"Target_CreateBonfire",
	"Shout_Druidcraft",
	"Target_Frostbite",
	"Target_GreenFlameBlade",
	"Target_Gust",
	"Target_Infestation",
	"Target_LightningLure",
	"Target_MagicStone",
	"Target_MindSliver",
	"Target_MoldEarth",
	"Target_Prestidigitation",
	"Target_ShapeWater",
	"Target_SpareTheDying",
	"Shout_SwordBurst",
	"Shout_Thunderclap",
	"Shout_WordOfRadiance"
}
local bardMagicalSecrets5thTCoE = {
	"Target_Cloudkill",
	"Shout_DestructiveWave",
	"Target_DominatePerson",
	"Target_FlameStrike",
	"Target_GreaterRestoration",
	"Target_HoldMonster",
	"Target_InsectPlague",
	"Target_CureWounds_Mass",
	"Target_PlanarBinding",
	"Target_Seeming",
	"Throw_Telekinesis",
	"Target_Confusion",
	"Target_ConjureElementals_Minor_Container",
	"Target_ConjureWoodlandBeings",
	"Teleportation_DimensionDoor",
	"Target_BlackTentacles",
	"Target_FreedomOfMovement",
	"Target_GraspingVine",
	"Target_Invisibility_Greater",
	"Target_PhantasmalKiller",
	"Target_Polymorph",
	"Target_ResilientSphere",
	"Target_Stoneskin",
	"Shout_BeaconOfHope",
	"Target_BestowCurse",
	"Target_Smite_Blinding",
	"Shout_Blink",
	"Zone_ConjureBarrage",
	"Shout_CrusadersMantle",
	"Target_ElementalWeapon",
	"Zone_Fear",
	"Target_FeignDeath",
	"Target_GlyphOfWarding",
	"Target_HungerOfHadar",
	"Target_HypnoticPattern",
	"Projectile_LightningArrow",
	"Target_PlantGrowth",
	"Target_ProtectionFromEnergy",
	"Target_SpeakWithDead",
	"Target_StinkingCloud",
	"Target_VampiricTouch",
	"Projectile_AcidArrow",
	"Shout_Aid",
	"Target_Barkskin",
	"Target_Blindness",
	"Target_Smite_Branding_Container",
	"Target_CalmEmotions",
	"Target_CloudOfDaggers",
	"Target_CrownOfMadness",
	"Shout_DetectThoughts",
	"Target_EnhanceAbility",
	"Target_EnlargeReduce",
	"Target_Enthrall",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Zone_GustOfWind",
	"Target_HeatMetal",
	"Target_HoldPerson",
	"Target_Invisibility",
	"Target_Knock",
	"Target_LesserRestoration",
	"Target_MagicWeapon",
	"Shout_MirrorImage",
	"Target_Moonbeam",
	"Target_PhantasmalForce",
	"Shout_PrayerOfHealing",
	"Target_ProtectionFromPoison",
	"Shout_SeeInvisibility",
	"Target_Shatter",
	"Target_Silence",
	"Target_WardingBond",
	"Target_AnimalFriendship",
	"Shout_ArmsOfHadar",
	"Target_Bane",
	"Zone_BurningHands",
	"Target_CharmPerson",
	"Zone_ColorSpray",
	"Target_CreateDestroyWater",
	"Target_CureWounds",
	"Shout_DisguiseSelf",
	"Target_DissonantWhispers",
	"Projectile_EnsnaringStrike_Container",
	"Shout_ExpeditiousRetreat",
	"Target_FaerieFire",
	"Shout_FeatherFall",
	"Target_FindFamiliar",
	"Target_FogCloud",
	"Target_Goodberry",
	"Target_Grease",
	"Projectile_HailOfThorns",
	"Target_HealingWord",
	"Target_Heroism",
	"Target_HideousLaughter",
	"Target_HuntersMark",
	"Target_InflictWounds",
	"Target_Jump",
	"Target_Longstrider",
	"Target_MageArmor",
	"Target_ProtectionFromEvilAndGood",
	"Projectile_RayOfSickness",
	"Shout_Shield_Sorcerer",
	"Target_ShieldOfFaith",
	"Target_Sleep",
	"Target_Smite_Searing",
	"Target_Smite_Wrathful",
	"Shout_SpeakWithAnimals",
	"Zone_Thunderwave",
	"Projectile_WitchBolt",
	"Projectile_AcidSplash",
	"Shout_BladeWard",
	"Target_ChillTouch",
	"Target_DancingLights",
	"Target_Friends",
	"Target_Guidance",
	"Target_Light",
	"Target_MageHand",
	"Target_MinorIllusion",
	"Projectile_PoisonSpray",
	"Shout_ProduceFlame",
	"Target_Resistance",
	"Shout_Shillelagh",
	"Target_ShockingGrasp",
	"Shout_Thaumaturgy",
	"Target_ThornWhip",
	"Target_TrueStrike"
}
local bardMagicalSecrets5thOther = {
	"Shout_AntilifeShell",
	"Shout_CircleOfPower",
	"Shout_CommuneWithNature",
	"ProjectileStrike_ConjureVolley",
	"Target_FarStep",
	"Target_HolyWeapon",
	"Target_Maelstrom",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SteelWindStrike",
	"Target_StormSphere",
	"Shout_SwiftQuiver",
	"Target_ArcaneEye",
	"Shout_AuraOfLife",
	"Shout_GuardianOfNature",
	"Shout_ShadowOfMoil",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Target_CreateFoodAndWater",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Target_HealingSpirit",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Target_WitherAndBloom",
	"Target_ZoneofTruth",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Target_Ceremony",
	"Target_ChaosBolt",
	"Shout_DetectEvilAndGood",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Shout_ZephyrStrike",
	"Target_BoomingBlade_5e",
	"Target_ControlFlames",
	"Target_CreateBonfire",
	"Shout_Druidcraft",
	"Target_Frostbite",
	"Target_GreenFlameBlade",
	"Target_Gust",
	"Target_Infestation",
	"Target_LightningLure",
	"Target_MagicStone",
	"Target_MindSliver",
	"Target_MoldEarth",
	"Target_Prestidigitation",
	"Target_ShapeWater",
	"Target_SpareTheDying",
	"Shout_SwordBurst",
	"Shout_Thunderclap",
	"Shout_WordOfRadiance"
}
local bardMagicalSecrets7thTCoE = {
	"Teleportation_ArcaneGate",
	"Wall_BladeBarrier",
	"Projectile_ChainLightning",
	"Target_CircleOfDeath",
	"Target_CreateUndead",
	"Projectile_Disintegrate",
	"Target_Eyebite",
	"Target_FreezingSphere",
	"Target_GlobeOfInvulnerability",
	"Target_FleshToStone",
	"Target_IrresistibleDance",
	"Target_Heal",
	"Target_Harm",
	"Shout_HeroesFeast",
	"Target_PlanarAlly_Container",
	"Wall_WallOfIce",
	"Wall_WallOfThorns",
	"Shout_WindWalk",
	"Zone_Sunbeam",
	"Target_Cloudkill",
	"Shout_DestructiveWave",
	"Target_DominatePerson",
	"Target_FlameStrike",
	"Target_GreaterRestoration",
	"Target_HoldMonster",
	"Target_InsectPlague",
	"Target_CureWounds_Mass",
	"Target_PlanarBinding",
	"Target_Seeming",
	"Throw_Telekinesis",
	"Target_Confusion",
	"Target_ConjureElementals_Minor_Container",
	"Target_ConjureWoodlandBeings",
	"Teleportation_DimensionDoor",
	"Target_BlackTentacles",
	"Target_FreedomOfMovement",
	"Target_GraspingVine",
	"Target_Invisibility_Greater",
	"Target_PhantasmalKiller",
	"Target_Polymorph",
	"Target_ResilientSphere",
	"Target_Stoneskin",
	"Shout_BeaconOfHope",
	"Target_BestowCurse",
	"Target_Smite_Blinding",
	"Shout_Blink",
	"Zone_ConjureBarrage",
	"Shout_CrusadersMantle",
	"Target_ElementalWeapon",
	"Zone_Fear",
	"Target_FeignDeath",
	"Target_GlyphOfWarding",
	"Target_HungerOfHadar",
	"Target_HypnoticPattern",
	"Projectile_LightningArrow",
	"Target_PlantGrowth",
	"Target_ProtectionFromEnergy",
	"Target_SpeakWithDead",
	"Target_StinkingCloud",
	"Target_VampiricTouch",
	"Projectile_AcidArrow",
	"Shout_Aid",
	"Target_Barkskin",
	"Target_Blindness",
	"Target_Smite_Branding_Container",
	"Target_CalmEmotions",
	"Target_CloudOfDaggers",
	"Target_CrownOfMadness",
	"Shout_DetectThoughts",
	"Target_EnhanceAbility",
	"Target_EnlargeReduce",
	"Target_Enthrall",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Zone_GustOfWind",
	"Target_HeatMetal",
	"Target_HoldPerson",
	"Target_Invisibility",
	"Target_Knock",
	"Target_LesserRestoration",
	"Target_MagicWeapon",
	"Shout_MirrorImage",
	"Target_Moonbeam",
	"Target_PhantasmalForce",
	"Shout_PrayerOfHealing",
	"Target_ProtectionFromPoison",
	"Shout_SeeInvisibility",
	"Target_Shatter",
	"Target_Silence",
	"Target_WardingBond",
	"Target_AnimalFriendship",
	"Shout_ArmsOfHadar",
	"Target_Bane",
	"Zone_BurningHands",
	"Target_CharmPerson",
	"Zone_ColorSpray",
	"Target_CreateDestroyWater",
	"Target_CureWounds",
	"Shout_DisguiseSelf",
	"Target_DissonantWhispers",
	"Projectile_EnsnaringStrike_Container",
	"Shout_ExpeditiousRetreat",
	"Target_FaerieFire",
	"Shout_FeatherFall",
	"Target_FindFamiliar",
	"Target_FogCloud",
	"Target_Goodberry",
	"Target_Grease",
	"Projectile_HailOfThorns",
	"Target_HealingWord",
	"Target_Heroism",
	"Target_HideousLaughter",
	"Target_HuntersMark",
	"Target_InflictWounds",
	"Target_Jump",
	"Target_Longstrider",
	"Target_MageArmor",
	"Target_ProtectionFromEvilAndGood",
	"Projectile_RayOfSickness",
	"Shout_Shield_Sorcerer",
	"Target_ShieldOfFaith",
	"Target_Sleep",
	"Target_Smite_Searing",
	"Target_Smite_Wrathful",
	"Shout_SpeakWithAnimals",
	"Zone_Thunderwave",
	"Projectile_WitchBolt",
	"Projectile_AcidSplash",
	"Shout_BladeWard",
	"Target_ChillTouch",
	"Target_DancingLights",
	"Target_Friends",
	"Target_Guidance",
	"Target_Light",
	"Target_MageHand",
	"Target_MinorIllusion",
	"Projectile_PoisonSpray",
	"Shout_ProduceFlame",
	"Target_Resistance",
	"Shout_Shillelagh",
	"Target_ShockingGrasp",
	"Shout_Thaumaturgy",
	"Target_ThornWhip",
	"Target_TrueStrike"
}
local bardMagicalSecrets7thOther = {
	"Target_FingerOfDeath",
	"Target_Regenerate",
	"Shout_TensersTransformation",
	"Target_TrueSeeing",
	"Shout_AntilifeShell",
	"Shout_CircleOfPower",
	"Shout_CommuneWithNature",
	"ProjectileStrike_ConjureVolley",
	"Target_FarStep",
	"Target_HolyWeapon",
	"Target_Maelstrom",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SteelWindStrike",
	"Target_StormSphere",
	"Shout_SwiftQuiver",
	"Target_ArcaneEye",
	"Shout_AuraOfLife",
	"Shout_GuardianOfNature",
	"Shout_ShadowOfMoil",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Target_CreateFoodAndWater",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Target_HealingSpirit",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Target_WitherAndBloom",
	"Target_ZoneofTruth",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Target_Ceremony",
	"Target_ChaosBolt",
	"Shout_DetectEvilAndGood",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Shout_ZephyrStrike",
	"Target_BoomingBlade_5e",
	"Target_ControlFlames",
	"Target_CreateBonfire",
	"Shout_Druidcraft",
	"Target_Frostbite",
	"Target_GreenFlameBlade",
	"Target_Gust",
	"Target_Infestation",
	"Target_LightningLure",
	"Target_MagicStone",
	"Target_MindSliver",
	"Target_MoldEarth",
	"Target_Prestidigitation",
	"Target_ShapeWater",
	"Target_SpareTheDying",
	"Shout_SwordBurst",
	"Shout_Thunderclap",
	"Shout_WordOfRadiance"
}
local bardMagicalSecrets9thTCoE = {
	"Teleportation_ArcaneGate",
	"Wall_BladeBarrier",
	"Projectile_ChainLightning",
	"Target_CircleOfDeath",
	"Target_CreateUndead",
	"Projectile_Disintegrate",
	"Target_Eyebite",
	"Target_FreezingSphere",
	"Target_GlobeOfInvulnerability",
	"Target_FleshToStone",
	"Target_IrresistibleDance",
	"Target_Heal",
	"Target_Harm",
	"Shout_HeroesFeast",
	"Target_PlanarAlly_Container",
	"Wall_WallOfIce",
	"Wall_WallOfThorns",
	"Shout_WindWalk",
	"Zone_Sunbeam",
	"Target_Cloudkill",
	"Shout_DestructiveWave",
	"Target_DominatePerson",
	"Target_FlameStrike",
	"Target_GreaterRestoration",
	"Target_HoldMonster",
	"Target_InsectPlague",
	"Target_CureWounds_Mass",
	"Target_PlanarBinding",
	"Target_Seeming",
	"Throw_Telekinesis",
	"Target_Confusion",
	"Target_ConjureElementals_Minor_Container",
	"Target_ConjureWoodlandBeings",
	"Teleportation_DimensionDoor",
	"Target_BlackTentacles",
	"Target_FreedomOfMovement",
	"Target_GraspingVine",
	"Target_Invisibility_Greater",
	"Target_PhantasmalKiller",
	"Target_Polymorph",
	"Target_ResilientSphere",
	"Target_Stoneskin",
	"Shout_BeaconOfHope",
	"Target_BestowCurse",
	"Target_Smite_Blinding",
	"Shout_Blink",
	"Zone_ConjureBarrage",
	"Shout_CrusadersMantle",
	"Target_ElementalWeapon",
	"Zone_Fear",
	"Target_FeignDeath",
	"Target_GlyphOfWarding",
	"Target_HungerOfHadar",
	"Target_HypnoticPattern",
	"Projectile_LightningArrow",
	"Target_PlantGrowth",
	"Target_ProtectionFromEnergy",
	"Target_SpeakWithDead",
	"Target_StinkingCloud",
	"Target_VampiricTouch",
	"Projectile_AcidArrow",
	"Shout_Aid",
	"Target_Barkskin",
	"Target_Blindness",
	"Target_Smite_Branding_Container",
	"Target_CalmEmotions",
	"Target_CloudOfDaggers",
	"Target_CrownOfMadness",
	"Shout_DetectThoughts",
	"Target_EnhanceAbility",
	"Target_EnlargeReduce",
	"Target_Enthrall",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Zone_GustOfWind",
	"Target_HeatMetal",
	"Target_HoldPerson",
	"Target_Invisibility",
	"Target_Knock",
	"Target_LesserRestoration",
	"Target_MagicWeapon",
	"Shout_MirrorImage",
	"Target_Moonbeam",
	"Target_PhantasmalForce",
	"Shout_PrayerOfHealing",
	"Target_ProtectionFromPoison",
	"Shout_SeeInvisibility",
	"Target_Shatter",
	"Target_Silence",
	"Target_WardingBond",
	"Target_AnimalFriendship",
	"Shout_ArmsOfHadar",
	"Target_Bane",
	"Zone_BurningHands",
	"Target_CharmPerson",
	"Zone_ColorSpray",
	"Target_CreateDestroyWater",
	"Target_CureWounds",
	"Shout_DisguiseSelf",
	"Target_DissonantWhispers",
	"Projectile_EnsnaringStrike_Container",
	"Shout_ExpeditiousRetreat",
	"Target_FaerieFire",
	"Shout_FeatherFall",
	"Target_FindFamiliar",
	"Target_FogCloud",
	"Target_Goodberry",
	"Target_Grease",
	"Projectile_HailOfThorns",
	"Target_HealingWord",
	"Target_Heroism",
	"Target_HideousLaughter",
	"Target_HuntersMark",
	"Target_InflictWounds",
	"Target_Jump",
	"Target_Longstrider",
	"Target_MageArmor",
	"Target_ProtectionFromEvilAndGood",
	"Projectile_RayOfSickness",
	"Shout_Shield_Sorcerer",
	"Target_ShieldOfFaith",
	"Target_Sleep",
	"Target_Smite_Searing",
	"Target_Smite_Wrathful",
	"Shout_SpeakWithAnimals",
	"Zone_Thunderwave",
	"Projectile_WitchBolt",
	"Projectile_AcidSplash",
	"Shout_BladeWard",
	"Target_ChillTouch",
	"Target_DancingLights",
	"Target_Friends",
	"Target_Guidance",
	"Target_Light",
	"Target_MageHand",
	"Target_MinorIllusion",
	"Projectile_PoisonSpray",
	"Shout_ProduceFlame",
	"Target_Resistance",
	"Shout_Shillelagh",
	"Target_ShockingGrasp",
	"Shout_Thaumaturgy",
	"Target_ThornWhip",
	"Target_TrueStrike"
}
local bardMagicalSecrets9thOther = {
	"Target_Foresight",
	"Target_PowerWordHeal",
	"Target_PowerWordKill",
	"Target_DominateMonster",
	"Target_Feeblemind",
	"Shout_HolyAura",
	"Target_MindBlank",
	"Target_FingerOfDeath",
	"Target_Regenerate",
	"Shout_TensersTransformation",
	"Target_TrueSeeing",
	"Shout_AntilifeShell",
	"Shout_CircleOfPower",
	"Shout_CommuneWithNature",
	"ProjectileStrike_ConjureVolley",
	"Target_FarStep",
	"Target_HolyWeapon",
	"Target_Maelstrom",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SteelWindStrike",
	"Target_StormSphere",
	"Shout_SwiftQuiver",
	"Target_ArcaneEye",
	"Shout_AuraOfLife",
	"Shout_GuardianOfNature",
	"Shout_ShadowOfMoil",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Target_CreateFoodAndWater",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Target_HealingSpirit",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Target_WitherAndBloom",
	"Target_ZoneofTruth",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Target_Ceremony",
	"Target_ChaosBolt",
	"Shout_DetectEvilAndGood",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Shout_ZephyrStrike",
	"Target_BoomingBlade_5e",
	"Target_ControlFlames",
	"Target_CreateBonfire",
	"Shout_Druidcraft",
	"Target_Frostbite",
	"Target_GreenFlameBlade",
	"Target_Gust",
	"Target_Infestation",
	"Target_LightningLure",
	"Target_MagicStone",
	"Target_MindSliver",
	"Target_MoldEarth",
	"Target_Prestidigitation",
	"Target_ShapeWater",
	"Target_SpareTheDying",
	"Shout_SwordBurst",
	"Shout_Thunderclap",
	"Shout_WordOfRadiance"
}
local clericCantrips = {
	"Target_SpareTheDying",
	"Shout_WordOfRadiance"
}
local clericSpells1stOther = {
	"Target_Ceremony",
	"Shout_DetectEvilAndGood",
	"Shout_DetectMagic"
}
local clericSpells2ndOther = {
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_ZoneofTruth"
}
local clericSpells3rdTCoE = {
	"Shout_AuraOfVitality"
}
local clericSpells3rdOther = {
	"Target_CreateFoodAndWater",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Target_MotivationalSpeech",
	"Shout_SpiritShroud",
	"Shout_WaterWalk"
}
local clericSpells4thOther = {
	"Shout_AuraOfLife"
}
local clericSpells5thOther = {
	"Target_HolyWeapon",
	"Target_RaiseDead"
}
local clericSpells6thTCoE = {
	"Zone_Sunbeam"
}
local clericSpells6thOther = {
	"Target_TrueSeeing"
}
local clericSpells7thOther = {
	"Target_Regenerate"
}
local clericSpells8thOther = {
	"Shout_HolyAura"
}
local clericSpells9thOther = {
	"Target_PowerWordHeal"
}
local druidCantrips = {
	"Target_ControlFlames",
	"Target_CreateBonfire",
	"Shout_Druidcraft",
	"Target_Frostbite",
	"Target_Gust",
	"Target_Infestation",
	"Target_MagicStone",
	"Target_MoldEarth",
	"Target_PrimalSavagery",
	"Target_ShapeWater",
	"Shout_Thunderclap"
}
local druidSpells1stTCoE = {
	"Target_ProtectionFromEvilAndGood"
}
local druidSpells1stOther = {
	"Shout_AbsorbElements",
	"Target_BeastBond",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Target_Snare"
}
local druidSpells2ndTCoE = {
	"Target_EnlargeReduce"
}
local druidSpells2ndOther = {
	"Target_ContinualFlame",
	"Target_DustDevil",
	"Target_HealingSpirit",
	"Target_SummonBeast",
	"Target_WitherAndBloom",
	"Shout_WardingWind"
}
local druidSpells3rdTCoE = {
	"Shout_AuraOfVitality",
	"Target_ElementalWeapon",
	"Teleportation_Revivify"
}
local druidSpells3rdOther = {
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_SummonFey",
	"Shout_WaterWalk"
}
local druidSpells4thTCoE = {
	"Shout_FireShield"
}
local druidSpells4thOther = {
	"Target_CharmMonster",
	"Shout_GuardianOfNature",
	"Target_SummonElemental"
}
local druidSpells5thTCoE = {
	"Zone_ConeOfCold"
}
local druidSpells5thOther = {
	"Shout_AntilifeShell",
	"Shout_CommuneWithNature",
	"Target_Maelstrom"
}
local druidSpells6thTCoE = {
	"Target_FleshToStone"
}
local druidSpells7thOther = {
	"Target_Regenerate"
}
local druidSpells8thOther = {
	"Target_Feeblemind"
}
local druidSpells9thOther = {
	"Target_Foresight"
}
local fighterEKSpells1stOther = {
	"Shout_AbsorbElements",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew"
}
local fighterEKSpells2ndOther = {
	"Zone_AganazzarsScorcher",
	"Target_ContinualFlame",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Shout_WardingWind",
	"Shout_AbsorbElements",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew"
}
local fighterEKSpells3rdOther = {
	"Target_IntellectFortress",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Zone_AganazzarsScorcher",
	"Target_ContinualFlame",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Shout_WardingWind",
	"Shout_AbsorbElements",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew"
}
local fighterEKSpells4thOther = {
	"Target_StormSphere",
	"Projectile_VitriolicSphere",
	"Target_IntellectFortress",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Zone_AganazzarsScorcher",
	"Target_ContinualFlame",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Shout_WardingWind",
	"Shout_AbsorbElements",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew"
}
local paladinSpells1stOther = {
	"Target_Ceremony",
	"Shout_DetectEvilAndGood",
	"Shout_DetectMagic"
}
local paladinSpells2ndTCoE = {
	"Shout_PrayerOfHealing",
	"Target_WardingBond",
	"Target_ZoneofTruth"
}
local paladinSpells3rdOther = {
	"Target_CreateFoodAndWater",
	"Target_MagicCircle",
	"Shout_SpiritShroud"
}
local paladinSpells4thOther = {
	"Shout_AuraOfLife"
}
local paladinSpells5thOther = {
	"Shout_CircleOfPower",
	"Target_HolyWeapon",
	"Target_RaiseDead"
}
local rangerSpells1stTCoE = {
	"Target_Entangle",
	"Target_Smite_Searing"
}
local rangerSpells1stOther = {
	"Shout_AbsorbElements",
	"Target_BeastBond",
	"Shout_DetectMagic",
	"Target_Snare",
	"Shout_ZephyrStrike"
}
local rangerSpells2ndTCoE = {
	"Shout_Aid",
	"Target_EnhanceAbility",
	"Zone_GustOfWind",
	"Target_MagicWeapon",
	"Target_Entangle",
	"Target_Smite_Searing"
}
local rangerSpells2ndOther = {
	"Target_HealingSpirit",
	"Target_SummonBeast",
	"Shout_AbsorbElements",
	"Target_BeastBond",
	"Shout_DetectMagic",
	"Target_Snare",
	"Shout_ZephyrStrike"
}
local rangerSpells3rdTCoE = {
	"Target_ElementalWeapon",
	"Teleportation_Revivify",
	"Shout_Aid",
	"Target_EnhanceAbility",
	"Zone_GustOfWind",
	"Target_MagicWeapon",
	"Target_Entangle",
	"Target_Smite_Searing"
}
local rangerSpells3rdOther = {
	"Shout_AshardalonsStride",
	"Target_FlameArrows",
	"Target_Nondetection",
	"Target_SummonFey",
	"Shout_WaterWalk",
	"Target_HealingSpirit",
	"Target_SummonBeast",
	"Shout_AbsorbElements",
	"Target_BeastBond",
	"Shout_DetectMagic",
	"Target_Snare",
	"Shout_ZephyrStrike"
}
local rangerSpells4thTCoE = {
	"Target_DominateBeast",
	"Target_ElementalWeapon",
	"Teleportation_Revivify",
	"Shout_Aid",
	"Target_EnhanceAbility",
	"Zone_GustOfWind",
	"Target_MagicWeapon",
	"Target_Entangle",
	"Target_Smite_Searing"
}
local rangerSpells4thOther = {
	"Shout_GuardianOfNature",
	"Target_SummonElemental",
	"Shout_AshardalonsStride",
	"Target_FlameArrows",
	"Target_Nondetection",
	"Target_SummonFey",
	"Shout_WaterWalk",
	"Target_HealingSpirit",
	"Target_SummonBeast",
	"Shout_AbsorbElements",
	"Target_BeastBond",
	"Shout_DetectMagic",
	"Target_Snare",
	"Shout_ZephyrStrike"
}
local rangerSpells5thTCoE = {
	"Target_GreaterRestoration",
	"Target_DominateBeast",
	"Target_ElementalWeapon",
	"Teleportation_Revivify",
	"Shout_Aid",
	"Target_EnhanceAbility",
	"Zone_GustOfWind",
	"Target_MagicWeapon",
	"Target_Entangle",
	"Target_Smite_Searing"
}
local rangerSpells5thOther = {
	"Shout_CommuneWithNature",
	"ProjectileStrike_ConjureVolley",
	"Target_SteelWindStrike",
	"Shout_SwiftQuiver",
	"Shout_GuardianOfNature",
	"Target_SummonElemental",
	"Shout_AshardalonsStride",
	"Target_FlameArrows",
	"Target_Nondetection",
	"Target_SummonFey",
	"Shout_WaterWalk",
	"Target_HealingSpirit",
	"Target_SummonBeast",
	"Shout_AbsorbElements",
	"Target_BeastBond",
	"Shout_DetectMagic",
	"Target_Snare",
	"Shout_ZephyrStrike"
}
local rogueATSpells2ndOther = {
	"Target_TashasMindWhip",
	"Target_NathairsMischief"
}
local rogueATSpells3rdOther = {
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_TashasMindWhip",
	"Target_NathairsMischief"
}
local rogueATSpells4thOther = {
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_Antagonize",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_TashasMindWhip",
	"Target_NathairsMischief"
}
local sorcererCantrips = {
	"Target_BoomingBlade_5e",
	"Target_ControlFlames",
	"Target_CreateBonfire",
	"Target_Frostbite",
	"Target_GreenFlameBlade",
	"Target_Gust",
	"Target_Infestation",
	"Target_LightningLure",
	"Target_MindSliver",
	"Target_MoldEarth",
	"Target_Prestidigitation",
	"Target_ShapeWater",
	"Shout_SwordBurst",
	"Shout_Thunderclap"
}
local sorcererSpells1stTCoE = {
	"Target_Grease"
}
local sorcererSpells1stOther = {
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells2ndTCoE = {
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells2ndOther = {
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells3rdTCoE = {
	"Target_VampiricTouch",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells3rdOther = {
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Projectile_MinuteMeteors",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells4thTCoE = {
	"Shout_FireShield",
	"Target_VampiricTouch",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells4thOther = {
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Projectile_MinuteMeteors",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells5thTCoE = {
	"Shout_FireShield",
	"Target_VampiricTouch",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells5thOther = {
	"Target_FarStep",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Projectile_MinuteMeteors",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells6thTCoE = {
	"Target_FleshToStone",
	"Target_FreezingSphere",
	"Shout_FireShield",
	"Target_VampiricTouch",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells6thOther = {
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Projectile_MinuteMeteors",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells7thTCoE = {
	"Target_FleshToStone",
	"Target_FreezingSphere",
	"Shout_FireShield",
	"Target_VampiricTouch",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells7thOther = {
	"Target_FingerOfDeath",
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Projectile_MinuteMeteors",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells8thTCoE = {
	"Target_FleshToStone",
	"Target_FreezingSphere",
	"Shout_FireShield",
	"Target_VampiricTouch",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells8thOther = {
	"Target_DominateMonster",
	"Target_FingerOfDeath",
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Projectile_MinuteMeteors",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local sorcererSpells9thTCoE = {
	"Target_FleshToStone",
	"Target_FreezingSphere",
	"Shout_FireShield",
	"Target_VampiricTouch",
	"Shout_FlameBlade",
	"Target_FlamingSphere",
	"Target_MagicWeapon",
	"Target_Grease"
}
local sorcererSpells9thOther = {
	"Target_PowerWordKill",
	"Target_DominateMonster",
	"Target_FingerOfDeath",
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_SkillEmpowerment",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Projectile_MinuteMeteors",
	"Teleportation_ThunderStep",
	"Shout_WaterWalk",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_ChaosBolt",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_TashasCausticBrew"
}
local warlockCantrips = {
	"Target_BoomingBlade_5e",
	"Target_CreateBonfire",
	"Target_Frostbite",
	"Target_GreenFlameBlade",
	"Target_Gust",
	"Target_Infestation",
	"Target_LightningLure",
	"Target_MagicStone",
	"Target_MindSliver",
	"Target_Prestidigitation",
	"Target_ShapeWater",
	"Shout_SwordBurst",
	"Shout_Thunderclap",
	"Target_TollTheDead"
}
warlockSpells1stOther = {
	"Target_CauseFear",
	"Target_UnseenServant"
}
warlockSpells2ndOther = {
	"Shout_BorrowedKnowledge",
	"Target_FlockOfFamiliars",
	"Target_MindSpike",
	"Target_CauseFear",
	"Target_UnseenServant"
}
warlockSpells3rdOther = {
	"Target_Antagonize",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MagicCircle",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Shout_BorrowedKnowledge",
	"Target_FlockOfFamiliars",
	"Target_MindSpike",
	"Target_CauseFear",
	"Target_UnseenServant"
}
warlockSpells4thOther = {
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Shout_ShadowOfMoil",
	"Target_SummonBeholderkin",
	"Target_Antagonize",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MagicCircle",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Shout_BorrowedKnowledge",
	"Target_FlockOfFamiliars",
	"Target_MindSpike",
	"Target_CauseFear",
	"Target_UnseenServant"
}
warlockSpells5thTCoE = {
	"Target_Mislead",
	"Target_PlanarBinding",
	"Teleportation_TeleportationCircle"
}
warlockSpells5thOther = {
	"Target_FarStep",
	"Projectile_NegativeEnergyFlood",
	"Target_SynapticStatic",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Shout_ShadowOfMoil",
	"Target_SummonBeholderkin",
	"Target_Antagonize",
	"Target_EnemiesAbound",
	"Target_IntellectFortress",
	"Target_MagicCircle",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Shout_BorrowedKnowledge",
	"Target_FlockOfFamiliars",
	"Target_MindSpike",
	"Target_CauseFear",
	"Target_UnseenServant"
}
warlockSpells6thOther = {
	"Target_TrueSeeing"
}
warlockSpells7thOther = {
	"Target_FingerOfDeath"
}
warlockSpells8thOther = {
	"Target_DominateMonster",
	"Target_Feeblemind"
}
warlockSpells9thOther = {
	"Target_Foresight",
	"Target_PowerWordKill"
}
local wizardCantrips = {
	"Target_BoomingBlade_5e",
	"Target_ControlFlames",
	"Target_CreateBonfire",
	"Target_Frostbite",
	"Target_GreenFlameBlade",
	"Target_Gust",
	"Target_Infestation",
	"Target_LightningLure",
	"Target_MindSliver",
	"Target_MoldEarth",
	"Target_Prestidigitation",
	"Target_ShapeWater",
	"Shout_SwordBurst",
	"Shout_Thunderclap",
	"Target_TollTheDead"
}
local wizardSpells1stOther = {
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells2ndTCoE = {
	"Target_EnhanceAbility"
}
local wizardSpells2ndOther = {
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells3rdTCoE = {
	"Target_SpeakWithDead",
	"Target_EnhanceAbility"
}
local wizardSpells3rdOther = {
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells4thTCoE = {
	"Target_SpeakWithDead",
	"Target_EnhanceAbility"
}
local wizardSpells4thOther = {
	"Target_ArcaneEye",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells5thTCoE = {
	"Target_SpeakWithDead",
	"Target_EnhanceAbility"
}
local wizardSpells5thOther = {
	"Target_FarStep",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SkillEmpowerment",
	"Target_SteelWindStrike",
	"Target_SynapticStatic",
	"Target_ArcaneEye",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells6thTCoE = {
	"Target_SpeakWithDead",
	"Target_EnhanceAbility"
}
local wizardSpells6thOther = {
	"Shout_TensersTransformation",
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SkillEmpowerment",
	"Target_SteelWindStrike",
	"Target_SynapticStatic",
	"Target_ArcaneEye",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells7thTCoE = {
	"Target_SpeakWithDead",
	"Target_EnhanceAbility"
}
local wizardSpells7thOther = {
	"Target_FingerOfDeath",
	"Shout_TensersTransformation",
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SkillEmpowerment",
	"Target_SteelWindStrike",
	"Target_SynapticStatic",
	"Target_ArcaneEye",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells8thTCoE = {
	"Target_SpeakWithDead",
	"Target_EnhanceAbility"
}
local wizardSpells8thOther = {
	"Target_DominateMonster",
	"Target_Feeblemind",
	"Target_MindBlank",
	"Target_FingerOfDeath",
	"Shout_TensersTransformation",
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SkillEmpowerment",
	"Target_SteelWindStrike",
	"Target_SynapticStatic",
	"Target_ArcaneEye",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local wizardSpells9thTCoE = {
	"Target_SpeakWithDead",
	"Target_EnhanceAbility"
}
local wizardSpells9thOther = {
	"Target_Foresight",
	"Target_PowerWordKill",
	"Target_DominateMonster",
	"Target_Feeblemind",
	"Target_MindBlank",
	"Target_FingerOfDeath",
	"Shout_TensersTransformation",
	"Target_TrueSeeing",
	"Target_FarStep",
	"Target_Mislead",
	"Projectile_NegativeEnergyFlood",
	"Target_SkillEmpowerment",
	"Target_SteelWindStrike",
	"Target_SynapticStatic",
	"Target_ArcaneEye",
	"Target_CharmMonster",
	"Projectile_RaulothimsPsychicLance",
	"Target_StormSphere",
	"Target_SummonBeholderkin",
	"Target_SummonConstruct",
	"Target_SummonElemental",
	"Projectile_VitriolicSphere",
	"Target_Antagonize",
	"Shout_AshardalonsStride",
	"Target_Catnap",
	"Target_EnemiesAbound",
	"Target_EruptingEarth",
	"Target_FlameArrows",
	"Target_IntellectFortress",
	"Target_LifeTransference",
	"Target_MagicCircle",
	"Projectile_MinuteMeteors",
	"Target_Nondetection",
	"Shout_SpiritShroud",
	"Target_SummonFey",
	"Target_SummonShadowspawn",
	"Teleportation_ThunderStep",
	"Zone_AganazzarsScorcher",
	"Shout_AlterSelf",
	"Shout_BorrowedKnowledge",
	"Target_ContinualFlame",
	"Target_DragonsBreath",
	"Target_DustDevil",
	"Target_FlockOfFamiliars",
	"Shout_KineticJaunt",
	"Target_MaximiliansEarthenGrasp",
	"Target_TashasMindWhip",
	"Target_MindSpike",
	"Target_NathairsMischief",
	"Zone_RimesBindingIce",
	"Target_SnillocsSnowballStorm",
	"Target_VortexWarp",
	"Shout_WardingWind",
	"Target_WitherAndBloom",
	"Shout_AbsorbElements",
	"Throw_Catapult",
	"Target_CauseFear",
	"Shout_DetectMagic",
	"Shout_EarthTremor",
	"Zone_FrostFingers",
	"Target_Snare",
	"Zone_TashasCausticBrew",
	"Target_UnseenServant"
}
local boomingblade5e = {
  "Target_BoomingBlade_5e"
}
local boomingbladeLarian = {
  "Target_BoomingBlade_ClassSpell"
}

local cantripList5ES = {
  SpellSniper = "64784e08-e31e-4850-a743-ecfb3fd434d7",
  BardCantrip = "61f79a30-2cac-4a7a-b5fe-50c89d307dd6",
  ClericCantrip = "2f43a103-5bf1-4534-b14f-663decc0c525",
  DruidCantrip = "b8faf12f-ca42-45c0-84f8-6951b526182a",
  SorcererCantrip = "485a68b4-c678-4888-be63-4a702efbe391",
  WarlockCantrip = "3489b1a5-9f7c-439a-b6e3-8cceb21e34fd",
  WizardCantrip = "3cae2e56-9871-4cef-bba6-96845ea765fa"
}

local tcoe1stLevelList5ES = {
  Bard1stTCoE = "dcb45167-86bd-4297-9b9d-c295be51af5b",
  Druid1stTCoE = "2cd54137-2fe5-4100-aad3-df64735a8145",
  Ranger1stTCoE = "458be063-60d4-4548-ae7d-50117fa0226f",
  Sorcerer1stTCoE = "92c4751f-6255-4f67-822c-a75d53830b27"
}

local tcoe2ndLevelList5ES = {
  Bard2ndTCoE = "7ea8f476-97a1-4256-8f10-afa76a845cce",
  Druid2ndTCoE = "92126d17-7f1a-41d2-ae6c-a8d254d2b135",
  Paladin2ndTCoE = "c14c9564-1503-47a1-be19-98e77f22ff59",
  Ranger2ndTCoE = "e7cfb80a-f5c2-4304-8446-9b00ea6a9814",
  Sorcerer2ndTCoE = "f80396e2-cb76-4694-b0db-5c34da61a478",
  Wizard2ndTCoE = "80c6b070-c3a6-4864-84ca-e78626784eb4"
}

local tcoe3rdLevelList5ES = {
  Bard3rdTCoE = "c213ca01-3767-457b-a5c8-fd4c1dd656e2",
  BardMS3rdTCoE = "175ceed7-5a53-4f48-823c-41c4f72d18ae",
  Cleric3rdTCoE = "21be0992-499f-4c7a-a77a-4430085e947a",
  Druid3rdTCoE = "3156daf5-9266-41d0-b52c-5bc559a98654",
  Ranger3rdTCoE = "9a60f649-7f82-4152-90b1-0499c5c9f3e2",
  Sorcerer3rdTCoE = "dcbaf2ae-1f45-453e-ab83-cd154f8277a4",
  Wizard3rdTCoE = "22755771-ca11-49f4-b772-13d8b8fecd93"
}

local tcoe4thLevelList5ES = {
  Bard4thTCoE = "75e04c40-be8f-40a5-9acc-0b5d59d5f3a6",
  Druid4thTCoE = "09c326c9-672c-4198-a4c0-6f07323bde27",
  Ranger4thTCoE = "7022d937-b2e4-4b6e-a3c5-e168f5c00194",
  Sorcerer4thTCoE = "5fe40622-1d3e-4cc1-8d89-e66fe51d8c5c",
  Wizard4thTCoE = "820b1220-0385-426d-ae15-458dc8a6f5c0"
}

local tcoe5thLevelList5ES = {
  Bard5thTCoE = "bd71fffb-e4d2-4233-9a31-13d43fba36e3",
  BardMS5thTCoE = "858d4322-9e9f-4aa4-aada-9c68835dc6fe",
  Druid5thTCoE = "ff711c12-b59f-4fde-b9ea-6e5c38ec8f23",
  Ranger5thTCoE = "412d77e1-4aa2-4149-aa0e-c835b8c79f32",
  Sorcerer5thTCoE = "3276fcfe-e143-4559-b6e0-7d7aa0ffcb53",
  WFiend5thTCoE = "deab57bf-4eec-4085-82f7-87335bce3f5d",
  WGoO5thTCoE = "6d2edca9-71a7-4f3f-89f0-fccfff0bdee5",
  WArchfey5thTCoE = "6d2edca9-71a7-4f3f-89f0-fccfff0bdee5",
  Wizard5thTCoE = "f781a25e-d288-43b4-bf5d-3d8d98846687"
}

local tcoe6thLevelList5ES = {
  Bard6thTCoE = "586a8796-34f4-41f5-a3ef-95738561d55d",
  Cleric6thTCoE = "f8ba7b05-1237-4eaa-97fa-1d3623d5862b",
  Druid6thTCoE = "6a4e2167-55f3-4ba8-900f-14666b293e93",
  Sorcerer6thTCoE = "1270a6db-980b-4e3b-bf26-2924da61dfd5",
  Wizard6thTCoE = "bc917f22-7f71-4a25-9a77-7d2f91a96a65"
}

local tcoe7thLevelList5ES = {
  Bard7thTCoE = "f923e058-b1d9-4b02-98ef-9daaa82a71b6",
  BardMS7thTCoE = "95f80109-32b7-43f8-a99a-7ee2286a993a",
  Sorcerer7thTCoE = "9e38e5ae-51e8-4dd4-aad5-869a571b1519",
  Wizard7thTCoE = "dff7917a-0abc-4671-b68f-c03e56212549"
}

local tcoe8thLevelList5ES = {
  Bard8thTCoE = "073c09e5-ccb9-4153-a210-001225a30cbb",
  Sorcerer8thTCoE = "5a8a002c-352b-44e9-8233-da7e6112f4b0",
  Wizard8thTCoE = "f27a2d0a-0d6c-4c01-98a5-60081abf4807"
}

local tcoe9thLevelList5ES = {
  Bard9thTCoE = "2bbd99d0-21b4-41cc-836e-e386a96fc8e6",
  BardMS9thTCoE = "cd83187f-c886-45c2-be81-34083981f240",
  Sorcerer9thTCoE = "d58ac072-e079-410b-b167-a5e43723b59f",
  Wizard9thTCoE = "cb123d97-8809-4d71-a0cb-0ecb66177d15"
}

local others1stLevelList5ES = {
  RitualCaster = "8c32c900-a8ea-4f2f-9f6f-eccd0d361a9d",
  Bard1stOther = "dcb45167-86bd-4297-9b9d-c295be51af5b",
  Cleric1stOther = "269d1a3b-eed8-4131-8901-a562238f5289",
  Druid1stOther = "2cd54137-2fe5-4100-aad3-df64735a8145",
  FighterEK1stOther = "32aeba85-13bd-4a6f-8e06-cd4447b746d8",
  Paladin1stOther = "c6288ac5-c68b-40ed-bbdd-2ff388575831",
  Ranger1stOther = "458be063-60d4-4548-ae7d-50117fa0226f",
  Sorcerer1stOther = "92c4751f-6255-4f67-822c-a75d53830b27",
  WFiend1stOther = "4823a292-f584-4f7f-8434-6630c72e5411",
  WGoO1stOther = "65952d48-bb16-4ad7-b173-532182bf7770",
  WArchfey1stOther = "e0099b15-2599-4cba-a54b-b25ae03d6519",
  Wizard1stOther = "11f331b0-e8b7-473b-9d1f-19e8e4178d7d"
}

local others2ndLevelList5ES = {
  Bard2ndOther = "7ea8f476-97a1-4256-8f10-afa76a845cce",
  Cleric2ndOther = "2968a3e6-6c8a-4c2e-882a-ad295a2ad8ac",
  Druid2ndOther = "92126d17-7f1a-41d2-ae6c-a8d254d2b135",
  FighterEK2ndOther = "4a86443c-6a21-4b8d-b1bf-55a99e021354",
  Ranger2ndOther = "e7cfb80a-f5c2-4304-8446-9b00ea6a9814",
  RogueAT2ndOther = "f9fd64f1-f417-4544-94a9-51d8876d68df",
  Sorcerer2ndOther = "f80396e2-cb76-4694-b0db-5c34da61a478",
  WFiend2ndOther = "835aeca7-c64a-4aaa-a25c-143aa14a5cec",
  WGoO2ndOther = "fe101a94-8619-49b2-859d-a68c2c291054",
  WArchfey2ndOther = "0cc2c8ab-9bbc-43a7-a66d-08e47da4c172",
  Wizard2ndOther = "80c6b070-c3a6-4864-84ca-e78626784eb4"
}

local others3rdLevelList5ES = {
  Bard3rdOther = "c213ca01-3767-457b-a5c8-fd4c1dd656e2",
  BardMS3rdOther = "175ceed7-5a53-4f48-823c-41c4f72d18ae",
  Cleric3rdOther = "21be0992-499f-4c7a-a77a-4430085e947a",
  Druid3rdOther = "3156daf5-9266-41d0-b52c-5bc559a98654",
  FighterEK3rdOther = "9ca503db-0e4b-4325-b1eb-e2f794a075d6",
  Paladin3rdOther = "d18dec04-478f-41c3-b816-239d5cfcf2a2",
  Ranger3rdOther = "9a60f649-7f82-4152-90b1-0499c5c9f3e2",
  RogueAT3rdOther = "c707cc1f-e5ed-4798-909a-3652ad497d24",
  Sorcerer3rdOther = "dcbaf2ae-1f45-453e-ab83-cd154f8277a4",
  WFiend3rdOther = "5dec41aa-f16a-434e-b209-50c07e64e4ed",
  WGoO3rdOther = "30e9b761-6be0-418e-bb28-5103c00c663b",
  WArchfey3rdOther = "f18ad912-e2f4-47a9-8744-73d6a51c2941",
  Wizard3rdOther = "22755771-ca11-49f4-b772-13d8b8fecd93"
}

local others4thLevelList5ES = {
  Bard4thOther = "75e04c40-be8f-40a5-9acc-0b5d59d5f3a6",
  Cleric4thOther = "37e9b20b-5fd1-45c5-b1c5-159c42397c83",
  Druid4thOther = "09c326c9-672c-4198-a4c0-6f07323bde27",
  FighterEK4thOther = "5798e5a8-da36-40bc-acf5-2b736cf607a2",
  Paladin4thOther = "11d0c2a0-41c6-4ec0-98fe-5d987f7e1665",
  Ranger4thOther = "7022d937-b2e4-4b6e-a3c5-e168f5c00194",
  RogueAT4thOther = "0329cc67-3e67-409c-9b22-fb510a564c98",
  Sorcerer4thOther = "5fe40622-1d3e-4cc1-8d89-e66fe51d8c5c",
  WFiend4thOther = "7ad7dbd0-751b-4bcd-8034-53bcc7bfb19d",
  WGoO4thOther = "b64e527e-1f97-4125-84f7-78376ab1440b",
  WArchfey4thOther = "c3d8a4a5-9dae-4193-8322-a5d1c5b89f47",
  Wizard4thOther = "820b1220-0385-426d-ae15-458dc8a6f5c0"
}

local others5thLevelList5ES = {
  Bard5thOther = "bd71fffb-e4d2-4233-9a31-13d43fba36e3",
  BardMS5thOther = "858d4322-9e9f-4aa4-aada-9c68835dc6fe",
  Cleric5thOther = "b73aeea5-1ff9-4cac-b61d-b5aa6dfe31c2",
  Druid5thOther = "ff711c12-b59f-4fde-b9ea-6e5c38ec8f23",
  Paladin5thOther = "f351595c-90f7-4804-9e55-18c4d624593c",
  Ranger5thOther = "412d77e1-4aa2-4149-aa0e-c835b8c79f32",
  Sorcerer5thOther = "3276fcfe-e143-4559-b6e0-7d7aa0ffcb53",
  WFiend5thOther = "deab57bf-4eec-4085-82f7-87335bce3f5d",
  WGoO5thOther = "6d2edca9-71a7-4f3f-89f0-fccfff0bdee5",
  WArchfey5thOther = "0a9b924f-64fb-4f22-b975-5eeedc99b2fd",
  Wizard5thOther = "f781a25e-d288-43b4-bf5d-3d8d98846687"
}

local others6thLevelList5ES = {
  Bard6thOther = "586a8796-34f4-41f5-a3ef-95738561d55d",
  Cleric6thOther = "f8ba7b05-1237-4eaa-97fa-1d3623d5862b",
  Sorcerer6thOther = "1270a6db-980b-4e3b-bf26-2924da61dfd5",
  Warlock6thOther = "e6ccab5e-3b3b-4b34-8fa2-1058dff2b3e6",
  Wizard6thOther = "bc917f22-7f71-4a25-9a77-7d2f91a96a65"
}

local others7thLevelList5ES = {
  Bard7thOther = "f923e058-b1d9-4b02-98ef-9daaa82a71b6",
  BardMS7thOther = "95f80109-32b7-43f8-a99a-7ee2286a993a",
  Cleric7thOther = "11862b36-c2d6-4d2f-b2d7-4af29f8fe31a",
  Druid7thOther = "29c9cf78-3bd6-47dc-88b4-2dce54710124",
  Sorcerer7thOther = "9e38e5ae-51e8-4dd4-aad5-869a571b1519",
  Warlock7thOther = "388cd3b0-914a-44b6-a828-1315323b9fd7",
  Wizard7thOther = "dff7917a-0abc-4671-b68f-c03e56212549"
}

local others8thLevelList5ES = {
  Bard8thOther = "073c09e5-ccb9-4153-a210-001225a30cbb",
  Cleric8thOther = "a0df1e32-1c61-4017-939f-44cc7695a924",
  Druid8thOther = "bdff0cba-d631-4b83-9562-63c0187df380",
  Sorcerer8thOther = "5a8a002c-352b-44e9-8233-da7e6112f4b0",
  Warlock8thOther = "070495e1-ccf4-4c05-9add-61c5010b8204",
  Wizard8thOther = "f27a2d0a-0d6c-4c01-98a5-60081abf4807"
}

local others9thLevelList5ES = {
  Bard9thOther = "2bbd99d0-21b4-41cc-836e-e386a96fc8e6",
  BardMS9thOther = "cd83187f-c886-45c2-be81-34083981f240",
  Cleric9thOther = "9ea2891d-f0f9-42d0-b13d-7f1a5df154c3",
  Druid9thOther = "9e388f0f-7432-4f29-bfe5-5358ebde4491",
  Sorcerer9thOther = "d58ac072-e079-410b-b167-a5e43723b59f",
  Warlock9thOther = "47766c27-e791-4e6e-9b3d-2bb379106e62",
  Wizard9thOther = "cb123d97-8809-4d71-a0cb-0ecb66177d15"
}

local boomingbladeLarianSpellLists = {
  SorcererCantripBB = "485a68b4-c678-4888-be63-4a702efbe391",
  WarlockCantripBB = "f5c4af9c-5d8d-4526-9057-94a4b243cd40",
  WizardCantripBB = "3cae2e56-9871-4cef-bba6-96845ea765fa"
}

local boomingblade5eSpellLists = {
  SpellSniperBB5E = "64784e08-e31e-4850-a743-ecfb3fd434d7",
  SorcererCantripBB5E = "485a68b4-c678-4888-be63-4a702efbe391",
  WarlockCantripBB5E = "f5c4af9c-5d8d-4526-9057-94a4b243cd40",
  WizardCantripBB5E = "3cae2e56-9871-4cef-bba6-96845ea765fa",
  BardMS3rdOtherBB5E = "175ceed7-5a53-4f48-823c-41c4f72d18ae",
  BardMS5thOtherBB5E = "858d4322-9e9f-4aa4-aada-9c68835dc6fe",
  BardMS7thOtherBB5E = "95f80109-32b7-43f8-a99a-7ee2286a993a",
  BardMS9thOtherBB5E = "cd83187f-c886-45c2-be81-34083981f240"
}

	local cantripspells = {
	SSCantrips = {
	  Spells = spellSniper,
	  SpellListID = cantripList5ES.SpellSniper
	},
	BardCantrip = {
	  Spells = bardCantrips,
	  SpellListID = cantripList5ES.BardCantrip
	},
	ClericCantrip = {
	  Spells = clericCantrips,
	  SpellListID = cantripList5ES.ClericCantrip
	},
	DruidCantrip = {
	  Spells = druidCantrips,
	  SpellListID = cantripList5ES.DruidCantrip
	},
	SorcererCantrip = {
	  Spells = sorcererCantrips,
	  SpellListID = cantripList5ES.SorcererCantrip
	},
	WarlockCantrip = {
	  Spells = warlockCantrips,
	  SpellListID = cantripList5ES.WarlockCantrip
	},
	WizardCantrip = {
	  Spells = wizardCantrips,
	  SpellListID = cantripList5ES.WizardCantrip
	},
}
	local tcoe1stlevelspells = {
	Bard1stTCoE = {
	  Spells = bardSpells1stTCoE,
	  SpellListID = tcoe1stLevelList5ES.Bard1stTCoE
	},
	Druid1stTCoE = {
	  Spells = druidSpells1stTCoE,
	  SpellListID = tcoe1stLevelList5ES.Druid1stTCoE
	},
	Ranger1stTCoE = {
	  Spells = rangerSpells1stTCoE,
	  SpellListID = tcoe1stLevelList5ES.Ranger1stTCoE
	},
	Sorcerer1stTCoE = {
	  Spells = sorcererSpells1stTCoE,
	  SpellListID = tcoe1stLevelList5ES.Sorcerer1stTCoE
	},
}

	local tcoe2ndlevelspells = {
	Bard2ndTCoE = {
	  Spells = bardSpells2ndTCoE,
	  SpellListID = tcoe2ndLevelList5ES.Bard2ndTCoE
	},
	Druid2ndTCoE = {
	  Spells = druidSpells2ndTCoE,
	  SpellListID = tcoe2ndLevelList5ES.Druid2ndTCoE
	},
	Paladin2ndTCoE = {
	  Spells = paladinSpells2ndTCoE,
	  SpellListID = tcoe2ndLevelList5ES.Paladin2ndTCoE
	},
	Ranger2ndTCoE = {
	  Spells = rangerSpells2ndTCoE,
	  SpellListID = tcoe2ndLevelList5ES.Ranger2ndTCoE
	},
	Sorcerer2ndTCoE = {
	  Spells = sorcererSpells2ndTCoE,
	  SpellListID = tcoe2ndLevelList5ES.Sorcerer2ndTCoE
	},
	Wizard2ndTCoE = {
	  Spells = wizardSpells2ndTCoE,
	  SpellListID = tcoe2ndLevelList5ES.Wizard2ndTCoE
	},
}

	local tcoe3rdlevelspells = {
	Bard3rdTCoE = {
	  Spells = bardSpells3rdTCoE,
	  SpellListID = tcoe3rdLevelList5ES.Bard3rdTCoE
	},
	BardMS3rdTCoE = {
	  Spells = bardMagicalSecrets3rdTCoE,
	  SpellListID = tcoe3rdLevelList5ES.BardMS3rdTCoE
	},
	Cleric3rdTCoE = {
	  Spells = clericSpells3rdTCoE,
	  SpellListID = tcoe3rdLevelList5ES.Cleric3rdTCoE
	},
	Druid3rdTCoE = {
	  Spells = druidSpells3rdTCoE,
	  SpellListID = tcoe3rdLevelList5ES.Druid3rdTCoE
	},
	Ranger3rdTCoE = {
	  Spells = rangerSpells3rdTCoE,
	  SpellListID = tcoe3rdLevelList5ES.Ranger3rdTCoE
	},
	Sorcerer3rdTCoE = {
	  Spells = sorcererSpells3rdTCoE,
	  SpellListID = tcoe3rdLevelList5ES.Sorcerer3rdTCoE
	},
	Wizard3rdTCoE = {
	  Spells = wizardSpells3rdTCoE,
	  SpellListID = tcoe3rdLevelList5ES.Wizard3rdTCoE
	},
}

	local tcoe4thlevelspells = {
	Bard4thTCoE = {
	  Spells = bardSpells4thTCoE,
	  SpellListID = tcoe4thLevelList5ES.Bard4thTCoE
	},
	Druid4thTCoE = {
	  Spells = druidSpells4thTCoE,
	  SpellListID = tcoe4thLevelList5ES.Druid4thTCoE
	},
	Ranger4thTCoE = {
	  Spells = rangerSpells4thTCoE,
	  SpellListID = tcoe4thLevelList5ES.Ranger4thTCoE
	},
	Sorcerer4thTCoE = {
	  Spells = sorcererSpells4thTCoE,
	  SpellListID = tcoe4thLevelList5ES.Sorcerer4thTCoE
	},
	Wizard4thTCoE = {
	  Spells = wizardSpells4thTCoE,
	  SpellListID = tcoe4thLevelList5ES.Wizard4thTCoE
	},
}

	local tcoe5thlevelspells = {
	Bard5thTCoE = {
	  Spells = bardSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.Bard5thTCoE
	},
	BardMS5thTCoE = {
	  Spells = bardMagicalSecrets5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.BardMS5thTCoE
	},
	Druid5thTCoE = {
	  Spells = druidSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.Druid5thTCoE
	},
	Ranger5thTCoE = {
	  Spells = rangerSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.Ranger5thTCoE
	},
	Sorcerer5thTCoE = {
	  Spells = sorcererSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.Sorcerer5thTCoE
	},
	Fiend5thTCoE = {
	  Spells = warlockSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.WFiend5thTCoE
	},
	GoO5thTCoE = {
	  Spells = warlockSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.WGoO5thTCoE
	},
	Archfey5thTCoE = {
	  Spells = warlockSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.WArchfey5thTCoE
	},
	Wizard5thTCoE = {
	  Spells = wizardSpells5thTCoE,
	  SpellListID = tcoe5thLevelList5ES.Wizard5thTCoE
	},
}

	local tcoe6thlevelspells = {
	Bard6thTCoE = {
	  Spells = bardSpells6thTCoE,
	  SpellListID = tcoe6thLevelList5ES.Bard6thTCoE
	},
	Cleric6thTCoE = {
	  Spells = clericSpells6thTCoE,
	  SpellListID = tcoe6thLevelList5ES.Cleric6thTCoE
	},
	Druid6thTCoE = {
	  Spells = druidSpells6thTCoE,
	  SpellListID = tcoe6thLevelList5ES.Druid6thTCoE
	},
	Sorcerer6thTCoE = {
	  Spells = sorcererSpells6thTCoE,
	  SpellListID = tcoe6thLevelList5ES.Sorcerer6thTCoE
	},
	Wizard6thTCoE = {
	  Spells = wizardSpells6thTCoE,
	  SpellListID = tcoe6thLevelList5ES.Wizard6thTCoE
	},
}

	local tcoe7thlevelspells = {
	Bard7thTCoE = {
	  Spells = bardSpells7thTCoE,
	  SpellListID = tcoe7thLevelList5ES.Bard7thTCoE
	},
	BardMS7thTCoE = {
	  Spells = bardMagicalSecrets7thTCoE,
	  SpellListID = tcoe7thLevelList5ES.BardMS7thTCoE
	},
	Sorcerer7thTCoE = {
	  Spells = sorcererSpells7thTCoE,
	  SpellListID = tcoe7thLevelList5ES.Sorcerer7thTCoE
	},
	Wizard7thTCoE = {
	  Spells = wizardSpells7thTCoE,
	  SpellListID = tcoe7thLevelList5ES.Wizard7thTCoE
	},
}

	local tcoe8thlevelspells = {
	Bard8thTCoE = {
	  Spells = bardSpells8thTCoE,
	  SpellListID = tcoe8thLevelList5ES.Bard8thTCoE
	},
	Sorcerer8thTCoE = {
	  Spells = sorcererSpells8thTCoE,
	  SpellListID = tcoe8thLevelList5ES.Sorcerer8thTCoE
	},
	Wizard8thTCoE = {
	  Spells = wizardSpells8thTCoE,
	  SpellListID = tcoe8thLevelList5ES.Wizard8thTCoE
	},
}

	local tcoe9thlevelspells = {
	Bard9thTCoE = {
	  Spells = bardSpells9thTCoE,
	  SpellListID = tcoe9thLevelList5ES.Bard9thTCoE
	},
	BardMS9thTCoE = {
	  Spells = bardMagicalSecrets9thTCoE,
	  SpellListID = tcoe9thLevelList5ES.BardMS9thTCoE
	},
	Sorcerer9thTCoE = {
	  Spells = sorcererSpells9thTCoE,
	  SpellListID = tcoe9thLevelList5ES.Sorcerer9thTCoE
	},
	Wizard9thTCoE = {
	  Spells = wizardSpells9thTCoE,
	  SpellListID = tcoe9thLevelList5ES.Wizard9thTCoE
	},
}

	local others1stlevelspells = {
	RCSpells = {
	  Spells = ritualCaster,
	  SpellListID = others1stLevelList5ES.RitualCaster
	},
	Bard1stOther = {
	  Spells = bardSpells1stOther,
	  SpellListID = others1stLevelList5ES.Bard1stOther
	},
	Cleric1stOther = {
	  Spells = clericSpells1stOther,
	  SpellListID = others1stLevelList5ES.Cleric1stOther
	},
	Druid1stOther = {
	  Spells = druidSpells1stOther,
	  SpellListID = others1stLevelList5ES.Druid1stOther
	},
	FighterEK1stOther = {
	  Spells = fighterEKSpells1stOther,
	  SpellListID = others1stLevelList5ES.FighterEK1stOther
	},
	Paladin1stOther = {
	  Spells = paladinSpells1stOther,
	  SpellListID = others1stLevelList5ES.Paladin1stOther
	},
	Ranger1stOther = {
	  Spells = rangerSpells1stOther,
	  SpellListID = others1stLevelList5ES.Ranger1stOther
	},
	Sorcerer1stOther = {
	  Spells = sorcererSpells1stOther,
	  SpellListID = others1stLevelList5ES.Sorcerer1stOther
	},
	Fiend1stOther = {
	  Spells = warlockSpells1stOther,
	  SpellListID = others1stLevelList5ES.WFiend1stOther
	},
	GoO1stOther = {
	  Spells = warlockSpells1stOther,
	  SpellListID = others1stLevelList5ES.WGoO1stOther
	},
	Archfey1stOther = {
	  Spells = warlockSpells1stOther,
	  SpellListID = others1stLevelList5ES.WArchfey1stOther
	},
	Wizard1stOther = {
	  Spells = wizardSpells1stOther,
	  SpellListID = others1stLevelList5ES.Wizard1stOther
	},
}

	local others2ndlevelspells = {
	Bard2ndOther = {
	  Spells = bardSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.Bard2ndOther
	},
	Cleric2ndOther = {
	  Spells = clericSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.Cleric2ndOther
	},
	Druid2ndOther = {
	  Spells = druidSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.Druid2ndOther
	},
	FighterEK2ndOther = {
	  Spells = fighterEKSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.FighterEK2ndOther
	},
	Ranger2ndOther = {
	  Spells = rangerSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.Ranger2ndOther
	},
	Sorcerer2ndOther = {
	  Spells = sorcererSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.Sorcerer2ndOther
	},
	Fiend2ndOther = {
	  Spells = warlockSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.WFiend2ndOther
	},
	GoO2ndOther = {
	  Spells = warlockSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.WGoO2ndOther
	},
	Archfey2ndOther = {
	  Spells = warlockSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.WArchfey2ndOther
	},
	Wizard2ndOther = {
	  Spells = wizardSpells2ndOther,
	  SpellListID = others2ndLevelList5ES.Wizard2ndOther
	},
}

	local others3rdlevelspells = {
	Bard3rdOther = {
	  Spells = bardSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.Bard3rdOther
	},
	BardMS3rdOther = {
	  Spells = bardMagicalSecrets3rdOther,
	  SpellListID = others3rdLevelList5ES.BardMS3rdOther
	},
	Cleric3rdOther = {
	  Spells = clericSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.Cleric3rdOther
	},
	Druid3rdOther = {
	  Spells = druidSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.Druid3rdOther
	},
	FighterEK3rdOther = {
	  Spells = fighterEKSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.FighterEK3rdOther
	},
	Paladin3rdOther = {
	  Spells = paladinSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.Paladin3rdOther
	},
	Ranger3rdOther = {
	  Spells = rangerSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.Ranger3rdOther
	},
	RogueAT3rdOther = {
	  Spells = rogueATSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.RogueAT3rdOther
	},
	Sorcerer3rdOther = {
	  Spells = sorcererSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.Sorcerer3rdOther
	},
	Fiend3rdOther = {
	  Spells = warlockSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.WFiend3rdOther
	},
	GoO3rdOther = {
	  Spells = warlockSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.WGoO3rdOther
	},
	Archfey3rdOther = {
	  Spells = warlockSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.WArchfey3rdOther
	},
	Wizard3rdOther = {
	  Spells = wizardSpells3rdOther,
	  SpellListID = others3rdLevelList5ES.Wizard3rdOther
	},
}

	local others4thlevelspells = {
	Bard4thOther = {
	  Spells = bardSpells4thOther,
	  SpellListID = others4thLevelList5ES.Bard4thOther
	},
	Cleric4thOther = {
	  Spells = clericSpells4thOther,
	  SpellListID = others4thLevelList5ES.Cleric4thOther
	},
	Druid4thOther = {
	  Spells = druidSpells4thOther,
	  SpellListID = others4thLevelList5ES.Druid4thOther
	},
	FighterEK4thOther = {
	  Spells = fighterEKSpells4thOther,
	  SpellListID = others4thLevelList5ES.FighterEK4thOther
	},
	Paladin4thOther = {
	  Spells = paladinSpells4thOther,
	  SpellListID = others4thLevelList5ES.Paladin4thOther
	},
	Ranger4thOther = {
	  Spells = rangerSpells4thOther,
	  SpellListID = others4thLevelList5ES.Ranger4thOther
	},
	RogueAT4thOther = {
	  Spells = rogueATSpells4thOther,
	  SpellListID = others4thLevelList5ES.RogueAT4thOther
	},
	Sorcerer4thOther = {
	  Spells = sorcererSpells4thOther,
	  SpellListID = others4thLevelList5ES.Sorcerer4thOther
	},
	Fiend4thOther = {
	  Spells = warlockSpells4thOther,
	  SpellListID = others4thLevelList5ES.WFiend4thOther
	},
	GoO4thOther = {
	  Spells = warlockSpells4thOther,
	  SpellListID = others4thLevelList5ES.WGoO4thOther
	},
	Archfey4thOther = {
	  Spells = warlockSpells4thOther,
	  SpellListID = others4thLevelList5ES.WArchfey4thOther
	},
	Wizard4thOther = {
	  Spells = wizardSpells4thOther,
	  SpellListID = others4thLevelList5ES.Wizard4thOther
	},
}

	local others5thlevelspells = {
	Bard5thOther = {
	  Spells = bardSpells5thOther,
	  SpellListID = others5thLevelList5ES.Bard5thOther
	},
	BardMS5thOther = {
	  Spells = bardMagicalSecrets5thOther,
	  SpellListID = others5thLevelList5ES.BardMS5thOther
	},
	Cleric5thOther = {
	  Spells = clericSpells5thOther,
	  SpellListID = others5thLevelList5ES.Cleric5thOther
	},
	Druid5thOther = {
	  Spells = druidSpells5thOther,
	  SpellListID = others5thLevelList5ES.Druid5thOther
	},
	Paladin5thOther = {
	  Spells = paladinSpells5thOther,
	  SpellListID = others5thLevelList5ES.Paladin5thOther
	},
	Ranger5thOther = {
	  Spells = rangerSpells5thOther,
	  SpellListID = others5thLevelList5ES.Ranger5thOther
	},
	Sorcerer5thOther = {
	  Spells = sorcererSpells5thOther,
	  SpellListID = others5thLevelList5ES.Sorcerer5thOther
	},
	Fiend5thOther = {
	  Spells = warlockSpells5thOther,
	  SpellListID = others5thLevelList5ES.WFiend5thOther
	},
	GoO5thOther = {
	  Spells = warlockSpells5thOther,
	  SpellListID = others5thLevelList5ES.WGoO5thOther
	},
	Archfey5thOther = {
	  Spells = warlockSpells5thOther,
	  SpellListID = others5thLevelList5ES.WArchfey5thOther
	},
	Wizard5thOther = {
	  Spells = wizardSpells5thOther,
	  SpellListID = others5thLevelList5ES.Wizard5thOther
	},
}

	local others6thlevelspells = {
	Bard6thOther = {
	  Spells = bardSpells6thOther,
	  SpellListID = others6thLevelList5ES.Bard6thOther
	},
	Cleric6thOther = {
	  Spells = clericSpells6thOther,
	  SpellListID = others6thLevelList5ES.Cleric6thOther
	},
	Sorcerer6thOther = {
	  Spells = sorcererSpells6thOther,
	  SpellListID = others6thLevelList5ES.Sorcerer6thOther
	},
	Warlock6thOther = {
	  Spells = warlockSpells6thOther,
	  SpellListID = others6thLevelList5ES.Warlock6thOther
	},
	Wizard6thOther = {
	  Spells = wizardSpells6thOther,
	  SpellListID = others6thLevelList5ES.Wizard6thOther
	},
}

	local others7thlevelspells = {
	Bard7thOther = {
	  Spells = bardSpells7thOther,
	  SpellListID = others7thLevelList5ES.Bard7thOther
	},
	BardMS7thOther = {
	  Spells = bardMagicalSecrets7thOther,
	  SpellListID = others7thLevelList5ES.BardMS7thOther
	},
	Cleric7thOther = {
	  Spells = clericSpells7thOther,
	  SpellListID = others7thLevelList5ES.Cleric7thOther
	},
	Druid7thOther = {
	  Spells = druidSpells7thOther,
	  SpellListID = others7thLevelList5ES.Druid7thOther
	},
	Sorcerer7thOther = {
	  Spells = sorcererSpells7thOther,
	  SpellListID = others7thLevelList5ES.Sorcerer7thOther
	},
	Warlock7thOther = {
	  Spells = warlockSpells7thOther,
	  SpellListID = others7thLevelList5ES.Warlock7thOther
	},
	Wizard7thOther = {
	  Spells = wizardSpells7thOther,
	  SpellListID = others7thLevelList5ES.Wizard7thOther
	},
}

	local others8thlevelspells = {
	Bard8thOther = {
	  Spells = bardSpells8thOther,
	  SpellListID = others8thLevelList5ES.Bard8thOther
	},
	Cleric8thOther = {
	  Spells = clericSpells8thOther,
	  SpellListID = others8thLevelList5ES.Cleric8thOther
	},
	Druid8thOther = {
	  Spells = druidSpells8thOther,
	  SpellListID = others8thLevelList5ES.Druid8thOther
	},
	Sorcerer8thOther = {
	  Spells = sorcererSpells8thOther,
	  SpellListID = others8thLevelList5ES.Sorcerer8thOther
	},
	Warlock8thOther = {
	  Spells = warlockSpells8thOther,
	  SpellListID = others8thLevelList5ES.Warlock8thOther
	},
	Wizard8thOther = {
	  Spells = wizardSpells8thOther,
	  SpellListID = others8thLevelList5ES.Wizard8thOther
	},
}

	local others9thlevelspells = {
	Bard9thOther = {
	  Spells = bardSpells9thOther,
	  SpellListID = others9thLevelList5ES.Bard9thOther
	},
	BardMS9thOther = {
	  Spells = bardMagicalSecrets9thOther,
	  SpellListID = others9thLevelList5ES.BardMS9thOther
	},
	Cleric9thOther = {
	  Spells = clericSpells9thOther,
	  SpellListID = others9thLevelList5ES.Cleric9thOther
	},
	Druid9thOther = {
	  Spells = druidSpells9thOther,
	  SpellListID = others9thLevelList5ES.Druid9thOther
	},
	Sorcerer9thOther = {
	  Spells = sorcererSpells9thOther,
	  SpellListID = others9thLevelList5ES.Sorcerer9thOther
	},
	Warlock9thOther = {
	  Spells = warlockSpells9thOther,
	  SpellListID = others9thLevelList5ES.Warlock9thOther
	},
	Wizard9thOther = {
	  Spells = wizardSpells9thOther,
	  SpellListID = others9thLevelList5ES.Wizard9thOther
	},
}

	local boomingblade5eSpells = {
	SpellSniperBB5E = {
	  Spells = boomingblade5e,
	  SpellListID = "451a982f-8a71-4261-b38a-da8916ccecbb"
	},
	SorcererCantripBB5E = {
	  Spells = boomingblade5e,
	  SpellListID = "3a585213-c055-48d7-9621-ace04e698840"
	},
	WarlockCantripBB5E = {
	  Spells = boomingblade5e,
	  SpellListID = "77d74d0c-4d34-4b7c-a37e-ecdbd4c10756"
	},
	WizardCantripBB5E = {
	  Spells = boomingblade5e,
	  SpellListID = "a5117087-fa75-4c1e-ac8c-1e578c8da2b3"
	},
	BardMS3rdOtherBB5E = {
	  Spells = boomingblade5e,
	  SpellListID = "253795e6-2062-4395-88e7-a65af5ab6233"
	},
	BardMS5thOtherBB5E = {
	  Spells = boomingblade5e,
	  SpellListID = "d9ef5f47-5a00-4e8e-907d-f8ab29a64c73"
	},
	Bard7BoomingBlade5e = {
	  Spells = boomingblade5e,
	  SpellListID = "c526dac1-b290-4f11-86b1-52d18e33e601"
	},
	BardMS9thOtherBB5E = {
	  Spells = boomingblade5e,
	  SpellListID = "14bb08d0-3e1e-4769-adc5-83d092931a78"
	},
}

	local boomingbladeLarianSpells = {
--[[	SorcererCantripBB = {
	  Spells = boomingbladeLarian,
	  SpellListID = boomingbladeLarianSpellLists.SorcererCantripBB
	},
	WarlockCantripBB = {
	  Spells = boomingbladeLarian,
	  SpellListID = boomingbladeLarianSpellLists.WarlockCantripBB
	},--]]
	WizardCantripBB = {
	  Spells = boomingbladeLarian,
	  SpellListID = boomingbladeLarianSpellLists.WizardCantripBB
	},
}

--[[function formatting(file)
	local result = ""
	local space = 0
	local str = false
	local character = ""
	for i = 1, #file do
		character = file:sub(i, i)
		if character == '"' and file:sub(i - 1, i - 1) ~= "\\" then
			str = not str
		end

		if str then
			result = result .. character
		else
			if character == "{" or character == "[" then
				space = space + 2
				result = result .. character .. "\n" .. string.rep(" ", space)
			elseif character == "}" or character == "]" then
				space = space - 2
				result = result .. "\n" .. string.rep(" ", space) .. character
			elseif character == "," then
				result = result .. character .. "\n" .. string.rep(" ", space)
			else
				result = result .. character
			end
		end
	end
	return result
end

config = {}
folder = "5eSpells"
filepath = "5eSpells.json"
filepath_RAW = "5eSpells_RAW.json"

function config.modpath(filepath)
    return folder .. '/' .. filepath
end

function config.modpath(filepath_RAW)
    return folder .. '/' .. filepath_RAW
end

function writing()
	local default = '{"Spells":{"Cantrips":{"Enabled":true},"TCoE":{"1st Level":{"Enabled":true},"2nd Level":{"Enabled":true},"3rd Level":{"Enabled":true},"4th Level":{"Enabled":true},"5th Level":{"Enabled":true},"6th Level":{"Enabled":true},"7th Level":{"Enabled":true},"8th Level":{"Enabled":true},"9th Level":{"Enabled":true}},"5e":{"1st Level":{"Enabled":true},"2nd Level":{"Enabled":true},"3rd Level":{"Enabled":true},"4th Level":{"Enabled":true},"5th Level":{"Enabled":true},"6th Level":{"Enabled":true},"7th Level":{"Enabled":true},"8th Level":{"Enabled":true},"9th Level":{"Enabled":true}}}}'
	local defaultraw = '{"RAW Adjustments":{"Spare the Dying":{"Enabled":false},"Raise Dead":{"Enabled":false}}}'
	local defaultJson = formatting(default)
	local defaultRawJson = formatting(defaultraw)
	Ext.IO.SaveFile(config.modpath(filepath), defaultJson)
	Ext.IO.SaveFile(config.modpath(filepath_RAW), defaultRawJson)
end

function reading()
	local status, file = pcall(Ext.IO.LoadFile, config.modpath(filepath))
	local status_raw, file_raw = pcall(Ext.IO.LoadFile, config.modpath(filepath_RAW))
	if not status or not file then
		print(string.format("5eSpells: Creating configuration at %%LOCALAPPDATA%%\\Larian Studios\\Baldur's Gate 3\\Script Extender\\5eSpells\\5eSpells.json"))
		writing()
		status, file = pcall(Ext.IO.LoadFile, config.modpath(filepath))
		if not status or not file then
			print("ERROR: Failed to load config file after writing default config")
			return nil
		end
	end

	if not status_raw or not file_raw then
		print(string.format("5eSpells: Creating configuration at %%LOCALAPPDATA%%\\Larian Studios\\Baldur's Gate 3\\Script Extender\\5eSpells\\5eSpells_RAW.json"))
		writing()
		status_raw, file_raw = pcall(Ext.IO.LoadFile, config.modpath(filepath_RAW))
		if not status_raw or not file_raw then
			print("ERROR: Failed to load config file after writing default config")
			return nil
		end
	end

	local status, result = pcall(Ext.Json.Parse, file)
	if not status then
		return nil
	end
	Table = result

	local status_raw, result_raw = pcall(Ext.Json.Parse, file_raw)
	if not status_raw then
		return nil
	end
	Table_RAW = result_raw
end

reading()

	local tcoe1stconfig = Table["Spells"]["TCoE"]["1st Level"]
	local tcoe2ndconfig = Table["Spells"]["TCoE"]["2nd Level"]
	local tcoe3rdconfig = Table["Spells"]["TCoE"]["3rd Level"]
	local tcoe4thconfig = Table["Spells"]["TCoE"]["4th Level"]
	local tcoe5thconfig = Table["Spells"]["TCoE"]["5th Level"]
	local tcoe6thconfig = Table["Spells"]["TCoE"]["6th Level"]
	local tcoe7thconfig = Table["Spells"]["TCoE"]["7th Level"]
	local tcoe8thconfig = Table["Spells"]["TCoE"]["8th Level"]
	local tcoe9thconfig = Table["Spells"]["TCoE"]["9th Level"]
	local cantripsconfig = Table["Spells"]["Cantrips"]
	local others1stconfig = Table["Spells"]["5e"]["1st Level"]
	local others2ndconfig = Table["Spells"]["5e"]["2nd Level"]
	local others3rdconfig = Table["Spells"]["5e"]["3rd Level"]
	local others4thconfig = Table["Spells"]["5e"]["4th Level"]
	local others5thconfig = Table["Spells"]["5e"]["5th Level"]
	local others6thconfig = Table["Spells"]["5e"]["6th Level"]
	local others7thconfig = Table["Spells"]["5e"]["7th Level"]
	local others8thconfig = Table["Spells"]["5e"]["8th Level"]
	local others9thconfig = Table["Spells"]["5e"]["9th Level"]
	local s5e_std = Table_RAW["RAW Adjustments"]["Spare the Dying"]
	local s5e_rd = Table_RAW["RAW Adjustments"]["Raise Dead"]
	local cantripsenabled = cantripsconfig["Enabled"]
	local tcoe1stlevelenabled = tcoe1stconfig["Enabled"]
	local tcoe2ndlevelenabled = tcoe2ndconfig["Enabled"]
	local tcoe3rdlevelenabled = tcoe3rdconfig["Enabled"]
	local tcoe4thlevelenabled = tcoe4thconfig["Enabled"]
	local tcoe5thlevelenabled = tcoe5thconfig["Enabled"]
	local tcoe6thlevelenabled = tcoe6thconfig["Enabled"]
	local tcoe7thlevelenabled = tcoe7thconfig["Enabled"]
	local tcoe8thlevelenabled = tcoe8thconfig["Enabled"]
	local tcoe9thlevelenabled = tcoe9thconfig["Enabled"]
	local others1stlevelenabled = others1stconfig["Enabled"]
	local others2ndlevelenabled = others2ndconfig["Enabled"]
	local others3rdlevelenabled = others3rdconfig["Enabled"]
	local others4thlevelenabled = others4thconfig["Enabled"]
	local others5thlevelenabled = others5thconfig["Enabled"]
	local others6thlevelenabled = others6thconfig["Enabled"]
	local others7thlevelenabled = others7thconfig["Enabled"]
	local others8thlevelenabled = others8thconfig["Enabled"]
	local others9thlevelenabled = others9thconfig["Enabled"]
	local s5e_stdenabled = s5e_std["Enabled"]
	local s5e_rdenabled = s5e_rd["Enabled"]
	if	cantripsenabled == true then
		print(string.format("5eSpells: Cantrips from 5eSpells are removed from spell lists."))
		S5E_SpellLists(cantripspells)
	end

	if	tcoe1stlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 1st level spells are removed from spell lists."))
		S5E_SpellLists(tcoe1stlevelspells)
	end

	if	tcoe2ndlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 2nd level spells are removed from spell lists."))
		S5E_SpellLists(tcoe2ndlevelspells)
	end
	
	if	tcoe3rdlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 3rd level spells are removed from spell lists."))
		S5E_SpellLists(tcoe3rdlevelspells)
	end

	if	tcoe4thlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 4th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe4thlevelspells)
	end
	
	if	tcoe5thlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 5th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe5thlevelspells)
	end

	if	tcoe6thlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 6th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe6thlevelspells)
	end
	
	if	tcoe7thlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 7th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe7thlevelspells)
	end
	
	if	tcoe8thlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 8th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe8thlevelspells)
	end
	
	if	tcoe9thlevelenabled == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 9th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe9thlevelspells)
	end

	if	others1stlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 1st level spells are removed from spell lists."))
		S5E_SpellLists(others1stlevelspells)
	end

	if	others2ndlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 2nd level spells are removed from spell lists."))
		S5E_SpellLists(others2ndlevelspells)
	end

	if	others3rdlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 3rd level spells are removed from spell lists."))
		S5E_SpellLists(others3rdlevelspells)
	end

	if	others4thlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 4th level spells are removed from spell lists."))
		S5E_SpellLists(others4thlevelspells)
	end

	if	others5thlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 5th level spells are removed from spell lists."))
		S5E_SpellLists(others5thlevelspells)
	end

	if	others6thlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 6th level spells are removed from spell lists."))
		S5E_SpellLists(others6thlevelspells)
	end

	if	others7thlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 7th level spells are removed from spell lists."))
		S5E_SpellLists(others7thlevelspells)
	end

	if	others8thlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 8th level spells are removed from spell lists."))
		S5E_SpellLists(others8thlevelspells)
	end

	if	others9thlevelenabled == true then
		print(string.format("5eSpells: Additional 5e Spells 9th level spells are removed from spell lists."))
		S5E_SpellLists(others9thlevelspells)
	end

	if	s5e_stdenabled == true then
		print(string.format("5eSpells: Modifying the Help action."))
		S5E_SpareTheDying()
	end

	if	s5e_rdenabled == true then
		print(string.format("5eSpells: Modifying the Revivify spell and the scroll."))
		S5E_RaiseDead()
	end--]]


local function OnStatsLoaded()
    Vars = {
        Cantrips = MCMGet("Cantrips"),
        TCoE1st = MCMGet("TCoE1st"),
        TCoE2nd = MCMGet("TCoE2nd"),
        TCoE3rd = MCMGet("TCoE3rd"),
        TCoE4th = MCMGet("TCoE4th"),
        TCoE5th = MCMGet("TCoE5th"),
        TCoE6th = MCMGet("TCoE6th"),
        TCoE7th = MCMGet("TCoE7th"),
        TCoE8th = MCMGet("TCoE8th"),
        TCoE9th = MCMGet("TCoE9th"),
        S5e1st = MCMGet("5e1st"),
        S5e2nd = MCMGet("5e2nd"),
        S5e3rd = MCMGet("5e3rd"),
        S5e4th = MCMGet("5e4th"),
        S5e5th = MCMGet("5e5th"),
        S5e6th = MCMGet("5e6th"),
        S5e7th = MCMGet("5e7th"),
        S5e8th = MCMGet("5e8th"),
        S5e9th = MCMGet("5e9th"),
        SparetheDying = MCMGet("SparetheDying"),
        RaiseDead = MCMGet("RaiseDead"),
        BoomingBladeChange = MCMGet("BoomingBladeChange")
    }

	if	Vars["Cantrips"] == true then
		print(string.format("5eSpells: Cantrips from 5eSpells are removed from spell lists."))
		S5E_SpellLists(cantripspells)
	elseif	Vars["Cantrips"] ~= true  then
		print(string.format("5eSpells: Cantrips from 5eSpells remain on spell lists."))
		S5E_SpellListsReadd(cantripspells)
	end

	if	Vars["TCoE1st"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 1st level spells are removed from spell lists."))
		S5E_SpellLists(tcoe1stlevelspells)
	elseif	Vars["TCoE1st"] ~= true  then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 1st level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe1stlevelspells)
	end

	if	Vars["TCoE2nd"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 2nd level spells are removed from spell lists."))
		S5E_SpellLists(tcoe2ndlevelspells)
	elseif	Vars["TCoE2nd"] ~= true  then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 2nd level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe2ndlevelspells)
	end
	
	if	Vars["TCoE3rd"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 3rd level spells are removed from spell lists."))
		S5E_SpellLists(tcoe3rdlevelspells)
	elseif	Vars["TCoE3rd"] ~= true  then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 3rd level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe3rdlevelspells)
	end

	if	Vars["TCoE4th"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 4th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe4thlevelspells)
	elseif	Vars["TCoE4th"] ~= true  then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 4th level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe4thlevelspells)
	end
	
	if	Vars["TCoE5th"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 5th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe5thlevelspells)
	elseif	Vars["TCoE5th"] ~= true  then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 5th level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe5thlevelspells)
	end

	if	Vars["TCoE6th"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 6th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe6thlevelspells)
	elseif	Vars["TCoE6th"] ~= true  then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 6th level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe6thlevelspells)
	end
	
	if	Vars["TCoE7th"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 7th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe7thlevelspells)
	elseif	Vars["TCoE7th"] ~= true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 7th level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe7thlevelspells)
	end
	
	if	Vars["TCoE8th"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 8th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe8thlevelspells)
	elseif	Vars["TCoE8th"] ~= true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 8th level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe8thlevelspells)
	end
	
	if	Vars["TCoE9th"] == true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 9th level spells are removed from spell lists."))
		S5E_SpellLists(tcoe9thlevelspells)
	elseif	Vars["TCoE9th"] ~= true then
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 9th level spells remain on spell lists."))
		S5E_SpellListsReadd(tcoe9thlevelspells)
	end

	if	Vars["S5e1st"] == true then
		print(string.format("5eSpells: Additional 5e Spells 1st level spells are removed from spell lists."))
		S5E_SpellLists(others1stlevelspells)
	elseif	Vars["S5e1st"] ~= true then
		print(string.format("5eSpells: 5e 1st level spells remain on spell lists."))
		S5E_SpellListsReadd(others1stlevelspells)
	end

	if	Vars["S5e2nd"] == true then
		print(string.format("5eSpells: Additional 5e Spells 2nd level spells are removed from spell lists."))
		S5E_SpellLists(others2ndlevelspells)
	elseif	Vars["S5e2nd"] ~= true then
		print(string.format("5eSpells: 5e 2nd level spells remain on spell lists."))
		S5E_SpellListsReadd(others2ndlevelspells)
	end

	if	Vars["S5e3rd"] == true then
		print(string.format("5eSpells: Additional 5e Spells 3rd level spells are removed from spell lists."))
		S5E_SpellLists(others3rdlevelspells)
	elseif	Vars["S5e3rd"] ~= true  then
		print(string.format("5eSpells: 5e 3rd level spells remain on spell lists."))
		S5E_SpellListsReadd(others3rdlevelspells)
	end

	if	Vars["S5e4th"] == true then
		print(string.format("5eSpells: Additional 5e Spells 4th level spells are removed from spell lists."))
		S5E_SpellLists(others4thlevelspells)
	elseif	Vars["S5e4th"] ~= true then
		print(string.format("5eSpells: 5e 4th level spells remain on spell lists."))
		S5E_SpellListsReadd(others4thlevelspells)
	end

	if	Vars["S5e5th"] == true then
		print(string.format("5eSpells: Additional 5e Spells 5th level spells are removed from spell lists."))
		S5E_SpellLists(others5thlevelspells)
	elseif	Vars["S5e5th"] ~= true then
		print(string.format("5eSpells: 5e 5th level spells remain on spell lists."))
		S5E_SpellListsReadd(others5thlevelspells)
	end

	if	Vars["S5e6th"] == true then
		print(string.format("5eSpells: Additional 5e Spells 6th level spells are removed from spell lists."))
		S5E_SpellLists(others6thlevelspells)
	elseif	Vars["S5e6th"] ~= true then
		print(string.format("5eSpells: 5e 6th level spells remain on spell lists."))
		S5E_SpellListsReadd(others6thlevelspells)
	end

	if	Vars["S5e7th"] == true then
		print(string.format("5eSpells: Additional 5e Spells 7th level spells are removed from spell lists."))
		S5E_SpellLists(others7thlevelspells)
	elseif	Vars["S5e7th"] ~= true then
		print(string.format("5eSpells: 5e 7th level spells remain on spell lists."))
		S5E_SpellListsReadd(others7thlevelspells)
	end

	if	Vars["S5e8th"] == true then
		print(string.format("5eSpells: Additional 5e Spells 8th level spells are removed from spell lists."))
		S5E_SpellLists(others8thlevelspells)
	elseif	Vars["S5e8th"] ~= true  then
		print(string.format("5eSpells: 5e 8th level spells remain on spell lists."))
		S5E_SpellListsReadd(others8thlevelspells)
	end

	if	Vars["S5e9th"] == true then
		print(string.format("5eSpells: Additional 5e Spells 9th level spells are removed from spell lists."))
		S5E_SpellLists(others9thlevelspells)
	elseif	Vars["S5e9th"] ~= true then
		print(string.format("5eSpells: 5e 9th level spells remain on spell lists."))
		S5E_SpellListsReadd(others9thlevelspells)
	end

	if	Vars["SparetheDying"] == true then
		print(string.format("5eSpells: Modifying the Help action."))
		S5E_SpareTheDying()
	elseif	Vars["SparetheDying"] ~= true then
		print(string.format("5eSpells: Keeping the Help action as is in the base game."))
		S5E_SpareTheDyingRevert()
	end

	if	Vars["RaiseDead"] == true then
		print(string.format("5eSpells: Modifying the Revivify spell and the scroll."))
		S5E_RaiseDead()
	elseif	Vars["RaiseDead"] ~= true then
		print(string.format("5eSpells: Keeping Revivify as is in the base game."))
		S5E_RaiseDeadRevert()
	end--]]

	if	Vars["BoomingBladeChange"] == true then
		print(string.format("5eSpells: Removing Larian's version of Booming Blade."))
		for _, uuid in pairs(boomingbladeLarianSpellLists) do
			local list = Ext.StaticData.Get(uuid, "SpellList").Spells
			for v, spell in pairs(list) do
				if "Target_BoomingBlade_ClassSpell" == spell then
					spellLists = Ext.Types.Serialize(list)
					table.remove(spellLists, v)
					Ext.Types.Unserialize(list, spellLists)
				end
			end
		end
	elseif	Vars["BoomingBladeChange"] ~= true then
		print(string.format("5eSpells: Removing 5e Spell's version of Booming Blade."))
		for _, uuid in pairs(boomingblade5eSpellLists) do
			local list = Ext.StaticData.Get(uuid, "SpellList").Spells
			for v, spell in pairs(list) do
				if "Target_BoomingBlade_5e" == spell then
					spellLists = Ext.Types.Serialize(list)
					table.remove(spellLists, v)
					Ext.Types.Unserialize(list, spellLists)
				end
			end
		end
	end
end
Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)

Ext.ModEvents.BG3MCM["MCM_Setting_Saved"]:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end

    if payload.settingId == "Cantrips" then
		if payload.value == true then
			S5E_SpellLists(cantripspells)
			print(string.format("5eSpells: Cantrips from 5eSpells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(cantripspells)
			print(string.format("5eSpells: Cantrips from 5eSpells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE1st" then
		if payload.value == true then
			S5E_SpellLists(tcoe1stlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 1st level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe1stlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 1st level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE2nd" then
		if payload.value == true then
			S5E_SpellLists(tcoe2ndlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 2nd level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe2ndlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 2nd level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE3rd" then
		if payload.value == true then
			S5E_SpellLists(tcoe3rdlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 3rd level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe3rdlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 3rd level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE4th" then
		if payload.value == true then
			S5E_SpellLists(tcoe4thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 4th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe4thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 4th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE5th" then
		if payload.value == true then
			S5E_SpellLists(tcoe5thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 5th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe5thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 5th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE6th" then
		if payload.value == true then
			S5E_SpellLists(tcoe6thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 6th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe6thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 6th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE7th" then
		if payload.value == true then
			S5E_SpellLists(tcoe7thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 7th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe7thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 7th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE8th" then
		if payload.value == true then
			S5E_SpellLists(tcoe8thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 8th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe8thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 8th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "TCoE9th" then
		if payload.value == true then
			S5E_SpellLists(tcoe9thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 9th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(tcoe9thlevelspells)
			print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 9th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e1st" then
		if payload.value == true then
			S5E_SpellLists(others1stlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 1st level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others1stlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 1st level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e2nd" then
		if payload.value == true then
			S5E_SpellLists(others2ndlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 2nd level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others2ndlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 2nd level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e3rd" then
		if payload.value == true then
			S5E_SpellLists(others3rdlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 3rd level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others3rdlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 3rd level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e4th" then
		if payload.value == true then
			S5E_SpellLists(others4thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 4th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others4thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 4th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e5th" then
		if payload.value == true then
			S5E_SpellLists(others5thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 5th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others5thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 5th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e6th" then
		if payload.value == true then
			S5E_SpellLists(others6thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 6th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others6thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 6th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e7th" then
		if payload.value == true then
			S5E_SpellLists(others7thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 7th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others7thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 7th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e8th" then
		if payload.value == true then
			S5E_SpellLists(others8thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 8th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others8thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 8th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "S5e9th" then
		if payload.value == true then
			S5E_SpellLists(others9thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 9th level spells are removed from spell lists."))
		elseif payload.value == false then	
			S5E_SpellListsReadd(others9thlevelspells)
			print(string.format("5eSpells: Additional 5e Spells 9th level spells remain on spell lists."))
		end
    end

    if payload.settingId == "SparetheDying" then
		if payload.value == true then
			S5E_SpareTheDying()
			print(string.format("5eSpells: Modifying the Help action."))
		elseif payload.value == false then	
			S5E_SpareTheDyingRevert()
			print(string.format("5eSpells: Keeping the Help action as is in the base game."))
		end
    end

    if payload.settingId == "RaiseDead" then
		if payload.value == true then
			S5E_RaiseDead()
			print(string.format("5eSpells: Modifying the Revivify spell and the scroll."))
		elseif payload.value == false then	
			S5E_RaiseDeadRevert()
			print(string.format("5eSpells: Keeping Revivify as is in the base game."))
		end
    end

    if payload.settingId == "BoomingBladeChange" then
		if payload.value == true then
		S5E_SpellLists(boomingbladeLarianSpells)
--		S5E_SpellListsReadd(boomingblade5eSpells)
		print(string.format("5eSpells: Removing Larian's version of Booming Blade."))
		elseif payload.value == false then	
		print(string.format("5eSpells: Removing 5e Spell's version of Booming Blade."))
		S5E_SpellLists(boomingblade5eSpells)
--		S5E_SpellListsReadd(boomingbladeLarianSpells)
		end
    end
end)

Ext.ModEvents.BG3MCM["MCM_Setting_Reset"]:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end

    if payload.settingId == "Cantrips" then
		S5E_SpellLists(cantripspells)
		print(string.format("5eSpells: Cantrips from 5eSpells are removed from spell lists."))
    end

    if payload.settingId == "TCoE1st" then
		S5E_SpellLists(tcoe1stlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 1st level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE2nd" then
		S5E_SpellLists(tcoe2ndlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 2nd level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE3rd" then
		S5E_SpellLists(tcoe3rdlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 3rd level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE4th" then
		S5E_SpellLists(tcoe4thlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 4th level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE5th" then
		S5E_SpellLists(tcoe5thlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 5th level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE6th" then
		S5E_SpellLists(tcoe6thlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 6th level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE7th" then
		S5E_SpellLists(tcoe7thlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 7th level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE8th" then
		S5E_SpellLists(tcoe8thlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 8th level spells are removed from spell lists."))
    end

    if payload.settingId == "TCoE9th" then
		S5E_SpellLists(tcoe9thlevelspells)
		print(string.format("5eSpells: Tasha's Calduron of Everything (TCoE) 9th level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e1st" then
		S5E_SpellLists(others1stlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 1st level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e2nd" then
		S5E_SpellLists(others2ndlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 2nd level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e3rd" then
		S5E_SpellLists(others3rdlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 3rd level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e4th" then
		S5E_SpellLists(others4thlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 4th level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e5th" then
		S5E_SpellLists(others5thlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 5th level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e6th" then
		S5E_SpellLists(others6thlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 6th level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e7th" then
		S5E_SpellLists(others7thlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 7th level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e8th" then
		S5E_SpellLists(others8thlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 8th level spells are removed from spell lists."))
    end

    if payload.settingId == "S5e9th" then
		S5E_SpellLists(others9thlevelspells)
		print(string.format("5eSpells: Additional 5e Spells 9th level spells are removed from spell lists."))
    end

    if payload.settingId == "SparetheDying" then
		S5E_SpareTheDying()
		print(string.format("5eSpells: Modifying the Help action."))
    end

    if payload.settingId == "RaiseDead" then
		S5E_RaiseDead()
		print(string.format("5eSpells: Modifying the Revivify spell and the scroll."))
    end

    if payload.settingId == "BoomingBladeChange" then
		print(string.format("5eSpells: Removing Larian's version of Booming Blade."))
		S5E_SpellLists(boomingbladeLarianSpells)
		S5E_SpellListsReadd(boomingblade5eSpells)
    end
end)

function S5E_SpellListsReadd(additions)
	if additions ~= nil then
		for _, add in pairs(additions) do
			if add ~= nil then
				local spellList = Spells["SpellList"]
				local list = Ext.StaticData.Get(add.SpellListID, "SpellList")
                list[spellList] = Set(list[spellList], add.Spells)
			end
		end
	end
end

function S5E_SpellLists(removals)
	if removals ~= nil then
		for _, rev in pairs(removals) do
			if rev ~= nil then
				local spellList = Spells["SpellList"]
				local list = Ext.StaticData.Get(rev.SpellListID, "SpellList").Spells
				for _, spells in pairs(rev.Spells) do
					for v, spell in pairs(list) do
						if spells == spell then
							spellLists = Ext.Types.Serialize(list)
							table.remove(spellLists, v)
							Ext.Types.Unserialize(list, spellLists)
						end
					end
				end
			end
		end
	end
end

function Set(spelllist, spells)
  local result = {}
  local num = 0

  if spelllist ~= nil and spells ~= nil then
    result, num = Insert(spelllist, result, num)
    result, num = Insert(spells, result, num)
  end

  return result
end

function InTable(list, val)
  if list ~= nil then
    for _, value in pairs(list) do
      if val == value then
        return true
      end
    end
  end
  return false
end

function Insert(list, result, num)
	for _, value in pairs(list) do
		if not InTable(result, value) then
		  result[num] = value
		  num = num + 1
		end
	end
	return result, num
end

function Remove(list, result, num)
	for _, value in pairs(list) do
		if InTable(result, value) then
		  result[num] = value
		  num = num - 1
		end
	end
	return result, num
end

-- Static Data helpers
function S5E_ApplyStaticData(defTable)
    for defType, defList in pairs(defTable) do
        for guid, changes in pairs (defList) do
            local resource = Ext.StaticData.Get(guid, defType)
            for attribute, replacement in pairs(changes) do
                local newValue
                if type(resource[attribute]) == "userdata"  then
                    if replacement.Type == "add" then
                        newValue = Ext.Types.Serialize(resource[attribute])
                        for _, value in pairs(replacement.Value) do
                            table.insert(newValue, value)
                        end
                    end
                    Ext.Types.Unserialize(resource[attribute], newValue)
                end
            end
        end
    end
end

local function S5E_StatsLoaded()
	S5E_Changes()
end

Ext.Events.StatsLoaded:Subscribe(S5E_StatsLoaded)