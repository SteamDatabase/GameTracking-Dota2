vengeful_spirit_magic_missile_projectile = class({})

----------------------------------------------------------------------------------------

function vengeful_spirit_magic_missile_projectile:Precache( context )
	PrecacheResource( "particle", "particles/creatures/vengeful_spirit/magic_missile_linear.vpcf", context )
end

--------------------------------------------------------------------------------

function vengeful_spirit_magic_missile_projectile:OnSpellStart()
	if IsServer() then
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" ) 
		self.duration = self:GetSpecialValueFor( "duration" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		
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
			EffectName = "particles/creatures/vengeful_spirit/magic_missile_linear.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ),
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function vengeful_spirit_magic_missile_projectile:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		local hCaster = self:GetCaster()
		if 	hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage = {
				victim = hTarget,
				attacker = hCaster,
				damage = self.attack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}
			ApplyDamage( damage )

			-- kill and pass through zombies
			if hTarget:IsZombie() == true then
				return false
			end

			hTarget:AddNewModifier( hCaster, self, "modifier_stunned", { duration = self.stun_duration } )

			EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )

			return true
		end

		return false
	end
end

--------------------------------------------------------------------------------