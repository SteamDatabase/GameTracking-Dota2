--[[ RPG checkpoints ]]

function Gate_OnStartTouch( trigger )
	local hHero = trigger.activator
	local sGateTriggerName = thisEntity:GetName()
	print( "Gate_OnStartTouch: " .. sGateTriggerName .. " activated by " .. hHero:GetUnitName() )

	-- Look through the hero's inventory to see if it's holding the right key
	local bHasKey = false
	for i = 0, 5 do
		local hItem = hHero:GetItemInSlot( i )
		if hItem and hItem:GetName() == "item_orb_of_passage" then
			print( "Found desired item named " .. hItem:GetName() .. " on " .. hHero:GetUnitName() )
			bHasKey = true
		end
	end

	if bHasKey then
		local hRelay = Entities:FindByName( nil, sGateTriggerName .. "_relay" )
		hRelay:Trigger()
		print( "Triggered relay named " .. hRelay:GetName() )
		BroadcastMessage( "Orb of Passage used", 3 )
		thisEntity:Destroy()
	end
end

function Checkpoint_OnStartTouch( trigger )
	local hHero = trigger.activator
	local sCheckpointTriggerName = thisEntity:GetName()
	local hBuilding = Entities:FindByName( nil, sCheckpointTriggerName .. "_building" )

	-- If it's already activated, we're done
	if hBuilding:GetTeamNumber() == nGOOD_TEAM then
		return
	end

	hBuilding:SetTeam( nGOOD_TEAM )
	GameRules.rpg_example:RecordActivatedCheckpoint( hHero:GetPlayerID(), sCheckpointTriggerName )

	if sCheckpointTriggerName ~= "checkpoint00" then
		BroadcastMessage( "Activated " .. sCheckpointTriggerName, 3 )
		EmitGlobalSound( "DOTA_Item.Refresher.Activate" ) -- Checkpoint.Activate
	end
end