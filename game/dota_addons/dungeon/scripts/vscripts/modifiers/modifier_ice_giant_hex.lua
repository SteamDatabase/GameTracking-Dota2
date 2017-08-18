
modifier_ice_giant_hex = class({})

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:OnCreated( kv )	
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:OnDestroy()
	if IsServer() then
		--ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
	end
end

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:GetModifierModelChange( params )
	return "models/creeps/ice_biome/yak/yakyok.vmdl"
end

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:GetModifierModelScale( params )
	return 20
end

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:GetModifierMoveSpeed_Absolute( params )
	return 250
end

--------------------------------------------------------------------------------

function modifier_ice_giant_hex:GetModifierAttackPointConstant( params )
	return 0.33
end
