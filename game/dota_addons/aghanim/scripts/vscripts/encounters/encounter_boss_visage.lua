require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BossVisage == nil then
	CMapEncounter_BossVisage = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVisage:constructor( hRoom, szEncounterName )
	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	self:AddSpawner( CDotaSpawner( "spawner_boss", "spawner_boss",
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
	
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_familiar", "spawner_familiar", 
		{
			{
				EntityName = "npc_dota_boss_visage_familiar",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
	
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_familiar_statue_east", "spawner_familiar_statue_east", 
		{
			{
				EntityName = "npc_dota_boss_visage_familiar_statue",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
	
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_familiar_statue_west", "spawner_familiar_statue_west", 
		{
			{
				EntityName = "npc_dota_boss_visage_familiar_statue",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
	
			},
		} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVisage:GetPreviewUnit()
	return "npc_dota_boss_visage"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVisage:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )
	
	PrecacheUnitByNameSync( "npc_dota_boss_visage_familiar", context, -1 )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_visage", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_visage.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVisage:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )

	self.vecFamiliars = self:GetSpawner( "spawner_familiar" ):SpawnUnits()
	self.vecFamiliarStatuesWest = self:GetSpawner( "spawner_familiar_statue_west" ):SpawnUnits()
	self.vecFamiliarStatuesEast = self:GetSpawner( "spawner_familiar_statue_east" ):SpawnUnits()
	for _,Familiar in pairs ( self.vecFamiliars ) do
		Familiar:FaceTowards( self:GetSpawner( "spawner_boss" ):GetSpawners()[1]:GetAbsOrigin() )
	end

	for _,StatueWest in pairs ( self.vecFamiliarStatuesWest ) do
		StatueWest:SetAbsAngles( 0, 0, 0 )
	end

	for _,StatueEast in pairs ( self.vecFamiliarStatuesEast ) do
		StatueEast:SetAbsAngles( 0, 180, 0 )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVisage:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVisage:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_boss_visage_familiar" then
    	return false
    end
    if hEnemyCreature:GetUnitName() == "npc_dota_boss_visage_familiar_statue" then
    	return false
    end
    return true
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVisage:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )
	hBoss.AI:SetEncounter( self )
	hBoss.WestStatues = self.vecFamiliarStatuesWest
	hBoss.EastStatues = self.vecFamiliarStatuesEast

	for _,Familiar in pairs ( self.vecFamiliars ) do
		Familiar:FaceTowards( self:GetSpawner( "spawner_boss" ):GetSpawners()[1]:GetAbsOrigin() )
		Familiar:FindAbilityByName( "boss_visage_familiar_stone_form" ):OnSpellStart()
	end

	for _,StatueWest in pairs ( self.vecFamiliarStatuesWest ) do
		StatueWest:FindAbilityByName( "boss_visage_familiar_stone_form" ):OnSpellStart()
	end
	
	for _,StatueEast in pairs ( self.vecFamiliarStatuesEast ) do
		StatueEast:FindAbilityByName( "boss_visage_familiar_stone_form" ):OnSpellStart()
	end
end

---------------------------------------------------------------------------

function CMapEncounter_BossVisage:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )

	for _,Familiar in pairs ( self.vecFamiliars ) do
		Familiar:ForceKill( false )
	end

	for _,StatueWest in pairs ( self.vecFamiliarStatuesWest ) do
		StatueWest:ForceKill( false )
	end
	
	for _,StatueEast in pairs ( self.vecFamiliarStatuesEast ) do
		StatueEast:ForceKill( false )
	end
end


--------------------------------------------------------------------------------

return CMapEncounter_BossVisage
