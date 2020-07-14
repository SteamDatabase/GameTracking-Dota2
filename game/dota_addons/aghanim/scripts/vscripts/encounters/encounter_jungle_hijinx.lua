require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_JungleHijinx == nil then
	CMapEncounter_JungleHijinx = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------


function CMapEncounter_JungleHijinx:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_huskar", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_dazzle", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context )
end


--------------------------------------------------------------------------------

function CMapEncounter_JungleHijinx:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_wildwing_laborer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 150.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_dazzle", "spawner_dazzle",
		{ 
			{
				EntityName = "npc_dota_creature_dazzle",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_huskar",  "spawner_huskar",
		{ 
			{
				EntityName = "npc_dota_creature_huskar",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:SetSpawnerSchedule( "spawner_peon", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_dazzle", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_huskar", nil )	-- means spawn once when triggered 

end


--------------------------------------------------------------------------------

function CMapEncounter_JungleHijinx:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_JungleHijinx:GetPreviewUnit()
	return "npc_dota_creature_huskar"
end

--------------------------------------------------------------------------------

function CMapEncounter_JungleHijinx:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )	
end


--------------------------------------------------------------------------------

function CMapEncounter_JungleHijinx:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerName() == "spawner_huskar" then
		for _,hUnit in pairs ( hSpawnedUnits ) do
			if hUnit then
				local hBurningSpears = hUnit:FindAbilityByName( "huskar_burning_spear" )
				if hBurningSpears then
					hBurningSpears:ToggleAutoCast()
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_JungleHijinx
