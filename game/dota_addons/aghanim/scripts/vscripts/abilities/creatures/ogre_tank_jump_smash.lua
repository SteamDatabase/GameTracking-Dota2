
ogre_tank_jump_smash = class({})

LinkLuaModifier( "modifier_ogre_tank_melee_smash_thinker", "modifiers/creatures/modifier_ogre_tank_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function ogre_tank_jump_smash:Precache( context )

	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )

end

-----------------------------------------------------------------------------

function ogre_tank_jump_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function ogre_tank_jump_smash:GetPlaybackRateOverride()
	return 0.75
end


-----------------------------------------------------------------------------

function ogre_tank_jump_smash:OnSpellStart()
	if IsServer() then
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_tank_melee_smash_thinker", { duration = self:GetSpecialValueFor( "jump_speed") }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------

ogre_tank_farmer_jump_smash = ogre_tank_jump_smash
bonus_ogre_tank_jump_smash = ogre_tank_jump_smash
