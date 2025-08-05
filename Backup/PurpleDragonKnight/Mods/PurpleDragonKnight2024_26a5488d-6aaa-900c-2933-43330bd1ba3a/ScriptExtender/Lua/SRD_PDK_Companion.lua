
local function SRD_PurpleDragon_EnteredCombat(object, combatGuid)

	local pdk = ""
	local byTagTable = ""
	local pdkUuid = ""
	local dragonUuid = ""
	
	if not SRD_IsNullUUID(object) and Osi.IsPartyMember(object, 0) == 1 and Osi.HasActiveStatus(object, "STALWART_BOND_TECHNICAL") == 1 then 
		local pdk = Ext.Entity.Get(object)
		if (Debug) then
			_P('-------------------------------------------------------------')
			_D(object)
			_P('-- Entered combat')
			_P('-- Knight summons are')
			_D(pdk.SummonContainer.ByTag)
			_P('\n\n\n')
		end
		
		if pdk.SummonContainer ~= nil and pdk.SummonContainer.ByTag ~= nil then 
			local byTagTable = pdk.SummonContainer.ByTag
			
			for key, entityList in pairs(byTagTable) do
				if key == "'PurpleDragonStack'" then
					for i,entity in ipairs(entityList) do
						if (Debug) then
							_P("-- ", object, "has purple dragon companion")
							_P("Key:", key, "Entity:", entity)
							_P('\n\n\n')
						end
						
						local dragonUuid = Ext.Entity.HandleToUuid(entity)
						local pdkUuid = string.sub(object, -36)
						if (Debug) then
							_P('-- Purple dragon UUID is')
							_D(dragonUuid)
							_P('-- Knight UUID is')
							_D(pdkUuid)
							_P('\n\n\n')
						end									
						
						SRD_ShareInitiative(pdkUuid, dragonUuid)
					end
				end
			end
		end	
		
	elseif not SRD_IsNullUUID(object) and Osi.IsSummon(object) == 1 and Osi.CombatGetGuidFor(Osi.CharacterGetOwner(object)) ~= nil and Osi.HasActiveStatus(object, "STALWART_BOND") == 1 then
		--local double = Ext.Entity.Get(object)
		if (Debug) then
			_P('-------------------------------------------------------------')
			_D(object)
			_P('-- Entered combat')
			_P('\n\n\n')
		end		
		
		local pdkUuid = Osi.CharacterGetOwner(object)
		local dragonUuid = string.sub(object, -36)	
		
		if (Debug) then
			_P("-- ", object, "is purple dragon summoned by")
			_D(pdkUuid)
			_P('\n\n\n')
		end			
		
		SRD_ShareInitiative(pdkUuid, dragonUuid)
		
	end
end			







Ext.Osiris.RegisterListener("EnteredCombat", 2, "after", SRD_PurpleDragon_EnteredCombat)
