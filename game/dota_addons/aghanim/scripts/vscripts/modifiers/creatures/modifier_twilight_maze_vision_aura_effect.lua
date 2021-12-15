
modifier_twilight_maze_vision_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura_effect:GetTexture()
	return "night_stalker_darkness"
end

----------------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura_effect:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura_effect:OnCreated( kv )
	self.nVisionRange = 300
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura_effect:GetFixedDayVision( params )
	return self.nVisionRange
end

--------------------------------------------------------------------------------

function modifier_twilight_maze_vision_aura_effect:GetFixedNightVision( params )
	return self.nVisionRange
end

----------------------------------------------------------------------------------------
