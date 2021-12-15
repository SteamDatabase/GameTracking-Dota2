require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "event_npcs/event_npc_minor_shard_shop" )

--------------------------------------------------------------------------------

if CMapEncounter_TransitionGateway == nil then
	CMapEncounter_TransitionGateway = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TransitionGateway:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_TransitionGateway:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	
	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_oracle", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_MinorShardShop( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC and hEventNPC:GetEntity() then 
			local vAngles = hSpawner[ 1 ]:GetAnglesAsVector()
			hEventNPC:GetEntity():SetAbsAngles( vAngles.x, vAngles.y, vAngles.z )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TransitionGateway:GetPreviewUnit()
	return "npc_dota_shop_keeper_lost_meepo"
end

--------------------------------------------------------------------------------

function CMapEncounter_TransitionGateway:CheckForCompletion()

	local connectedPlayers = GameRules.Aghanim:GetConnectedPlayers()
	for i=1,#connectedPlayers do
		local nPlayerID = connectedPlayers[i]
		print( )
		if GameRules.Aghanim:GetPlayerCurrentRoom( nPlayerID ) ~= self:GetRoom() then
			return false
		end
	end

	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_TransitionGateway
