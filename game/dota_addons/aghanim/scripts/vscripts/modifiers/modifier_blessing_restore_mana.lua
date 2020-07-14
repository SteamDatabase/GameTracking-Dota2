require( "modifiers/modifier_blessing_base" )

modifier_blessing_restore_mana = class( modifier_blessing_base )

-------------------------------------------------------------------------------

function modifier_blessing_restore_mana:GetTexture()
	return "../items/lifesteal"
end

-------------------------------------------------------------------------------

function modifier_blessing_restore_mana:OnBlessingCreated( kv )
	self.mana_on_kill = kv.mana_on_kill
end

--------------------------------------------------------------------------------

function modifier_blessing_restore_mana:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_restore_mana:OnDeath( params )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return 1
		end

		if params.unit ~= nil and params.attacker ~= nil and params.attacker == self:GetParent() then
			self:GetParent():GiveMana( self.mana_on_kill )

			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_blessing_restore_mana:OnTooltip( params )
	return self.mana_on_kill
end
