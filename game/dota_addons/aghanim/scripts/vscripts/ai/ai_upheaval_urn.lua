--[[
Upheaval Urn AI
]]

function Spawn( entityKeyValues )
	if IsServer() == false then
		return
	end

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = -1 } )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_magic_immune", { duration = -1 } )

	AbilityUpheaval = thisEntity:FindAbilityByName( "urn_upheaval" )

	thisEntity.nPreviewFX = nil
	thisEntity.bCastSpell = false
	
	thisEntity.fWarningTime = 2.5

	local flInitialThinkDelay = RandomFloat( 1, 3 )
	thisEntity:SetContextThink( "UrnAIThink", UrnAIThink, flInitialThinkDelay )
end


function Precache( context )
	PrecacheResource( "particle", "particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn_debuff.vpcf", context )

	PrecacheResource( "particle", "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker_ring.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
end


function UrnAIThink()
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

	if thisEntity.bCastSpell == true then
		thisEntity.bCastSpell = false

		if thisEntity.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( thisEntity.nPreviewFX, false )
			thisEntity.nPreviewFX = nil
		end

		local order = {}	
		order.UnitIndex = thisEntity:entindex()
		order.OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET
		order.AbilityIndex = AbilityUpheaval:entindex()
		ExecuteOrderFromTable( order )

		local channelTime = AbilityUpheaval:GetChannelTime()
		local downTime = RandomFloat( 3, 7 )
		local flThinkDelay = channelTime + downTime
		--print( 'Upheaval Urn sleeping for ' .. flThinkDelay )

		return flThinkDelay
	end

	if AbilityUpheaval ~= nil and AbilityUpheaval:IsFullyCastable() then
		thisEntity.bCastSpell = true
--[[
		local radius = AbilityUpheaval:GetSpecialValueFor( "aoe" )
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, thisEntity:GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( thisEntity.fWarningTime, thisEntity.fWarningTime, thisEntity.fWarningTime ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
--]]
		local warningRadius = 80
		thisEntity.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, thisEntity )
		ParticleManager:SetParticleControlEnt( thisEntity.nPreviewFX, 0, thisEntity, PATTACH_ABSORIGIN_FOLLOW, nil, thisEntity:GetOrigin(), true )
		ParticleManager:SetParticleControl( thisEntity.nPreviewFX, 1, Vector( warningRadius, warningRadius, warningRadius ) )
		ParticleManager:SetParticleControl( thisEntity.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		return thisEntity.fWarningTime
	end

	return 1.0
end

