modGuid = "2e4e938a-81fa-4566-a60b-281dc4e86301"
subClassGuid = "4ecdc960-87f5-4bda-aecb-dc24663a4232"

if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then
  local subClasses = {
    SumradagnothK5E = {
      modGuid = modGuid,
      subClassGuid = subClassGuid,
      class = "monk",
      subClassName = "Kensei"
    }
  }

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework.Api.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
end