local module = {}

---@type ExtuiText|nil
local editorTargetText

---@module "SK_EditorTabBoosts"
local BoostTabModule = Ext.Require("Client/Modules/SK_EditorTabBoosts.lua")

local submodules = {
    BoostTabModule,
}

local function OnCharacterChanged(entity)
    if entity == nil then
        -- one last try
        entity = Helpers.Character:GetLocalControlledEntity()
        if entity == nil then return end
    end
    if editorTargetText ~= nil then
        editorTargetText.Label = string.format(Ext.Loca.GetTranslatedString("h044fe8822f484d5da1ce8a100723be30518d", "Currently Editing:").." %s", entity.DisplayName ~= nil and entity.DisplayName.NameKey:Get() or Ext.Loca.GetTranslatedString("hc86af83da94a4351a61691c1fa771f94094d", "Unknown"))
    end
    CharacterInterface_UI:OnCharacterChanged(entity)
    for _, m in ipairs(submodules) do
        if m ~= nil and m.OnCharacterChanged then
            m.OnCharacterChanged(entity)
        end
    end
end

Ext.Entity.OnCreate("ClientControl", function(entity, ct, c)
    if entity.UserReservedFor == nil or entity.UserReservedFor.UserID ~= 1 then return end -- not us

    -- ECDebug("ClientControl created: %s", entity.DisplayName and entity.DisplayName.NameKey:Get() or "Unknown")
    OnCharacterChanged(entity)
end)

---@param treeParent ExtuiTabItem
function module.GenerateEditorTab(treeParent)
    local entity = Helpers.Character:GetLocalControlledEntity()
    if entity == nil then return end
    editorTargetText = treeParent:AddText(string.format(Ext.Loca.GetTranslatedString("h044fe8822f484d5da1ce8a100723be30518d", "Currently Editing:").." %s", entity.DisplayName.NameKey:Get() or Ext.Loca.GetTranslatedString("hc86af83da94a4351a61691c1fa771f94094d", "Unknown")))
    local refreshCharacterButton = treeParent:AddImageButton("StatusRefresh", "ico_randomize_h", {20,20})
    refreshCharacterButton.OnClick = function(b) OnCharacterChanged() end
    refreshCharacterButton.SameLine = true
    treeParent:AddSeparator()
    local statTabBar = treeParent:AddTabBar("SKEStatTabBar")
    local spellTab = statTabBar:AddTabItem(Ext.Loca.GetTranslatedString("hc21d4a45c9f340c6b1513f05ecf182d1630a", "Spells"))
    local statusTab = statTabBar:AddTabItem(Ext.Loca.GetTranslatedString("h969d13aab95c4723a11d0f609110f76b6e16", "Statuses"))
    local passiveTab = statTabBar:AddTabItem(Ext.Loca.GetTranslatedString("h6ed14f52f4544bb780593219084efa13bd4a", "Passives"))
    local tagTab = statTabBar:AddTabItem(Ext.Loca.GetTranslatedString("h79463dffb72e46b4bd57c6e613b4a3d0a4c8", "Tags"))
    -- local boostCrafterTab = statTabBar:AddTabItem("Boost Crafter")

    local function addRefreshButton(tp, name)
        local refreshButton = tp:AddImageButton(name.."Refresh", "ico_randomize_h", {20,20})
        local statTree = tp:AddTree(name)
        refreshButton.OnClick = function(b) OnCharacterChanged() end
        statTree.SameLine = true
        return statTree
    end

    SearchableSpellUI:CreateSearchableUI(spellTab)
    local spellTree = addRefreshButton(spellTab, "SpellBook")
    CharacterInterface_UI.SpellBookUITree = spellTree
    CharacterInterface_UI.SpellBookUITree:SetOpen(false, "Appearing")
    CharacterInterface_UI:RegenerateSpellBookInfo(entity)
    SearchableSpellUI.RegenerateUI = function() CharacterInterface_UI:RegenerateSpellBookInfo() end
    
    SearchableStatusUI:CreateSearchableUI(statusTab)
    local statTree = addRefreshButton(statusTab, "Statuses")
    CharacterInterface_UI.StatusUITree = statTree
    CharacterInterface_UI.StatusUITree:SetOpen(false, "Appearing")
    CharacterInterface_UI:RegenerateStatusInfo(entity)
    SearchableStatusUI.RegenerateUI = function() CharacterInterface_UI:RegenerateStatusInfo() end
    
    SearchablePassiveUI:CreateSearchableUI(passiveTab)
    local passiveTree = addRefreshButton(passiveTab, "Passives")
    CharacterInterface_UI.PassiveUITree = passiveTree
    CharacterInterface_UI.PassiveUITree:SetOpen(false, "Appearing")
    CharacterInterface_UI:RegeneratePassiveInfo(entity)
    
    SearchableTagUI:CreateSearchableUI(tagTab)
    local tagTree = addRefreshButton(tagTab, "Tags")
    CharacterInterface_UI.TagUITree = tagTree
    CharacterInterface_UI.TagUITree:SetOpen(false, "Appearing")
    CharacterInterface_UI:RegenerateTagInfo(entity)
    SearchableTagUI.RegenerateUI = function() CharacterInterface_UI:RegenerateTagInfo() end
    
    -- BoostTabModule.GenerateBoostTab(boostCrafterTab)
    -- local boostCrafterChildWin = boostCrafterTab:AddChildWindow("BoostCrafterChildWin")
    -- boostCrafterChildWin.Size = {400, 600}
    -- BoostCrafter.TreeParent = boostCrafterChildWin
    -- BoostCrafter:RegenerateBoostInfo()
end

return module