--[[ Utility Functions ]]


---------------------------------------------------------------------------
-- Broadcast messages to screen
---------------------------------------------------------------------------
function printf(...)
 print(string.format(...))
end

---------------------------------------------------------------------------
-- Broadcast messages to screen
---------------------------------------------------------------------------
function BroadcastMessage( sMessage, fDuration )
	local centerMessage = {
		message = sMessage,
		duration = fDuration
	}
	FireGameEvent( "show_center_message", centerMessage )
end

---------------------------------------------------------------------------
-- GetRandomElement
---------------------------------------------------------------------------
function GetRandomElement( table )
	local nRandomIndex = RandomInt( 1, #table )
    local randomElement = table[ nRandomIndex ]
    return randomElement
end

---------------------------------------------------------------------------
-- ShuffledList
---------------------------------------------------------------------------
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

---------------------------------------------------------------------------
-- string.starts
---------------------------------------------------------------------------
function string.starts( string, start )
   return string.sub( string, 1, string.len( start ) ) == start
end

function string.ends( String, End )
   return End=='' or string.sub(String,-string.len(End))==End
end

---------------------------------------------------------------------------
-- string.split
---------------------------------------------------------------------------
function string.split( str, sep )
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

---------------------------------------------------------------------------
-- shallowcopy
---------------------------------------------------------------------------
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

---------------------------------------------------------------------------
-- Table functions
---------------------------------------------------------------------------
function PrintTable( t, indent )
	--print( "PrintTable( t, indent ): " )

	if type(t) ~= "table" then return end
	
	if indent == nil then
		indent = "   "
	end

	for k,v in pairs( t ) do
		if type( v ) == "table" then
			if ( v ~= t ) then
				print( indent .. tostring( k ) .. ":\n" .. indent .. "{" )
				PrintTable( v, indent .. "  " )
				print( indent .. "}" )
			end
		else
		print( indent .. tostring( k ) .. ":" .. tostring(v) )
		end
	end
end

function table.ToStringShallow(t)
	if t == nil then return "nil" end
	
	local s = "{"
	for k,v in pairs(t) do
		s = string.format(" %s %s=%s, ", s, k, v)
	end
	s = s .. "}"
	return s
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

function TableLength( t )
	local nCount = 0
	for _ in pairs( t ) do
		nCount = nCount + 1
	end
	return nCount
end

function tablefirstkey( t )
	for k, _ in pairs( t ) do
		return k
	end
	return nil
end

function tablehaselements( t )
	return tablefirstkey( t ) ~= nil
end

---------------------------------------------------------------------------

function TableContainsValue( t, value )
	for _, v in pairs( t ) do
		if v == value then
			return true
		end
	end

	return false
end

---------------------------------------------------------------------------

function ConvertToTime( value )
  	local value = tonumber( value )

	if value <= 0 then
		return "00:00:00";
	else
	    hours = string.format( "%02.f", math.floor( value / 3600 ) );
	    mins = string.format( "%02.f", math.floor( value / 60 - ( hours * 60 ) ) );
	    secs = string.format( "%02.f", math.floor( value - hours * 3600 - mins * 60 ) );
	    if math.floor( value / 3600 ) == 0 then
	    	return mins .. ":" .. secs
	    end
	    return hours .. ":" .. mins .. ":" .. secs
	end
end

---------------------------------------------------------------------------
-- AI functions
---------------------------------------------------------------------------

function SetAggroRange( hUnit, fRange )
	--print( string.format( "Set search radius and acquisition range (%.2f) for unit %s", fRange, hUnit:GetUnitName() ) )
	hUnit.fSearchRadius = fRange
	hUnit:SetAcquisitionRange( fRange )
	hUnit.bAcqRangeModified = true
end

--------------------------------------------------------------------------------

