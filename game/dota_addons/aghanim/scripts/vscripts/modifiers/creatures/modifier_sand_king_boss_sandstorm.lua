modifier_sand_king_boss_sandstorm = class({})

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:IsAura()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:GetModifierAura()
	return "modifier_sand_king_boss_sandstorm_effect"
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:GetAuraRadius()
	return self.sand_storm_radius
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end

		self.nProjHandle = self:GetParent().nProjHandle
		self.sand_storm_radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.storm_move_speed = self:GetAbility():GetSpecialValueFor( "storm_move_speed" )
		self.storm_decreased_turn_rate = self:GetAbility():GetSpecialValueFor( "storm_decreased_turn_rate" )

		EmitSoundOn( "SandKingBoss.SandStorm.loop", self:GetParent() )
	end
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		StopSoundOn( "SandKingBoss.SandStorm.loop", self:GetParent() )
		if self.nProjHandle ~= nil then
			ProjectileManager:DestroyLinearProjectile( self.nProjHandle )
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:DeclareFunctions()
	local funcs =
	{
		--MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:GetModifierTurnRate_Percentage( params )
	return -self.storm_decreased_turn_rate
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self.nProjHandle == nil then
			local vForward = self:GetParent():GetForwardVector()
			local vNewPos = self:GetParent():GetOrigin() + vForward * dt * self:GetParent().storm_speed
			me:SetOrigin( vNewPos )
		else
			local vNewPos = ProjectileManager:GetLinearProjectileLocation( self.nProjHandle )
			me:SetOrigin( vNewPos )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end




