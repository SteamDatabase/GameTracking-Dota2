PLAYERTABLES_VERSION = "0.90"

--[[
  PlayerTables: Player-specific shared state/nettable Library by BMD

  PlayerTables sets up a table that is shared between server (lua) and client (javascript) between specific (but changeable) clients.
  It is very similar in concept to nettables, but is built on being player-specific state (not sent to all players).
  Like nettables, PlayerTable state adjustments are mirrored to clients (that are currently subscribed).
  If players disconnect and then reconnect, PlayerTables automatically transmits their subscribed table states to them when they connect.
  PlayerTables only support sending numbers, strings, and tables of numbers/strings/tables to clients.

  Installation
  -"require" this file inside your code in order to gain access to the PlayerTables global table.
  -Ensure that you have the playertables/playertables_base.js in your panorama content scripts folder.
  -Ensure that playertables/playertables_base.js script is included in your custom_ui_manifest.xml with
    <scripts>
      <include src="file://{resources}/scripts/playertables/playertables_base.js" />
    </scripts>

  Library Usage
  -Lua
    -void PlayerTables:CreateTable(tableName, tableContents, pids)
      Creates a new PlayerTable with the given name, default table contents, and automatically sets up a subscription
      for all playerIDs in the "pids" object.
    -void PlayerTables:DeleteTable(tableName)
      Deletes a table by the given name, alerting any subscribed clients.
    -bool PlayerTables:TableExists(tableName)
      Returns whether a table currently exists with the given name
    -void PlayerTables:SetPlayerSubscriptions(tableName, pids)
      Clear and reset all player subscriptions based on the "pids" object.
    -void PlayerTables:AddPlayerSubscription(tableName, pid)
      Adds a subscription for the given player ID.
    -void PlayerTables:RemovePlayerSubscription(tableName, pid)
      Removes a subscription for the given player ID.
    -<> PlayerTables:GetTableValue(tableName, key)
      Returns the current value for this PlayerTable for the given "key", or nil if the key doesn't exist.
    -<> PlayerTables:GetAllTableValues(tableName)
      Returns the current keys and values for the given table.
    -void PlayerTables:DeleteTableValue(tableName, key)
      Delete a key from a playertable.
    -void PlayerTables:DeleteTableValues(tableName, keys)
      Delete the keys from a playertable given in the keys object.
    -void PlayerTables:SetTableValue(tableName, key, value)
      Set a value for the given key.
    -void PlayerTables:SetTableValues(tableName, changes)
      Set a all of the given key-value pairs in the changes object.


  -Javascript: include the javascript API with "var PlayerTables = GameUI.CustomUIConfig().PlayerTables" at the top of your file.
    -void PlayerTables.GetAllTableValues(tableName)
      Returns the current keys and values of all keys within the table "tableName".
      Returns null if no table exists with that name.
    -void PlayerTables.GetTableValue(tableName, keyName)
      Returns the current value for the key given by "keyName" if it exists on the table given by "tableName".
      Returns null if no table exists, or undefined if the key does not exist.
    -int PlayerTables.SubscribeNetTableListener(tableName, callback) 
      Sets up a callback for when this playertable is changed.  The callback is of the form:
        function(tableName, changesObject, deletionsObject).
          changesObject contains the key-value pairs that were changed
          deletionsObject contains the keys that were deleted.
          If changesObject and deletionsObject are both null, then the entire table was deleted.

      Returns an integer value representing this subscription.
    -void PlayerTables.UnsubscribeNetTableListener(callbackID)
      Remvoes the existing subscription as given by the callbackID (the integer returned from SubscribeNetTableListener)

  Examples:
    --Create a Table and set a few values.
      PlayerTables:CreateTable("new_table", {initial="initial value"}, {0})
      PlayerTables:SetTableValue("new_table", "count", 0)
      PlayerTables:SetTableValues("new_table", {val1=1, val2=2})

    --Change player subscriptions
      PlayerTables:RemovePlayerSubscription("new_table", 0)
      PlayerTables:SetPlayerSubscriptions("new_table", {[1]=true,[3]=true})  -- the pids object can be a map or array type table

    --Retrieve values on the client
      var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
      $.Msg(PlayerTables.GetTableVaue("new_table", "count"));

    --Subscribe to changes on the client
      var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
      PlayerTables.SubscribeNetTableListener("new_table", function(tableName, changes, deletions){
        $.Msg(tableName + " changed: " + changes + " -- " + deletions);
      });

]]

if not PlayerTables then
  PlayerTables = class({})
end

function PlayerTables:start()
  self.tables = {}
  self.subscriptions = {}

  CustomGameEventManager:RegisterListener("PlayerTables_Connected", Dynamic_Wrap(PlayerTables, "PlayerTables_Connected"))
end

function PlayerTables:equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or self:equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

function PlayerTables:copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[self:copy(k, s)] = self:copy(v, s) end
  return res
end

function PlayerTables:PlayerTables_Connected(args)
  --print('PlayerTables_Connected')
  --PrintTable(args)

  local pid = args.pid
  if not pid then
    return
  end

  local player = PlayerResource:GetPlayer(pid)
  --print('player: ', player)


  for k,v in pairs(PlayerTables.subscriptions) do
    if v[pid] then
      if player then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_fu", {name=k, table=PlayerTables.tables[k]} )
      end
    end
  end
end

function PlayerTables:CreateTable(tableName, tableContents, pids)
  tableContents = tableContents or {}
  pids = pids or {}

  if pids == true then
    pids = {}
    for i=0,DOTA_MAX_TEAM_PLAYERS-1 do
      pids[#pids+1] = i
    end
  end

  if self.tables[tableName] then
    print("[playertables.lua] Warning: player table '" .. tableName .. "' already exists.  Overriding.")
  end

  self.tables[tableName] = tableContents
  self.subscriptions[tableName] = {}

  for k,v in pairs(pids) do
    local pid = k
    if type(v) == "number" then
      pid = v
    end
    if pid >= 0 and pid < DOTA_MAX_TEAM_PLAYERS then
      self.subscriptions[tableName][pid] = true
      local player = PlayerResource:GetPlayer(pid)
      if player then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_fu", {name=tableName, table=tableContents} )
      end
    else
      print("[playertables.lua] Warning: Pid value '" .. pid .. "' is not an integer between [0," .. DOTA_MAX_TEAM_PLAYERS .. "].  Ignoring.")
    end
  end
end

function PlayerTables:DeleteTable(tableName)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local pids = self.subscriptions[tableName]

  for k,v in pairs(pids) do
    local player = PlayerResource:GetPlayer(k)
    if player then  
      CustomGameEventManager:Send_ServerToPlayer(player, "pt_fu", {name=tableName, table=nil} )
    end
  end

  self.tables[tableName] = nil
  self.subscriptions[tableName] = nil  
end

function PlayerTables:TableExists(tableName)
  return self.tables[tableName] ~= nil
end

function PlayerTables:SetPlayerSubscriptions(tableName, pids)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local oldPids = self.subscriptions[tableName]
  self.subscriptions[tableName] = {}

  for k,v in pairs(pids) do
    local pid = k
    if type(v) == "number" then
      pid = v
    end
    if pid >= 0 and pid < DOTA_MAX_TEAM_PLAYERS then
      self.subscriptions[tableName][pid] = true
      local player = PlayerResource:GetPlayer(pid)
      if player and oldPids[pid] == nil then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_fu", {name=tableName, table=table} )
      end
    else
      print("[playertables.lua] Warning: Pid value '" .. pid .. "' is not an integer between [0," .. DOTA_MAX_TEAM_PLAYERS .. "].  Ignoring.")
    end
  end
end

function PlayerTables:AddPlayerSubscription(tableName, pid)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local oldPids = self.subscriptions[tableName]

  if not oldPids[pid] then
    if pid >= 0 and pid < DOTA_MAX_TEAM_PLAYERS then
      self.subscriptions[tableName][pid] = true
      local player = PlayerResource:GetPlayer(pid)
      if player then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_fu", {name=tableName, table=table} )
      end
    else
      print("[playertables.lua] Warning: Pid value '" .. v .. "' is not an integer between [0," .. DOTA_MAX_TEAM_PLAYERS .. "].  Ignoring.")
    end
  end
end

function PlayerTables:RemovePlayerSubscription(tableName, pid)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local oldPids = self.subscriptions[tableName]
  oldPids[pid] = nil
end

function PlayerTables:GetTableValue(tableName, key)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local ret = self.tables[tableName][key]
  if type(ret) == "table" then
    return self:copy(ret)
  end
  return ret
end

function PlayerTables:GetAllTableValues(tableName)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local ret = self.tables[tableName]
  if type(ret) == "table" then
    return self:copy(ret)
  end
  return ret
end

function PlayerTables:DeleteTableKey(tableName, key)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local pids = self.subscriptions[tableName]

  if table[key] ~= nil then
    table[key] = nil
    for pid,v in pairs(pids) do
      local player = PlayerResource:GetPlayer(pid)
      if player then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_kd", {name=tableName, keys={[key]=true}} )
      end
    end
  end
end

function PlayerTables:DeleteTableKeys(tableName, keys)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local pids = self.subscriptions[tableName]

  local deletions = {}
  local notempty = false

  for k,v in pairs(keys) do
    if type(k) == "string" then
      if table[k] ~= nil then
        deletions[k] = true
        table[k] = nil
        notempty = true
      end
    elseif type(v) == "string" then
      if table[v] ~= nil then
        deletions[v] = true
        table[v] = nil
        notempty = true
      end
    end
  end

  if notempty then
    for pid,v in pairs(pids) do
      local player = PlayerResource:GetPlayer(pid)
      if player then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_kd", {name=tableName, keys=deletions} )
      end
    end
  end
end

function PlayerTables:SetTableValue(tableName, key, value)
  if value == nil then
    self:DeleteTableKey(tableName, key)
    return 
  end
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local pids = self.subscriptions[tableName]

  if not self:equals(table[key], value) then
    table[key] = value
    for pid,v in pairs(pids) do
      local player = PlayerResource:GetPlayer(pid)
      if player then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_uk", {name=tableName, changes={[key]=value}} )
      end
    end
  end
end

function PlayerTables:SetTableValues(tableName, changes)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local pids = self.subscriptions[tableName]

  for k,v in pairs(changes) do
    if self:equals(table[k], v) then
      changes[k] = nil
    else
      table[k] = v
    end
  end

  local notempty, _ = next(changes, nil)

  if notempty then
    for pid,v in pairs(pids) do
      local player = PlayerResource:GetPlayer(pid)
      if player then  
        CustomGameEventManager:Send_ServerToPlayer(player, "pt_uk", {name=tableName, changes=changes} )
      end
    end
  end
end

if not PlayerTables.tables then PlayerTables:start() end