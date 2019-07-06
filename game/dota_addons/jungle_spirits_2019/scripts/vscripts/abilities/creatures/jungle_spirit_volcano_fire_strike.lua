jungle_spirit_volcano_fire_strike = class({})
LinkLuaModifier( "modifier_jungle_spirit_volcano_fire_strike_thinker", "modifiers/creatures/modifier_jungle_spirit_volcano_fire_strike_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_volcano_fire_strike:GetIntrinsicModifierName()
	return "modifier_jungle_spirit_volcano_fire_strike_thinker"
end

--------------------------------------------------------------------------------
function jungle_spirit_volcano_fire_strike:GetCastAnimation()
	if IsServer() then
		if  self:GetSpecialValueFor( "animation_change_level" ) > 0 and self:GetCaster():GetLevel() >= self:GetSpecialValueFor( "animation_change_level" ) then
			return ACT_DOTA_OVERRIDE_ABILITY_1
		else
			return ACT_DOTA_CAST_ABILITY_1
		end
	end
end