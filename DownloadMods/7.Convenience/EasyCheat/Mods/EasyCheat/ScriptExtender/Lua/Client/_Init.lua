RequireFiles("Client/", {
    "Helpers/_Init",
    "Classes/_Init",
    "RandomGarbo",
    "CheatMenu",
    "ItemSpawnerMenu",
    "PartyMenu",
    "TeleportMenu",
    "DailyBuffMenu",
    "Sidekick",
})
-- FIXME whole client codebase is a nightmare that can't be cleaned until IMGUI things are more finalized

---@type ExtuiTabBar
ItemSpawnerTab = nil
---@type ExtuiTabBar
CheatMenuTab = nil
---@type ExtuiGroup
CheatGroup = nil
HostOnlyMode = true
---@type ImguiHelperStatus
StatusNotify = nil
---@type ImguiHelperStatus
SpawnNotify = nil

Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "EasyCheat", CheatMenu)