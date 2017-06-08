
--[[ df_death_maze_gate.lua ]]

-- if there's a player with a key in the trigger, then it triggers the logic relay

local bHasKey = false

function OnStartTouch( trigger )
	local hHero = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon

	-- Look through the hero's inventory to see if it's holding the correct key
	for i = 0, DOTA_ITEM_INVENTORY_SIZE do
		local hItem = hHero:GetItemInSlot( i )
		if hItem and hItem:GetName() == "item_orb_of_passage" then
			bHasKey = true
		end
	end

	if bHasKey then
		local hRelay = Entities:FindByName( nil, szTriggerName .. "_relay" )
		if hRelay == nil then
			print( "ERROR: No trigger relay found" )
			return
		end
		print( "Triggering relay named " .. hRelay:GetName() )
		hRelay:Trigger()
		EmitSoundOn( "Door.Open", hRelay )
		--BroadcastMessage( "Opened With Orb of Passage", 3 )
		thisEntity:Destroy()

		return -1
	end
end

function OnEndTouch( trigger )
	local hHero = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon
end


