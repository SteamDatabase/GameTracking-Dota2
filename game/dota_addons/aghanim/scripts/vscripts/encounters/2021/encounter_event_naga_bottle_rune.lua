require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_naga_siren_bottle_runes" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_NagaBottleRunes == nil then
	CMapEncounter_Event_NagaBottleRunes = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NagaBottleRunes:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_naga_siren_event", context, -1 )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_naga_siren.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NagaBottleRunes:GetPreviewUnit()
	return "npc_dota_creature_naga_siren_event"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NagaBottleRunes:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_NagaBottleRunes:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_naga", true )
	if hSpawner[ 1 ] then 
		print( "found the spawner" )
		local hEventNPC = CEvent_NPC_Naga_BottleRunes( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_NagaBottleRunes
