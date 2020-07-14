
--[[ ai/healing_burrower.lua ]]

----------------------------------------------------------------------------------------------

function Precache( context )

	PrecacheResource( "model", "models/heroes/nerubian_assassin/mound.vmdl", context )

end

----------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	hHealAbility = thisEntity:FindAbilityByName( "nyx_suicide_heal" )
	hUnburrowAbility = thisEntity:FindAbilityByName( "nyx_assassin_unburrow" )

	-- Start already burrowed
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_nyx_assassin_burrow", { duration = -1 } )
	hUnburrowAbility:SetHidden( false )

	thisEntity:SetContextThink( "HealingNyxThink", HealingNyxThink, 0.5 )
end

----------------------------------------------------------------------------------------------

function HealingNyxThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	local bIsBurrowed = ( thisEntity:FindModifierByName( "modifier_nyx_assassin_burrow" ) ~= nil )
	if bIsBurrowed then
		return CastUnburrow()
	end

	local hCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 2000 )
	local hGuardians = {}
	for _, hCreature in pairs( hCreatures ) do
		if ( hCreature:GetUnitName() == "npc_dota_creature_sand_king" ) and hCreature:IsAlive() then
			return CastSuicideHeal( hCreature )
		end
	end

	return 0.1
end

----------------------------------------------------------------------------------------------

function CastUnburrow()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hUnburrowAbility:entindex(),
	})
	return 0.3
end

----------------------------------------------------------------------------------------------

function CastSuicideHeal( hCreature )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hHealAbility:entindex(),
		TargetIndex = hCreature:entindex(),
	})
	return 1
end


