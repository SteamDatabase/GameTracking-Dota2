
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SwingAbility = thisEntity:FindAbilityByName( "frozen_giant_swing" )
	DanceAbility = thisEntity:FindAbilityByName( "frozen_giant_dance_smash" )

	thisEntity:SetContextThink( "FrozenGiantThink", FrozenGiantThink, 1 )
end

--------------------------------------------------------------------------------

function FrozenGiantThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity and thisEntity:IsChanneling() then 
		return 0.1
	end


	local nEnemiesRemoved = 0
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	for i = 1, #enemies do
		local enemy = enemies[i]
		if enemy ~= nil then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 210 then
				nEnemiesRemoved = nEnemiesRemoved + 1
				table.remove( enemies, i )
			end
		end
	end

	if DanceAbility ~= nil and DanceAbility:IsFullyCastable() and nEnemiesRemoved > 0 then
		print( "dance" )
		return Dance()
	end

	if #enemies == 0 then
		-- @todo: Could check whether there are ogre magi nearby that I should be positioning myself next to.  Either that or have the magi come to me.
		return 1
	end

	if SwingAbility ~= nil and SwingAbility:IsCooldownReady() then
		return Swing( enemies[1] )
	end

	return 0.5
end


--------------------------------------------------------------------------------

function Dance()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = DanceAbility:entindex(),
		Queue = false,
	})
	
	return 1.2
end


--------------------------------------------------------------------------------

function Swing( hTarget )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.3 } )
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetAbsOrigin(),
		AbilityIndex = SwingAbility:entindex(),
		Queue = false,
	})

	return 1.1 -- was 1.2
end

--------------------------------------------------------------------------------

