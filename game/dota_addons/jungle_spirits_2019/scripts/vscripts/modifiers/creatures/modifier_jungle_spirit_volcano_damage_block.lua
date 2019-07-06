modifier_jungle_spirit_volcano_damage_block = class({})

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_damage_block:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_damage_block:IsHidden()
	return false;
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_volcano_damage_block:OnCreated( kv )
	if IsServer() then 
		self.block_chance = self:GetAbility():GetSpecialValueFor( "block_chance" )
		self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	end
end

function modifier_jungle_spirit_volcano_damage_block:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_jungle_spirit_volcano_damage_block:GetModifierIncomingPhysicalDamage_Percentage( params )
	if IsServer() then
		if ( RandomFloat ( 0 , 1 ) > self.block_chance ) then
			return 0
		end

		local hAttacker = params.attacker
		if hAttacker == nil or not hAttacker:IsHero() then
			return 0
		end

		EmitSoundOn( "Jungle_Spirit.Volcano.Block", self:GetParent() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/jungle_spirit/volcano_damage_block.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hAttacker, PATTACH_POINT_FOLLOW, "attach_hitloc", hAttacker:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		return -self.damage_reduction

	end
	return 0
end
