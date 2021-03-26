require( "npx_scenario" )
require( "spawner" )

--------------------------------------------------------------------

if CDotaNPXScenario_GlimmerCape == nil then
	CDotaNPXScenario_GlimmerCape = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:InitScenarioKeys()
	self.fSurviveForTime1 = 20
	self.fSurviveForTime2 = 20
	self.fSurviveForTime3 = 20

	self.hScenario =
	{
		DaynightCycleDisabled = true,
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_crystal_maiden",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel	= 3,
		StartingGold		= 0,

		StartingItems 		=
		{
			"item_glimmer_cape",
		},

		StartingAbilities =
		{
		},

		ScenarioTimeLimit = 600.0,

		Tasks =
		{
			{
				TaskName = "intro_delay",
				TaskType = "task_delay",
				Hidden = true,
				TaskParams =
				{
					Delay = 2.0,
				},
				CheckTaskStart =
				function() 
					if GameRules:GetDOTATime( false, false ) >= 0.0 then 
						return true 
					else 
						return false 
					end
				end,
			},

			{
				TaskName = "do_not_die",
				TaskType = "task_fail_player_hero_death",
				Hidden = true,
				TaskParams = 
				{
					Count = 1,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "intro_delay" )
				end,
			},
			{
				TaskName = "move_to_start",
				TaskType = "task_move_to_trigger",
				Hidden = true,
				TaskParams =
				{
					TriggerName = "start_trigger",
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "intro_delay" )
				end,
			},
			{
				TaskName = "move_to_escape",
				TaskType = "task_move_to_trigger",
				UseHints = true,
				TaskParams =
				{
					TriggerName = "escape_trigger",
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "intro_delay" )
				end,
				OnCheckpoint =
				function()
					print( 'CHECKPOINT 1' )

					local Task
					Task = self:GetTask( "move_to_escape" )
					if Task then Task:SetTaskHidden( true ) end

					local bForceStart = true
					self:CheckpointSkipCompleteTask( "intro_delay", true, bForceStart )
					self:CheckpointSkipCompleteTask( "move_to_escape", true )

					if self:GetPlayerHero() ~= nil then
						local hCheckpointPos = Entities:FindByName( nil, "crystal_maiden_start_location_2" )
						if hCheckpointPos ~= nil then
							FindClearSpaceForUnit( self:GetPlayerHero(), hCheckpointPos:GetAbsOrigin(), true )
							SendToConsole( "+dota_camera_center_on_hero" )
							SendToConsole( "-dota_camera_center_on_hero" )
						end
					end
				end,
			},
			{
				TaskName = "move_to_location_2",
				TaskType = "task_move_to_trigger",
				Hidden = true,
				UseHints = true,
				TaskParams =
				{
					TriggerName = "start_trigger_2",
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_escape" )
				end,
			},
			{
				TaskName = "protect_ogre",
				TaskType = "task_protect_units",
				TaskParams =
				{
					FailureString = "scenario_glimmer_cape_failure_ogre_died",
				},
				CheckTaskStart = 
				function()
					return GameRules.DotaNPX:IsTaskComplete( "move_to_escape" )
				end,
				OnCheckpoint =
				function()
					print( 'CHECKPOINT 2' )

					local Task
					Task = self:GetTask( "move_to_escape" )
					if Task then Task:SetTaskHidden( true ) end
					Task = self:GetTask( "protect_ogre" )
					if Task then Task:SetTaskHidden( true ) end

					local bForceStart = true
					self:CheckpointSkipCompleteTask( "intro_delay", true, bForceStart )
					self:CheckpointSkipCompleteTask( "move_to_escape", true )
					self:CheckpointSkipCompleteTask( "move_to_location_2", true )
					self:CheckpointSkipCompleteTask( "protect_ogre", true )

					if self:GetPlayerHero() ~= nil then
						local hCheckpointPos = Entities:FindByName( nil, "crystal_maiden_start_location_3" )
						if hCheckpointPos ~= nil then
							FindClearSpaceForUnit( self:GetPlayerHero(), hCheckpointPos:GetAbsOrigin(), true )
							SendToConsole( "+dota_camera_center_on_hero" )
							SendToConsole( "-dota_camera_center_on_hero" )
						end
					end
				end,
			},
			{
				TaskName = "move_to_start_3",
				TaskType = "task_move_to_trigger",
				Hidden = true,
				TaskParams =
				{
					TriggerName = "start_trigger_3",
				},
				CheckTaskStart = 
				function() 
					local task = self:GetTask( "protect_ogre" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end
					return false
				end,
			},
			{
				TaskName = "protect_sniper",
				TaskType = "task_protect_units",
				Hidden = true,
				TaskParams =
				{
					FailureString = "scenario_glimmer_cape_failure_sniper_died",
				},
				CheckTaskStart = 
				function()
					local task = self:GetTask( "protect_ogre" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end
					return false
				end,
			},
			{
				TaskName = "kill_necrophos",
				TaskType = "task_kill_units",
				TaskParams =
				{
				},
				CheckTaskStart = 
				function() 
					local task = self:GetTask( "protect_ogre" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end
					return false
				end,
			}
		},

		Queries =
		{
		},
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:SetHeroRespawnEnabled( false )

	self.hTutorialBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	if #self.hTutorialBlockers == 0 then
		print( "WARNING - Found no blockers!" )
	end

	return true
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	self:GetPlayerHero():SetAbilityPoints( 0 )
end

--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )

	print( 'OnHeroFinishSpawn' )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:OnNPCSpawned( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	

	print( 'CDotaNPXScenario_GlimmerCape:OnNPCSpawned - ' .. hEnt:GetUnitName() )

	if hEnt == nil or hEnt:IsNull() == true then
		return
	end

	if hEnt:GetUnitName() == "npc_dota_hero_chaos_knight" then

		self.hCK = hEnt
		--self.hCK:AddNewModifier( self.hCK, nil, "modifier_no_damage", {} )

		-- if we've hit the checkpoint then put the CK into ogre hunting mode
		if self.szCheckpointTaskName then
			if hEnt.Bot then
				hEnt.Bot:SetMode( "attack_ogre" )
			else
				print( 'ERROR: CK .Bot is nil!' )
			end
		end

	elseif hEnt:GetUnitName() == "npc_dota_hero_ogre_magi" then

		self.hOgre = hEnt

		local TaskProtect = self:GetTask( "protect_ogre")
		if TaskProtect then
			printf( "found task protect_ogre, doing SetUnitsToProtect")
			local hUnitsToProtect = {}
			table.insert( hUnitsToProtect, hEnt )
			TaskProtect:SetUnitsToProtect( hUnitsToProtect )
		end

	elseif hEnt:GetUnitName() == "npc_dota_hero_sniper" then

		self.hSniper = hEnt

		local TaskProtect = self:GetTask( "protect_sniper")
		if TaskProtect then
			printf( "found task protect_sniper, doing SetUnitsToProtect")
			local hUnitsToProtect = {}
			table.insert( hUnitsToProtect, hEnt )
			TaskProtect:SetUnitsToProtect( hUnitsToProtect )
		end

	elseif hEnt:GetUnitName() == "npc_dota_hero_necrolyte" then

		self.hNecrophos = hEnt

		local TaskKill = self:GetTask( "kill_necrophos")
		if TaskKill then
			printf( "found task kill_necrophos, doing SetUnitsToKill" )
			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hEnt )
			TaskKill:SetUnitsToKill( hUnitsToKill )
		end

	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	print( 'Task Completed - ' .. Task:GetTaskName() )

	if Task:GetTaskName() == "kill_necrophos" then
		local task = self:GetTask( "protect_sniper" )
		if task and task:IsCompleted() == false then
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				
				self:OnScenarioRankAchieved( 1 )

			end )
		end

	elseif Task:GetTaskName() == "move_to_start_3" then

		if self.hNecrophos ~= nil and self.hNecrophos.Bot ~= nil then
			self.hNecrophos.Bot:MoveToAttackPos()
		end

	elseif Task:GetTaskName() == "protect_ogre" then
		if event.success == 1 then

			local hPlayerHero = self:GetPlayerHero()
			RefreshHero( hPlayerHero )

			if self.hCK and self.hCK:IsNull() == false and self.hCK.Bot then
				self.hCK.Bot:TpOut()
				self.hCK = nil
			end

			if self.hOgre and self.hOgre:IsNull() == false and self.hOgre.Bot then
				self.hOgre.Bot:TpOut()
				self.hOgre = nil
			end

			for _,hBlocker in pairs ( self.hTutorialBlockers ) do
				hBlocker:SetEnabled( false )
			end

			self.hSniperSpawner = CDotaSpawner( "sniper_spawn_pos", 
			{
				{
					EntityName = "npc_dota_hero_sniper",
					Team = DOTA_TEAM_GOODGUYS,
					Count = 1,
					PositionNoise = 0,
					StartingHealth = 600,
					BotPlayer =
					{
						PlayerID = 1,
						BotName = "Sniper",
						EntityScript = "ai/glimmer_cape/ai_sniper.lua",
						StartingHeroLevel = 8,
						StartingItems = 
						{
							"item_power_treads",
							"item_satanic",
						},
						StartingAbilities =
						{
						},
						AbilityBuild = 
						{
							AbilityPriority =
							{
							},
						},
					},
				},
			}, self, true )

		self.hNecrophosSpawner = CDotaSpawner( "necrophos_spawn_pos", 
		{
			{
				EntityName = "npc_dota_hero_necrolyte",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "Necrophos",
					EntityScript = "ai/glimmer_cape/ai_necrophos.lua",
					StartingHeroLevel = 10,
					StartingItems = 
					{
						"item_boots",
						"item_gem",
						--"item_greater_crit",
					},
					StartingAbilities =
					{
						"necrolyte_reapers_scythe",
						"necrolyte_reapers_scythe",
					},
					AbilityBuild = 
					{
						AbilityPriority =
						{
							"necrolyte_reapers_scythe",
							"necrolyte_reapers_scythe",
						},
					},
				},
			},
		}, self, true )

		end	

	elseif Task:GetTaskName() == "move_to_escape" then

		self.hOgreSpawner = CDotaSpawner( "ogre_spawn_pos", 
		{
			{
				EntityName = "npc_dota_hero_ogre_magi",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 2,
					BotName = "Ogre Magi",
					EntityScript = "ai/glimmer_cape/ai_ogre.lua",
					StartingHeroLevel = 3,
					StartingItems = 
					{
					},
					StartingAbilities =
					{
					},
				},
			},
		}, self, true )

	end


	if event.checkpoint_skip == 1 then
		print( 'Checkpoint Skipping past the task completed logic for - ' .. Task:GetTaskName() )
		return
	end


	if Task:GetTaskName() == "intro_delay" then
		
		local hEscapeTrigger = Entities:FindByName( nil, "escape_trigger" )
		if hEscapeTrigger then
			SendToConsole( "dota_camera_lerp_position " .. hEscapeTrigger:GetAbsOrigin().x .. " " .. hEscapeTrigger:GetAbsOrigin().y .. " " .. 1 )
		
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2.5, function()
				SendToConsole( "dota_camera_lerp_position " .. self:GetPlayerHero():GetAbsOrigin().x .. " " .. self:GetPlayerHero():GetAbsOrigin().y .. " " .. 1 )
				--SendToConsole( "+dota_camera_center_on_hero" )
				--SendToConsole( "-dota_camera_center_on_hero" )
			end )

			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3.5, function()
				self:ShowItemHint( "item_glimmer_cape" )
			end )

			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 9.5, function()
				self:HideUIHint()
			end )
		end

	elseif Task:GetTaskName() == "move_to_start" then
		self.hCKSpawner = CDotaSpawner( "chaos_knight_spawn_pos", 
		{
			{
				EntityName = "npc_dota_hero_chaos_knight",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "Chaos Knight",
					EntityScript = "ai/glimmer_cape/ai_chaos_knight.lua",
					StartingHeroLevel = 10,
					StartingItems = 
					{
						"item_phase_boots",
						"item_echo_sabre",
						"item_greater_crit",
					},
					StartingAbilities =
					{
						"chaos_knight_chaos_bolt",
					},
					AbilityBuild = 
					{
						AbilityPriority =
						{
							"chaos_knight_chaos_bolt",
						},
					},
				},
			},
		}, self, true )

	elseif Task:GetTaskName() == "move_to_location_2" then
		self.hCKSpawner = CDotaSpawner( "chaos_knight_spawn_pos_2", 
		{
			{
				EntityName = "npc_dota_hero_chaos_knight",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "Chaos Knight",
					EntityScript = "ai/glimmer_cape/ai_chaos_knight.lua",
					StartingHeroLevel = 10,
					StartingItems = 
					{
						"item_phase_boots",
						"item_echo_sabre",
						"item_greater_crit",
					},
					StartingAbilities =
					{
						"chaos_knight_chaos_bolt",
					},
					AbilityBuild = 
					{
						AbilityPriority =
						{
							"chaos_knight_chaos_bolt",
						},
					},
				},
			},
		}, self, true )

		if self.hOgre and self.hOgre.Bot then
			self.hOgre.Bot:GoToDestination()
		else
			print( 'ERROR: Ogre bot ref is missing!' )
		end

		local hOgreUnitLocation = Entities:FindByName( nil, "ogre_move_pos" )		
		if hOgreUnitLocation ~= nil then
 			self:HintLocation( hOgreUnitLocation:GetAbsOrigin(), true )
 		end

	elseif Task:GetTaskName() == "move_to_escape" then

		local hPlayerHero = self:GetPlayerHero()
		RefreshHero( hPlayerHero )

		if self.hCK and self.hCK:IsNull() == false and self.hCK.Bot then
			self.hCK.Bot:TpOut()
			self.hCK = nil
		end

	elseif Task:GetTaskName() == "protect_ogre" then
		local hOgreUnitLocation = Entities:FindByName( nil, "ogre_move_pos" )		
		if hOgreUnitLocation ~= nil then
 			self:HintLocation( hOgreUnitLocation:GetAbsOrigin(), false )
 		end

		if event.success == 1 then
			self:Fade( 1 )
			self:Fade( 0 )
		end

	end

end


--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	-- command restrict the player at the start of the scenario
	if Task:GetTaskName() == "intro_delay" and self.szCheckpointTaskName == nil then
		self:GetPlayerHero():AddNewModifier( self:GetPlayerHero(), nil, "modifier_command_restricted", { duration = 5 } )	
	end

	if Task:GetTaskName() == "move_to_escape" then
		self:ShowWizardTip( "scenario_glimmer_cape_wizard_tip_intro", 15.0, { "item_glimmer_cape" } )
	elseif Task:GetTaskName() == "move_to_location_2" then
		self:ShowWizardTip( "scenario_glimmer_cape_wizard_tip_ally", 15.0 )
	elseif Task:GetTaskName() == "move_to_start_3" then
		self:ShowWizardTip( "scenario_glimmer_cape_wizard_tip_magic_resist", 15.0 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:OnThink()
	CDotaNPXScenario.OnThink( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:Fade( nFade )
	-- Fade should be 1 to fade to black and 0 to fade in
	FireGameEvent("fade_to_black", {
		fade_down = nFade,
		} )
end

--------------------------------------------------------------------

function CDotaNPXScenario_GlimmerCape:ShowItemHint( szItemName )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	local hItem = self.hPlayerHero:FindItemInInventory( szItemName )
	if hItem then
		local nItemSlot = hItem:GetItemSlot()
		if nItemSlot >= 0 then
			self:ShowUIHint( "inventory_slot_" .. nItemSlot )
			return
		end
	end
	self:HideUIHint()
end

----------------------------------------------------------------------------

return CDotaNPXScenario_GlimmerCape