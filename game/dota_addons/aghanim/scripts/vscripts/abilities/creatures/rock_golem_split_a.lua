rock_golem_split_a = class({})

LinkLuaModifier( "modifier_rock_golem_split", "modifiers/creatures/modifier_rock_golem_split", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function rock_golem_split_a:Precache( context )

	self.strSplitFx = "particles/creature_splitter/splitter_a.vpcf"
	self.strSummonedUnit = "npc_dota_creature_rock_golem_b"

	PrecacheResource( "particle", "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf", context )	
	PrecacheResource( "particle", "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", context )	
	PrecacheResource( "particle", self.strSplitFx, context )	
	PrecacheUnitByNameSync( self.strSummonedUnit, context, -1 )

end

--------------------------------------------------------------------------------

function rock_golem_split_a:GetIntrinsicModifierName()
	return "modifier_rock_golem_split"
end

--------------------------------------------------------------------------------

