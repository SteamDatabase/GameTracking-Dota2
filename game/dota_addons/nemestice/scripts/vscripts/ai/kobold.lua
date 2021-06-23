
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hRushAbility = thisEntity:FindAbilityByName( "kobold_rush" )

	thisEntity:SetContextThink( "KoboldThink", KoboldThink, 1 )
end

--------------------------------------------------------------------------------

function KoboldThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	local hAggroTarget = thisEntity:GetAggroTarget()
	if hAggroTarget ~= nil then
		-- have a target
		if hAggroTarget:IsNull() == false and hAggroTarget:IsAlive() == true and hAggroTarget:IsRealHero() == true then
			-- target is a valid hero so let's go eat them and override our ai
			--AttackHero( hAggroTarget )

			if hRushAbility ~= nil and hRushAbility:IsCooldownReady() then
				return Rush()
			end
			return 0.5
		end
	end

	-- ***no aggro target or aggro target is a creep***

	-- search for enemy heroes to attack
	--[[
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies > 0 then
		-- go eat a hero
		AttackHero( enemies[ RandomInt( 1, #enemies ) ] )
		return 0.5
	end
	]]--

	-- ok to default to normal AI in this case
	--print( '***KOBOLD AI - FALL THROUGH - REVERTING TO STANDARD AI' )
	--thisEntity.OverrideCreepAI = false

	return 0.5
end

--------------------------------------------------------------------------------

function Rush()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hRushAbility:entindex(),
		Queue = false,
	})

	return 1.0
end

--------------------------------------------------------------------------------

function AttackHero( hTarget )
	--print( '***KOBOLD AI - ATTACKING A HERO' )
	thisEntity.OverrideCreepAI = true
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
	})
end

