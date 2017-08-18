
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	TombstoneAbility = thisEntity:FindAbilityByName( "undead_tusk_mage_tombstone" )

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

	if TombstoneAbility ~= nil and TombstoneAbility:IsFullyCastable() then
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
