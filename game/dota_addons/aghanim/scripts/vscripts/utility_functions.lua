--[[ Utility Functions ]]

---------------------------------------------------------------------------
-- Bitwise and
--------------------------------------------------------------------------
function bitand(a, b)
    local result = 0
    local bitval = 1

    -- Hack to try to fix an error about comparing userdata to a number
    local a_int = tonumber( tostring( a ) )
    local b_int = tonumber( tostring( b ) )

    while a_int > 0 and b_int > 0 do
      if a_int % 2 == 1 and b_int % 2 == 1 then -- test the rightmost bits
          result = result + bitval      -- set the current bit
      end
      bitval = bitval * 2 -- shift left
      a_int = math.floor(a_int/2) -- shift right
      b_int = math.floor(b_int/2)
    end

    return result
end

---------------------------------------------------------------------------
function Lerp(t, a, b) 
	return a + t * (b - a)
end

---------------------------------------------------------------------------
function LerpClamp(t, a, b) 
	if t < 0 then
		t = 0
	elseif t > 1 then
		t = 1
	end
	return Lerp( t, a, b )
end

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
-- Pretty-format a number value (to integer if integer, to places with
--   trailing zeroes stripped if float)
---------------------------------------------------------------------------
function FormatValue( szValue, nPlaces, bStripZeroes )
	if nPlaces == nil then
		nPlaces = 2
	end
	if bStripZeroes == nil then
		bStripZeroes = true
	end
	local flValue = tonumber( szValue )
	local nValue = math.floor( flValue )
	if nValue == flValue then
		return string.format( "%d", nValue )
	end
	local szOutput = string.format( "%.2f", flValue )
	while string.sub( szOutput, -1, -1) == '0' do
		szOutput = string.sub(szOutput, 1, -2)
	end
	return szOutput
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
-- ShuffleListInPlace
---------------------------------------------------------------------------
function ShuffleListInPlace( list, hRandomStream )
	local count = #list
	for i = 1, count do
		local j = 0
		if hRandomStream == nil then
			j = RandomInt( 1, #list )
		else
			j = hRandomStream:RandomInt( 1, #list )
		end
		list[i] , list[j] = list[j] , list[i]
	end
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
-- deepcopy
---------------------------------------------------------------------------
function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
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

function TableFindFirst( rgArray, fnCondition )
	for _,v in ipairs( rgArray ) do
		if fnCondition( v ) then
			return v
		end
	end
	return nil
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

function TableContainsSubstring( t, substr )
	for _, v in pairs( t ) do
		if v and string.match(v,substr) then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

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

function SimpleSpline( value )
	local valueSquared = value * value;
	return ( 3 * valueSquared ) - ( 2 * valueSquared * value )
end

---------------------------------------------------------------------------

function IsGlobalAscensionCaster( hUnit )
	if hUnit == nil then
		return false
	end
	return hUnit:GetName() == "ascension_global_caster"
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

function GetRandomPathablePositionWithin( vPos, nRadius, nMinRadius )
	if IsServer() then
		-- Try to find a good position, be willing to fail and return a nil value
		local nMaxAttempts = 10
		local nAttempts = 0
		local vTryPos = nil

		if nMinRadius == nil then
			nMinRadius = nRadius
		end

		repeat
			vTryPos = vPos + RandomVector( RandomFloat( nMinRadius, nRadius ) )

			nAttempts = nAttempts + 1
			if nAttempts >= nMaxAttempts then
				break
			end
		until ( GridNav:CanFindPath( vPos, vTryPos ) )

		return vTryPos
	end
end

--------------------------------------------------------------------------------

function GetDOTAItemCost( szItemName ) 
	local ItemKV = GetAbilityKeyValuesByName( szItemName )
	if ItemKV == nil then
		print ( "ItemKV kv is nil" )
		return 0
	end

	return tonumber( ItemKV[ "ItemCost" ] )
end

--------------------------------------------------------------------------------

function RandomizeAbilityCooldown( hAbility )
	if hAbility then
		local fCooldown = hAbility:GetCooldown( -1 )
		hAbility:StartCooldown( RandomFloat( 0, fCooldown ) )
	end
end

--------------------------------------------------------------------------------

function Util_FindEnemiesAroundUnit( hUnit, fRadius, bIgnoreInvis )
	local enemies = FindUnitsInRadius(
		hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, fRadius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		( bIgnoreInvis and DOTA_UNIT_TARGET_FLAG_NO_INVIS ) or DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false
	)

	return enemies
end

--------------------------------------------------------------------------------

function Util_FindEnemiesAroundUnit_Farthest( hUnit, fRadius, bIgnoreInvis )
	local enemies = FindUnitsInRadius(
		hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, fRadius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		( bIgnoreInvis and DOTA_UNIT_TARGET_FLAG_NO_INVIS ) or DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false
	)

	return enemies
end

--------------------------------------------------------------------------------
