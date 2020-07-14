function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity.hIos = {}
	thisEntity.TossAbility = thisEntity:FindAbilityByName( "aghsfort_elemental_tiny_toss" )
	thisEntity.CreateIoAbility = thisEntity:FindAbilityByName( "aghsfort_elemental_tiny_create_io" )

	thisEntity:SetContextThink( "ElementalTinyTossThink", ElementalTinyTossThink, 1 )
end

function LastTargetTossTime( hTarget )

	local flLastTime = thisEntity.Encounter.TossTargets[ tostring( hTarget:entindex() ) ]
	if flLastTime == nil then
		flLastTime = 0
	end

	return flLastTime

end

function ElementalTinyTossThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	--if thisEntity.Encounter.TossTargets == nil then
	--	thisEntity.Encounter.TossTargets = {}
	--end

	if thisEntity.TossAbility ~= nil and thisEntity.TossAbility:IsFullyCastable() then

		-- Select a unit in range to attack
		-- And don't pick a target who was tossed at at in the last 2 seconds

	-- Check to make sure we have an io to toss
		local grab_radius = thisEntity.TossAbility:GetSpecialValueFor( "grab_radius")
		local entities = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, grab_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,  DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false )
		local hPossibleProjectiles = {}
		for _, hAlly in pairs( entities ) do
	
			if hAlly ~= nil and not hAlly:IsNull() and hAlly:IsAlive() == true and hAlly:GetUnitName() == "npc_dota_creature_elemental_io" then
				table.insert( hPossibleProjectiles, hAlly )
			end
		end
		if #hPossibleProjectiles ~= 0 then
			local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 
				thisEntity.TossAbility:GetCastRange(thisEntity:GetAbsOrigin(), nil), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			
			local hPossibleEnemies = {}
			for _,hEnemy in pairs( enemies ) do
				--local flTimeSinceLastToss = GameRules:GetGameTime() - LastTargetTossTime( hEnemy )
				if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then --and 
					--hEnemy:IsMagicImmune() == false and ( flTimeSinceLastToss > 1.5 ) then
	
					table.insert( hPossibleEnemies, hEnemy )
				end
			end
	
			-- Pick a random one, but prefer one who is at least 500 away
			local hNearEnemy = nil
			while #hPossibleEnemies > 0 do
				local nIndex = math.random( 1, #hPossibleEnemies )
				local hEnemy = hPossibleEnemies[ nIndex ]
				if ( ( hEnemy:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D() > 500 ) then
					return Toss( hEnemy )
				end
				hNearEnemy = hEnemy
				table.remove( hPossibleEnemies, nIndex )
			end
	
			-- If not, then pick a close one
			if hNearEnemy ~= nil then
				return Toss( hNearEnemy )
			end
		end
	end

	if thisEntity.CreateIoAbility ~= nil and thisEntity.CreateIoAbility:IsFullyCastable() == true then
		
		-- Only spawn ios if we haven't got too many already
		local max_summons = thisEntity.CreateIoAbility:GetSpecialValueFor( "max_summons" )
		
		if #thisEntity.hIos <= max_summons then
			return CreateIos()
		end
	end

	return 0.1
end

function Toss( hTarget )

	local vTargetPos = hTarget:GetAbsOrigin() + RandomVector( RandomFloat( 25, 25 ) )
	--thisEntity.Encounter.TossTargets[ tostring( hTarget:entindex() ) ] = GameRules:GetGameTime()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.TossAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})
	
	return 0.5
end


function CreateIos( )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.CreateIoAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

