
modifier_mine_death_explosion_thinker = class({})

--------------------------------------------------------------

function modifier_mine_death_explosion_thinker:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_mine_death_explosion_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_mine_death_explosion_thinker:OnCreated()
	self:StartIntervalThink( 0.1 )
end

--------------------------------------------------------------

function modifier_mine_death_explosion_thinker:OnIntervalThink()
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor( "radius" )
		local detection_radius = ( radius / 2 ) + 50
		local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, detection_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

		if #entities > 0 then
			self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mine_death_explosion", { delay = 2 } )
		end
	end
end

---------------------------------------------------------

function modifier_mine_death_explosion_thinker:CheckState()
	if self.is_ascension_ability == 1 then
		return {}
	end

	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------

function modifier_mine_death_explosion_thinker:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end
-------------------------------------------------------------------

function modifier_mine_death_explosion_thinker:Detonate()
	if not IsServer() then
		return
	end
		
	if self:GetAbility() == nil then
		return
	end

	self:Destroy()

end

--------------------------------------------------------------------------------
