
--------------------------------------------------------------------------------

function CDotaNPX:OnThink()
	local nGameState = GameRules:State_Get()
	if nGameState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if self.CurrentScenario and self.CurrentScenario:IsTimed() then
			local flTimeLeft = self.CurrentScenario:GetTimeLeft()
	
			if GameRules:GetDOTATime( false, false ) >= self.flNextTimerConsoleNotify then
				print( "CDotaNPX:OnThink - Current Scenario has " .. string.format( "%.0f", flTimeLeft  ) .. " seconds remaining" )
				self.flNextTimerConsoleNotify = GameRules:GetDOTATime( false, false ) + NPX_TIMER_NOTIFY_RATE
			end

			if flTimeLeft <= 0 then
				self.CurrentScenario:OnTimeExpired()
			end
		end
	end

	if self.CurrentScenario then
		self.CurrentScenario:OnThink()
	end

	return NPX_THINK_TIME
end

--------------------------------------------------------------------------------
-- player_connect_full
-- > index - byte
-- > userid - short
-- > PlayerID - int
--------------------------------------------------------------------------------
function CDotaNPX:OnPlayerConnected( event )
	local hPlayer = EntIndexToHScript( event.index )
	if hPlayer == nil then
		return
	end
	
	sSelectedScenario = GameRules:GetGameSessionConfigValue( "scenario", "scenario_basics_intro" )
	self:SetupScenario( sSelectedScenario )
end

--------------------------------------------------------------------------------
-- dota_on_hero_finish_spawn
-- > heroindex - int
-- > hero - string
--------------------------------------------------------------------------------
function CDotaNPX:OnHeroFinishSpawn( event )
	local hHero = EntIndexToHScript( event.heroindex )
	if hHero == nil then
		return
	end

	local hPlayer = hHero:GetPlayerOwner()
	if hPlayer == nil then
		return
	end

	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnHeroFinishSpawn( hHero, hPlayer )
	end
end

--------------------------------------------------------------------------------
-- dota_game_state_change
-- > old_state - short
-- > new_state - short
--------------------------------------------------------------------------------
function CDotaNPX:OnGameRulesStateChange( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnGameRulesStateChange( event.old_state, event.new_state )
	end
end

--------------------------------------------------------------------------------
-- dota_match_done
-- > winningteam - byte
--------------------------------------------------------------------------------
function CDotaNPX:OnGameFinished( event )
	local hScenarioTable = {}
	if self.CurrentScenario ~= nil then
		hScenarioTable = self.CurrentScenario:AddResultToSignOut()
	end

	local hSignOutTable = {}
	hSignOutTable["scenario"] = hScenarioTable
	PrintTable( hSignOutTable, "signout: --> " )
	GameRules:SetEventSignoutCustomTable( hSignOutTable )
end

--------------------------------------------------------------------------------
-- npc_spawned
-- > entindex - long
--------------------------------------------------------------------------------
function CDotaNPX:OnNPCSpawned( event )
	local hEnt = nil
	if event.entindex ~= nil then
		hEnt = EntIndexToHScript( event.entindex )
	end

	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnNPCSpawned( hEnt )
	end
end

--------------------------------------------------------------------------------
-- entity_killed
-- > entindex_killed - int
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------
function CDotaNPX:OnEntityKilled( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	local hKiller = nil 
	if event.entindex_attacker ~= nil then
		hKiller = EntIndexToHScript( event.entindex_attacker )
	end

	local hInflictor = nil 
	if event.entindex_inflictor ~= nil then
		hInflictor = EntIndexToHScript( event.entindex_inflictor )
	end

	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnEntityKilled( hVictim, hKiller, hInflictor )
	end
end


--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - int    // ugh, yes. it's called killed even if it's just damage
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------
function CDotaNPX:OnTakeDamage( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	local hKiller = nil 
	if event.entindex_attacker ~= nil then
		hKiller = EntIndexToHScript( event.entindex_attacker )
	end

	local hInflictor = nil 
	if event.entindex_inflictor ~= nil then
		hInflictor = EntIndexToHScript( event.entindex_inflictor )
	end

	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnTakeDamage( hVictim, hKiller, hInflictor )
	end
end

--------------------------------------------------------------------------------
-- modifier_event
-- > eventname - string
-- > caster - short
-- > ability- short

--------------------------------------------------------------------------------
function CDotaNPX:OnModifierEvent( event )
	print("modifier event!")
end



--------------------------------------------------------------------------------
-- trigger_start_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short

--------------------------------------------------------------------------------
function CDotaNPX:OnTriggerStartTouch( event )
	local sTriggerName = nil  
	if event.trigger_name ~= nil then
		sTriggerName = event.trigger_name
	end

	local hActivator = nil 
	if event.activator_entindex ~= nil then
		hActivator = EntIndexToHScript( event.activator_entindex )
	end

	local hCaller= nil 
	if event.caller_entindex ~= nil then
		hCaller = EntIndexToHScript( event.caller_entindex )
	end

	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnTriggerStartTouch( sTriggerName, hActivator, hCaller )
	end
end



--------------------------------------------------------------------------------
-- dota_item_picked_up
-- > itemname - string
-- > PlayerID - short
-- > ItemEntityIndex - short
-- > HeroEntityIndex - short
--------------------------------------------------------------------------------
function CDotaNPX:OnItemPickedUp( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnItemPickedUp( event.itemname )
	end 
end

--------------------------------------------------------------------------------
-- 
-- > itemname - string
-- > PlayerID - short
-- > ItemEntityIndex - short
-- > HeroEntityIndex - short
--------------------------------------------------------------------------------
function CDotaNPX:OnItemPhysicalDestroyed( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnItemPhysicalDestroyed( event.itemname )
	end
end

--------------------------------------------------------------------------------
-- OnQueryProgressChanged
-- > query_id - int
-- > progress - int
--------------------------------------------------------------------------------
function CDotaNPX:OnQueryProgressChanged( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnQueryProgressChanged( event.query_id, event.progress )
	end 
end

--------------------------------------------------------------------------------
-- OnQuerySucceeded
-- > query_id - int
--------------------------------------------------------------------------------
function CDotaNPX:OnQuerySucceeded( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnQuerySucceeded( event.query_id )
	end
end

--------------------------------------------------------------------------------
-- OnQueryFailed
-- > query_id - int
--------------------------------------------------------------------------------
function CDotaNPX:OnQueryFailed( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnQueryFailed( event.query_id )
	end
end

--------------------------------------------------------------------------------
-- OnRestartScenarioClicked
--------------------------------------------------------------------------------
function CDotaNPX:OnRestartScenarioClicked()
	self:RestartScenario()
end

--------------------------------------------------------------------------------
-- OnExitScenarioClicked
--------------------------------------------------------------------------------
function CDotaNPX:OnExitScenarioClicked()
	self:ExitScenario()
end

--------------------------------------------------------------------------------
-- OnWinScenarioClicked
--------------------------------------------------------------------------------
function CDotaNPX:OnWinScenarioClicked()
	self:WinScenario()
end

--------------------------------------------------------------------------------
-- task_started
-- > task_name - string
--------------------------------------------------------------------------------
function CDotaNPX:OnTaskStarted( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnTaskStarted( event )
	end
end

--------------------------------------------------------------------------------
-- task_completed
-- > task_name - string
-- > success - bool 
-- > checkpoint_skip - bool
-- > failure_reason - string
--------------------------------------------------------------------------------
function CDotaNPX:OnTaskCompleted( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnTaskCompleted( event )
	end
end

--------------------------------------------------------------------------------
-- spawner_finished
-- > spawner_name - string
--------------------------------------------------------------------------------
function CDotaNPX:OnSpawnerFinished( event )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnSpawnerFinished( event )
	end
end

--------------------------------------------------------------------------------
-- Gold Filter
-- > player_id_const - int
-- > gold - int
-- > reliable - bool
-- > reason_const - int
--------------------------------------------------------------------------------

function CDotaNPX:ModifyGoldFilter( filterTable )
	if self.CurrentScenario ~= nil and self.CurrentScenario.hScenario.bLetGoldThrough ~= nil and self.CurrentScenario.hScenario.bLetGoldThrough == false then
		return false
	end

	return true
end

--------------------------------------------------------------------------------
-- Experience Filter
-- > player_id_const - int
-- > hero_entindex_const - int
-- > experience - float
-- > reason_const - int
--------------------------------------------------------------------------------

function CDotaNPX:ModifyExperienceFilter( filterTable )
	if self.CurrentScenario ~= nil and self.CurrentScenario.hScenario.bLetXPThrough ~= nil and self.CurrentScenario.hScenario.bLetXPThrough == false then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function CDotaNPX:OnUIHintAdvanced( nSourceEventIndex, data )
	if self.CurrentScenario ~= nil then
		self.CurrentScenario:OnUIHintAdvanced( data[ "ui_hint_id" ] )
	end
end
