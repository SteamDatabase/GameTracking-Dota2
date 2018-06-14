
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		hSunStrikeAbility = thisEntity:FindAbilityByName( "creature_invoker_sun_strike" )
		hExortAbility = thisEntity:FindAbilityByName( "invoker_exort" )

		thisEntity.nExortsActive = 0

		thisEntity.fMinThink = 1.0 -- was 0.5
		thisEntity.fMaxThink = 1.0

		local fRandomInitialDelay = RandomFloat( 0.0, 1.0 )

		thisEntity:SetContextThink( "InvokerThink", InvokerThink, fRandomInitialDelay )
	end
end

--------------------------------------------------------------------------------

function InvokerThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	if thisEntity.hRoom == nil then
		printf( "ERROR: InvokerThink -- thisEntity.hRoom is nil" )
		return nil
	end

	if not thisEntity.bInitialized then
		hSunStrikeAbility:SetLevel( thisEntity.hRoom:GetRoomLevel() )
		thisEntity.bInitialized = true
	end

	if thisEntity.nExortsActive < 3 then
		CastExort()
	end

	local hEnemies = GetEnemyHeroesInRoom( thisEntity, 1500 )
	if #hEnemies == 0 then
		return RandomFloat( thisEntity.fMinThink, thisEntity.fMaxThink )
	end

	if ( thisEntity.timeOfLastSunStrike == nil ) or ( GameRules:GetGameTime() > thisEntity.timeOfLastSunStrike + 8 ) then
		return CastSunStrike( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end

	return RandomFloat( thisEntity.fMinThink, thisEntity.fMaxThink )
end

--------------------------------------------------------------------------------

function CastSunStrike( hEnemy )
	local vEnemyPos = hEnemy:GetAbsOrigin()
	local vEnemyFacing = hEnemy:GetForwardVector()
	local vSunStrikeTargetPos = vEnemyPos

	if hEnemy:IsMoving() then
		local bGuessPlayerWillJuke = RandomFloat( 0, 1 ) > 0.7
		if bGuessPlayerWillJuke then
			vSunStrikeTargetPos = vEnemyPos
		else
			local nRandomDistance = RandomInt( 350, 550 )
			vSunStrikeTargetPos = vEnemyPos + ( vEnemyFacing * nRandomDistance )
		end
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hSunStrikeAbility:entindex(),
		Position = vSunStrikeTargetPos,
	})

	EmitSoundOnLocationForAllies( vSunStrikeTargetPos, "Hero_Invoker.SunStrike.Charge", hEnemy )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vSunStrikeTargetPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	thisEntity.timeOfLastSunStrike = GameRules:GetGameTime()

	return RandomFloat( thisEntity.fMinThink, thisEntity.fMaxThink )
end

--------------------------------------------------------------------------------

function CastExort()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hExortAbility:entindex(),
	})

	thisEntity.nExortsActive = thisEntity.nExortsActive + 1
end

--------------------------------------------------------------------------------
