
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Wendigoes == nil then
	CMapEncounter_Wendigoes = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Wendigoes:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	------------------------
	-- Pre-placed units
	------------------------
	self:AddSpawner( CDotaSpawner( "spawner_frostbitten", "spawner_frostbitten",
		{
			{
				EntityName = "npc_dota_creature_frostbitten_melee",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			}
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_shaman", "spawner_shaman",
		{
			{
				EntityName = "npc_dota_creature_frostbitten_ranged",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 200.0,
			}
		} ) )

    self.hGiantWendigoSpawner = self:AddSpawner( CDotaSpawner( "spawner_giant_wendigo", "spawner_giant_wendigo",
		{
			{
				EntityName = "npc_dota_giant_wendigo",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 50.0,
			}
		} ) )

	self:SetSpawnerSchedule( "spawner_frostbitten", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_shaman", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_giant_wendigo", nil )	-- means spawn once when triggered 
end

--------------------------------------------------------------------------------

function CMapEncounter_Wendigoes:GetPreviewUnit()
	return "npc_dota_giant_wendigo"
end

--------------------------------------------------------------------------------

function CMapEncounter_Wendigoes:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

return CMapEncounter_Wendigoes
