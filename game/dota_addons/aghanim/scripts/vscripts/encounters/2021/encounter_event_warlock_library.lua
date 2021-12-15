require( "encounters/2021/encounter_event_npc_interaction" )
_G.WARLOCK_TOME_LIBRARY_CLASS = require( "event_npcs/event_npc_warlock_tome_shop" )


--------------------------------------------------------------------------------

if CMapEncounter_Event_WarlockLibrary == nil then
	CMapEncounter_Event_WarlockLibrary = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_WarlockLibrary:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_warlock_librarian", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/hero_warlock/warlock_ambient_smoke.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_warlock/warlock_ambient_staff.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_warlock.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_WarlockLibrary:GetPreviewUnit()
	return "npc_dota_creature_warlock_librarian"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_WarlockLibrary:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_WarlockLibrary:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )
	
	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_warlock", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_WarlockTomeShop( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

-------------------------------------------------------------------------------

function CMapEncounter_Event_WarlockLibrary:OnComplete()
	CMapEncounter_Event_NPCInteraction.OnComplete( self )
end


--------------------------------------------------------------------------------

return CMapEncounter_Event_WarlockLibrary
