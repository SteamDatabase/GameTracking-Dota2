
require( "encounters/2021/encounter_event_npc_interaction" )
require( "event_npcs/event_npc_ogre_magi_casino" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_OgreMagiCasino == nil then
	CMapEncounter_Event_OgreMagiCasino = class( {}, {}, CMapEncounter_Event_NPCInteraction )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_OgreMagiCasino:Precache( context )
	CMapEncounter_Event_NPCInteraction.Precache( self, context )

	PrecacheUnitByNameSync( self:GetPreviewUnit(), context, -1 )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_weapon.vpcf" , context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_OgreMagiCasino:GetPreviewUnit()
	return "npc_dota_creature_event_ogre_magi"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_OgreMagiCasino:constructor( hRoom, szEncounterName )
	CMapEncounter_Event_NPCInteraction.constructor( self, hRoom, szEncounterName )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_OgreMagiCasino:OnEncounterLoaded()
	CMapEncounter_Event_NPCInteraction.OnEncounterLoaded( self )

	local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_ogre_magi", true )
	if hSpawner[ 1 ] then 
		--printf( "found the spawner" )
		local hOgreEventNPC = CEvent_NPC_OgreMagiCasino( hSpawner[ 1 ]:GetAbsOrigin() )
		if hOgreEventNPC then 
			self:AddInteractionNPC( hOgreEventNPC )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_OgreMagiCasino
