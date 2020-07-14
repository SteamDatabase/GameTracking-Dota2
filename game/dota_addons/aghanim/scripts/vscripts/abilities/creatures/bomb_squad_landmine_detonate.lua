bomb_squad_landmine_detonate = class({})
LinkLuaModifier( "modifier_bomb_squad_landmine_detonate", "modifiers/creatures/modifier_bomb_squad_landmine_detonate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bomb_squad_landmine_intrinsic", "modifiers/creatures/modifier_bomb_squad_landmine_intrinsic", LUA_MODIFIER_MOTION_NONE )


----------------------------------------------------------------------------------------

function bomb_squad_landmine_detonate:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end

--------------------------------------------------------------------------------

function bomb_squad_landmine_detonate:GetIntrinsicModifierName()
	return "modifier_bomb_squad_landmine_intrinsic"
end

--------------------------------------------------------------------------------

function bomb_squad_landmine_detonate:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_bomb_squad_landmine_detonate", { duration = self:GetSpecialValueFor( "duration" ) } )
	end
end

