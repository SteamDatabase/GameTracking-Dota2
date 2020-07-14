require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

--------------------------------------------------------------------------------

if CMapEncounter_BonusChicken == nil then
	CMapEncounter_BonusChicken = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusChicken:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_bonus_chicken",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		} ) )

end

--------------------------------------------------------------------------------

function CMapEncounter_BonusChicken:GetPreviewUnit()
	return "npc_dota_creature_bonus_chicken"
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusChicken:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )
	self:SetupBristlebackShop( false )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusChicken:OnTriggerStartTouch( event )
	CMapEncounter_BonusBase.OnTriggerStartTouch( self, event )

	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )

	if self.bGameStarted == false and szTriggerName == "trigger_spawn_creatures" then
		self:GetSpawner( "spawner_peon" ):SpawnUnits()
		self:StartBonusRound( 45.0 )

		EmitGlobalSound( "BonusRoom.ChaseMusicLoop" )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusChicken:CheckForCompletion()
	return self.bGameStarted == true and not self:HasRemainingEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusChicken:OnComplete()
	CMapEncounter_BonusBase.OnComplete( self )

	StopGlobalSound( "BonusRoom.ChaseMusicLoop" )
end

--------------------------------------------------------------------------------

return CMapEncounter_BonusChicken
