
require( "ai/shared" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hTombstoneAbility = thisEntity:FindAbilityByName( "undead_tusk_mage_tombstone" )

	thisEntity.hTombstones = {}

	thisEntity.nMyMaxTombstones = 2
	thisEntity.nMaxTombstonesInArea = 4

	thisEntity.fSearchRadius = thisEntity:GetAcquisitionRange() + 200

	thisEntity:SetContextThink( "UndeadSpectralTuskMageThink", UndeadSpectralTuskMageThink, 0.5 )
end

--------------------------------------------------------------------------------

function UndeadSpectralTuskMageThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if ( not thisEntity:GetAggroTarget() ) then
		return 1.0
	end

	-- Are we currently holding aggro?
    if ( not thisEntity.bHasAggro ) and thisEntity:GetAggroTarget() then
		thisEntity.timeOfLastAggro = GameRules:GetGameTime()
		thisEntity.bHasAggro = true
	elseif thisEntity.bHasAggro and ( not thisEntity:GetAggroTarget() ) then
		thisEntity.bHasAggro = false
	end

	if ( not thisEntity.bHasAggro ) then
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.hTombstoneAbility ~= nil and thisEntity.hTombstoneAbility:IsFullyCastable() then
		for k, hTombstone in pairs( thisEntity.hTombstones ) do
			if hTombstone == nil or hTombstone:IsNull() or hTombstone:IsAlive() == false then
				table.remove( thisEntity.hTombstones, k )
			end
		end

		local nTombstonesAround = 0
		local nFlags = DOTA_UNIT_TARGET_FLAG_NONE
		local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, nFlags, FIND_CLOSEST, false )
		for _, friendly in pairs ( friendlies ) do
			if friendly ~= nil and friendly:GetUnitName() == "npc_dota_undead_tusk_tombstone" then
				nTombstonesAround = nTombstonesAround + 1
			end
		end

		if ( #friendlies < 80 ) and ( nTombstonesAround < thisEntity.nMaxTombstonesInArea ) and ( #thisEntity.hTombstones < thisEntity.nMyMaxTombstones ) then
			local fNow = GameRules:GetGameTime()
			local flLastAllyCastTime = LastAllyCastTime( thisEntity, thisEntity.hTombstoneAbility, 1000, nil )
			local fCastPoint = thisEntity.hTombstoneAbility:GetCastPoint()
			if ( fNow - flLastAllyCastTime ) > ( fCastPoint + 0.1 ) then
				local vCastLocation = thisEntity:GetAbsOrigin() + ( thisEntity:GetForwardVector() * 300 )
				if GridNav:CanFindPath( thisEntity:GetAbsOrigin(), vCastLocation ) then
					UpdateLastCastTime( thisEntity, thisEntity.hTombstoneAbility, nil )
					return CastTombstone( vCastLocation )
				end
			end
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastTombstone( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPos,
		AbilityIndex = thisEntity.hTombstoneAbility:entindex(),
		Queue = false,
	})

	return 1.0
end

--------------------------------------------------------------------------------

