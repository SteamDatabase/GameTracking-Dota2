function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bAcqRangeModified = false

	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityKilled' ), nil )

	thisEntity:SetContextThink( "ShroomGiantThink", ShroomGiantThink, 1 )
end

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.hEntityKilledGameEvent )
end

function ShroomGiantThink()
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

	-- Check all of the other giants, and see if any others are aggroed.
	-- If not, then we'll force aggro on the closest one
	if thisEntity.Encounter == nil then
		print( 'ai_shroom_giant - OnEntityKilled: Encounter is nil!')
		return
	end

	local flNearDist = 60000
	local hGiant = nil
	local hGiants = thisEntity.Encounter:GetSpawnedUnitsOfType( "npc_dota_creature_shroom_giant" )
	for i=1,#hGiants do
		if hGiants[i] ~= thisEntity then

			if hGiants[i].bAcqRangeModified then
				hGiant = nil
				break
			end

			local flDist = ( hGiants[i]:GetAbsOrigin() - hVictim:GetAbsOrigin() ):Length2D()
			if flDist < flNearDist then
				flNearDist = flDist
				hGiant = hGiants[i]
			end

		end
	end

	if hGiant == nil then
		return
	end

	hGiant:SetDayTimeVisionRange( 5000 )
	hGiant:SetNightTimeVisionRange( 5000 )
	hGiant:SetAcquisitionRange( 5000 )
	hGiant.bAcqRangeModified = true

	-- Order nearby shamans idle unonwned to start attacking also
	local hShamans = thisEntity.Encounter:GetSpawnedUnitsOfType( "npc_dota_creature_shadow_shaman" )
	print( 'Shroom Giant Death - Searching for Shadow Shamans... found ' .. #hShamans )
	for i=1,#hShamans do
		local hShaman = hShamans[i]
		if hShaman:GetOwnerEntity() == nil and hShaman:GetAggroTarget() == nil and ( hGiant:GetAbsOrigin() - hShaman:GetAbsOrigin() ):Length2D() < 800 then
			hShaman:SetDayTimeVisionRange( 5000 )
			hShaman:SetNightTimeVisionRange( 5000 )
			hShaman:SetAcquisitionRange( 5000 )
		end
	end
end
