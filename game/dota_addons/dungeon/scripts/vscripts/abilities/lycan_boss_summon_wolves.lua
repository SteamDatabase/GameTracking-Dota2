
lycan_boss_summon_wolves = class({})

--------------------------------------------------------------------------------

function lycan_boss_summon_wolves:OnAbilityPhaseStart()
	if IsServer() then
		local nSound = RandomInt( 1, 3 )
		if nSound == 1 then
			EmitSoundOn( "lycan_lycan_ability_summon_02", self:GetCaster() )
		end
		if nSound == 2 then
			EmitSoundOn( "lycan_lycan_ability_summon_03", self:GetCaster() )
		end
		if nSound == 3 then
			EmitSoundOn( "lycan_lycan_ability_summon_06", self:GetCaster() )
		end
	end
	return true
end

--------------------------------------------------------------------------------

function lycan_boss_summon_wolves:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "LycanBoss.SummonWolves", self:GetCaster() )
		local nHoundSpawns = 3
		local nHoundBossSpawns = 1
		local nWerewolves = 1
		if self:GetCaster():FindModifierByName( "modifier_lycan_boss_shapeshift" ) ~= nil then
			nHoundSpawns = 6
			nHoundBossSpawns = 2
			nWerewolves = 2
		end

		for i = 0, nHoundSpawns do
			if #self:GetCaster().LYCAN_BOSS_SUMMONED_UNITS + 1 < self:GetCaster().LYCAN_BOSS_MAX_SUMMONS then
				local hHound = CreateUnitByName( "npc_dota_creature_dire_hound", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hHound ~= nil then
					hHound:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
					table.insert( self:GetCaster().LYCAN_BOSS_SUMMONED_UNITS, hHound )
					if self:GetCaster().zone ~= nil then
						self:GetCaster().zone:AddEnemyToZone( hHound )
					end	

					local vRandomOffset = Vector( RandomInt( -300, 300 ), RandomInt( -300, 300 ), 0 )
					local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hHound, vSpawnPoint, true )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					ParticleManager:ReleaseParticleIndex(  ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHound ) )
				end
			end
		end

		for i = 0, nHoundBossSpawns do
			if #self:GetCaster().LYCAN_BOSS_SUMMONED_UNITS + 1 < self:GetCaster().LYCAN_BOSS_MAX_SUMMONS then
				local hHoundBoss = CreateUnitByName( "npc_dota_creature_dire_hound_boss", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hHoundBoss ~= nil then
					hHoundBoss:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
					table.insert( self:GetCaster().LYCAN_BOSS_SUMMONED_UNITS, hHoundBoss )
					if self:GetCaster().zone ~= nil then
						self:GetCaster().zone:AddEnemyToZone( hHoundBoss )
					end

					local vRandomOffset = Vector( RandomInt( -300, 300 ), RandomInt( -300, 300 ), 0 )
					local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hHoundBoss, vSpawnPoint, true )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					ParticleManager:ReleaseParticleIndex(  ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHoundBoss ) )
				end	
			end
		end

		for i = 0, nWerewolves do
			if #self:GetCaster().LYCAN_BOSS_SUMMONED_UNITS + 1 < self:GetCaster().LYCAN_BOSS_MAX_SUMMONS then
				local hWerewolf = CreateUnitByName( "npc_dota_creature_werewolf", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hWerewolf ~= nil then
					hWerewolf:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
					table.insert( self:GetCaster().LYCAN_BOSS_SUMMONED_UNITS, hWerewolf )
					if self:GetCaster().zone ~= nil then
						self:GetCaster().zone:AddEnemyToZone( hWerewolf )
					end

					local vRandomOffset = Vector( RandomInt( -300, 300 ), RandomInt( -300, 300 ), 0 )
					local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hWerewolf, vSpawnPoint, true )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					ParticleManager:ReleaseParticleIndex(  ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hWerewolf ) )
				end	
			end
		end

		self:GetCaster().nCAST_SUMMON_WOLVES_COUNT = self:GetCaster().nCAST_SUMMON_WOLVES_COUNT + 1
	end
end

--------------------------------------------------------------------------------

function lycan_boss_summon_wolves:GetCooldown( iLevel )
	local fReducedCD = self.BaseClass.GetCooldown( self, self:GetLevel() ) - ( self:GetCaster().nCAST_SUMMON_WOLVES_COUNT * 3 )
	local fMinCD = ( self.BaseClass.GetCooldown( self, self:GetLevel() ) / 2 ) + 5
	local fNewCD = math.max( fMinCD, fReducedCD )
	--print( string.format( "lycan_boss_summon_wolves:GetCooldown - fReducedCD: %d, fMinCD: %d, fNewCD: %d", fReducedCD, fMinCD, fNewCD ) )

	return fNewCD
end

--------------------------------------------------------------------------------

