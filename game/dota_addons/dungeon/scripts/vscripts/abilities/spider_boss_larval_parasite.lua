
spider_boss_larval_parasite = class({})

LinkLuaModifier( "modifier_spider_boss_larval_parasite", "modifiers/modifier_spider_boss_larval_parasite", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spider_boss_larval_parasite:OnAbilityPhaseStart()
	if IsServer() then
		self:PlayLarvalParasiteSpeech()

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 175, 175, 175 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 131, 251, 40 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function spider_boss_larval_parasite:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

-----------------------------------------------------------------------------

function spider_boss_larval_parasite:GetPlaybackRateOverride()
	return 0.3
end

--------------------------------------------------------------------------------

function spider_boss_larval_parasite:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		--self.damage = self:GetSpecialValueFor( "damage" )
		self.buff_duration = self:GetSpecialValueFor( "buff_duration" )
		self.projectile_width_initial = self:GetSpecialValueFor( "projectile_width_initial" )
		self.projectile_width_end = self:GetSpecialValueFor( "projectile_width_end" )
		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		
		local fCastRange = self:GetCastRange( self:GetCaster():GetOrigin(), nil )
		local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, fCastRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

		for _, hEnemy in pairs( hEnemies ) do
			local vPos = hEnemy:GetOrigin()
			local vDirection = vPos - self:GetCaster():GetOrigin()
			vDirection.z = 0.0
			vDirection = vDirection:Normalized()

			self.projectile_speed = self.projectile_speed * ( self.projectile_distance / ( self.projectile_distance - self.projectile_width_initial ) )

			local info = {
				--EffectName = "particles/test_particle/dungeon_broodmother_linear.vpcf",
				Ability = self,
				vSpawnOrigin = self:GetCaster():GetOrigin(), 
				fStartRadius = self.projectile_width_initial,
				fEndRadius = self.projectile_width_end,
				vVelocity = vDirection * self.projectile_speed,
				fDistance = self.projectile_distance,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			}

			ProjectileManager:CreateLinearProjectile( info )

			local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_broodmother_linear.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, info.vVelocity )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.projectile_width_end, self.projectile_width_end, self.projectile_width_end ) )
		end

		EmitSoundOn( "Broodmother.LarvalParasite.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function spider_boss_larval_parasite:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_spider_boss_larval_parasite", { duration = self.buff_duration } )

			EmitSoundOn( "Broodmother.LarvalParasite.Impact", hTarget );
		end

		return true
	end
end

--------------------------------------------------------------------------------

function spider_boss_larval_parasite:PlayLarvalParasiteSpeech()
	if IsServer() then
		if self:GetCaster().nLastLarvalSound == nil then
			self:GetCaster().nLastLarvalSound = -1
		end

		local nSound = RandomInt( 1, 3 )
		while nSound == self:GetCaster().nLastLarvalSound do 
			nSound = RandomInt( 1, 3 )
		end

		if nSound == 1 then
			EmitSoundOn( "broodmother_broo_attack_06", self:GetCaster() )
		end
		if nSound == 2 then
			EmitSoundOn( "broodmother_broo_attack_10", self:GetCaster() )
		end
		if nSound == 3 then
			EmitSoundOn( "broodmother_broo_attack_11", self:GetCaster() )
		end
		if nSound == 4 then
			EmitSoundOn( "broodmother_broo_attack_12", self:GetCaster() )
		end

		self:GetCaster().nLastLarvalSound = nSound
	end
end

--------------------------------------------------------------------------------

