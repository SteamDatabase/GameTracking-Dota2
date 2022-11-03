--[[ Utility Functions ]]

---------------------------------------------------------------------------
-- Bitwise and
--------------------------------------------------------------------------
function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
          result = result + bitval      -- set the current bit
      end
      bitval = bitval * 2 -- shift left
      a = math.floor(a/2) -- shift right
      b = math.floor(b/2)
    end
    return result
end

---------------------------------------------------------------------------
-- Creates a new function with its first N arguments fixed to the N arguments provided to bind
---------------------------------------------------------------------------
function Bind(fn, ...)
	local args={...}
	return function(...) return fn(unpack(args), ...) end
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
function RemapValClampedPower( num, a, b, c, d, flPow )
	if a == b then
		return c
	end

	local t = ( num - a ) / ( b - a )
	if flPow ~= 1.0 then
		t = math.pow( t, flPow )
	end
	return LerpClamp( t, c, d )
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
-- GetRandomElement
---------------------------------------------------------------------------
function GetRandomElement( table )
	local nRandomIndex = RandomInt( 1, #table )
    local randomElement = table[ nRandomIndex ]
    return randomElement
end

---------------------------------------------------------------------------
-- GetRandomElements
---------------------------------------------------------------------------
function GetRandomElements( table, nCount )
	local shuffledCopy = ShuffledList( table )
	for i=#table,nCount + 1 do
		table.remove( shuffledCopy, i )
	end
	return shuffledCopy
end

---------------------------------------------------------------------------
-- ShuffledList
---------------------------------------------------------------------------
function ShuffledList( orig_list )
	local list = shallowcopy( orig_list )
	ShuffleListInPlace( list )
	return list
end

---------------------------------------------------------------------------
-- ShuffleListInPlace
---------------------------------------------------------------------------
function ShuffleListInPlace( list, hRandomStream )
	local count = #list
	for i = 1, count - 1 do
		local j
		if hRandomStream == nil then
			j = RandomInt( i, count )
		else
			j = hRandomStream:RandomInt( i, count )
		end
		list[i] , list[j] = list[j] , list[i]
	end
end

---------------------------------------------------------------------------
-- string.ends
---------------------------------------------------------------------------

function string.ends( String, End )
   return End=='' or string.sub(String,-string.len(End))==End
end

---------------------------------------------------------------------------
-- string.lpad
---------------------------------------------------------------------------
function string.lpad( str, len, char )
   return string.rep( char or " ", len - #str ) .. str
end

---------------------------------------------------------------------------
-- string.starts
---------------------------------------------------------------------------
function string.starts( string, start )
   return string.sub( string, 1, string.len( start ) ) == start
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

function TableFind( table, fnCondition ) -- fnCondition is (key, value) -> boolean
	if table == nil then
		return nil, nil
	end

	for k, v in pairs( table ) do
		if fnCondition( k, v ) then
			return k, v
		end
	end
	return nil, nil
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

function TableCount( rgArray, fnCondition )
	local nCount = 0
	for _,v in ipairs( rgArray ) do
		if fnCondition( v ) then
			nCount = nCount + 1
		end
	end
	return nCount
end

function TableFilter( rgArray, fnCondition )
	local rgFiltered = {}
	for _,v in ipairs( rgArray ) do
		if fnCondition( v ) then
			table.insert( rgFiltered, v )
		end
	end
	return rgFiltered
end

function TableFindFirst( rgArray, fnCondition )
	for _,v in ipairs( rgArray ) do
		if fnCondition( v ) then
			return v
		end
	end
	return nil
end

function TableMap( t, fnMap )
	local mapped = {}
	for k,v in pairs( t ) do
		mapped[k] = fnMap( k, v )
	end
	return mapped
end

function TableMinBy( rgArray, fnSelector )
	local min
	local minIndex
	local minValue

	for i,v in ipairs(rgArray) do
		local value = fnSelector(v)
		if minValue == nil or value < minValue then
			min = v
			minIndex = i
			minValue = value
		end
	end

	return min, minIndex, minValue
end

function TableSortBy( rgArray, fnSelector )
	table.sort( rgArray, function( a, b ) return fnSelector( a ) < fnSelector( b ) end )
end

function TableMaxValue( tTable )
	local maxValue
	for _,v in pairs(tTable) do
		if maxValue == nil or v > maxValue then
			maxValue = v
		end
	end
	return maxValue
end

function TableKeys( tTable )
	local rgKeys = {}
	for k in pairs(tTable) do
		table.insert( rgKeys, k )
	end
	return rgKeys
end

function TableValues( tTable )
	local rgValues = {}
	for _,v in pairs(tTable) do
		table.insert( rgValues, v )
	end
	return rgValues
end

function TableUnique( rgArray ) -- returns an array with only unique values
	local rgUnique = {}
	local rgSeen = {}
	for _,v in ipairs( rgArray ) do
		if not rgSeen[v] then
			rgSeen[v] = true
			table.insert( rgUnique, v )
		end
	end
	return rgUnique
end

function TableConcatenated( rgArrays )
	local rgConcatenated = {}
	for _,arg in ipairs( rgArrays ) do
		for _,v in ipairs( arg ) do
			table.insert( rgConcatenated, v )
		end
	end
	return rgConcatenated
end

function TableSlice( rgArray, first, last )
	if first < 1 then first = 1 end
	if last > #rgArray then last = #rgArray end

	local rgSlice = {}
	for i = first, last do
		table.insert( rgSlice, rgArray[i] )
	end

	return rgSlice
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

---------------------------------------------------------------------------

function PrintGrid( tRows )
	local columnWidths = {}
	for r,row in ipairs( tRows ) do
		for c,cell in ipairs( row ) do
			columnWidths[c] = math.max(#cell, columnWidths[c] or 0)
		end
	end

	for _,row in ipairs( tRows ) do
		print( table.concat(TableMap( row, function( c, cell )
			return string.lpad( cell, columnWidths[c] )
		end), " ") )
	end
end

---------------------------------------------------------------------------

function ConvertToTime( value )
  	local value = tonumber( value )

	if value <= 0 then
		return "00:00";
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

function Dist2D( vA, vB )
	return (vA - vB):Length2D()
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

function GetRandomPathablePositionWithin( vPos, nRadius, nMinRadius, vExcludeCenter, flInnerRadius, flOuterRadius )
	if IsServer() then
		-- Try to find a good position, be willing to fail and return a nil value
		local nMaxAttempts = 10
		if vExcludeCenter ~= nil then
			nMaxAttempts = 20
		end
		local nAttempts = 0
		local vTryPos = nil

		if nMinRadius == nil then
			nMinRadius = nRadius
		end

		repeat
			vTryPos = vPos + RandomVector( RandomFloat( nMinRadius, nRadius ) )
			--DebugDrawSphere( vTryPos, Vector(0,255,255), 0.8, 50, false, 1.0 )

			nAttempts = nAttempts + 1
			if nAttempts >= nMaxAttempts then
				return nil
			end
		until ( ( vExcludeCenter == nil or IsPositionValidInRing( vTryPos, vExcludeCenter, flInnerRadius, flOuterRadius ) ) and GridNav:CanFindPath( vPos, vTryPos ) )

		return vTryPos
	end
end

--------------------------------------------------------------------------------

function DoPlayersExistOnTeam( nTeam )
	local bAnyExistOnTeam = false
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == nTeam then
			local hTeammateHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hTeammateHero ~= nil and not hTeammateHero:IsNull() then
				bAnyExistOnTeam = true
				break
			end
		end
	end

	return bAnyExistOnTeam
end

--------------------------------------------------------------------------------

function FlipTeamNumber( nTeam )
	if nTeam == DOTA_TEAM_GOODGUYS then return DOTA_TEAM_BADGUYS end
	if nTeam == DOTA_TEAM_BADGUYS then return DOTA_TEAM_GOODGUYS end
	return nTeam
end

--------------------------------------------------------------------------------

function PlayerIter()
	local nNextPlayerID = 0
	return function()
		local hPlayer
		while nNextPlayerID < DOTA_MAX_PLAYERS and hPlayer == nil do
			hPlayer = PlayerResource:GetPlayer( nNextPlayerID )
			nNextPlayerID = nNextPlayerID + 1
		end
		return hPlayer
	end
end

--------------------------------------------------------------------------------

function IsPositionValid( vPos, tCheckPositions, flExcludeRadius )
	for _,vCheck in pairs( tCheckPositions ) do
		if (vPos - vCheck):Length2D() < flExcludeRadius then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------

function IsPositionValidInRing( vPos, vRingCenter, flInnerRadius, flOuterRadius )
	local flRadius = (vPos - vRingCenter):Length2D()
	--printf( "^^^IsPositionValidInRing() - Distance = %f, flInnerRadius = %f, flOuterRadius = %f", flRadius, flInnerRadius, flOuterRadius )
	if flRadius < flInnerRadius or flRadius > flOuterRadius then
		return false
	end
	return true
end

--------------------------------------------------------------------------------

function IsCandyBuilding( hUnit )
	if hUnit ~= nil and hUnit:IsNull() == false and hUnit:FindAbilityByName( "building_candy_bucket" ) ~= nil then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function CandyCount( hTarget, bRealHeroOnly )
	if hTarget == nil or hTarget:IsNull() == true then
		return 0
	end

	if hTarget:IsHero() then
		if bRealHeroOnly and hTarget:IsRealHero() == false then
			return 0
		end
		return hTarget:GetModifierStackCount( "modifier_hero_candy_bucket", nil )
	end

	return hTarget:GetModifierStackCount( "modifier_building_candy_bucket", nil )
end

--------------------------------------------------------------------------------

function BuildingCandyCount( hTarget )
	return hTarget:GetModifierStackCount( "modifier_building_candy_bucket", nil )
end

--------------------------------------------------------------------------------

function FullOfCandy( hBuilding )
	hAbility = hBuilding:FindAbilityByName( "building_candy_bucket" )
	if hAbility ~= nil and hAbility:IsNull() == false and hAbility:GetCandyLimit() == hAbility:GetCandy() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function AbsoluteCandyCount( hTarget, bRealHeroOnly )
	local nCandy = CandyCount( hTarget, bRealHeroOnly )
	local hAbility = hTarget:FindAbilityByName( "building_candy_bucket" )
	if hAbility ~= nil and hAbility:IsNull() == false then
		nCandy = nCandy + hAbility:GetCandyLimitRaw() - hAbility:GetCandyLimit()
	end
end

--------------------------------------------------------------------------------

function IsGreevil( hUnit, bIncludeLeader )
	if bIncludeLeader == nil then bIncludeLeader = true end
	return ( bIncludeLeader and hUnit:GetUnitName() == "npc_dota_greevil_leader" ) or hUnit:GetUnitName() == "npc_dota_greevil"
end

--------------------------------------------------------------------------------

function AddCandyToHero( hHero, nNumCandy )
	if hHero == nil or not ( nNumCandy > 0 ) then
		return false
	end

	local hHeroBucket = hHero:FindAbilityByName( "hero_candy_bucket" )
	if hHeroBucket == nil then
		return false
	end

	local hAnnouncer = GameRules.Winter2022:GetTeamAnnouncer( hHero:GetTeamNumber() )
	if hAnnouncer ~= nil then
		hAnnouncer:OnCandyPickup( hHero:GetPlayerID() )
	end

	EmitSoundOn( "Candy.Pickup", hHero )

	--printf( "item_candy:OnSpellStart - candy being picked up; found hero's candy bucket, adding %d candy to it", nNumCandy )
	hHeroBucket:SetCandy( hHeroBucket:GetCandy() + nNumCandy )

	local nPlayerID = hHero:GetPlayerOwnerID()
	--print( '{STATS} candy_picked_up - Adding ' .. nNumCandy .. ' to PlayerID ' .. nPlayerID )
	GameRules.Winter2022:ModifyCandyStat("candy_picked_up", nPlayerID, nNumCandy)

	return true
end

--------------------------------------------------------------------------------

function UpdateNetTableValueProperty( tableName, keyName, propertyName, propertyValue )
	local value = CustomNetTables:GetTableValue( tableName, keyName )
	if value == nil then
		value = {}
	end
	value[ propertyName ] = propertyValue
	CustomNetTables:SetTableValue( tableName, keyName, value )
end

--------------------------------------------------------------------------------

function IsConsideredHeroDamageSource( hEntity )
	return hEntity:IsOwnedByAnyPlayer() or hEntity:IsConsideredHero() or hEntity:IsBoss() or hEntity:IsZombie() or hEntity:GetUnitName() == "dota_fountain"
end