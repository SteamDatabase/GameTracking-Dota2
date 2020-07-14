mushroom_split = class({})

LinkLuaModifier( "modifier_rock_golem_split", "modifiers/creatures/modifier_rock_golem_split", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function mushroom_split:Precache( context )

	self.strSplitFx = "particles/creature_splitter/splitter_a.vpcf"
	self.strSummonedUnit = "npc_dota_creature_shroomling"

	PrecacheResource( "particle", self.strSplitFx, context )	
	PrecacheUnitByNameSync( self.strSummonedUnit, context, -1 )

end

--------------------------------------------------------------------------------

function mushroom_split:GetIntrinsicModifierName()
	return "modifier_rock_golem_split"
end

--------------------------------------------------------------------------------

