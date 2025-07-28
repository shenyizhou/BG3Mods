if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then
  local subClasses = {
    Zhou_YeCultivator = {
      modGuid = "79416edc-88c2-4dd0-ba72-1a70963b1f87",
      subClassGuid = "52c3319b-8b38-4283-8e22-12a3cab458b0",
      class = "fighter",
      subClassName = "Cultivator"
    }
  }

  local function OnSessionLoaded()
    Mods.SubclassCompatibilityFramework = Mods.SubclassCompatibilityFramework or {}
    Mods.SubclassCompatibilityFramework.API = Mods.SubclassCompatibilityFramework.Api or {}
    Mods.SubclassCompatibilityFramework.API.InsertSubClasses(subClasses)
  end

  Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
end
