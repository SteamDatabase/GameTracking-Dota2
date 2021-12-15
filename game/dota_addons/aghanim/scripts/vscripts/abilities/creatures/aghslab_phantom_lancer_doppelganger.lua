aghslab_phantom_lancer_doppelganger = class({})
LinkLuaModifier( "modifier_aghslab_phantom_lancer_doppelganger", "modifiers/creatures/modifier_aghslab_phantom_lancer_doppelganger", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghslab_phantom_lancer_doppelganger_thinker", "modifiers/creatures/modifier_aghslab_phantom_lancer_doppelganger_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghslab_phantom_lancer_doppelganger:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_immortal_doppelganger_aoe.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_phantom_lancer_illusion", context, -1 )
end

--------------------------------------------------------------------------------

function aghslab_phantom_lancer_doppelganger:OnAbilityPhaseStart()
	if IsServer() then
		local hLines = { "phantom_lancer_plance_ability_doppelwalk_01", "phantom_lancer_plance_ability_doppelwalk_02", "phantom_lancer_plance_ability_doppelwalk_06", }
		local nRandomInt = RandomInt(1,3)
		local hDoppelgangerLine = hLines[nRandomInt]
		EmitSoundOn( hDoppelgangerLine, self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function aghslab_phantom_lancer_doppelganger:OnSpellStart()
	if IsServer() == false then
		return
	end

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_aghslab_phantom_lancer_doppelganger_thinker", kv, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
	
	EmitSoundOn( "Hero_PhantomLancer.Doppelganger.Cast", self:GetCaster() )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_aghslab_phantom_lancer_doppelganger", { duration = self:GetSpecialValueFor( "duration" ) } )
end

--------------------------------------------------------------------------------