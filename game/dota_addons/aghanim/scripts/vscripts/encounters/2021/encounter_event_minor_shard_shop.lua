require( "encounters/2021/encounter_event_npc_interaction" )


--------------------------------------------------------------------------------

if CMapEncounter_Event_MinorShardShop == nil then
	CMapEncounter_Event_MinorShardShop = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MinorShardShop:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_shard_shop_oracle", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MinorShardShop:GetPreviewUnit()
	return "npc_dota_creature_shard_shop_oracle"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MinorShardShop:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_MinorShardShop:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )
	
	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_oracle", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_MinorShardShop( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

-------------------------------------------------------------------------------

function CMapEncounter_Event_MinorShardShop:OnComplete()
	CMapEncounter_Event_NPCInteraction.OnComplete( self )
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_MinorShardShop
