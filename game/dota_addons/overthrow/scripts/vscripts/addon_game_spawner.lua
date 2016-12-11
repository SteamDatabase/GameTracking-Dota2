

local camp_counter = 0 
local vacated_time = 0

-- Think that checks if neutral creeps are close to spawner entities

function OnTriggerThink_Timer()
	camp_counter = 0
	local count = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 1000 )
	for _,entity in pairs(count) do
		if entity:IsNeutralUnitType() or entity:IsCreature() then
			camp_counter = camp_counter + 1
		end
		--print(entity:GetClassname())
	end
	if camp_counter == 0 then
		if vacated_time == 0 then
			vacated_time = Time()
		end
		--print("camp_counter is zero")
	else
		vacated_time = 0
	end
	if vacated_time > 0 and Time() > vacated_time + 60 then
		print("Time to respawn")
		GameRules:GetGameModeEntity().COverthrowGameMode:spawncamp(thisEntity:GetName())
	end
	--print(camp_counter)
	return 3
end

thisEntity:SetThink( "OnTriggerThink_Timer", 3 )

