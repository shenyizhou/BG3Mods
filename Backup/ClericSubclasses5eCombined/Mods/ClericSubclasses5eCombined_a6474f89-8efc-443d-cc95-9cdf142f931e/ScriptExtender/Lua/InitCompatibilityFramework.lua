modGuid = "a6474f89-8efc-443d-cc95-9cdf142f931e"
subClassGuidTWI = "26622c6d-4dfb-4f19-a805-abcb1994d1f6"
subClassGuidORD = "66fdabd7-78af-4298-96c9-e71d4225a478"

if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then

	local subClasses = {
	SumradagnothTWI5E = {
	  modGuid = modGuid,
	  subClassGuid = subClassGuidTWI,
      class = "cleric",
      subClassName = "Twilight Domain"
	},
	SumradagnothORDS5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidORD,
      class = "cleric",
      subClassName = "Order Domain"
	},
	}

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework.Api.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
end