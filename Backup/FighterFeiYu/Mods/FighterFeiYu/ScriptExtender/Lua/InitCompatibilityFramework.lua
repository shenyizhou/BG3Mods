modGuid = "a1b2c3d4-e5f6-7890-abcd-ef1234567898"
subClassGuidFeiYu = "1fd21638-e994-4c5b-bc48-9ed0c53a653c"

if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then

	local subClasses = {
    ShenlangFeiYu = {
      modGuid = modGuid,
      subClassGuid = subClassGuidFeiYu,
        class = "fighter",
        subClassName = "FeiYu"
    },
	}

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework.Api.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
end