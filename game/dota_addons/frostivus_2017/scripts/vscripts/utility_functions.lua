--[[ utility_functions.lua ]]

---------------------------------------------------------------------------
-- Handle messages
---------------------------------------------------------------------------
function BroadcastMessage( sMessage, fDuration )
    local centerMessage = {
        message = sMessage,
        duration = fDuration
    }
    FireGameEvent( "show_center_message", centerMessage )
end

function PickRandomShuffle( reference_list, bucket )
    if ( TableCount(reference_list) == 0 ) then
        return nil
    end
    if ( #bucket == 0 ) then
        -- ran out of options, refill the bucket from the reference
        local i = 1
        for k, v in pairs(reference_list) do
            bucket[i] = v
            i = i + 1
        end
    end
    -- pick a value from the bucket and remove it
    local pick_index = RandomInt( 1, #bucket )
    local result = bucket[ pick_index ]
    table.remove( bucket, pick_index )
    return result
end

function GetRandomTableElement( myTable )
    -- iterate over whole table to get all keys
    local keyset = {}
    for k in pairs(myTable) do
        table.insert(keyset, k)
    end
    -- now you can reliably return a random key
    return myTable[keyset[RandomInt(1, #keyset)]]
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function ShuffledList( orig_list )
	local list = shallowcopy( orig_list )
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt( 1, #list )
		result[ #result + 1 ] = list[ pick ]
		table.remove( list, pick )
	end
	return result
end

function TableCount( t )
	local n = 0
	for _ in pairs( t ) do
		n = n + 1
	end
	return n
end

function TableFindKey( table, val )
	if table == nil then
		print( "nil" )
		return nil
	end

	for k, v in pairs( table ) do
		if v == val then
			return k
		end
	end
	return nil
end

function ConvertTimeToTable(t)
    local minutes = math.floor(t / 60)
    local seconds = t - (minutes * 60)
    local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
    local s01 = seconds - (s10 * 10)
    local broadcast_gametimer = 
        {
            timer_minute_10 = m10,
            timer_minute_01 = m01,
            timer_second_10 = s10,
            timer_second_01 = s01,
        }
    return broadcast_gametimer
end

function GetCurrentTime()
    return ConvertTimeToTable(math.max(nCOUNTDOWNTIMER, 0))
end

function CountdownTimer()
    nCOUNTDOWNTIMER = nCOUNTDOWNTIMER - 1
    broadcast_gametimer = GetCurrentTime()
    CustomGameEventManager:Send_ServerToAllClients( "countdown", broadcast_gametimer )
    -- if nCOUNTDOWNTIMER <= 120 then
    --     CustomGameEventManager:Send_ServerToAllClients( "time_remaining", broadcast_gametimer )
    -- end
end

function SetTimer( time )
    print( "Set the timer to: " .. time )
    nCOUNTDOWNTIMER = time
end
