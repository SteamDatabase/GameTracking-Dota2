item_tables = require( "item_tables" )

--------------------------------------------------------------------------------
-- PrecacheItemSpawners
--------------------------------------------------------------------------------
function CRPGExample:PrecacheItemSpawners( context )
	for _, tItemTier in pairs( item_tables ) do
		for _, sItemName in pairs( tItemTier ) do
			PrecacheItemByNameSync( sItemName, context )
		end
	end
end

--------------------------------------------------------------------------------
-- SetupItemSpawners
--------------------------------------------------------------------------------
function CRPGExample:SetupItemSpawners()
	self.tITEM_SPAWNERS_ALL = {}
	for name, itemTable in pairs( item_tables ) do
		table.insert( self.tITEM_SPAWNERS_ALL, { spawners = Entities:FindAllByName( name.."*" ), itemTable = itemTable } )
	end
end

--------------------------------------------------------------------------------
-- SpawnItems
--------------------------------------------------------------------------------
function CRPGExample:SpawnItems()
	for _, spawnerInfo in pairs( self.tITEM_SPAWNERS_ALL ) do
		local itemTable = spawnerInfo.itemTable
		for _, hSpawner in pairs( spawnerInfo.spawners ) do
			local sItemName = GetRandomElement( itemTable )
			self:SpawnItem( sItemName, hSpawner )
		end
	end
end

--------------------------------------------------------------------------------
-- SpawnItem
--------------------------------------------------------------------------------
function CRPGExample:SpawnItem( sItemName, hSpawner )
	local vSpawnLoc = nil
	while vSpawnLoc == nil do
		vSpawnLoc = hSpawner:GetOrigin() + RandomVector( RandomFloat( 0, 64 ) )
	    if ( GridNav:CanFindPath( hSpawner:GetOrigin(), vSpawnLoc ) == false ) then
	        print( "Choosing new item spawnloc.  Bad spawnloc was: " .. tostring( vSpawnLoc ) )
	        vSpawnLoc = nil
	    end
	end
	
	self:CreateWorldItemOnPosition( sItemName, vSpawnLoc )
end
