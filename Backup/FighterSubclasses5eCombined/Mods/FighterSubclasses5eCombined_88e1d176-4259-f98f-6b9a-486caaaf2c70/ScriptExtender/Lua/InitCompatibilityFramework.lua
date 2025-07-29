modGuid = "88e1d176-4259-f98f-6b9a-486caaaf2c70"
subClassGuidBAN = "38ea7fea-c486-40e3-973b-b9bc633d4aaa"
subClassGuidBRU = "3449e88a-b378-40c2-b505-f8fe43d26c2d"
subClassGuidCAV = "b3c39e0a-aa51-416f-b2a2-c848d56f4890"
subClassGuidPW = "d30f652e-a5ed-4d78-bc18-25290ceec524"
subClassGuidRK = "2f5a4183-8885-49dc-a211-fa1c53bc1606"
subClassGuidSAM = "7f93e89c-fe4d-49a8-ad45-666071bd962f"
subClassGuidSS = "59091945-177c-419d-a847-46901a8a8687"

if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then

	local subClasses = {
	SumradagnothBAN5E = {
	  modGuid = modGuid,
	  subClassGuid = subClassGuidBAN,
      class = "fighter",
      subClassName = "Banneret"
	},
	SumradagnothBRU5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidBRU,
      class = "fighter",
      subClassName = "Brute"
	},
	SumradagnothCAV5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidCAV,
      class = "fighter",
      subClassName = "Cavalier"
	},	
	SumradagnothPW5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidPW,
      class = "fighter",
      subClassName = "Psi Warrior"
	},
	SumradagnothRK5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidRK,
      class = "fighter",
      subClassName = "Rune Knight"
	},
	SumradagnothSAM5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidSAM,
      class = "fighter",
      subClassName = "Samurai"
	},
	SumradagnothSS5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuidSS,
      class = "fighter",
      subClassName = "Sharpshooter"
	},
	}

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework.Api.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
end