require( "ai/shared" )
require( "ai/ai_core" )

--------------------------------------------------------------------------------
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	local hUnit = thisEntity

	thisEntity.hDismember = hUnit:FindAbilityByName( "creature_pudge_dismember" )

	thisEntity:SetContextThink( "PudgeMinibossThink", PudgeMinibossThink, 1 )
end

--------------------------------------------------------------------------------
function PudgeMinibossThink()

	local hUnit = thisEntity
	if hUnit:IsChanneling() then
		return 0.25
	end

	if thisEntity.hPhaseBoots == nil then

		for j = 0,DOTA_ITEM_INVENTORY_SIZE-1 do
			local hItem = thisEntity:GetItemInSlot( j )
			if hItem and hItem:GetAbilityName() == "item_phase_boots" then
				thisEntity.hPhaseBoots = hItem
				break
			end
		end
	else
		if thisEntity.hPhaseBoots:IsFullyCastable() then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = thisEntity.hPhaseBoots:entindex(),
				Queue = false,
			})
		end
	end

	local flNow = GameRules:GetGameTime()


	if thisEntity.hDismember and thisEntity.hDismember:IsFullyCastable() then
		local hHeroes = GetEnemyHeroesInRange( hUnit, 9000 )
		if #hHeroes > 1 then
			ExecuteOrderFromTable({
				UnitIndex = hUnit:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hHeroes[1]:entindex(),
				AbilityIndex = thisEntity.hDismember:entindex(),
				Queue = false,
			})
		end

	else
		hUnit.flLastAggroSwitch = hUnit.flLastAggroSwitch and hUnit.flLastAggroSwitch or 0
	
		local hTarget = AICore:ClosestEnemyHeroInRange( hUnit, 9000, false, true )

		if (flNow - hUnit.flLastAggroSwitch) > 2 then
			AttackTargetOrder( hUnit, hTarget )
			hUnit.flLastAggroSwitch = flNow
		end
	end

	return 0.25
end

--------------------------------------------------------------------------------