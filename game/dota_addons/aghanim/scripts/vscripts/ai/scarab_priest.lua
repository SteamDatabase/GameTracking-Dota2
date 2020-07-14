function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.SpikedCarapaceAbility = thisEntity:FindAbilityByName( "aghsfort_creature_spiked_carapace" )
	thisEntity.SummonZealotsAbility = thisEntity:FindAbilityByName( "scarab_priest_summon_zealots" )
	thisEntity.nLastHealth = thisEntity:GetHealth()
	thisEntity.bAcqRangeModified = false

	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )

	thisEntity:SetContextThink( "ScarabPriestThink", ScarabPriestThink, 1 )
end

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.hEntityKilledGameEvent )
end

function ScarabPriestThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Increase acquisition range after the initial aggro
	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 850 )
		thisEntity.bAcqRangeModified = true
	end

	local nHealth = thisEntity:GetHealth()	
	if thisEntity.nLastHealth > nHealth then
		if thisEntity.SpikedCarapaceAbility ~= nil and thisEntity.SpikedCarapaceAbility:IsFullyCastable() then
			return SpikedCarapace( )
		end
		thisEntity.nLastHealth = nHealth
	end
	
	if thisEntity.SummonZealotsAbility ~= nil and thisEntity.SummonZealotsAbility:IsFullyCastable() == true and
		thisEntity.bAcqRangeModified == true then

		-- Only spawn zealots if we haven't got too many already
		local nMyZealotCount = thisEntity.SummonZealotsAbility:GetSpecialValueFor( "max_summons" )
		local hZealots = thisEntity.Encounter:GetSpawnedUnitsOfType( "npc_dota_creature_zealot_scarab" )
		for i=1,#hZealots do
			if hZealots[i]:GetOwnerEntity() == thisEntity then
				nMyZealotCount = nMyZealotCount - 1
				if nMyZealotCount == 0 then
					break
				end
			end
		end

		if nMyZealotCount > 0 then
			return SummonZealots()
		end
	end

	return 0.5
end

function OnEntityKilled( event )

	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim ~= thisEntity then
		return
	end

	-- Check all of the other priests, and see if any others are aggroed.
	-- If not, then we'll force aggro on the closest one
	local flNearDist = 60000
	local hNearPriest = nil
	local hPriests = thisEntity.Encounter:GetSpawnedUnitsOfType( "npc_dota_creature_scarab_priest" )
	for i=1,#hPriests do
		if hPriests[i] ~= thisEntity then

			if hPriests[i].bAcqRangeModified then
				hNearPriest = nil
				break
			end

			local flDist = ( hPriests[i]:GetAbsOrigin() - hVictim:GetAbsOrigin() ):Length2D()
			if flDist < flNearDist then
				flNearDist = flDist
				hNearPriest = hPriests[i]
			end

		end
	end

	if hNearPriest == nil then
		return
	end

	hNearPriest:SetDayTimeVisionRange( 5000 )
	hNearPriest:SetNightTimeVisionRange( 5000 )
	hNearPriest:SetAcquisitionRange( 5000 )
	hNearPriest.bAcqRangeModified = true

	-- Order nearby zealots idle unonwned to start attacking also
	local hZealots = thisEntity.Encounter:GetSpawnedUnitsOfType( "npc_dota_creature_zealot_scarab" )
	for i=1,#hZealots do
		local hZealot = hZealots[i]
		if hZealot:GetOwnerEntity() == nil and hZealot:GetAggroTarget() == nil and ( hNearPriest:GetAbsOrigin() - hZealot:GetAbsOrigin() ):Length2D() < 800 then
			hZealot:SetDayTimeVisionRange( 5000 )
			hZealot:SetNightTimeVisionRange( 5000 )
			hZealot:SetAcquisitionRange( 5000 )
		end
	end
end


function SpikedCarapace()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.SpikedCarapaceAbility:entindex(),
		Queue = false,
	})
	
	return 0.5
end


function SummonZealots( )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.SummonZealotsAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

