aghslab_phantom_lancer_spirit_lance = class({})

----------------------------------------------------------------------------------------

function aghslab_phantom_lancer_spirit_lance:Precache( context )
	PrecacheResource( "particle", "particles/creatures/phantom_lancer/pl_spirit_lance_projectile.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_phantom_lancer.vsndevts", context )

	self.Projectiles = {}
end

--------------------------------------------------------------------------------

function aghslab_phantom_lancer_spirit_lance:OnSpellStart()
	if IsServer() then
		self.lance_speed = self:GetSpecialValueFor( "lance_speed" )
		self.lance_distance = self:GetSpecialValueFor( "lance_distance" )
		self.lance_damage = self:GetSpecialValueFor( "lance_damage" ) 
		self.duration = self:GetSpecialValueFor( "duration" )
		self.num_illusions = self:GetSpecialValueFor( "num_illusions" )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local info = {
			EffectName = "particles/creatures/phantom_lancer/pl_spirit_lance_projectile.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ),
			fStartRadius = 64,
			fEndRadius = 64,
			vVelocity = vDirection * self.lance_speed,
			fDistance = self.lance_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_PhantomLancer.SpiritLance.Throw", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function aghslab_phantom_lancer_spirit_lance:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.lance_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			ApplyDamage( damage )

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_phantom_lancer_spirit_lance", { duration = self.duration } )

			EmitSoundOn( "Hero_PhantomLancer.SpiritLance.Impact", hTarget )

			local vPos = hTarget:GetAbsOrigin()
			local illusion_name = "npc_dota_creature_phantom_lancer_illusion"
			
			for i = 1, self.num_illusions do
				local illusion_origin = vPos + RandomVector( RandomFloat( 50, 150 ) )
				local illusion = CreateUnitByName(illusion_name, illusion_origin, true, self:GetCaster(), nil, DOTA_TEAM_BADGUYS)
				illusion:SetInitialGoalEntity( hTarget )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_flash_target.vpcf", PATTACH_WORLDORIGIN, nil )
				ParticleManager:SetParticleControl( nFXIndex, 0, illusion:GetOrigin() )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
	 	
		end

		return true
	end
end

--------------------------------------------------------------------------------