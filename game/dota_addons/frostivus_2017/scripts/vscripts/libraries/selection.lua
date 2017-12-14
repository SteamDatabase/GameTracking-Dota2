SELECTION_VERSION = "1.00"

--[[
    Lua-controlled Selection Library by Noya
    
    Installation:
    - "require" this file inside your code in order to add the new API functions to the PlayerResource global
    - Additionally, ensure your game scripts custom_net_tables.txt has a "selection" entry
    - Finally, ensure that you have the following files correctly added and included in your panorama content folder
        selection.xml, and include line on custom_ui_manifest.xml, on layout/custom_game/ folder
        selection folder containing selection.js and selection_filter.js, on /scripts/ folder

    Usage:
    - Functions with unit_args can recieve an Entity Index, a NPC Handle, or a table of each type.
    - Functions with unit can recieve an Entity Index or NPC Handle

    * Create a new selection for the player
        PlayerResource:NewSelection(playerID, unit_args)

    * Add units to the current selection of the player
        PlayerResource:AddToSelection(playerID, unit_args)
    
    * Remove units by index from the player selection group
        PlayerResource:RemoveFromSelection(playerID, unit_args)
    
    * Returns the list of units by entity index that are selected by the player
        PlayerResource:GetSelectedEntities(playerID)

    * Deselect everything, selecting the main hero (which can be redirected to another entity)
        PlayerResource:ResetSelection(playerID)

    * Get the index of the first selected unit of the player
        PlayerResource:GetMainSelectedEntity(playerID)
    
    * Check if a unit is selected or not by a player, returns bool
        PlayerResource:IsUnitSelected(playerID, unit_args)

    * Force a refresh of the current selection on all players, useful after abilities are removed
        PlayerResource:RefreshSelection()
    
    * Redirects the selection of the main hero to another entity of choice
        PlayerResource:SetDefaultSelectionEntity(playerID, unit)
    
    * Redirects the selection of any entity to another entity of choice
        hero:SetSelectionOverride(unit)

    * Use -1 to reset to default
        PlayerResource:SetDefaultSelectionEntity(playerID, -1)
        hero:SetSelectionOverride(-1)

    Notes:
    - Enemy units that you don't control can't be added to the selection group of a player
    - This library requires "libraries/timers.lua" to be present in your vscripts directory.

--]]

function CDOTA_PlayerResource:NewSelection(playerID, unit_args)
    local player = self:GetPlayer(playerID)
    if player then
        local entities = Selection:GetEntIndexListFromTable(unit_args)
        CustomGameEventManager:Send_ServerToPlayer(player, "selection_new", {entities = entities})
    end
end 

function CDOTA_PlayerResource:AddToSelection(playerID, unit_args)
    local player = self:GetPlayer(playerID)
    if player then
        local entities = Selection:GetEntIndexListFromTable(unit_args)
        CustomGameEventManager:Send_ServerToPlayer(player, "selection_add", {entities = entities})
    end
end

function CDOTA_PlayerResource:RemoveFromSelection(playerID, unit_args)
    local player = self:GetPlayer(playerID)
    if player then
        local entities = Selection:GetEntIndexListFromTable(unit_args)
        CustomGameEventManager:Send_ServerToPlayer(player, "selection_remove", {entities = entities})
    end
end

function CDOTA_PlayerResource:ResetSelection(playerID)
    local player = self:GetPlayer(playerID)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "selection_reset", {})
    end
end

function CDOTA_PlayerResource:GetSelectedEntities(playerID)
    return Selection.entities[playerID] or {}
end

function CDOTA_PlayerResource:GetMainSelectedEntity(playerID)
    local selectedEntities = self:GetSelectedEntities(playerID) 
    return selectedEntities and selectedEntities["0"]
end

function CDOTA_PlayerResource:IsUnitSelected(playerID, unit)
    if not unit then return false end
    local entIndex = type(unit)=="number" and unit or IsValidEntity(unit) and unit:GetEntityIndex()
    if not entIndex then return false end
    
    local selectedEntities = self:GetSelectedEntities(playerID)
    for _,v in pairs(selectedEntities) do
        if v==entIndex then
            return true
        end
    end
    return false
end

function CDOTA_PlayerResource:RefreshSelection()
    Timers:CreateTimer(0.03, function()
        FireGameEvent("dota_player_update_selected_unit", {})
    end)
end

function CDOTA_PlayerResource:SetDefaultSelectionEntity(playerID, unit)
    if not unit then unit = -1 end
    local entIndex = type(unit)=="number" and unit or unit:GetEntityIndex()
    local hero = self:GetSelectedHeroEntity(playerID)
    if hero then
        hero:SetSelectionOverride(unit)
    end
end

function CDOTA_BaseNPC:SetSelectionOverride(reselect_unit)
    local unit = self
    local reselectIndex = type(reselect_unit)=="number" and reselect_unit or reselect_unit:GetEntityIndex()

    CustomNetTables:SetTableValue("selection", tostring(unit:GetEntityIndex()), {entity = reselectIndex})
end

------------------------------------------------------------------------
-- Internal
------------------------------------------------------------------------

require('libraries/timers')

if not Selection then
    Selection = class({})
end

function Selection:Init()
    Selection.entities = {} --Stores the selected entities of each playerID
    CustomGameEventManager:RegisterListener("selection_update", Dynamic_Wrap(Selection, 'OnUpdate'))
end

function Selection:OnUpdate(event)
    local playerID = event.PlayerID
    Selection.entities[playerID] = event.entities
end

-- Internal function to build an entity index list out of various inputs
function Selection:GetEntIndexListFromTable(unit_args)
    local entities = {}
    if type(unit_args)=="number" then
        table.insert(entities, unit_args) -- Entity Index
    -- Check contents of the table
    elseif type(unit_args)=="table" then
        if unit_args.IsCreature then
            table.insert(entities, unit_args:GetEntityIndex()) -- NPC Handle
        else
            for _,arg in pairs(unit_args) do
                -- Table of entity index values
                if type(arg)=="number" then
                    table.insert(entities, arg)
                -- Table of npc handles
                elseif type(arg)=="table" then
                    if arg.IsCreature then
                        table.insert(entities, arg:GetEntityIndex())
                    end
                end
            end
        end
    end
    return entities
end

if not Selection.entities then Selection:Init() end