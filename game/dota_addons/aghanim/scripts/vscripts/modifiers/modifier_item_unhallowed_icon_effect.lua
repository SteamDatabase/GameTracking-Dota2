modifier_item_unhallowed_icon_effect = class({})

----------------------------------------

function modifier_item_unhallowed_icon_effect:GetTexture()
	return "item_unhallowed_icon"
end

----------------------------------------

function modifier_item_unhallowed_icon_effect:OnCreated( kv )
	self.lifesteal_pct = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" )
end

----------------------------------------

function modifier_item_unhallowed_icon_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

----------------------------------------

function modifier_item_unhallowed_icon_effect:GetModifierConstantHealthRegen( params )
	return self.hp_regen
end

----------------------------------------

function modifier_item_unhallowed_icon_effect:OnAttackLanded( params )
	if IsServer() then
		local Target = params.target
		local Attacker = params.attacker
		if Attacker ~= nil and Attacker == self:GetParent() and Target ~= nil then
			local allies = FindUnitsInRadius( Attacker:GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,ally in pairs( allies ) do
				if ally ~= nil and ally:FindModifierByName( "modifier_item_unhallowed_icon_effect" ) then
					local heal = ( params.damage * self.lifesteal_pct / 100 ) / #allies
					ally:Heal( heal, self:GetAbility() )
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
		end
	end
	return 0
end