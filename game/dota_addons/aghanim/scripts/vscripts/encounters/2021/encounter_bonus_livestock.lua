require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

--------------------------------------------------------------------------------

if CMapEncounter_BonusLivestock == nil then
	CMapEncounter_BonusLivestock = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusLivestock:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )
	self.bAllButtonsReady = false
	self.nPlayersReady = 0
	self.nHeroOnTrigger1 = 0
	self.nHeroOnTrigger2 = 0
	self.nHeroOnTrigger3 = 0
	self.nHeroOnTrigger4 = 0
	self.flEndTime = nil

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_bonus_pig",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		} ) )

end

--------------------------------------------------------------------------------

function CMapEncounter_BonusLivestock:GetPreviewUnit()
	return "npc_dota_creature_bonus_pig"
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusLivestock:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )
	self:SetupBristlebackShop( false )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusLivestock:OnTriggerStartTouch( event )
	CMapEncounter_BonusBase.OnTriggerStartTouch( self, event )

	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )

	if self.bAllButtonsReady == true then
		return
	end

	if self.bGameStarted == false then
		if szTriggerName == "trigger_player_1" then
			self.nHeroOnTrigger1 = 1
		elseif szTriggerName == "trigger_player_2" then
			self.nHeroOnTrigger2 = 1
		elseif  szTriggerName == "trigger_player_3" then
			self.nHeroOnTrigger3 = 1
		elseif  szTriggerName == "trigger_player_4" then
			self.nHeroOnTrigger4 = 1
		end
		self.nPlayersReady = self.nHeroOnTrigger1 + self.nHeroOnTrigger2 + self.nHeroOnTrigger3 + self.nHeroOnTrigger4
		local vecPlayers = GameRules.Aghanim:GetConnectedPlayers()
		if #vecPlayers > 0 then
			if self.nPlayersReady == #vecPlayers then
				print("All players ready!")
				self.bAllButtonsReady = true
				self:GetSpawner( "spawner_peon" ):SpawnUnits()
				self:StartBonusRound( 45.0 )
				self.flEndTime = GameRules:GetGameTime() + 50
				EmitGlobalSound( "BonusRoom.ChaseMusicLoop" )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusLivestock:OnTriggerEndTouch( event )
	CMapEncounter_BonusBase.OnTriggerEndTouch( self, event )
	if self.bAllButtonsReady == true then
		return
	end

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	if szTriggerName == "trigger_player_1" then
		self.nHeroOnTrigger1 = 0
	elseif szTriggerName == "trigger_player_2" then
		self.nHeroOnTrigger2 = 0
	elseif  szTriggerName == "trigger_player_3" then
		self.nHeroOnTrigger3 = 0
	elseif  szTriggerName == "trigger_player_4" then
		self.nHeroOnTrigger4 = 0
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusLivestock:CheckForCompletion()
	if self.flEndTime ~= nil then
		if self.bGameStarted == true and not self:HasRemainingEnemies() then
			return true
		elseif self.bGameStarted == true and self.flEndTime <= GameRules:GetGameTime() then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusLivestock:OnComplete()
	CMapEncounter_BonusBase.OnComplete( self )

	StopGlobalSound( "BonusRoom.ChaseMusicLoop" )
end

--------------------------------------------------------------------------------

return CMapEncounter_BonusLivestock
