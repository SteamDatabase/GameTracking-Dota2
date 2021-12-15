require( "encounters/2021/encounter_event_npc_interaction" )
_G.BREWMASTER_BARTENDER_CLASS = require( "event_npcs/event_npc_brewmaster_bartender" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_BrewmasterBar == nil then
	CMapEncounter_Event_BrewmasterBar = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BrewmasterBar:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_brewmaster_bartender", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_splash.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BrewmasterBar:GetPreviewUnit()
	return "npc_dota_creature_brewmaster_bartender"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BrewmasterBar:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BrewmasterBar:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )
	
	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_bartender", true )
	if hSpawner[ 1 ] then 
		local hEventNPC = CEvent_NPC_BrewmasterBartender( hSpawner[ 1 ]:GetAbsOrigin() )
		if hEventNPC then 
			self:AddInteractionNPC( hEventNPC )
		end
	end
end

-------------------------------------------------------------------------------

function CMapEncounter_Event_BrewmasterBar:OnComplete()
	CMapEncounter_Event_NPCInteraction.OnComplete( self )
end

-------------------------------------------------------------------------------

return CMapEncounter_Event_BrewmasterBar
