--[[
Catapult AI
]]

function Spawn( entityKeyValues )
	if IsServer() == false then
		return
	end
	thisEntity:SetContextThink( "CatapultAIThink", CatapultAIThink, 0.25 )

	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )
end

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.hEntityKilledGameEvent )
end

function Precache( context )
	PrecacheResource( "particle", "particles/creatures/catapult/catapult_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/siege_fx/siege_bad_death_01.vpcf", context )
end


function CatapultAIThink()
	if IsServer() == false then
		return
	end

	s_AbilityCatapultAttack = thisEntity:FindAbilityByName( "catapult_attack" )

	-- Get the current time
	local currentTime = GameRules:GetGameTime()
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end


	if s_AbilityCatapultAttack ~= nil and s_AbilityCatapultAttack:IsCooldownReady() then

		local radius = s_AbilityCatapultAttack:GetSpecialValueFor("explosion_radius")
		local minRange = s_AbilityCatapultAttack:GetSpecialValueFor("mindistance")
		local range = s_AbilityCatapultAttack:GetCastRange()
		local nMaxAdjacentEnemies = 0
		local bestEnemy = nil

		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsAlive() then
				local flDistToEnemy = #(thisEntity:GetOrigin() - enemy:GetOrigin())
				if range > flDistToEnemy and minRange < flDistToEnemy then
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
			return CatapultAttack( bestEnemy )
		end
	end

	return 1.0
end

function CatapultAttack( enemy )
	local order = {}	
	order.UnitIndex = thisEntity:entindex()
	order.OrderType = DOTA_UNIT_ORDER_CAST_POSITION
	order.Position = enemy:GetOrigin()
	order.AbilityIndex = s_AbilityCatapultAttack:entindex()
	ExecuteOrderFromTable( order )

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 2.0 } )

	return 3.5
end

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

	local nFXIndex = ParticleManager:CreateParticle( "particles/siege_fx/siege_bad_death_01.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hVictim, PATTACH_ABSORIGIN, nil, hVictim:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end
