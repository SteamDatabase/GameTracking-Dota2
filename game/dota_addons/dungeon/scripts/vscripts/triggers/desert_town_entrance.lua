
--[[ triggers/desert_town_entrance.lua ]]

-- Only let Bristleback Son NPC open the desert_town entrance

function OnStartTouch( trigger )
	local hActivator = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon

	--print( "desert_town_entrance - OnStartTouch" )
	--print( "activator's name: " .. hActivator:GetUnitName() )

	if hActivator:GetUnitName() == "npc_dota_friendly_bristleback_son" then
		local hRelay = Entities:FindByName( nil, szTriggerName .. "_relay" )
		if hRelay == nil then
			print( "ERROR: No trigger relay found" )
			return
		end
		--print( "Triggering relay named " .. hRelay:GetName() )
		hRelay:Trigger()
		--BroadcastMessage( "#welcome_brigwyr", 3 )
		EmitSoundOn( "Door.Open", hRelay )

		hActivator:AddNewModifier( hActivator, nil, "modifier_followthrough", { duration = 2.0 } )

		thisEntity:Destroy()

		return -1
	end
end

function OnEndTouch( trigger )
	local hActivator = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon
end
