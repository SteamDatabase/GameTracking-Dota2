
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hCleave = thisEntity:FindAbilityByName( "bear_cleave" )
	thisEntity.hFrenzy = thisEntity:FindAbilityByName( "bear_frenzy" )

	thisEntity:SetContextThink( "BearMediumThink", BearMediumThink, 0.5 )
end

--------------------------------------------------------------------------------

function BearMediumThink()
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

	-- print("medium bear - health: " .. thisEntity:GetHealthPercent())

	if thisEntity:GetHealthPercent() < 50 and thisEntity.hFrenzy and thisEntity.hFrenzy:IsFullyCastable() then
		CastFrenzy()
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastFrenzy()
	-- print("medium bear - frenzy")

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:entindex(),
		AbilityIndex = thisEntity.hFrenzy:entindex(),
		Queue = false,
	})
end

function CastCleave( hTarget )
	-- print("medium bear - cleaving")

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:GetAggroTarget():entindex(),
		AbilityIndex = thisEntity.hCleave:entindex(),
		Queue = false,
	})
end
