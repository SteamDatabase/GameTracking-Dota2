--[[ Spawners for camp units (the ones placed in rpg_example.vmap) ]]

-- Separate lists of spawners for each camp type
local tSMALL_CAMP_SPAWNERS_ALL = {}
local tMEDIUM_CAMP_SPAWNERS_ALL = {}
local tLARGE_CAMP_SPAWNERS_ALL = {}

AddSpawnerLocToTable( "small_camp*", tSMALL_CAMP_SPAWNERS_ALL )
AddSpawnerLocToTable( "medium_camp*", tMEDIUM_CAMP_SPAWNERS_ALL )
AddSpawnerLocToTable( "large_camp*", tLARGE_CAMP_SPAWNERS_ALL )

-- All camp spawner lists in one table
tCAMP_SPAWNERS_ALL = {}
tCAMP_SPAWNERS_ALL[1] = tSMALL_CAMP_SPAWNERS_ALL
tCAMP_SPAWNERS_ALL[2] = tMEDIUM_CAMP_SPAWNERS_ALL
tCAMP_SPAWNERS_ALL[3] = tLARGE_CAMP_SPAWNERS_ALL

return tCAMP_SPAWNERS_ALL

--------------------------------------------------------------------------------
-- List hierarchy example:
--------------------------------------------------------------------------------
-- tCAMP_SPAWNERS_ALL
--    tSMALL_CAMP_SPAWNERS_ALL
--      "small_camp_01"