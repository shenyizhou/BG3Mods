--[[ Certain weapons Kensei can use as Monk Weapons will not be factored into MonkWeaponDamageDiceOverride, so we need to set them manually

Debug = false

local ProficiencyGroupBitFlags = {
    Battleaxes = 1,
    Clubs = 2,
    Daggers = 4,
    Darts = 8,
    Flails = 16,
    Glaives = 32,
    Greataxes = 64,
    Greatclubs = 128,
    Greatswords = 256,
    Halberds = 512,
    HandCrossbows = 1024,
    Handaxes = 2048,
    HeavyArmor = 4096,
    HeavyCrossbows = 8192,
    Javelins = 16384,
    LightArmor = 32768,
    LightCrossbows = 65536,
    LightHammers = 131072,
    Longbows = 262144,
    Longswords = 524288,
    Maces = 1048576,
    MartialWeapons = 2097152,
    Mauls = 4194304,
    MediumArmor = 8388608,
    Morningstars = 16777216,
    Pikes = 33554432,
    Quarterstaffs = 67108864,
    Rapiers = 134217728,
    Scimitars = 268435456,
    Shields = 536870912,
    Shortbows = 1073741824,
    Shortswords = 2147483648,
    Sickles = 4294967296,
    SimpleWeapons = 8589934592,
    Slings = 17179869184,
    Spears = 34359738368,
    Tridents = 68719476736,
    Warhammers = 137438953472,
    Warpicks = 274877906944,
    MusicalInstrument = 549755813888
}

local function KDelayedCall(delayInMs, func)
    local startTime = Ext.Utils.MonotonicTime()
    local handlerId;
    handlerId = Ext.Events.Tick:Subscribe(function()
        local endTime = Ext.Utils.MonotonicTime()
        if (endTime - startTime > delayInMs) then
            Ext.Events.Tick:Unsubscribe(handlerId)
            func()
        end
    end) 
end

function KenseiWeaponOverride(weapon, wielder)
	local proficiencyGroups = Ext.Entity.Get(weapon).ProficiencyGroup.Flags
	--local weaponProperties = Ext.Entity.Get(weapon).Weapon.WeaponProperties
			
	if (proficiencyGroups & ProficiencyGroupBitFlags["Darts"] == ProficiencyGroupBitFlags["Darts"] and Osi.HasActiveStatus(wielder,"KENSEI_WEAPONS_RANGED_DARTS") == 1) or 
	   (proficiencyGroups & ProficiencyGroupBitFlags["Greatclubs"] == ProficiencyGroupBitFlags["Greatclubs"] and Osi.HasActiveStatus(wielder,"KENSEI_WEAPONS_MELEE_GREATCLUBS") == 1) or 
	   (proficiencyGroups & ProficiencyGroupBitFlags["LightCrossbows"] == ProficiencyGroupBitFlags["LightCrossbows"] and Osi.HasActiveStatus(wielder,"KENSEI_WEAPONS_RANGED_LIGHTCROSSBOWS") == 1) or 
	   (proficiencyGroups & ProficiencyGroupBitFlags["Longbows"] == ProficiencyGroupBitFlags["Longbows"] and Osi.HasActiveStatus(wielder,"KENSEI_WEAPONS_RANGED_LONGBOWS") == 1) or 
	   (proficiencyGroups & ProficiencyGroupBitFlags["Shortbows"] == ProficiencyGroupBitFlags["Shortbows"] and Osi.HasActiveStatus(wielder,"KENSEI_WEAPONS_RANGED_SHORTBOWS") == 1) or 
	   (proficiencyGroups & ProficiencyGroupBitFlags["Slings"] == ProficiencyGroupBitFlags["Slings"] and Osi.HasActiveStatus(wielder,"KENSEI_WEAPONS_RANGED_SLINGS") == 1) then 
		return true
	else
		return false
	end
end

local weaponInfo = {
	KENSEI_WEAPONS_RANGED_DARTS = "WPN_DART_c23ac9ef-5b47-4c2d-8ce5-7b60a8b34787",
	KENSEI_WEAPONS_MELEE_GREATCLUBS = "WPN_GREATCLUB_ab44887d-0eb0-4fef-bd9d-943ea8971aa2",
	KENSEI_WEAPONS_RANGED_LIGHTCROSSBOWS = "WPN_LIGHT_CROSSBOW_a302a8e2-a3f9-41e1-a68c-70a453e65399",
	KENSEI_WEAPONS_RANGED_LONGBOWS = "WPN_LONGBOW_557d335c-0780-4665-9802-709a7d202dba",
	KENSEI_WEAPONS_RANGED_SHORTBOWS = "WPN_SHORTBOW_81197304-7116-4d7b-8ef4-207bbf636682"
}

local weapond6Tags = {
	KENSEI_WEAPONS_RANGED_DARTS = "WPN_DART_c23ac9ef-5b47-4c2d-8ce5-7b60a8b34787"
}

local weapond8Tags = {
	KENSEI_WEAPONS_RANGED_DARTS = "WPN_DART_c23ac9ef-5b47-4c2d-8ce5-7b60a8b34787",
	KENSEI_WEAPONS_MELEE_FLAILS = "WPN_FLAIL_5d7b1304-6d20-4d60-ba1b-0fbb491bfc18",
	KENSEI_WEAPONS_RANGED_HANDCROSSBOWS = "WPN_HAND_CROSSBOW_1c12ee6d-50e2-459f-90c8-ae56701190ce",
	KENSEI_WEAPONS_MELEE_SCIMITARS = "WPN_SCIMITAR_206f9701-7b24-4eaf-9ac4-a47746c251e2",
	KENSEI_WEAPONS_RANGED_SHORTBOWS = "WPN_SHORTBOW_81197304-7116-4d7b-8ef4-207bbf636682",
	KENSEI_WEAPONS_MELEE_TRIDENTS = "WPN_TRIDENT_c808f076-4a0f-422a-97db-e985ce35f3f9"
}

local weapond10Tags = {
	KENSEI_WEAPONS_MELEE_BATTLEAXES = "WPN_BATTLEAXE_7609654e-b213-410d-b08f-6d2930da6411",
	KENSEI_WEAPONS_RANGED_DARTS = "WPN_DART_c23ac9ef-5b47-4c2d-8ce5-7b60a8b34787",
	KENSEI_WEAPONS_MELEE_FLAILS = "WPN_FLAIL_5d7b1304-6d20-4d60-ba1b-0fbb491bfc18",
	KENSEI_WEAPONS_MELEE_GREATCLUBS = "WPN_GREATCLUB_ab44887d-0eb0-4fef-bd9d-943ea8971aa2",
	KENSEI_WEAPONS_RANGED_HANDCROSSBOWS = "WPN_HAND_CROSSBOW_1c12ee6d-50e2-459f-90c8-ae56701190ce",
	KENSEI_WEAPONS_RANGED_LIGHTCROSSBOWS = "WPN_LIGHT_CROSSBOW_a302a8e2-a3f9-41e1-a68c-70a453e65399",
	KENSEI_WEAPONS_RANGED_LONGBOWS = "WPN_LONGBOW_557d335c-0780-4665-9802-709a7d202dba",
	KENSEI_WEAPONS_MELEE_LONGSWORDS = "WPN_LONGSWORD_96a99a42-ec5d-4081-9d62-c9e3f0057136",
	KENSEI_WEAPONS_MELEE_MORNINGSTARS = "WPN_MORNINGSTAR_aa4cfcea-aee8-44b9-a460-e7231df796b1",
	KENSEI_WEAPONS_MELEE_RAPIERS = "WPN_RAPIER_aeaf4e95-38d7-45ec-8900-40bc9e6106b0",
	KENSEI_WEAPONS_MELEE_SCIMITARS = "WPN_SCIMITAR_206f9701-7b24-4eaf-9ac4-a47746c251e2",
	KENSEI_WEAPONS_RANGED_SHORTBOWS = "WPN_SHORTBOW_81197304-7116-4d7b-8ef4-207bbf636682",
	KENSEI_WEAPONS_MELEE_TRIDENTS = "WPN_TRIDENT_c808f076-4a0f-422a-97db-e985ce35f3f9",
	KENSEI_WEAPONS_MELEE_WARHAMMERS = "WPN_WARHAMMER_1dff197e-b74c-4173-94d3-e1323239556c",
	KENSEI_WEAPONS_MELEE_WARPICKS = "WPN_WAR_PICK_eed87cdb-c5ee-45c2-9a5a-6949dce87a1e"
}

-- Kensei Weapon Override
Ext.Osiris.RegisterListener("LeveledUp", 1, "after", function(character)
	KDelayedCall(500, function ()
		if IsTagged(character,"MONK_5EKENSEI_3adb6cd0-1543-430f-bccf-8aaf2df0dab0") == 1 then
			
			if (Debug) then
				_P('-------------------------------------------------------------')
				_P('-- Character is 5e Kensei')
				_P('\n\n\n')
			end 
			
			Osi.IterateInventory(character,"CheckKenseiWeapons","CompleteKenseiWeaponCheck")
		end	
	end)	
end)		

-- Override Kensei Weapon on Inventory Check
Ext.Osiris.RegisterListener("EntityEvent", 2, "after", function(item, event)
	if event == "CheckKenseiWeapons" and Osi.IsWeapon(item) == 1 then
		local character = Osi.GetInventoryOwner(item)	
		for status,tag in pairs(weaponInfo) do

			if (Debug) then
				_P('-------------------------------------------------------------')
				_P('-- Override Kensei Weapon:')
				_D(item)
				_P('\n\n\n')
			end 		

			if Osi.IsTagged(item,tag) == 1 and Osi.HasActiveStatus(character,status) == 1 then
				for wepstatus,weapontag in pairs(weapond6Tags) do
					for wepstatus2,weapontag2 in pairs(weapond8Tags) do
						for wepstatus3,weapontag3 in pairs(weapond10Tags) do
							if Osi.HasPassive(character,"KenseiLevel_5") == 1 and Osi.HasActiveStatus(character,wepstatus) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D6") == 0 and Osi.IsTagged(item,weapontag) == 1 then
								Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D6",-1.0,1)
							elseif Osi.HasPassive(character,"KenseiLevel_11") == 1 and Osi.HasActiveStatus(character,wepstatus2) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D8") == 0 and Osi.IsTagged(item,weapontag2) == 1 then
								Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D8",-1.0,1)
							elseif Osi.HasPassive(character,"KenseiLevel_17") == 1 and Osi.HasActiveStatus(character,wepstatus3) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D10") == 0 and Osi.IsTagged(item,weapontag3) == 1 then
								Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D10",-1.0,1)
							end
						end
					end
				end
			end
		end
	end
end)

-- Override Kensei Weapon on Equip
Ext.Osiris.RegisterListener("Equipped", 2, "after", function(item, character)	
	if Osi.IsPlayer(character) == 1 and Osi.IsTagged(character,"MONK_5EKENSEI_3adb6cd0-1543-430f-bccf-8aaf2df0dab0") == 1 then
		for status,tag in pairs(weaponInfo) do
			for wepstatus,weapontag in pairs(weapond6Tags) do
				for wepstatus2,weapontag2 in pairs(weapond8Tags) do
					for wepstatus3,weapontag3 in pairs(weapond10Tags) do
						if Osi.HasPassive(character,"KenseiLevel_5") == 1 and Osi.HasActiveStatus(character,wepstatus) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D6") == 0 and Osi.IsTagged(item,weapontag) == 1 then
							Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D6",-1.0,1)
						elseif Osi.HasPassive(character,"KenseiLevel_11") == 1 and Osi.HasActiveStatus(character,wepstatus2) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D8") == 0 and Osi.IsTagged(item,weapontag2) == 1 then
							Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D8",-1.0,1)
						elseif Osi.HasPassive(character,"KenseiLevel_17") == 1 and Osi.HasActiveStatus(character,wepstatus3) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D10") == 0 and Osi.IsTagged(item,weapontag3) == 1 then
							Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D10",-1.0,1)
						end
					end
				end
			end
		end
	end
end)

-- Override Kensei Weapon on Add
Ext.Osiris.RegisterListener("AddedTo", 3, "after", function(item, character, _)
	if Osi.IsPlayer(character) == 1 and Osi.IsTagged(character,"MONK_5EKENSEI_3adb6cd0-1543-430f-bccf-8aaf2df0dab0") == 1 then
		for status,tag in pairs(weaponInfo) do
			for wepstatus,weapontag in pairs(weapond6Tags) do
				for wepstatus2,weapontag2 in pairs(weapond8Tags) do
					for wepstatus3,weapontag3 in pairs(weapond10Tags) do
						if Osi.HasPassive(character,"KenseiLevel_5") == 1 and Osi.HasActiveStatus(character,wepstatus) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D6") == 0 and Osi.IsTagged(item,weapontag) == 1 then
							Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D6",-1.0,1)
						elseif Osi.HasPassive(character,"KenseiLevel_11") == 1 and Osi.HasActiveStatus(character,wepstatus2) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D8") == 0 and Osi.IsTagged(item,weapontag2) == 1 then
							Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D8",-1.0,1)
						elseif Osi.HasPassive(character,"KenseiLevel_17") == 1 and Osi.HasActiveStatus(character,wepstatus3) == 1 and Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D10") == 0 and Osi.IsTagged(item,weapontag3) == 1 then
							Osi.ApplyStatus(item,"KENSEI_WEAPON_OVERRIDE_D10",-1.0,1)
						end
					end
				end
			end
		end
	end
end)

-- Revert Kensei Weapon on Drop/Remove
Ext.Osiris.RegisterListener("RemovedFrom", 2, "after", function(item, character)
	if Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D6") == 1 then
		Osi.RemoveStatus(item,"KENSEI_WEAPON_OVERRIDE_D6")
	end

	if Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D8") == 1 then
		Osi.RemoveStatus(item,"KENSEI_WEAPON_OVERRIDE_D8")
	end
	
	if Osi.HasActiveStatus(item,"KENSEI_WEAPON_OVERRIDE_D10") == 1 then
		Osi.RemoveStatus(item,"KENSEI_WEAPON_OVERRIDE_D10")
	end	
end)--]]