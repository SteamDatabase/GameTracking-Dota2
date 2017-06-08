
--[[ triggers/ut_activate_bosses.lua ]]

---------------------------------------------------------------------------------

function OnTrigger() -- was passing: trigger
	print( "ut_activate_bosses - OnTrigger" )
	local gamemode = GameRules.Dungeon

	local Zone = gamemode:GetZoneByName( "underground_temple" )
	if Zone ~= nil then
		print( "Wake the Temple Guardians" )
		Zone:WakeBosses()
	end
end

---------------------------------------------------------------------------------


