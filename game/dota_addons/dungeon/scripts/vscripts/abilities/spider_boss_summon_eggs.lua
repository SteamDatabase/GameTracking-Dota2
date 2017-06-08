
spider_boss_summon_eggs = class({})

--------------------------------------------------------------------------------

function spider_boss_summon_eggs:OnAbilityPhaseStart()
	if IsServer() then
		self:PlaySummonEggsSpeech()

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function spider_boss_summon_eggs:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function spider_boss_summon_eggs:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "LycanBoss.SummonWolves", self:GetCaster() )

		local nEggSpawns = 8
		local nPoisonSpiderSpawns = 4

		for i = 0, nEggSpawns do
			if #self:GetCaster().hSummonedUnits + 1 < self:GetCaster().nMaxSummonedUnits then
				local hEgg = CreateUnitByName( "npc_dota_spider_sack", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hEgg ~= nil then
					hEgg:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
					table.insert( self:GetCaster().hSummonedUnits, hEgg )
					if self:GetCaster().zone ~= nil then
						self:GetCaster().zone:AddEnemyToZone( hEgg )
					end	

					local vRandomOffset = Vector( RandomInt( -600, 600 ), RandomInt( -600, 600 ), 0 )
					local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hEgg, vSpawnPoint, true )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPoint )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
		end

		for i = 0, nPoisonSpiderSpawns do
			if #self:GetCaster().hSummonedUnits + 1 < self:GetCaster().nMaxSummonedUnits then
				local hPoisonSpider = CreateUnitByName( "npc_dota_creature_spider_medium", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hPoisonSpider ~= nil then
					hPoisonSpider:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
					table.insert( self:GetCaster().hSummonedUnits, hPoisonSpider )
					if self:GetCaster().zone ~= nil then
						self:GetCaster().zone:AddEnemyToZone( hPoisonSpider )
					end	

					local vRandomOffset = Vector( RandomInt( -600, 600 ), RandomInt( -600, 600 ), 0 )
					local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hPoisonSpider, vSpawnPoint, true )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPoint )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
		end

		self:GetCaster().nNumSummonCasts = self:GetCaster().nNumSummonCasts + 1
	end
end

--------------------------------------------------------------------------------

function spider_boss_summon_eggs:GetCooldown( iLevel )
	if self:GetCaster().nNumSummonCasts == nil then
		self:GetCaster().nNumSummonCasts = 0
	end
	local fReducedCD = self.BaseClass.GetCooldown( self, self:GetLevel() ) - ( self:GetCaster().nNumSummonCasts * 5 )
	local fMinCD = ( self.BaseClass.GetCooldown( self, self:GetLevel() ) / 2 ) + 5
	local fNewCD = math.max( fMinCD, fReducedCD )
	--print( string.format( "spider_boss_summon_eggs:GetCooldown - fReducedCD: %d, fMinCD: %d, fNewCD: %d", fReducedCD, fMinCD, fNewCD ) )

	return fNewCD
end

--------------------------------------------------------------------------------

function spider_boss_summon_eggs:PlaySummonEggsSpeech()
	if IsServer() then
		if self:GetCaster().nLastSummonEggsSound == nil then
			self:GetCaster().nLastSummonEggsSound = -1
		end

		local nSound = RandomInt( 1, 12 )
		while nSound == self:GetCaster().nLastSummonEggsSound do
			nSound = RandomInt( 1, 12 )
		end

		if nSound == 1 then
			EmitSoundOn( "broodmother_broo_ability_spawn_01", self:GetCaster() )
		end
		if nSound == 2 then
			EmitSoundOn( "broodmother_broo_ability_spawn_02", self:GetCaster() )
		end
		if nSound == 3 then
			EmitSoundOn( "broodmother_broo_ability_spawn_03", self:GetCaster() )
		end
		if nSound == 4 then
			EmitSoundOn( "broodmother_broo_ability_spawn_04", self:GetCaster() )
		end
		if nSound == 5 then
			EmitSoundOn( "broodmother_broo_ability_spawn_05", self:GetCaster() )
		end
		if nSound == 6 then
			EmitSoundOn( "broodmother_broo_ability_spawn_06", self:GetCaster() )
		end
		if nSound == 7 then
			EmitSoundOn( "broodmother_broo_ability_spawn_07", self:GetCaster() )
		end
		if nSound == 8 then
			EmitSoundOn( "broodmother_broo_ability_spawn_08", self:GetCaster() )
		end
		if nSound == 9 then
			EmitSoundOn( "broodmother_broo_ability_spawn_09", self:GetCaster() )
		end
		if nSound == 10 then
			EmitSoundOn( "broodmother_broo_ability_spawn_10", self:GetCaster() )
		end
		if nSound == 11 then
			EmitSoundOn( "broodmother_broo_ability_spawn_11", self:GetCaster() )
		end
		if nSound == 12 then
			EmitSoundOn( "broodmother_broo_ability_spawn_12", self:GetCaster() )
		end

		self:GetCaster().nLastSummonEggsSound = nSound
	end
end

--------------------------------------------------------------------------------

