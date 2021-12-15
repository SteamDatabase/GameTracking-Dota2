polarity_ranged_attack = class({})
polarity_ranged_attack_positive = polarity_ranged_attack
polarity_ranged_attack_negative = polarity_ranged_attack

----------------------------------------------------------------------------------------

function polarity_ranged_attack:Precache( context )
	PrecacheResource( "particle", "particles/polarity/polarity_ranged_attack_negative.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_ranged_attack_positive.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_absorb_positive.vpcf", context )	
	PrecacheResource( "particle", "particles/polarity/polarity_absorb_negative.vpcf", context )	
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
end

--------------------------------------------------------------------------------

function polarity_ranged_attack:OnSpellStart()
	if IsServer() then
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" ) 
		self.duration = self:GetSpecialValueFor( "duration" )
		self.polarity = self:GetSpecialValueFor( "polarity" )
		--print( 'POLARITY = ' .. self.polarity )

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

		local effect_name
		if self.polarity == 1 then
			effect_name = "particles/polarity/polarity_ranged_attack_positive.vpcf"
		elseif self.polarity == -1 then
			effect_name = "particles/polarity/polarity_ranged_attack_negative.vpcf"
		else
			print( 'ERROR - polarity_ranged_attack OnSpellStart() without a polarity value! BAILING!!!')
			return
		end

		local info = {
			EffectName = effect_name,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ),
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "n_creep_SatyrHellcaller.Shockwave", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function polarity_ranged_attack:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
			
			local hPolarityBuff = hTarget:FindModifierByName( "modifier_polarity" )
			if hPolarityBuff and hPolarityBuff:GetPolarity() == self.polarity then
				-- polarity is the same - no damage!
				EmitSoundOn( "Polarity.AbsorbedDamage", hTarget )

				local strEffectName = "particles/polarity/polarity_absorb_positive.vpcf"
				local nPolarity = hPolarityBuff:GetPolarity()
				if nPolarity == -1 then
					strEffectName = "particles/polarity/polarity_absorb_negative.vpcf"
				end

				local nFxIndex = ParticleManager:CreateParticle( strEffectName, PATTACH_ABSORIGIN_FOLLOW, hTarget )
				ParticleManager:SetParticleControlEnt( nFxIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFxIndex )
			else
				-- no polarity on target or polarity is different - damage!
				local damage = {
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = self.attack_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self
				}

				ApplyDamage( damage )

				EmitSoundOn( "Polarity.Damage", hTarget )
			end

			return true
		end

		return false
	end
end

--------------------------------------------------------------------------------