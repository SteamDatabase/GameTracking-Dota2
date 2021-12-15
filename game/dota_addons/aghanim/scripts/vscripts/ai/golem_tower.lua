--[[ Golem Tower AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() == false then
		return
	end
	thisEntity.hBoulderAbility = thisEntity:FindAbilityByName( "golem_tower_boulder_toss" )

	thisEntity:SetContextThink( "GolemTowerAIThink", GolemTowerAIThink, 0.25 )

	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )
end

--------------------------------------------------------------------------------

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.hEntityKilledGameEvent )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( "particle", "particles/econ/world/towers/rock_golem/dire_rock_golem_attack_model.vpcf", context )
	PrecacheResource( "particle", "particles/econ/world/towers/rock_golem/dire_rock_golem_destruction.vpcf", context )
end

--------------------------------------------------------------------------------

function GolemTowerAIThink()
	if IsServer() == false then
		return
	end

	-- Get the current time
	local currentTime = GameRules:GetGameTime()
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	if thisEntity.hBoulderAbility ~= nil and thisEntity.hBoulderAbility:IsCooldownReady() then

		local radius = thisEntity.hBoulderAbility:GetSpecialValueFor("radius")
		local range = 700
		local nMaxAdjacentEnemies = 0
		local bestEnemy = nil

		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsAlive() then
				local flDistToEnemy = #(thisEntity:GetOrigin() - enemy:GetOrigin())
				if range > flDistToEnemy then
					local nAdjacentEnemies = 1
					for _,adjacentEnemy in pairs( enemies ) do
						if adjacentEnemy ~= nil and adjacentEnemy ~= enemy and adjacentEnemy:IsAlive() then
							local vSeparation = enemy:GetOrigin() - adjacentEnemy:GetOrigin()
							local flDistBetweenEnemies = #vSeparation
							if flDistBetweenEnemies < radius then
								nAdjacentEnemies = nAdjacentEnemies + 1
							end
						end
					end
				
					if nMaxAdjacentEnemies < nAdjacentEnemies or ( nMaxAdjacentEnemies == nMaxAdjacentEnemies and RandomInt( 0,1 ) == 1 ) then
						nMaxAdjacentEnemies = nAdjacentEnemies
						bestEnemy = enemy
					end
				end
			end
		end
		
		if bestEnemy ~= nil then
			return BoulderToss( bestEnemy )
		end
	else
		local target = enemies[#enemies]
		local vPos = target:GetAbsOrigin()
		thisEntity:FaceTowards( vPos )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function BoulderToss( hEnemy )
	--print( "Casting BoulderToss on " .. hEnemy:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hBoulderAbility:entindex(),
		Position = hEnemy:GetOrigin(),
		Queue = false,
	})

	return 0.55
end

--------------------------------------------------------------------------------

function OnEntityKilled( event )
	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim ~= thisEntity then
		return
	end

	EmitSoundOn( "Creep_Siege_Dire.Destruction", hVictim )

	hVictim:AddEffects( EF_NODRAW )

	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/world/towers/rock_golem/dire_rock_golem_destruction.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hVictim, PATTACH_ABSORIGIN, nil, hVictim:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	-- Remove obstruction
	print( "Removing Obstruction" )
	local hObstructions = Entities:FindAllByClassname( "point_simple_obstruction" )
	if hObstructions ~= nil then
		for _,obstruction in ipairs( hObstructions ) do
			local flDist = ( obstruction:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 500 then
				UTIL_Remove( obstruction )
			end
		end
	end
end

--------------------------------------------------------------------------------
