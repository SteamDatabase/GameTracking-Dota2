
elemental_tiny_tree_attack = class({})


function elemental_tiny_tree_attack:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tiny/tiny_craggy_cleave.vpcf", context )
end

-----------------------------------------------------------------------------------------

function elemental_tiny_tree_attack:GetIntrinsicModifierName()
	return "modifier_tiny_tree_grab"
end

-----------------------------------------------------------------------------------------
