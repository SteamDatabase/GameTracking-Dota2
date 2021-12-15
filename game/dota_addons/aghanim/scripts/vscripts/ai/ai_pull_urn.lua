--[[ Pull Urn AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() == false then
		return
	end

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = -1 } )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_magic_immune", { duration = -1 } )

	thisEntity.hBlackHoleAbility = thisEntity:FindAbilityByName( "enigma_black_hole" )
	if thisEntity.hBlackHoleAbility == nil then
		print( "Black Hole Ability not found!")
	end

	thisEntity.nPreviewFX = nil
	thisEntity.bCastSpell = false
	
	thisEntity.fWarningTime = 1.0

	local flInitialThinkDelay = RandomFloat( 1, 3 )
	thisEntity:SetContextThink( "UrnAIThink", UrnAIThink, flInitialThinkDelay )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( "particle", "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker_ring.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
end


function UrnAIThink()
	--print( "Urn thinking..." )
	if IsServer() == false then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:IsAlive() == false then
		if thisEntity.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( thisEntity.nPreviewFX, false )
			thisEntity.nPreviewFX = nil
		end
		
		return
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.5
	end

	if thisEntity.bCastSpell == true then
		thisEntity.bCastSpell = false

		if thisEntity.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( thisEntity.nPreviewFX, false )
			thisEntity.nPreviewFX = nil
		end

		CastBlackHole()

		local channelTime = thisEntity.hBlackHoleAbility:GetChannelTime()
		local downTime = RandomFloat( 4, 5 )
		local flThinkDelay = channelTime + downTime
		--print( 'Pull Urn sleeping for ' .. flThinkDelay )

		return flThinkDelay
	end

	if thisEntity.hBlackHoleAbility ~= nil and thisEntity.hBlackHoleAbility:IsFullyCastable() then
		thisEntity.bCastSpell = true

		local warningRadius = 80
		thisEntity.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, thisEntity )
		ParticleManager:SetParticleControlEnt( thisEntity.nPreviewFX, 0, thisEntity, PATTACH_ABSORIGIN_FOLLOW, nil, thisEntity:GetOrigin(), true )
		ParticleManager:SetParticleControl( thisEntity.nPreviewFX, 1, Vector( warningRadius, warningRadius, warningRadius ) )
		ParticleManager:SetParticleControl( thisEntity.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		return thisEntity.fWarningTime
	end

	return 1.0
end

--------------------------------------------------------------------------------

function CastBlackHole()
	--print( "Casting Black Hole" )

	local vTargetPos = thisEntity:GetOrigin()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hBlackHoleAbility:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------
