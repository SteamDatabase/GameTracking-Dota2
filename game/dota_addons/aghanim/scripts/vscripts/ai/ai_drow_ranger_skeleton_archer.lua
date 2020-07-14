
LinkLuaModifier( "modifier_drow_ranger_skeleton_archer", "modifiers/creatures/modifier_drow_ranger_skeleton_archer", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function Precache( context )
   PrecacheResource( "particle", "particles/units/heroes/hero_clinkz/clinkz_burning_army_start.vpcf", context )
   PrecacheResource( "particle", "particles/units/heroes/hero_clinkz/clinkz_burning_army.vpcf", context )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	-- reveal our position for spawning
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 0.5 } )

	-- this modifier will kill them when it falls off
	local flDuration = RandomFloat( 9, 12 )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_drow_ranger_skeleton_archer", { duration = flDuration } )
end
