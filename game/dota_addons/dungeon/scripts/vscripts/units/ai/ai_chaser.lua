
--------------------------------------------------------------------------------
-- Called in zones.lua by SpawnChasingSquads

function Chaser_aiThink( self, hUnit )
	if hUnit:IsNull() or ( hUnit:IsAlive() == false ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	--[[
	if hUnit:IsAttacking() or hUnit:IsMoving() or hUnit.bMoving then -- creatures such as dire_hound_boss set thisEntity.bMoving
		print( string.format( "%s has aggro or is on the move, returning early", hUnit:GetUnitName() ) )
		return 1
	else
		print( string.format( "%s doesn't have aggro and isn't moving, proceed into Chaser_aiThink", hUnit:GetUnitName() ) )
	end
	]]

	--print( "---------------" )
	--print( "hUnit: " .. hUnit:GetUnitName() )

	local bHasValidGoalEnt = IsValidChaseTarget( self, hUnit:GetInitialGoalEntity() )
	--print( string.format( "bHasValidGoalEnt == %s", tostring( bHasValidGoalEnt ) ) )

	if not bHasValidGoalEnt then
		hUnit:SetInitialGoalEntity( nil )
	end

	local bHasValidAttackEnt = IsValidChaseTarget( self, hUnit.hAttackTarget )
	--print( string.format( "bHasValidGoalEnt == %s", tostring( bHasValidAttackEnt ) ) )

	if not bHasValidAttackEnt then
		hUnit.hAttackTarget = nil
	end

	local bHasValidChaseTarget = ( IsValidChaseTarget( self, hUnit:GetInitialGoalEntity() ) or IsValidChaseTarget( self, hUnit.hAttackTarget ) )
	if bHasValidChaseTarget then
		--print( "Has valid chase target, return early" )
		return 1
	else
		--print( "Doesn't have valid chase target, continue" )
	end

	local hHeroesToCheck = HeroList:GetAllHeroes()
	if #hHeroesToCheck == 0 then
		print( "Chaser_aiThink - ERROR: No heroes" )
		return 1
	end

	if not ( bHasValidChaseTarget ) then
		--print( "Try to get a new hero to AttackMove to" )
		while hUnit.hAttackTarget == nil and #hHeroesToCheck > 0 do
			local nRandHeroIndex = RandomInt( 1, #hHeroesToCheck )
			hUnit.hAttackTarget = hHeroesToCheck[ nRandHeroIndex ]
			--[[
			print( "-----" )
			print( "hUnit.hAttackTarget ~= nil == " .. tostring( hUnit.hAttackTarget ~= nil ) )
			print( "self:ContainsUnit( hUnit.hAttackTarget ) == " .. tostring( self:ContainsUnit( hUnit.hAttackTarget ) ) )
			print( "hUnit.hAttackTarget:IsRealHero() == ", tostring( hUnit.hAttackTarget:IsRealHero() ) )
			print( "hUnit.hAttackTarget:IsAlive() == ", tostring( hUnit.hAttackTarget:IsAlive() ) )
			]]
			if not IsValidChaseTarget( self, hUnit.hAttackTarget ) then
				--print( "Set hUnit.hAttackTarget to nil" )
				hUnit.hAttackTarget = nil
				table.remove( hHeroesToCheck, nRandHeroIndex )
			end
		end
		if hUnit.hAttackTarget ~= nil then
			--print( "AttackMove towards target" )
			ExecuteOrderFromTable({
				UnitIndex = hUnit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hUnit.hAttackTarget:GetOrigin(),
			})
		else
			--print( "Chaser_aiThink - No Valid Attacker Target Found.  Are all heroes dead?" )
			return 1
		end	
	end

	return 1
end

--------------------------------------------------------------------------------

function IsValidChaseTarget( self, hAttackTarget )
	return ( hAttackTarget ~= nil and self:ContainsUnit( hAttackTarget ) and hAttackTarget:IsRealHero() and hAttackTarget:IsAlive() )
end
