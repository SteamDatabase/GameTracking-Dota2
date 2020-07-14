boss_visage_ranged_attack = class({})

----------------------------------------------------------------------------------------

function boss_visage_ranged_attack:Precache( context )
	PrecacheResource( "particle", "particles/creatures/visage_boss_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/quill_beast/test_model_cluster_linear_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )

	self.Projectiles = {}
end

--------------------------------------------------------------------------------

function boss_visage_ranged_attack:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_Visage.preAttack", self:GetCaster() )
	end
	return true
end

--------------------------------------------------------------------------------

function boss_visage_ranged_attack:OnSpellStart()
	if IsServer() then
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" ) 
		
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.attack_speed = self.attack_speed * ( self.attack_distance / ( self.attack_distance - self.attack_width_initial ) )

		local info = {
			EffectName = "particles/creatures/quill_beast/test_model_cluster_linear_projectile.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack1" ) ), 
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_Visage.Attack", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function boss_visage_ranged_attack:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.attack_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self
			}

			ApplyDamage( damage )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true  );
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			EmitSoundOn( "Hero_Visage.projectileImpact", hTarget )
		end

		return true
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------