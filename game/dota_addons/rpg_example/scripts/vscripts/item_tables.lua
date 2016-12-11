--[[ Item tables ]]

--------------------------------------------------------------------------------
-- Camp lists for each roamer group type
--------------------------------------------------------------------------------

local tTIER_01_ITEMS_ALL = {
	"item_teleport", "item_flask", "item_enchanted_mango", "item_arboreal_refreshment"
}

local tTIER_02_ITEMS_ALL = {
	"item_broadsword_tier1", "item_broadsword_tier2", "item_ring_of_health", "item_saprophytic_blade", "item_ritual_dirk"
}

local tTIER_03_ITEMS_ALL = {
	"item_invis_sword", "item_phase_boots", "item_broadsword_tier3", "item_bfury", "item_staff_of_the_ruminant"
}

local tKEY_GATE01 = {
	"item_orb_of_passage"
}

--------------------------------------------------------------------------------
-- All roamer lists
--------------------------------------------------------------------------------
local tITEMS_ALL = {
	worlditems_tier01 = tTIER_01_ITEMS_ALL,
	worlditems_tier02 = tTIER_02_ITEMS_ALL,
	worlditems_tier03 = tTIER_03_ITEMS_ALL,
	worlditems_gate01_key = tKEY_GATE01
}

return tITEMS_ALL