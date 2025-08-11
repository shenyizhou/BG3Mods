modGuid = "3b8967db-864f-8995-3a2d-23ea140a18a3"
subClassGuidAG = "221b4264-9aed-4d14-b5dc-41b3add2d8b0"
subClassGuidBR = "460fcfa7-5219-4ab4-9151-2dd813e82d14"
subClassGuidB = "e0ce004e-575a-4f73-a540-f8f16ff39ad8"
subClassGuidJUG = "d524c770-8406-485b-8c1b-6a65fac5a393"
subClassGuidSH = "3dfb9ba3-4a66-4304-9c3d-9ac1308ccbec"
subClassGuidZ = "41d149ff-7110-433d-bb1c-63bf9c7950e7"

if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then

	local subClasses = {
	SumradagnothAG5E = {
	  modGuid = modGuid,
	  subClassGuid = subClassGuidAG,
      class = "barbarian",
      subClassName = "Ancestral Guardian"
	},
	SumradagnothBR5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidBR,
      class = "barbarian",
      subClassName = "Battlerager"
	},
	SumradagnothB5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidB,
      class = "barbarian",
      subClassName = "Beast"
	},	
	SumradagnothJUG5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidJUG,
      class = "barbarian",
      subClassName = "Juggernaut"
	},
	SumradagnothSH5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidSH,
      class = "barbarian",
      subClassName = "Storm Herald"
	},
	SumradagnothZ5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidZ,
      class = "barbarian",
      subClassName = "Zealot"
	},
	}

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework.Api.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
end