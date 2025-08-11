-- Defining the key pieces of information for the mod here. modGuid = meta UUID, subClassGuid = ClassDescriptions UUID
local modGuid = "465084ab-5656-4893-b295-d5210aff4fbc"
local subClassGuid = "c296bed5-341e-498a-9933-e9900d17a6f8"
local BootStrap = {}

-- If SCF is loaded, use it to load Subclass into Progressions. Otherwise, DIY.
if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then
  local subClasses = {
    HavsglimtGreenKnight = {
      modGuid = modGuid,
      subClassGuid = subClassGuid,
      class = "fighter",
      subClassName = "Green Knight"
    }
  }

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework = Mods.SubclassCompatibilityFramework or {}
    Mods.SubclassCompatibilityFramework.API = Mods.SubclassCompatibilityFramework.Api or {}
    Mods.SubclassCompatibilityFramework.API.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
-- If SCF isn't installed, insert class into Progression if another mod overwrites the Progression
else
  local function InsertSubClass(arr)
    table.insert(arr, subClassGuid)
  end

  local function DetectSubClass(arr)
    for _, value in pairs(arr) do
      if value == subClassGuid then
        return true
      end
    end
  end

  function BootStrap.loadSubClass(arr)
    if arr ~= nil then
      local found = DetectSubClass(arr)
      if not found then
        InsertSubClass(arr)
      end
    end
  end

  BootStrap.loadSubClass(Ext.Definition.Get("23eacff0-9efe-4ea6-b031-19075cc96b63", "Progression").SubClasses)
end