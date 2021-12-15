
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.fOrigModelScale = thisEntity:GetModelScale()

	thisEntity:AddNewModifier( nil, nil, "modifier_phased", { duration = -1 } )

	thisEntity.hSunRayAbility = thisEntity:FindAbilityByName( "aghsfort_assault_captain_sun_ray" )
	thisEntity.hChainsAbility = thisEntity:FindAbilityByName( "aghsfort_assault_captain_searing_chains" )

	thisEntity:SetContextThink( "AssaultCaptainThink", AssaultCaptainThink, 0.5 )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_right.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", context )
end

--------------------------------------------------------------------------------

function AssaultCaptainThink()
	if not IsServer() then
		return
	end

	-- Search for items here instead of in Spawn, because they don't seem to exist yet when Spawn runs
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	--[[
	if thisEntity.fLastSearingCast then
		print( "last searing cast: " .. thisEntity.fLastSearingCast )
	end

	if thisEntity.fLastSearingCast ~= nil and GameRules:GetGameTime() > ( thisEntity.fLastSearingCast + 1 ) then
		ParticleManager:DestroyParticle( thisEntity.nPreviewFX, false )
		thisEntity.fLastSearingCast = nil
	end
	]]

	if thisEntity:HasModifier( "modifier_aghsfort_assault_captain_sun_ray" ) then
		--print( 'SUN RAY!' )
		-- continuously face our sunray target if it's still alive
		if thisEntity.hSunRayTarget ~= nil and thisEntity.hSunRayTarget:IsAlive() then
			--print( 'VALID SUN RAY TARGET!' )
			thisEntity:FaceTowards( thisEntity.hSunRayTarget:GetOrigin() )
		end
		return 0.25
	else
		thisEntity.hSunRayTarget = nil
		thisEntity:SetModelScale( thisEntity.fOrigModelScale )
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	if thisEntity.hChainsAbility ~= nil and thisEntity.hChainsAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 95 ) then
			return CastSearingChains()
		end
	end

	local hSunRayTarget = nil
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy and hEnemy:IsAlive() and hEnemy:IsRealHero() then
			if hEnemy:HasModifier( "modifier_ember_spirit_searing_chains" ) or hEnemy:HasModifier( "modifier_rod_of_atos_debuff" ) then
				hSunRayTarget = hEnemy
				break
			end
		end
	end

	if hSunRayTarget ~= nil and thisEntity.hSunRayAbility ~= nil and thisEntity.hSunRayAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 95 ) then
			thisEntity.hSunRayTarget = hSunRayTarget
			return CastSunRay( hSunRayTarget )
		end
	end

	--[[
	if thisEntity.hRodOfAtosAbility and thisEntity.hRodOfAtosAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 100 ) then
			print( "try to use atos" )
			return UseRodOfAtos( hEnemies[ RandomInt( 1, #hEnemies ) ] )
		end
	end
	]]

	if thisEntity.hBlademailAbility and thisEntity.hBlademailAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 80 ) then
			return UseBlademail()
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_aghsfort_creature_blade_mail" then
				thisEntity.hBlademailAbility = item
			end
			if item:GetAbilityName() == "item_rod_of_atos" then
				thisEntity.hRodOfAtosAbility = item
			end
		end
	end
end

--------------------------------------------------------------------------------

function CastSunRay( hEnemy )
	thisEntity:SetModelScale( 2 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hEnemy:GetOrigin(),
		AbilityIndex = thisEntity.hSunRayAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------


function CastSearingChains()
	if IsServer() then
		--[[
		print( "creating a warning particle" )
		thisEntity.fLastSearingCast = GameRules:GetGameTime()
		thisEntity.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, thisEntity )
		ParticleManager:SetParticleControlEnt( thisEntity.nPreviewFX, 0, thisEntity, PATTACH_ABSORIGIN_FOLLOW, nil, thisEntity:GetOrigin(), true )
		ParticleManager:SetParticleControl( thisEntity.nPreviewFX, 1, Vector( 120, 120, 120 ) )
		ParticleManager:SetParticleControl( thisEntity.nPreviewFX, 15, Vector( 180, 40, 10 ) )
		]]
	end

	--thisEntity:SetSequence( "hit" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hChainsAbility:entindex(),
		Queue = false,
	})

	return 0.75
end

--------------------------------------------------------------------------------

function UseRodOfAtos( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.hRodOfAtosAbility:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function UseBlademail()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hBlademailAbility:entindex(),
		Queue = false,
	})

	return 2
end

--------------------------------------------------------------------------------

