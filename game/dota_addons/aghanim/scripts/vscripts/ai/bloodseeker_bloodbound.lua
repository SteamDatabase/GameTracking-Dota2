
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	RuptureAbility = thisEntity:FindAbilityByName( "bloodseeker_bloodbound_rupture" )
	BloodbathAbility = thisEntity:FindAbilityByName( "bloodseeker_bloodbound_blood_bath" )
	SummonAbility = thisEntity:FindAbilityByName( "bloodseeker_summon" )

	thisEntity.bAbsoluteNoCC = true

	thisEntity:SetContextThink( "BloodseekerBloodboundThink", BloodseekerBloodboundThink, 1 )
	thisEntity.bHadAggroTarget = nil
end

--------------------------------------------------------------------------------

function BloodseekerBloodboundThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:GetHealth() < thisEntity:GetMaxHealth() then
		thisEntity.bTakenDamage = true
	end

	if thisEntity:GetAggroTarget() then
		thisEntity.bHadAggroTarget = true
	end

	if ( RuptureAbility ~= nil and RuptureAbility:IsChanneling() )
			or ( BloodbathAbility ~= nil and BloodbathAbility:IsChanneling() )
			or ( SummonAbility ~= nil and SummonAbility:IsChanneling() ) then
		return 0.5
	end
	
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )

	if thisEntity.bHadAggroTarget and SummonAbility ~= nil and SummonAbility:IsFullyCastable() then
		return CastSummon()
	end

	if thisEntity.bTakenDamage == true and RuptureAbility ~= nil and RuptureAbility:IsFullyCastable() then
		local hBestEnemy = nil
		local nLowestHealth = 99999999
		for _,enemy in pairs ( enemies ) do
			if enemy ~= nil and enemy:IsNull() == false and enemy:FindModifierByName( "modifier_bloodseeker_rupture" ) == nil and enemy:IsRealHero() then
				local fDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				local fCastRange = RuptureAbility:GetCastRange( thisEntity:GetOrigin(), nil )
				--print( string.format( "fDist == %d, fCastRange == %d", fDist, fCastRange ) )
				if ( fDist <= fCastRange ) then
					local nHealth = enemy:GetHealth()
					if nLowestHealth > nHealth then
						nLowestHealth = nHealth
						hBestEnemy = enemy
					end
				end
			end
		end
		if hBestEnemy ~= nil then
			local fDist = ( hBestEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			local fCastRange = RuptureAbility:GetCastRange( thisEntity:GetOrigin(), nil )
			if ( fDist <= fCastRange and thisEntity.bTakenDamage == true ) then
				return Rupture( hBestEnemy )
			end
		end
	end

	if thisEntity.bHadAggroTarget and thisEntity.bTakenDamage == true and BloodbathAbility ~= nil and BloodbathAbility:IsFullyCastable() then
		local nFindChoice = FIND_CLOSEST
		if RandomFloat( 0, 1 ) > 0.4 then
			nFindChoice = FIND_FARTHEST
		end
		local vecBathEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, BloodbathAbility:GetCastRange( thisEntity:GetOrigin(), nil ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, nFindChoice, false )
		if #vecBathEnemies > 0 then
			return Bloodbath( vecBathEnemies[1]:GetAbsOrigin() )
		end
	end

	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation to these magi
	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

function Approach( hUnit )
	--print( "Bloodseeker is approaching unit named " .. hUnit:GetUnitName() )

	local vToUnit = hUnit:GetOrigin() - thisEntity:GetOrigin()
	vToUnit = vToUnit:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToUnit * thisEntity:GetIdealSpeed()
	})

	return 0.25
end

--------------------------------------------------------------------------------

function Rupture( hUnit )
	--print( "Casting Rupture on " .. hUnit:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = RuptureAbility:entindex(),
		TargetIndex = hUnit:entindex(),	
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function Bloodbath( vPos )
	--print( "Casting Bloodbath at " .. vPos )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = BloodbathAbility:entindex(),
		Position = vPos,	
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function CastSummon( vPos )
	--print( "Casting Bloodbath at " .. vPos )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SummonAbility:entindex(),
		Queue = false,
	})

	return SummonAbility:GetChannelTime() + 0.5
end

--------------------------------------------------------------------------------
