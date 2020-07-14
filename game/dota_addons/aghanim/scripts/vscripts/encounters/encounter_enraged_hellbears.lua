require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounterEnragedHellbears == nil then
	CMapEncounterEnragedHellbears = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounterEnragedHellbears:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )
	
	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"

	self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_small_hellbear",
				Team = DOTA_TEAM_BADGUYS,
				Count = 7,
				PositionNoise = 225.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_hellbear",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 75.0,
			},
		} ) )

	self.flEnrageTimer = 60

end

--------------------------------------------------------------------------------

function CMapEncounterEnragedHellbears:GetPreviewUnit()
	return "npc_dota_creature_hellbear"
end

--------------------------------------------------------------------------------

function CMapEncounterEnragedHellbears:GetMaxSpawnedUnitCount()
	local nCount = 0
	local hWarriorSpawners = self:GetSpawner( self.szPeonSpawner )
	if hWarriorSpawners then
		nCount = nCount + hWarriorSpawners:GetSpawnPositionCount() * 6
	end

	local hChampionSpawners = self:GetSpawner( self.szCaptainSpawner )
	if hChampionSpawners then
		nCount = nCount + hChampionSpawners:GetSpawnPositionCount() 
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounterEnragedHellbears:Start()
	CMapEncounter.Start( self )
	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounterEnragedHellbears:OnThink()
	CMapEncounter.OnThink( self )
	local flNow = GameRules:GetGameTime()

	if ( flNow - self.flStartTime ) > self.flEnrageTimer then

		--printf("ENRAGING!!")

		for _,hMob in pairs ( self:GetSpawnedUnits() ) do

			if hMob:GetLevel() < 2 then
				--printf("UPGRADING CREATURE %s to level 2", hMob:GetUnitName())
				hMob:CreatureLevelUp(1)
				hMob:AddNewModifier( hMob, nil, "modifier_aghsfort_enrage" , {} )
				hMob:SetAcquisitionRange(9000)
			end

			local hAbility = hMob:FindAbilityByName("hellbear_smash")	
			if hAbility then
				--printf("UPGRADING ABILITY %s from %d to %d", hAbility:GetAbilityName(), hAbility:GetLevel(), 2 )
				hAbility:SetLevel(2)
			end

		end

	end
end

--------------------------------------------------------------------------------

function CMapEncounterEnragedHellbears:CheckForCompletion()
	if not self:HasRemainingEnemies() then
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function CMapEncounterEnragedHellbears:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

return CMapEncounterEnragedHellbears
