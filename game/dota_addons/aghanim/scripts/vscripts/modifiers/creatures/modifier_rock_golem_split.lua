
modifier_rock_golem_split = class({})

-----------------------------------------------------------------------------------------

function modifier_rock_golem_split:GetTexture()
	return "sandking_caustic_finale"
end

-----------------------------------------------------------------------------------------

function modifier_rock_golem_split:OnCreated( kv )

	if not IsServer() then
		return
	end

	self.unit_count = self:GetAbility():GetSpecialValueFor( "unit_count" ) 
	self.spawn_radius = self:GetAbility():GetSpecialValueFor( "spawn_radius" )
	self.knockback_duration_min = self:GetAbility():GetSpecialValueFor( "knockback_duration_min" )
	self.knockback_duration_max = self:GetAbility():GetSpecialValueFor( "knockback_duration_max" )
	self.knockback_distance_min = self:GetAbility():GetSpecialValueFor( "knockback_distance_min" )
	self.knockback_distance_max = self:GetAbility():GetSpecialValueFor( "knockback_distance_max" )
	self.knockback_height_min = self:GetAbility():GetSpecialValueFor( "knockback_height_min" )
	self.knockback_height_max = self:GetAbility():GetSpecialValueFor( "knockback_height_max" )
	
	self.split_fx = self:GetAbility().strSplitFx
	self.summoned_unit = self:GetAbility().strSummonedUnit

end

-----------------------------------------------------------------------------------------

function modifier_rock_golem_split:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_rock_golem_split:OnDeath( params )
	if not IsServer() or params.unit ~= self:GetParent() then
		return 0
	end

	EmitSoundOn( "Ability.SplitA", self:GetParent() )

	local nDeathFX = ParticleManager:CreateParticle( self.split_fx, PATTACH_ABSORIGIN, self:GetParent() )

	ParticleManager:SetParticleControl( nDeathFX, 1, Vector( 100, 1, 1 ) );
	ParticleManager:SetParticleControl( nDeathFX, 2, Vector( 1, 1, 1 ) );
	ParticleManager:SetParticleControl( nDeathFX, 3, Vector( 100, 100, 100 ) );
	ParticleManager:SetParticleControl( nDeathFX, 4, Vector( 200, 200, 200 ) );
	ParticleManager:SetParticleControl( nDeathFX, 14, Vector( 1, 1, 1 ) );
	ParticleManager:SetParticleControl( nDeathFX, 15, Vector( 100, 100, 100 ) );

	ParticleManager:ReleaseParticleIndex( nDeathFX )

	for i = 1,self.unit_count do
		local knockback_duration = RandomFloat( self.knockback_duration_min, self.knockback_duration_max )
		local knockback_distance = RandomFloat( self.knockback_distance_min, self.knockback_distance_max )
		local knockback_height = RandomFloat( self.knockback_height_min, self.knockback_height_max )
		print( 'duration: ' .. knockback_duration .. '. distance ' .. knockback_distance .. '. height ' .. knockback_height )

		local kv =
		{
			center_x = self:GetParent():GetAbsOrigin().x,
			center_y = self:GetParent():GetAbsOrigin().y,
			center_z = self:GetParent():GetAbsOrigin().z,
			should_stun = true, 
			duration = knockback_duration,
			knockback_duration = knockback_duration,
			knockback_distance = knockback_distance,
			knockback_height = knockback_height,
		}

		vSpawnPosition = self:GetParent():GetAbsOrigin() + RandomVector( self.spawn_radius )
		vSpawnPosition = FindPathablePositionNearby( vSpawnPosition, 250, 250 )
		
		vSpawnDirection = vSpawnPosition - self:GetParent():GetAbsOrigin()
		vSpawnDirection = vSpawnDirection:Normalized()
		local angles = VectorAngles( vSpawnDirection )

		local hSplitUnit = CreateUnitByName( self.summoned_unit , vSpawnPosition, true, 
			self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )

		hSplitUnit:SetAbsAngles( angles.x, angles.y, angles.z )

		hSplitUnit:AddNewModifier( hSplitUnit, self:GetAbility(), "modifier_knockback", kv )

	end

	return 0
end
