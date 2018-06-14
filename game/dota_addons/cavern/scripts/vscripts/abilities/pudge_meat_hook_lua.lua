pudge_meat_hook_lua = class({})
LinkLuaModifier( "modifier_pudge_meat_hook_followthrough_lua", "modifiers/modifier_pudge_meat_hook_followthrough_lua",  LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(  "modifier_pudge_meat_hook_lua", "modifiers/modifier_pudge_meat_hook_lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	return true
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnSpellStart()
	self.bChainAttached = false
	if self.hVictim ~= nil then
		self.hVictim:InterruptMotionControllers( true )
	end

	self.hook_damage = self:GetSpecialValueFor( "hook_damage" )  
	self.hook_speed = self:GetSpecialValueFor( "hook_speed" )
	self.hook_width = self:GetSpecialValueFor( "hook_width" )
	self.hook_distance = self:GetSpecialValueFor( "hook_distance" )

	self.vision_radius = self:GetSpecialValueFor( "vision_radius" )  
	self.vision_duration = self:GetSpecialValueFor( "vision_duration" )  
	
	if self:GetCaster() and self:GetCaster():IsHero() then
		local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if hHook ~= nil then
			hHook:AddEffects( EF_NODRAW )
		end
	end

	self.vStartPosition = self:GetCaster():GetOrigin()
	self.vProjectileLocation = vStartPosition

	local vDirection = self:GetCursorPosition() - self.vStartPosition
	vDirection.z = 0.0

	local vDirection = ( vDirection:Normalized() ) * self.hook_distance
	self.vTargetPosition = self.vStartPosition + vDirection

	
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_meat_hook_followthrough_lua", {  } )

	self.vHookOffset = Vector( 0, 0, 96 )
	local vHookTarget = self.vTargetPosition + self.vHookOffset
	local vKillswitch = Vector( ( ( self.hook_distance / self.hook_speed ) * 2 ), 0, 0 )

	self.nChainParticleFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleAlwaysSimulate( self.nChainParticleFXIndex )
	ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 1, vHookTarget )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 2, Vector( self.hook_speed, self.hook_distance, self.hook_width ) )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 3, vKillswitch )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 1, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetOrigin(), true )

	EmitSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster() )

	local info = {
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		vVelocity = vDirection:Normalized() * self.hook_speed,
		fDistance = self.hook_distance,
		fStartRadius = self.hook_width ,
		fEndRadius = self.hook_width ,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
	}

	ProjectileManager:CreateLinearProjectile( info )

	self.bRetracting = false
	self.hVictims = {}
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget == self:GetCaster() then
		return false
	end

	if hTarget == nil then
		if self.bRetracting then
			if self:GetCaster() and self:GetCaster():IsHero() then
				local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
				if hHook ~= nil then
					hHook:RemoveEffects( EF_NODRAW )
				end
			end

			for _,Victim in pairs ( self.hVictims ) do
				local vFinalHookPos = vLocation
				Victim:InterruptMotionControllers( true )
				Victim:RemoveModifierByName( "modifier_pudge_meat_hook_lua" )

				local vVictimPosCheck = Victim:GetOrigin() - vFinalHookPos 
				local flPad = self:GetCaster():GetPaddedCollisionRadius() + Victim:GetPaddedCollisionRadius()
				if vVictimPosCheck:Length2D() > flPad then
					FindClearSpaceForUnit( Victim, self.vStartPosition, false )
				end
			end

			self.hVictims = {}
			ParticleManager:DestroyParticle( self.nChainParticleFXIndex, true )
			EmitSoundOn( "Hero_Pudge.AttackHookRetractStop", self:GetCaster() )
			self:GetCaster():RemoveModifierByName( "modifier_pudge_meat_hook_followthrough_lua" )

			return true
		else
			--Missing: Setting target facing angle
			local vVelocity = self.vStartPosition - vLocation
			vVelocity.z = 0.0

			local flPad = self:GetCaster():GetPaddedCollisionRadius()

			local flDistance = vVelocity:Length2D() - flPad
			vVelocity = vVelocity:Normalized() * self.hook_speed

			local info = {
				Ability = self,
				vSpawnOrigin = vLocation,
				vVelocity = vVelocity,
				fDistance = flDistance,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			}

			ProjectileManager:CreateLinearProjectile( info )
			self.vProjectileLocation = vLocation

			ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true);

			--EmitSoundOn( "Hero_Pudge.AttackHookRetract", hTarget )

			if self:GetCaster():IsAlive() then
				self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
				self:GetCaster():StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
			end

			self.bRetracting = true

			return true
		end
	else
		local bIsValidTarget = ( hTarget:FindModifierByName( "modifier_breakable_container" ) == nil ) and ( hTarget:FindModifierByName( "modifier_destructible_gate" ) == nil ) and ( hTarget:FindModifierByName( "modifier_blocked_gate" ) == nil )
		
		if not self.bRetracting and hTarget:FindModifierByName( "modifier_pudge_meat_hook_lua" ) == nil and bIsValidTarget then
			EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_pudge_meat_hook_lua", nil )
			
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				local damage = {
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = self.hook_damage,
						damage_type = DAMAGE_TYPE_PURE,		
						ability = this
					}

				ApplyDamage( damage )

				
				if not hTarget:IsMagicImmune() then
					hTarget:Interrupt()
				end
		
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end

			AddFOWViewer( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self.vision_radius, self.vision_duration, false )
			table.insert( self.hVictims, hTarget )
			bTargetPulled = true

			--Missing: Setting target facing angle
		
			local vVelocity = self.vStartPosition - vLocation
			vVelocity.z = 0.0

			local flPad = self:GetCaster():GetPaddedCollisionRadius()

			local flDistance = vVelocity:Length2D() - flPad
			vVelocity = vVelocity:Normalized() * self.hook_speed

			local info = {
				Ability = self,
				vSpawnOrigin = vLocation,
				vVelocity = vVelocity,
				fDistance = flDistance,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			}

			ProjectileManager:CreateLinearProjectile( info )
			self.vProjectileLocation = vLocation

			if hTarget ~= nil and ( not hTarget:IsInvisible() ) and bTargetPulled then
				ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin() + self.vHookOffset, true )
				ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 4, Vector( 0, 0, 0 ) )
				ParticleManager:SetParticleControl( self.nChainParticleFXIndex, 5, Vector( 1, 0, 0 ) )
			else
				ParticleManager:SetParticleControlEnt( self.nChainParticleFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true);
			end

			EmitSoundOn( "Hero_Pudge.AttackHookRetract", hTarget )

			if self:GetCaster():IsAlive() then
				self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
				self:GetCaster():StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
			end
			
			self.bRetracting = true

			return true
		end
	end

	self.vProjectileLocation = vLocation

	return false
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnProjectileThink( vLocation )
	self.vProjectileLocation = vLocation
end 

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnOwnerDied()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
	self:GetCaster():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
end

--------------------------------------------------------------------------------