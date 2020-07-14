
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hHellfireBlast = thisEntity:FindAbilityByName( "undead_woods_skeleton_king_hellfire_blast" )
	thisEntity.hMortalStrike = thisEntity:FindAbilityByName( "undead_woods_skeleton_king_mortal_strike" )
	thisEntity.bInitialSkeletons = false

	thisEntity:SetContextThink( "SkeletonKingThink", SkeletonKingThink, 1.0 )
end

--------------------------------------------------------------------------------

function SkeletonKingThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.hHellfireBlast and thisEntity.hHellfireBlast:IsFullyCastable() then
		return CastHellFireBlast( hEnemies[#hEnemies] )
	end

	if thisEntity.hMortalStrike then
		local hBuff = thisEntity:FindModifierByName( "modifier_skeleton_king_mortal_strike" )
		if hBuff ~= nil then
			local nMaxSkeletons = thisEntity.hMortalStrike:GetSpecialValueFor( "max_skeleton_charges" )
			if thisEntity.bInitialSkeletons == false then
				hBuff:SetStackCount( nMaxSkeletons ) 
				thisEntity.bInitialSkeletons = true
				return CastMortalStrike()
			end

			if hBuff:GetStackCount() < nMaxSkeletons then
				hBuff:IncrementStackCount()
			elseif thisEntity.hMortalStrike:IsFullyCastable() then
				return CastMortalStrike()
			end
		end	
	end

	return 0.5
end


--------------------------------------------------------------------------------

function CastHellFireBlast( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hHellfireBlast:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function CastMortalStrike( )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hMortalStrike:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------
