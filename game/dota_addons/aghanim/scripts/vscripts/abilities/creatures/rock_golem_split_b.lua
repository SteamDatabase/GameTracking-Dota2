rock_golem_split_b = class({})

LinkLuaModifier( "modifier_rock_golem_split", "modifiers/creatures/modifier_rock_golem_split", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function rock_golem_split_b:Precache( context )

	self.strSplitFx = "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast_mid.vpcf"
	self.strSummonedUnit = "npc_dota_creature_rock_golem_c"

	PrecacheResource( "particle", self.strSplitFx, context )	
	PrecacheUnitByNameSync( self.strSummonedUnit, context, -1 )

end

--------------------------------------------------------------------------------

function rock_golem_split_b:GetIntrinsicModifierName()
	return "modifier_rock_golem_split"
end
--------------------------------------------------------------------------------

