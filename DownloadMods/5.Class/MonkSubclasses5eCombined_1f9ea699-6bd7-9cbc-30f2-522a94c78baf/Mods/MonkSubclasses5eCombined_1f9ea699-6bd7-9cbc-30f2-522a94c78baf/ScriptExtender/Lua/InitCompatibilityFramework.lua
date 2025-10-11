modGuid = "1f9ea699-6bd7-9cbc-30f2-522a94c78baf"
subClassGuidAD = "631bb090-8daf-4805-84ed-cb23d8824774"
subClassGuidAS = "7f28db7a-86ee-4ef0-9409-57544ba7c19a"
subClassGuidKEN = "4ecdc960-87f5-4bda-aecb-dc24663a4232"
subClassGuidLD = "fc93bfaa-a364-431e-bb33-d562dd8e347b"
subClassGuidMER = "0ceaa14b-71b9-4e87-b5e5-d285bfc97c49"
subClassGuidSUS = "bc915e8d-ff9a-4b4d-b54d-4503b57440fb"

if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then

	local subClasses = {
	SumradagnothAD5E = {
	  modGuid = modGuid,
	  subClassGuid = subClassGuidAD,
      class = "monk",
      subClassName = "Ascendant Dragon"
	},
	SumradagnothAS5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidAS,
      class = "monk",
      subClassName = "Astral Self"
	},
	SumradagnothKEN5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidKEN,
      class = "monk",
      subClassName = "Kensei"
	},	
	SumradagnothLD5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidLD,
      class = "monk",
      subClassName = "Long Death"
	},
	SumradagnothMER5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidMER,
      class = "monk",
      subClassName = "Mercy"
	},
	SumradagnothSUS5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidSUS,
      class = "monk",
      subClassName = "Sun Soul"
	},
	}

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework.Api.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
end