require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BambooGarden == nil then
	CMapEncounter_BambooGarden = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_BambooGarden:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_monkey_king", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_monkey_king.vsndevts", context )
	PrecacheResource( "particle", "particles/creatures/monkey_king/boundless_strike_preview.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/monkey_king/primal_spring_ground_preview.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/relict/relict_amp_gale.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_amp_glow.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_BambooGarden:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_boss", "spawner_boss",
		{ 
			{
				EntityName = "npc_dota_creature_monkey_king",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain", "spawner_captain",
		{ 
			{
				EntityName = "npc_dota_creature_large_relict",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )


	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_relict",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		} ) )

end

--------------------------------------------------------------------------------

function CMapEncounter_BambooGarden:GetMaxSpawnedUnitCount()
	local nLargeRelicts = self:GetSpawner( "spawner_captain" ):GetSpawnPositionCount()
	local nRelicts = self:GetSpawner( "spawner_peon" ):GetSpawnPositionCount() * 4
	local nMonkeyKings = self:GetSpawner( "spawner_boss" ):GetSpawnPositionCount()

	local nTotal = nLargeRelicts + nRelicts + nMonkeyKings
	printf( "GetMaxSpawnedUnitCount - nTotal: %d", nTotal )
	return nTotal
end

--------------------------------------------------------------------------------

function CMapEncounter_BambooGarden:GetPreviewUnit()
	return "npc_dota_creature_monkey_king"
end

--------------------------------------------------------------------------------

function CMapEncounter_BambooGarden:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_BambooGarden:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BambooGarden:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	-- Tint the relict models
	for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
		if hSpawnedUnit:GetUnitName() =="npc_dota_creature_relict" or 
			hSpawnedUnit:GetUnitName() =="npc_dota_creature_large_relict" then
			hSpawnedUnit:SetRenderColor(240,190,140)
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_BambooGarden
