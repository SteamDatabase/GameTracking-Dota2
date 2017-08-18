
local fThinkInterval = 0.5
local fTimeThreshold = 30
local nActivators = 0
local fTotalTriggeredTime = 0

---------------------------------------------------------------------------------

function OnStartTouch( trigger )
	if IsServer() then
		thisEntity.hActivatorHero = trigger.activator
		nActivators = nActivators + 1
		--print( string.format( "%s - Incremented activators, activators == %d", thisEntity:GetName(), nActivators ) )

		thisEntity.fLastTimeTouched = GameRules:GetGameTime()
		thisEntity.szThink = thisEntity:GetName() .. "_Think" -- trigger should be uniquely named so its think doesn't collide with others?
		thisEntity.szPlatform = thisEntity:GetName() .. "_platform"

		if nActivators == 1 then

			thisEntity.hPlatform = Entities:FindByNameNearest( thisEntity.szPlatform, thisEntity:GetOrigin(), 500 )
			if thisEntity.hPlatform then
				DoEntFire( thisEntity.szPlatform, "SetAnimation", "ancient_trigger001_down", 0, thisEntity, thisEntity )
				--DoEntFire( thisEntity.szPlatform, "SetDefaultAnimation", "ancient_trigger001_down_idle", 0.2, thisEntity, thisEntity )
				thisEntity.hPlatform:SetSkin( 2 )
			end
			EmitSoundOn( "Door.Triggering.loop", thisEntity )

			thisEntity:SetContextThink( thisEntity.szThink, CryptHoldoutThink, fThinkInterval )
		end
	end
end

---------------------------------------------------------------------------------

function OnEndTouch( trigger )
	if IsServer() then
		thisEntity.hActivatorHero = trigger.activator
		nActivators = nActivators - 1
		--print( string.format( "%s - Decremented activators, activators == %d", thisEntity:GetName(), nActivators ) )

		if nActivators <= 0 then
			nActivators = 0 -- not clear whether this is necessary
			thisEntity:SetContextThink( thisEntity.szThink, CryptHoldoutThink, -1 )

			if thisEntity.hPlatform then
				DoEntFire( thisEntity.szPlatform, "SetAnimation", "ancient_trigger001_idle", 0, thisEntity, thisEntity )
				thisEntity.hPlatform:SetSkin( 3 )
			end
			StopSoundOn( "Door.Triggering.loop", thisEntity )
		end
	end
end

---------------------------------------------------------------------------------

function CryptHoldoutThink()
	if not IsServer() then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if nActivators >= 1 then
		fTotalTriggeredTime = fTotalTriggeredTime + fThinkInterval
		
		--print( string.format( "%s - Added %.2f seconds, total triggered time is now: %.2f", thisEntity:GetName(), fThinkInterval, fTotalTriggeredTime ) )
	end

	local data = {}
	data["PercentComplete"] = fTotalTriggeredTime / fTimeThreshold
	data["X"] = thisEntity:GetOrigin().x
	data["Y"] = thisEntity:GetOrigin().y
	data["Z"] = thisEntity:GetOrigin().z
	CustomNetTables:SetTableValue( "crypt_holdout", thisEntity:GetName(), data )

	if fTotalTriggeredTime >= fTimeThreshold then
		TriggerOurRelay()
		StopSoundOn( "Door.Triggering.loop", thisEntity )
		EmitSoundOn( "Door.Triggered.Complete", thisEntity )

		local data = {}
		data["PercentComplete"] = 1.0
		data["X"] = thisEntity:GetOrigin().x
		data["Y"] = thisEntity:GetOrigin().y
		data["Z"] = thisEntity:GetOrigin().z
		CustomNetTables:SetTableValue( "crypt_holdout", thisEntity:GetName(), data )
		return -1
	end

	return fThinkInterval
end

---------------------------------------------------------------------------------

function TriggerOurRelay()
	local szRelayName = thisEntity:GetName() .. "_relay"
	local hRelay = Entities:FindByName( nil, szRelayName )
	if hRelay then
		print( string.format( "%s - hRelay found named %s, triggering it", thisEntity:GetName(), szRelayName ) )
		GameRules.Dungeon:OnCustomZoneEvent( "crypt_holdout", "door_switch_completed" )
		hRelay:Trigger()
	else
		print( string.format( "%s - TriggerOurRelay - ERROR: No relay found named %s", thisEntity:GetName(), szRelayName ) )
		return
	end
end

---------------------------------------------------------------------------------

