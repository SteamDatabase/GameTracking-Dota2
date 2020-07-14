function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.ImpaleAbility = thisEntity:FindAbilityByName( "aghsfort_creature_impale" )

	thisEntity:SetContextThink( "ScarabZealotThink", ScarabZealotThink, 1 )
end

function LastTargetImpaleTime( hTarget )

	local flLastTime = thisEntity.Encounter.ImpaleTargets[ tostring( hTarget:entindex() ) ]
	if flLastTime == nil then
		flLastTime = 0
	end

	return flLastTime

end

function ScarabZealotThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.Encounter.ImpaleTargets == nil then
		thisEntity.Encounter.ImpaleTargets = {}
	end

	if thisEntity.ImpaleAbility ~= nil and thisEntity.ImpaleAbility:IsFullyCastable() then

		-- Select a unit in range to attack
		-- And don't pick a target who was impaled at in the last second
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 
			thisEntity.ImpaleAbility:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

		local hPossibleEnemies = {}
		for _,hEnemy in pairs( enemies ) do
			local flTimeSinceLastImpale = GameRules:GetGameTime() - LastTargetImpaleTime( hEnemy )
			if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false and 
				hEnemy:IsMagicImmune() == false and ( flTimeSinceLastImpale > 0.5 ) then

				table.insert( hPossibleEnemies, hEnemy )
			end
		end

		-- Pick a random one, but prefer one who is at least 500 away
		local hNearEnemy = nil
		while #hPossibleEnemies > 0 do
			local nIndex = math.random( 1, #hPossibleEnemies )
			local hEnemy = hPossibleEnemies[ nIndex ]
			if ( ( hEnemy:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D() > 500 ) then
				return Impale( hEnemy )
			end
			hNearEnemy = hEnemy
			table.remove( hPossibleEnemies, nIndex )
		end

		-- If not, then pick a close one
		if hNearEnemy ~= nil then
			return Impale( hNearEnemy )
		end

	end

	return 0.1
end

function Impale( hTarget )

	local vTargetPos = hTarget:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
	thisEntity.Encounter.ImpaleTargets[ tostring( hTarget:entindex() ) ] = GameRules:GetGameTime()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.ImpaleAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})
	
	return 0.5
end
