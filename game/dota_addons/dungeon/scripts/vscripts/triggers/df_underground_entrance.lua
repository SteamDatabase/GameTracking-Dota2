
if thisEntity:GetName() == "df_underground_entrance_trigger01" then
	thisEntity.szOrangeGoblet = "GobletFire_R"
	thisEntity.szGreenGoblet = "GreenGobletFire_R"
	thisEntity.szTriggerpad = "triggerpad_R"
elseif thisEntity:GetName() == "df_underground_entrance_trigger02" then
	thisEntity.szOrangeGoblet = "GobletFire_L"
	thisEntity.szGreenGoblet = "GreenGobletFire_L"
	thisEntity.szTriggerpad = "triggerpad_L"
end

local bHasKey = false

--------------------------------------------------------------------------------

function OnStartTouch( trigger )
	--print( "OnStartTouch" )
	thisEntity.hActivatorHero = trigger.activator
	thisEntity.bActivated = false
	thisEntity:SetContextThink( "UndergroundEntranceThink", UndergroundEntranceThink, 0.2 )
end

--------------------------------------------------------------------------------

function GainActivator()
	local hOrangeGoblet = thisEntity.szOrangeGoblet
	if hOrangeGoblet then
		DoEntFire( hOrangeGoblet, "Stop", "", 0, thisEntity, thisEntity )
		EmitSoundOn( "Torch.Light", thisEntity )
	else
		print( "WARNING: Couldn't find " .. thisEntity.szOrangeGoblet )
	end

	local hGreenGoblet = thisEntity.szGreenGoblet
	if hGreenGoblet then
		DoEntFire( hGreenGoblet, "Start", "", 0, thisEntity, thisEntity )
		EmitSoundOn( "Torch.Light", thisEntity )
	else
		print( "WARNING: Couldn't find " .. thisEntity.szGreenGoblet )
	end

	local hTriggerpad = thisEntity.szTriggerpad
	if hTriggerpad then
		DoEntFire( hTriggerpad, "SetAnimation", "temple_portal001_spinning", 0, thisEntity, thisEntity )
	else
		print( "WARNING: Couldn't find " .. thisEntity.szTriggerpad )
	end

	local gamemode = GameRules.Dungeon
	gamemode.nUndergroundGateActivators = gamemode.nUndergroundGateActivators + 1
	--print( "activators incremented, activators == " .. gamemode.nUndergroundGateActivators )
	
	thisEntity.bActivated = true
end

--------------------------------------------------------------------------------

function OnEndTouch( trigger )
	--print( "OnEndTouch" )
	thisEntity.hActivatorHero = trigger.activator
	if thisEntity.hActivatorHero ~= nil and thisEntity.hActivatorHero:FindItemInInventory( "item_orb_of_passage" ) ~= nil and thisEntity.bActivated == true then
		LoseActivator()
	end
	thisEntity.hActivatorHero = nil
end

function LoseActivator()
	local hOrangeGoblet = thisEntity.szOrangeGoblet
	if hOrangeGoblet then
		DoEntFire( hOrangeGoblet, "Start", "", 0, thisEntity, thisEntity )
	else
		print( "WARNING: Couldn't find " .. thisEntity.szOrangeGoblet )
	end

	local hGreenGoblet = thisEntity.szGreenGoblet
	if hGreenGoblet then
		DoEntFire( hGreenGoblet, "Stop", "", 0, thisEntity, thisEntity )
	else
		print( "WARNING: Couldn't find " .. thisEntity.szGreenGoblet )
	end

	local hTriggerpad = thisEntity.szTriggerpad
	if hTriggerpad then
		DoEntFire( hTriggerpad, "SetAnimation", "temple_portal001_stopped", 0, thisEntity, thisEntity )
	else
		print( "WARNING: Couldn't find " .. thisEntity.szTriggerpad )
	end

	local gamemode = GameRules.Dungeon
	gamemode.nUndergroundGateActivators = gamemode.nUndergroundGateActivators - 1
	if gamemode.nUndergroundGateActivators < 0 then
		gamemode.nUndergroundGateActivators = 0
	end

	thisEntity.bActivated = false
	print( "Decremented activators, activators == " .. gamemode.nUndergroundGateActivators )
end

--------------------------------------------------------------------------------

function UndergroundEntranceThink()
	--print( "Thinking")
	if thisEntity.hActivatorHero ~= nil then
		if thisEntity.hActivatorHero:FindItemInInventory( "item_orb_of_passage" ) == nil and thisEntity.bActivated == true then
			LoseActivator()
		end
		if thisEntity.hActivatorHero:FindItemInInventory( "item_orb_of_passage" ) ~= nil and thisEntity.bActivated == false then
			GainActivator()
		end
	else
		return -1
	end

	local gamemode = GameRules.Dungeon
	if gamemode.nUndergroundGateActivators >= 2 then
		ActivateStuff()

		return -1
	end

	return 0.2
end

--------------------------------------------------------------------------------

function ActivateStuff()
	local hRelay = Entities:FindByName( nil, "df_underground_entrance_relay" )
	if hRelay == nil then
		print( "ERROR: No trigger relay found" )
		return
	end
	--print( "Triggering relay named " .. hRelay:GetName() )
	hRelay:Trigger()

	--BroadcastMessage( "#consumed_orbs_of_passage", 3 )

	local hTriggerpad = thisEntity.szTriggerpad
	if hTriggerpad then
		DoEntFire( hTriggerpad, "SetAnimation", "temple_portal001_stopped", 0, thisEntity, thisEntity )
	else
		print( "WARNING: Couldn't find " .. thisEntity.szTriggerpad )
	end

	local OrbOfPassage = thisEntity.hActivatorHero:FindItemInInventory( "item_orb_of_passage" )
	if OrbOfPassage then
		thisEntity.hActivatorHero:RemoveItem( OrbOfPassage )
	end

	EmitSoundOn( "Door.Open", thisEntity )
	thisEntity:Destroy()
end

--------------------------------------------------------------------------------

