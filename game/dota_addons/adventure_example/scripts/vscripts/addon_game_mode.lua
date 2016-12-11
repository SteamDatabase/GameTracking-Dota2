-- Sample adventure script

-- Create the class for the game mode, unused in this example as the functions for the quest are global
if CAddonAdvExGameMode == nil then
	CAddonAdvExGameMode = class({})
end


-- If something was being created via script such as a new npc, it would need to be precached here
function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end


-- Create the game mode class when we activate
function Activate()
	GameRules.AddonAdventure = CAddonAdvExGameMode()
	GameRules.AddonAdventure:InitGameMode()
end

-- Begins processing script for the custom game mode.  This "template_example" contains a main OnThink function.
function CAddonAdvExGameMode:InitGameMode()
	print( "Adventure Example loaded." )
end


-- Quest entity that will contain the quest data so it can be referenced later
local entQuestKillBoss = nil


-- Call this function from Hammer to start the quest.  Checks to see if the entity has been created, if not, create the entity
-- See "adventure_example.vmap" for syntax on accessing functions
function QuestKillBoss()
	if entQuestKillBoss == nil then
		entQuestKillBoss = SpawnEntityFromTableSynchronous( "quest", { name = "KillBoss", title = "#quest_boss_kill" } )
	end
end


-- Call this function to end the quest.  References the previously created quest if it has been created, if not, should do nothing
function QuestKillBossComplete()
	if entQuestKillBoss ~= nil then
		entQuestKillBoss:CompleteQuest()
	end
end