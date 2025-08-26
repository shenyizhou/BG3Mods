Ext.Require("Shared/_Init.lua")
Ext.Require("Server/_Init.lua")

-- StatPaths={
--     -- "Public/ModName/Stats/Generated/Data/FileName1.txt",
--     -- "Public/ModName/Stats/Generated/Data/FileName2.txt",
--     -- "Public/ModName/Stats/Generated/Data/FileName3.txt",
-- }

-- local function OnResetCompleted()
--     --Ext.Stats.LoadStatsFile("Public/ModName/Stats/Generated/Data/ModName.txt",1)
--     for _, statPath in ipairs(StatPaths) do
--         Ext.Stats.LoadStatsFile(statPath,1)
--     end
--     _P('Reload complete')
-- end

-- Ext.Events.ResetCompleted:Subscribe(OnResetCompleted)