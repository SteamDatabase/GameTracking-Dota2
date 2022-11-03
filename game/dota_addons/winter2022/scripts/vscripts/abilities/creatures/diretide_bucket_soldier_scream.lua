diretide_bucket_soldier_scream = class({})

----------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_bucket_soldier_attack_fear", "modifiers/creatures/modifier_bucket_soldier_attack_fear", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function diretide_bucket_soldier_scream:Precache( context )
	PrecacheResource( "particle", "particles/hw_fx/golem_terror.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/golem_terror_telegraph_guardian.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/golem_terror_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/golem_terror_status_effect.vpcf", context )
	
	--PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )

	self.Projectiles = {}
end

--------------------------------------------------------------------------------

function diretide_bucket_soldier_scream:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/hw_fx/golem_terror_telegraph_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		EmitSoundOn( "Creature.StartCast", self:GetCaster() )		
	end
end

--------------------------------------------------------------------------------

function diretide_bucket_soldier_scream:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function diretide_bucket_soldier_scream:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		--print( '***SCREAM SPELL START!' )
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" ) 
		self.debuff_duration = self:GetSpecialValueFor( "debuff_duration" )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		self.vDirection = vPos - self:GetCaster():GetOrigin()
		self.vDirection.z = 0.0
		self.vDirection = self.vDirection:Normalized()

		--printf( "Scream direction = %f, %f, %f", self.vDirection.x, self.vDirection.y, self.vDirection.z )

		self.attack_speed = self.attack_speed * ( self.attack_distance / ( self.attack_distance - self.attack_width_initial ) )

		local info = {
			EffectName = "particles/hw_fx/golem_terror.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ),
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = self.vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "BucketSoldier.Scream.Attack", self:GetCaster() )

		-- randomize cooldown
		self.cooldown_random_reduction_percent = self:GetSpecialValueFor( "cooldown_random_reduction_percent" )
		local fCooldown = self:GetCooldown( -1 )
		fCooldown = RandomFloat( fCooldown * ( self.cooldown_random_reduction_percent / 100 ), fCooldown )
		--print( 'SETTING SCREAM CD TO ' .. fCooldown )
		self:EndCooldown()
		self:StartCooldown( fCooldown )
	end
end

--------------------------------------------------------------------------------

function diretide_bucket_soldier_scream:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		--print( '***SCREAM PROJECTILE HIT!' )
		local hCaster = self:GetCaster()
		if 	hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then

			local nTargetTeam = hTarget:GetTeamNumber()
			if nTargetTeam == DOTA_TEAM_NEUTRALS or nTargetTeam == DOTA_TEAM_CUSTOM_1 then
				return false
			end
			
			local fDamage = self.attack_damage
			local hBuff = self:GetCaster():FindModifierByName( "modifier_creature_buff_dynamic" )
			if hBuff ~= nil then
				self.damage_per_buff_level = self:GetSpecialValueFor( "damage_per_buff_level" )
				local nBuffLevel = hBuff:GetBaseBuffLevel()
				fDamage = fDamage + ( nBuffLevel * self.damage_per_buff_level )
				--print( 'SCREAM DAMAGE BUMPED TO ' .. fDamage )
			end
	
			local damage = {
				victim = hTarget,
				attacker = hCaster,
				damage = fDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}
			ApplyDamage( damage )

			-- kill and pass through zombies
			if hTarget:IsZombie() == true then
				return false
			end

			-- fear target in the direction
			hTarget:AddNewModifier( hCaster, self, "modifier_bucket_soldier_attack_fear", {
																							run_from_bucket = false,
																							run_direction_x = self.vDirection.x,
																							run_direction_y = self.vDirection.y,
																							run_direction_z = self.vDirection.z,
																							duration = self.debuff_duration 
																						  } )
		
			return false
		end

		return false
	end
end

--------------------------------------------------------------------------------

function diretide_bucket_soldier_scream:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function diretide_bucket_soldier_scream:IsStealable()
	return false
end
