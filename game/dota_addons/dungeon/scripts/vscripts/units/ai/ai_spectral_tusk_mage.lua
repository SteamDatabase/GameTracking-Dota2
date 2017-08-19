
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	TombstoneAbility = thisEntity:FindAbilityByName( "undead_tusk_mage_tombstone" )

	thisEntity.hTombstones = {}

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

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	for k, hTombstone in pairs( thisEntity.hTombstones ) do
		if hTombstone == nil or hTombstone:IsNull() or hTombstone:IsAlive() == false then
			table.remove( thisEntity.hTombstones, k )
		end
	end

	local nTombstonesAround = 0

	local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _, friendly in pairs ( friendlies ) do
		if friendly ~= nil and friendly:GetUnitName() == "npc_dota_undead_tusk_tombstone" then
			nTombstonesAround = nTombstonesAround + 1
		end
	end

	--[[
	if #friendlies >= 60 then
		print( "UndeadSpectralTuskMageThink - too many fiendlies around, not making any more for now" )
	end
	]]

	--[[
	if nTombstonesAround >= 6 then
		print( "UndeadSpectralTuskMageThink - too many tombstones around, not making any more for now" )
	end
	]]

	if TombstoneAbility ~= nil and TombstoneAbility:IsFullyCastable() and ( #friendlies < 80 ) and ( nTombstonesAround < 6 ) then
		local vCastLocation = nil
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil then
				if vCastLocation == nil then
					vCastLocation = enemy:GetOrigin() + RandomVector( 150 ) 
				else
					vCastLocation = vCastLocation + enemy:GetOrigin() + RandomVector( 150 ) 
				end
			end
		end
		if vCastLocation ~= nil and GridNav:CanFindPath( thisEntity:GetOrigin(), vCastLocation ) then
			return CastTombstone( vCastLocation )
		end	
	end

	return 0.5
end


function CastTombstone( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPos,
		AbilityIndex = TombstoneAbility:entindex(),
		Queue = false,
	})

	return 1.0
end
