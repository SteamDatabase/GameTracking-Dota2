modifier_jungle_spirit_jungle_building_regeneration = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration:IsHidden()
	return false;
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_jungle_building_regeneration:OnCreated( kv )
	if IsServer() then 
		--self.reset_cooldown = self:GetAbility():GetSpecialValueFor( "reset_cooldown" )
		self.regeneration = self:GetAbility():GetSpecialValueFor( "regeneration" )
		self:StartIntervalThink(1.0)
	end
end

function modifier_jungle_spirit_jungle_building_regeneration:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_jungle_spirit_jungle_building_regeneration:GetModifierConstantHealthRegen( params )
	return self.regeneration
end

function modifier_jungle_spirit_jungle_building_regeneration:GetStatusEffectName()
	return "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl1.vpcf"
end


function modifier_jungle_spirit_jungle_building_regeneration:OnIntervalThink()
    if IsServer() then
    	if ( self:GetParent():IsAlive() and self:GetParent():GetHealth() < self:GetParent():GetMaxHealth() ) then
			SendOverheadEventMessage( self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_HEAL, self:GetParent(), self.regeneration, nil )
		end
    end
end

