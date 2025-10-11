modGuid = "26a5488d-6aaa-900c-2933-43330bd1ba3a"
subClassGuid = "579e83f7-3882-4163-89b7-1d8c1559487a"

if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then

	local subClasses = {
	SumradagnothPDK2024 = {
	  modGuid = modGuid,
	  subClassGuid = subClassGuid,
      class = "fighter",
      subClassName = "Purple Dragon Knight"
	}
	}

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework.Api.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
end