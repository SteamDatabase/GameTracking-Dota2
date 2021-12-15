require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_neutral_item_shop" )


--------------------------------------------------------------------------------

if CMapEncounter_Event_AlchemistNeutralItems == nil then
	CMapEncounter_Event_AlchemistNeutralItems = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_AlchemistNeutralItems:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_alchemist_event", context, -1 )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_alchemist.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_AlchemistNeutralItems:GetPreviewUnit()
	return "npc_dota_creature_alchemist_event"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_AlchemistNeutralItems:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_AlchemistNeutralItems:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_alchemist", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_NeutralItemShop( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_AlchemistNeutralItems
