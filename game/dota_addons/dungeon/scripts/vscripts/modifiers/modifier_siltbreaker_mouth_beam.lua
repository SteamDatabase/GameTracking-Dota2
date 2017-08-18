
modifier_siltbreaker_mouth_beam = class({})

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:GetActivityTranslationModifiers( params )
	return "channelling"
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:OnCreated( kv )
	if IsServer() then
		self.damage_per_tick = self:GetAbility():GetSpecialValueFor( "damage_per_tick" )
		self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
		self.damage_radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
		self.beam_range = self:GetAbility():GetSpecialValueFor( "beam_range" )
		self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )

		self.channel_time = self:GetAbility():GetChannelTime()
		self.nSunRayVisionCount = 8
		self.bRight = self:GetParent():GetSequence() == "attack_mouthray_r"

		self.vBeamEnd = Vector( kv.vBeamEndX, kv.vBeamEndY, kv.vBeamEndZ )
		self.vBeamDir = self:GetCaster():GetOrigin() - Vector( kv.vBeamEndX, kv.vBeamEndY, kv.vBeamEndZ )
		self.vBeamDir = self.vBeamDir:Normalized()
		--print( "BeamDir.x: " .. self.vBeamDir.x .. "BeamDir.y: " .. self.vBeamDir.y  )
		self.CurAngles = self:GetCaster():GetAngles()

		local hVisionDummy = CreateUnitByName( "npc_dota_invisible_vision_source", self.vBeamEnd, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hVisionDummy then
			local kv = {}
			kv[ "duration" ] = self.channel_time
			hVisionDummy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_phoenix_sun_ray_vision", kv )
			self.hBeamEnd = hVisionDummy
		end

		self.nBeamFXIndex = ParticleManager:CreateParticle( "particles/act_2/siltbreaker_mouth_beam.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex, 1, self.hBeamEnd, PATTACH_ABSORIGIN_FOLLOW, nil, self.hBeamEnd:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self.hBeamEnd:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nBeamFXIndex, false, false, -1, false, true )
		self:StartIntervalThink( self.tick_interval )
	end
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:OnIntervalThink()
	if IsServer() then
		self:DoBeamDamageAndVision()
	end
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:DoBeamDamageAndVision()
	if IsServer() then
		if ( not self:GetCaster() ) then
			return
		end

		if self.bRight == true then
			self.CurAngles.y = self.CurAngles.y - ( self.turn_rate * self.tick_interval )
		else
			self.CurAngles.y = self.CurAngles.y + ( self.turn_rate * self.tick_interval )
		end
		self.vBeamDir = RotatePosition( Vector( 0, 0, 0 ), self.CurAngles, Vector( 1, 0, 0 ) ) 
		--print( "BeamDir.x: " .. self.vBeamDir.x .. "BeamDir.y: " .. self.vBeamDir.y  )

		--self:GetCaster():SetAngles( self.CurAngles.x, self.CurAngles.y, self.CurAngles.z )
		self.vBeamEnd = self:GetCaster():GetOrigin() + ( self.vBeamDir * self.beam_range )
		local hHitEnemies = {}
		local nThinkerIndex = 0
		local nCount = 0
		local nStepSize = 50

		for fDist = 0, self.beam_range, nStepSize do
			local vPos = self:GetCaster():GetOrigin() + ( self.vBeamDir * fDist )

			local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vPos, nil, self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			for _, hEnemy in pairs( hEnemies ) do
				if ( not hEnemy ) or ( hEnemy == self:GetCaster() ) then
					return
				end

				if ( not hEnemy:IsInvulnerable() ) then
					if ( TableContainsValue( hHitEnemies, hEnemy ) == false ) then
						table.insert( hHitEnemies, hEnemy )
					end
				end
			end
		end

		for _, hHitEnemy in pairs( hHitEnemies ) do
			if hHitEnemy and ( not hHitEnemy:IsMagicImmune() ) then
				local damageInfo = 
				{
					victim = hHitEnemy,
					attacker = self:GetCaster(),
					damage = self.damage_per_tick,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_sunray_beam_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHitEnemy )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, hHitEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hHitEnemy:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		self:UpdateBeamEffect()
	end
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:UpdateBeamEffect()
	if ( not self:GetCaster() ) then
		return
	end

	self.hBeamEnd:SetOrigin( self.vBeamEnd )

	ParticleManager:SetParticleControlFallback( self.nBeamFXIndex, 0, self:GetCaster():GetAbsOrigin() )
	ParticleManager:SetParticleControlFallback( self.nBeamFXIndex, 1, self.vBeamEnd )
	ParticleManager:SetParticleControlFallback( self.nBeamFXIndex, 9, self:GetCaster():GetAbsOrigin() )
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:GetModifierDisableTurning( params )
	return 1
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_mouth_beam:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_ROOTED ] = true
	end

	return state
end

