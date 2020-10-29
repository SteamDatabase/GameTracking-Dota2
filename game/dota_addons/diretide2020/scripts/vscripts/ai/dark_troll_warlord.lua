
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hRaiseDead = thisEntity:FindAbilityByName( "creature_dark_troll_warlord_raise_dead" )

	thisEntity:SetContextThink( "DarkTrollThink", DarkTrollThink, 1 )
end

----------------------------------------------------------------------------------------

function DarkTrollThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.hRaiseDead and thisEntity.hRaiseDead:IsCooldownReady() then
		local fSearchRadius = 500
		local max_skeletons_per_cast = thisEntity.hRaiseDead:GetSpecialValueFor( "max_skeletons_per_cast" )
		local vecDeadUnits = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, fSearchRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_DEAD, 0, false )
		if #vecDeadUnits >= max_skeletons_per_cast then
			return RaiseDead()
		end
	end

	return 1
end

----------------------------------------------------------------------------------------

function RaiseDead()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hRaiseDead:entindex(),
		Queue = false,
	})

	return 1
end

----------------------------------------------------------------------------------------
