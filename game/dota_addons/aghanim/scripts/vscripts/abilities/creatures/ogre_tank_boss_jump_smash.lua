
ogre_tank_boss_jump_smash = class({})
LinkLuaModifier( "modifier_ogre_tank_melee_smash_thinker", "modifiers/creatures/modifier_ogre_tank_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function ogre_tank_boss_jump_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function ogre_tank_boss_jump_smash:GetPlaybackRateOverride()
	return 0.9 -- keep this proportional to jump_speed
end


-----------------------------------------------------------------------------

function ogre_tank_boss_jump_smash:OnSpellStart()
	if IsServer() then
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_tank_melee_smash_thinker", { duration = self:GetSpecialValueFor( "jump_speed") }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------
