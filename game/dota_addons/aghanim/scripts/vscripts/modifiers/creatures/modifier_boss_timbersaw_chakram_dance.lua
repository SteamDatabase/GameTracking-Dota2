modifier_boss_timbersaw_chakram_dance = class({})

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
	}
	return state
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:OnCreated( kv )
	if IsServer() then

		self.is_ascension_ability = kv[ "is_ascension_ability" ]
		self.num_chakrams = self:GetAbility():GetSpecialValueFor( "num_chakrams" )
		self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
		self.short_range = self:GetAbility():GetSpecialValueFor( "short_range" )
		self.long_range = self:GetAbility():GetSpecialValueFor( "long_range" )

		local flInterval = self.interval
		if self.is_ascension_ability == 1 then
			flInterval = self:GetAbility():GetSpecialValueFor( "spawn_interval" )
			self.spawn_count = self:GetAbility():GetSpecialValueFor( "spawn_count" )
		end
		
		self.radius = kv[ "radius" ]
		self.nAngleStepPerChakram = 360 / self.num_chakrams
		self.nAngleStepPerInterval = self.nAngleStepPerChakram / 2
		self.bLongRange = true
		self.Angle = QAngle( 0, 0, 0 )
		self.Chakrams = {}

		self:StartIntervalThink( flInterval )
		self:OnIntervalThink()
	end
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:OnDestroy()
	if IsServer() then
		for _,Chakram in pairs ( self.Chakrams ) do
			if Chakram.bReturning == false then
				local vLocation = ProjectileManager:GetLinearProjectileLocation( Chakram.nProjectileHandle )
				self:ReturnChakram( Chakram, vLocation )
			end
		end
	end
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:OnIntervalThink()
	if IsServer() then
		
		local Angle = QAngle( self.Angle.x, self.Angle.y, self.Angle.z )

		for i=1,self.num_chakrams do
			local flDist = self.short_range
			if self.bLongRange == true then
				flDist = self.long_range
			end

			local flSpeed = ( flDist / self.interval ) * 2 -- need enough time to go out and back
			local vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), Angle, Vector( 1, 0, 0 ) ) ) * flSpeed

			self:LaunchOutgoingChakram( vVelocity, flDist )

			self.bLongRange = not self.bLongRange
			Angle.y = Angle.y + self.nAngleStepPerChakram
		end
		EmitSoundOn( "Boss_Timbersaw.Chakram.Cast", self:GetParent() )
		self.Angle.y = self.Angle.y + self.nAngleStepPerInterval

		if self.is_ascension_ability == 1 then
			self.spawn_count = self.spawn_count - 1
			if self.spawn_count <= 0 then
				self:StartIntervalThink( -1 )
			end
		end		
	end
end

--------------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:ChooseRandomPointsOnEdges()

	local hRoom = self:GetCaster().Encounter:GetRoom()
	local vMins = hRoom:GetMins()
	local vMaxs = hRoom:GetMaxs()
	local vDelta = ( vMaxs - vMins ) * 0.15
	local vClampedMins = Vector( vMins.x + vDelta.x, vMins.y + vDelta.y, vMins.z )
	local vClampedMaxs = Vector( vMaxs.x - vDelta.x, vMaxs.y - vDelta.y, vMaxs.z ) 
	local retVal = 
	{
		vSpawnOrigin = Vector( vClampedMins.x, vClampedMins.y, vMins.z ),
		vDestination = Vector( vClampedMaxs.x, vClampedMaxs.y, vMaxs.z ),
	}

	local nSide = math.random( 1,4 )
	if nSide <= 2 then
		if nSide == 1 then
			retVal.vSpawnOrigin.x = vMins.x
			retVal.vDestination.x = vMaxs.x
		else
			retVal.vSpawnOrigin.x = vMaxs.x
			retVal.vDestination.x = vMins.x
		end
		retVal.vSpawnOrigin.y = RandomFloat( vClampedMins.y, vClampedMaxs.y )
		retVal.vDestination.y = RandomFloat( vClampedMins.y, vClampedMaxs.y )
	else
		if nSide == 3 then
			retVal.vSpawnOrigin.y = vMins.y
			retVal.vDestination.y = vMaxs.y
		else
			retVal.vSpawnOrigin.y = vMaxs.y
			retVal.vDestination.y = vMins.y
		end
		retVal.vSpawnOrigin.x = RandomFloat( vClampedMins.x, vClampedMaxs.x )
		retVal.vDestination.x = RandomFloat( vClampedMins.x, vClampedMaxs.x )
	end

	retVal.vDestination.z = retVal.vSpawnOrigin.z

	return retVal

end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:LaunchOutgoingChakram( vVel, flDist )
	if IsServer() then

		local projectileInfo =
		{
			Ability = self:GetAbility(),
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(), 
			fStartRadius = self.radius,
			fEndRadius = self.radius,
			vVelocity = vVel,
			fDistance = flDist,
			Source = self:GetParent(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		local Chakram = {}

		local flSpeed = vVel:Length2D()
		if self.is_ascension_ability == 1 then
			local pts = self:ChooseRandomPointsOnEdges()
			projectileInfo.vSpawnOrigin = pts.vSpawnOrigin
			projectileInfo.vVelocity = ( pts.vDestination - pts.vSpawnOrigin ):Normalized() * flSpeed
			Chakram.vReturnLocation = projectileInfo.vSpawnOrigin
		end

		if flDist == self.long_range then
			projectileInfo[ "EffectName" ] = "particles/units/heroes/hero_shredder/shredder_chakram.vpcf"
			Chakram.bBlue = false
		else
			projectileInfo[ "EffectName" ] = "particles/units/heroes/hero_shredder/shredder_chakram_aghs.vpcf"
			Chakram.bBlue = true
		end
		Chakram.flDist = flDist
		Chakram.flSpeed = flSpeed
		Chakram.bReturning = false
		Chakram.nProjectileHandle = ProjectileManager:CreateLinearProjectile( projectileInfo )
		table.insert( self.Chakrams, Chakram.nProjectileHandle, Chakram )
	end
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:LaunchIncomingChakram( vSpawnOrigin, vReturnLocation, flSpeed, flDist )
	if IsServer() then

		if vReturnLocation == nil then
			vReturnLocation = self:GetParent():GetAbsOrigin()
			flSpeed = flDist	-- Seems like a bug in the original boss encounter, but preserving the behavior
		end

		local vDir = vReturnLocation - vSpawnOrigin
		vDir.z = 0.0
		vDir = vDir:Normalized()

		local projectileInfo =
		{
			Ability = self:GetAbility(),
			vSpawnOrigin = vSpawnOrigin, 
			fStartRadius = self.radius,
			fEndRadius = self.radius,
			vVelocity = vDir * flSpeed,
			fDistance = flDist,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		local Chakram = {}
		if flDist == self.long_range then
			projectileInfo[ "EffectName" ] = "particles/units/heroes/hero_shredder/shredder_chakram.vpcf"
			Chakram.bBlue = false
		else
			projectileInfo[ "EffectName" ] = "particles/units/heroes/hero_shredder/shredder_chakram_aghs.vpcf"
			Chakram.bBlue = true
		end

		Chakram.bReturning = true
		Chakram.nProjectileHandle = ProjectileManager:CreateLinearProjectile( projectileInfo )
		table.insert( self.Chakrams, Chakram.nProjectileHandle, Chakram )
		ProjectileManager:CreateLinearProjectile( projectileInfo )
	end
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:ReturnChakram( Chakram, vLocation )
	if IsServer() then
		for k,v in pairs ( self.Chakrams ) do
			if v == Chakram and v.bReturning == false then
				Chakram.bReturning = true
				EmitSoundOnLocationWithCaster( vLocation, "Boss_Timbersaw.Chakram.Return", self:GetParent() )
				self:LaunchIncomingChakram( vLocation, Chakram.vReturnLocation, Chakram.flSpeed, Chakram.flDist )
			end
		end
	end
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:DestroyChakram( Chakram )
	if IsServer() then
		for k,v in pairs ( self.Chakrams ) do
			if v == Chakram  then
				table.remove( self.Chakrams, k )
			end
		end
	end
end

-----------------------------------------------------------------------------

function modifier_boss_timbersaw_chakram_dance:GetChakram( nProjectileHandle )
	return self.Chakrams[ nProjectileHandle ]
end

-----------------------------------------------------------------------------