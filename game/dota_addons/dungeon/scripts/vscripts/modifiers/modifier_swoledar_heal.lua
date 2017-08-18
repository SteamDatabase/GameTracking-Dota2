
modifier_swoledar_heal = class({})

-----------------------------------------------------------------------------

function modifier_swoledar_heal:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-----------------------------------------------------------------------------

--[[
function modifier_swoledar_heal:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end
]]

-----------------------------------------------------------------------------

function modifier_swoledar_heal:OnCreated( kv )
	if not self:GetAbility() then
		return
	end
	
	self.heal_interval = self:GetAbility():GetSpecialValueFor( "heal_interval" )
	self.heal_per_tick = self:GetAbility():GetSpecialValueFor( "heal_per_tick" )
	
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex , true, false, 0, false, false )	

		self:StartIntervalThink( self.heal_interval )
	end
end

-----------------------------------------------------------------------------

function modifier_swoledar_heal:OnIntervalThink()
	if IsServer() then
		self:GetParent():Heal( self.heal_per_tick, self:GetAbility() )
	end
end

-----------------------------------------------------------------------------

