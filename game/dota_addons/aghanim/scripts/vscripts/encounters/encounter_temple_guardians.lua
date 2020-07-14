
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_boss_base" )

--------------------------------------------------------------------------------

if CMapEncounter_TempleGuardians == nil then
	CMapEncounter_TempleGuardians = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:constructor( hRoom, szEncounterName )

	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )


	self.szBossSpawner = "spawner_boss"

	self:AddSpawner( CDotaSpawner( self.szBossSpawner, self.szBossSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_temple_guardian",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetPreviewUnit()
	return "npc_dota_creature_temple_guardian"
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetBossIntroGesture()
	return ACT_DOTA_CAPTURE
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetBossIntroCameraPitch()
	return 30
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetBossIntroCameraDistance()
	return 800
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetBossIntroCameraHeight()
	return 85
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetBossIntroCameraYawRotateSpeed()
	return 0.1
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetBossIntroCameraInitialYaw()
	return 120
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:GetBossIntroDuration()
	return 5.0
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGuardians:IntroduceBoss( hEncounteredBoss )
	CMapEncounter_BossBase.IntroduceBoss( self, hEncounteredBoss )

	EmitGlobalSound( "Boss.Intro" )
end

--------------------------------------------------------------------------------

return CMapEncounter_TempleGuardians
