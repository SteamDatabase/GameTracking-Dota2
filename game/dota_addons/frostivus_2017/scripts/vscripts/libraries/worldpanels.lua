WORLDPANELS_VERSION = "0.81"

--[[
  Lua-controlled Frankenstein WorldPanels Library by BMD

  Installation
  -"require" this file inside your code in order to make the WorldPanels API availble
  -Ensure that this file is placed in the vscripts/libraries path along with timers.lua and playertables.lua
  -Ensure that you have the barebones_worldpanels.xml in your panorama content layout folder.
  -Ensure that you have the barebones_worldpanels.js in your panorama content scripts folder.
  -Ensure that barebones_worldpanels.xml is included in your custom_ui_manifest.xml with
    <CustomUIElement type="Hud" layoutfile="file://{resources}/layout/custom_game/barebones_worldpanels.xml" />

  Library Usage
  -WorldPanels are a means of displaying panorama layout files to individuals which act as though they are positioned at a specific point in the world
    or on a specific entity.
  -WorldPanels can be shared with an individual player, a whole team, or all clients at once via
    WorldPanels:CreateWorldPanel(playerID, configTable) -- 1 player or array of playerIDs like {3,5,8}
    WorldPanels:CreateWorldPanelForTeam(teamID, configTable) -- 1 team
    WorldPanels:CreateWorldPanelForAll(configTable) -- All players
  -WorldPanels are specified by a configuration table which has several potential parameters:
    -layout: The panorama layout file to display in this worldpanel.
    -position: Mutually exclusive with "entity".  Position is the world vector position to display the worldpanel at.
    -entity: Mutually exclusive with "position".  Entity is the entity (hscript or index) which the worldpanel will track for its position.
    -offsetX: An optional (default is 0) screen pixel offset to apply to the worldpanel (in the x direction)
    -offsetY: An optional (default is 0) screen pixel offset to apply to the worldpanel (in the y direction)
    -horizontalAlign: An optional (default is "center") alignment for the worldpanel to use when adjusting the panel size. "center", "left", "right" are valid options
    -verticalAlign: An optional (default is "bottom") alignment for the worldpanel to use when adjusting the panel size. "bottom", "center", "top" are valid options
    -entityHeight: An optional (default is 0) height offset to use for the entity world panel (see: "HealthBarOffset" in unit KV definition)
    -edgePadding: An optional (default is to not lock to screen edge) padding percentage of the screen to limit the worldpanel to.
    -duration: An optional (default is infinite) duration in GameTime seconds that the panel will exist for and then be automatically destroyed.
    -data: An optional table of data which will be attached to the worldpanel so that valeus can be used in javascript through $.GetContextPanel().Data
      This table should only contain numeric, string, or table values (no entities/hscripts)

  -WorldPanels returned by the Create methods have the following methods:
    wp:SetPosition(position)
    wp:SetEntity(entity)
    wp:SetHorizontalAlign(hAlign)
    wp:SetVerticalAlign(vAlign)
    wp:SetOffsetX(offsetX)
    wp:SetOffsetY(offsetY)
    wp:SetEdgePadding(edge)
    wp:SetEntityHeight(entityHeight)
    wp:SetData(data)
    wp:Delete()

  -See examples/worldpanelsExample.lua for usage examples.


  Notes
  -WorldPanel panorama performance can still be an issue (depending on layout).  Use sparingly.
  -A WorldPanel attached to an entity will only show when the player has vision of that entity
  -A WorldPanel is automatically deleted if the entity it is attached to dies (and is not a hero type unit)
  -Edge tracking is currently inaccurate in certain sitautions due to a valve bug with Game.WorldToScreenX/Y
  -The WorldPanel library provides a few helpful properties for use in your layout file's javascript.
    $.GetContextPanel().WorldPanel      contains the WorldPanel configuration in the following table format:
      {layout, offsetX, offsetY, position, entity, entityHeight, hAlign, vAlign, edge}
    $.GetContextPanel().OnEdge          true if this worldpanel has edgelocking/padding and is touching the edge/padded edge of the screen.  false otherwise.  Updates every frame.
    $.GetContextPanel().OffScreen       true if this worldpanel has no edgelocking/padding and is completely off screen.  false otherwise.  Updates every frame.
    $.GetContextPanel().Data            the "data" object passed in to CreateWorldPanel.

  Examples
  -Create a special worldpanel for the hero entity of player 0, only visible to player 0. Adds 210 to the unit position for the height of the panel.
    WorldPanels:CreateWorldPanel(0, 
      {layout = "file://{resources}/layout/custom_game/worldpanels/healthbar.xml",
        entity = PlayerResource:GetSelectedHeroEntity(0),
        entityHeight = 210,
      })

  -Create a worldpanel for all players that displays at 200 height above the ground at Vector(0,0,0) and locks to 5% of the dge of the screen 
    WorldPanels:CreateWorldPanelForAll(
      {layout = "file://{resources}/layout/custom_game/worldpanels/arrow.xml",
        position = GetGroundPosition(Vector(0,0,0), nil) + Vector(0,0,200),
        edgePadding = 5,
      })


]]

require('libraries/timers')
require('libraries/playertables')

local haStoI = {[0]="center", [1]="left", [2]="right"}
local haItoS = {center=0, left=1, right=2}
local vaStoI = {bottom=0, center=1, top=2}
local vaItoS = {[0]="bottom", [1]="center", [2]="top"}

if not WorldPanels then
  WorldPanels = class({})
end

local UpdateTable = function(wp)
  local idString = wp.idString
  local pt = wp.pt
  local pids = wp.pids
  for i=1,#pids do
    local pid = pids[i]
    local ptName = "worldpanels_" .. pid

    if not PlayerTables:TableExists(ptName) then
      PlayerTables:CreateTable(ptName, {[idString]=pt}, {pid})
    else
      PlayerTables:SetTableValue(ptName, idString, pt)
    end
  end
end

function WorldPanels:start()
  self.initialized = true

  self.entToPanels = {}
  self.worldPanels = {}
  self.nextID = 0

  --CustomGameEventManager:RegisterListener("Attachment_DoSphere", Dynamic_Wrap(WorldPanels, "Attachment_DoSphere"))
  ListenToGameEvent('entity_killed', Dynamic_Wrap(WorldPanels, 'OnEntityKilled'), self)
end

function WorldPanels:OnEntityKilled( keys )
  --print( '[WorldPanels] OnEntityKilled Called' )
  --PrintTable( keys )
  

  -- The Ent that was Killed
  local killedEnt = EntIndexToHScript( keys.entindex_killed )

  local panels = WorldPanels.entToPanels[killedEnt]

  if not killedEnt.IsRealHero or not killedEnt:IsRealHero() then
    if panels then
      for i=1,#panels do
        local panel = panels[i]
        for j=1,#panel.pids do
          local pid = panel.pids[j]
          PlayerTables:DeleteTableKey("worldpanels_" .. pid, panel.idString)
        end
      end
    end
  end

  
end

function WorldPanels:CreateWorldPanelForAll(conf)
  local pids = {}
  for i=0,DOTA_MAX_TEAM_PLAYERS do
    if PlayerResource:IsValidPlayer(i) then
      pids[#pids+1] = i;
    end
  end

  return WorldPanels:CreateWorldPanel(pids, conf)
end

function WorldPanels:CreateWorldPanelForTeam(team, conf)
  local count = PlayerResource:GetPlayerCountForTeam(team)
  local pids = {}
  for i=1,count do
    pids[#pids+1] = PlayerResource:GetNthPlayerIDOnTeam(team, i)
  end

  return WorldPanels:CreateWorldPanel(pids, conf)
end

function WorldPanels:CreateWorldPanel(pids, conf)
  --{position, entity, offsetX, offsetY, hAlign, vAlign, entityHeight, edge, duration, data}
  -- duration?
  if type(pids) == "number" then
    pids = {pids}
  end

  local ent = conf.entity
  local ei = conf.entity
  if ent and type(ent) == "number" then
    ei = ent
    ent = EntIndexToHScript(ent)
  elseif ent and ent.GetEntityIndex then
    ei = ent:GetEntityIndex() 
  end

  local pt = {
    layout =            conf.layout,
    position =          conf.position,
    entity =            ei,
    offsetX =           conf.offsetX,
    offsetX =           conf.offsetY,
    entityHeight =      conf.entityHeight,
    edge =              conf.edgePadding,
    data =              conf.data,
  }

  if conf.horizontalAlign then pt.hAlign = haStoI[conf.horizontalAlign] end
  if conf.verticalAlign   then pt.vAlign = vaStoI[conf.verticalAlign] end

  local idString = tostring(self.nextID)

  local wp = {
    id =                self.nextID,
    idString =          idString,
    pids =              pids,
    pt =                pt,
  }

  function wp:SetPosition(pos)
    self.pt.entity = nil
    self.pt.position = pos
    UpdateTable(self)
  end

  function wp:SetEntity(entity)
    local ei = entity
    if entity and not type(entity) == "number" and entity.GetEntityIndex then
      ei = entity:GetEntityIndex() 
    end

    self.pt.entity = ei
    self.pt.position = nil
    UpdateTable(self)
  end

  function wp:SetHorizontalAlign(hAlign)
    self.pt.hAlign = haStoI[hAlign]
    UpdateTable(self)
  end

  function wp:SetVerticalAlign(vAlign)
    self.pt.vAlign = vaStoI[vAlign]
    UpdateTable(self)
  end

  function wp:SetOffsetX(offX)
    self.pt.offsetX = offX
    UpdateTable(self)
  end

  function wp:SetOffsetY(offY)
    self.pt.offsetY = offY
    UpdateTable(self)
  end

  function wp:SetEntityHeight(height)
    self.pt.entityHeight = height
    UpdateTable(self)
  end

  function wp:SetEdgePadding(edge)
    self.pt.edge = edge
    UpdateTable(self)
  end

  function wp:SetData(data)
    self.pt.data = data
    UpdateTable(self)
  end

  function wp:Delete()
    for j=1,#self.pids do
      local pid = self.pids[j]
      PlayerTables:DeleteTableKey("worldpanels_" .. pid, self.idString)
    end
  end

  if conf.duration then
    pt.endTime = GameRules:GetGameTime() + conf.duration
    Timers:CreateTimer(conf.duration,function()
      wp:Delete()
    end)
  end

  UpdateTable(wp)

  if ei then
    self.entToPanels[ent] = self.entToPanels[ent] or {}
    table.insert(self.entToPanels[ent], wp)
  end

  self.worldPanels[self.nextID] = wp
  self.nextID = self.nextID + 1
  return wp
end

if not WorldPanels.initialized then WorldPanels:start() end