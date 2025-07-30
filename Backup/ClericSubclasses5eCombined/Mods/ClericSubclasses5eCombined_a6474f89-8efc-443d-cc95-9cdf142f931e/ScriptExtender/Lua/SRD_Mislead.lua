
local function SRD_Mislead_EnteredCombat(object, combatGuid)

	local caster = ""
	--local double = ""
	local byTagTable = ""
	local casterUuid = ""
	local doubleUuid = ""
	local casterUuid = ""
	
	if not SRD_IsNullUUID(object) and Osi.IsPartyMember(object, 0) == 1 and Osi.HasActiveStatus(object, "MISLEAD_TECHNICAL") == 1 then 
		local caster = Ext.Entity.Get(object)
		if (Debug) then
			_P('-------------------------------------------------------------')
			_D(object)
			_P('-- Entered combat')
			_P('-- Caster summons are')
			_D(caster.SummonContainer.ByTag)
			_P('\n\n\n')
		end
		
		if caster.SummonContainer ~= nil and caster.SummonContainer.ByTag ~= nil then 
			local byTagTable = caster.SummonContainer.ByTag
			
			for key, entityList in pairs(byTagTable) do
				if key == "'MisleadStack'" then
					for i,entity in ipairs(entityList) do
						if (Debug) then
							_P("-- ", object, "has Mislead illusory double")
							_P("Key:", key, "Entity:", entity)
							_P('\n\n\n')
						end
						
						local doubleUuid = Ext.Entity.HandleToUuid(entity)
						local casterUuid = string.sub(object, -36)
						if (Debug) then
							_P('-- Illusory double UUID is')
							_D(doubleUuid)
							_P('-- Caster UUID is')
							_D(casterUuid)
							_P('\n\n\n')
						end									
						
						SRD_ShareInitiative(casterUuid, doubleUuid)
					end
				end
			end
		end	
		
	elseif not SRD_IsNullUUID(object) and Osi.IsSummon(object) == 1 and Osi.CombatGetGuidFor(Osi.CharacterGetOwner(object)) ~= nil and Osi.HasActiveStatus(object, "MISLEAD_ILLUSION") == 1 then
		--local double = Ext.Entity.Get(object)
		if (Debug) then
			_P('-------------------------------------------------------------')
			_D(object)
			_P('-- Entered combat')
			_P('\n\n\n')
		end		
		
		local casterUuid = Osi.CharacterGetOwner(object)
		local doubleUuid = string.sub(object, -36)	
		
		if (Debug) then
			_P("-- ", object, "is Mislead illusory double cast by")
			_D(casterUuid)
			_P('\n\n\n')
		end			
		
		SRD_ShareInitiative(casterUuid, doubleUuid)
		
	end
end			







Ext.Osiris.RegisterListener("EnteredCombat", 2, "after", SRD_Mislead_EnteredCombat)
