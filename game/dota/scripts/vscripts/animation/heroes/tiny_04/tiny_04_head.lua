--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\tiny_04\tiny_04_head.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "thigh_R", 0.5 },
		{ "knee_R", 0.25 },
		{ "ankle_R", 0 },
		{ "thigh_L", 0.5 },
		{ "knee_L", 0.25 },
		{ "root", 0.76 },
		{ "spine1", 0.86 },
		{ "spine2", 1 },
		{ "spine3", 1 }
	}
)


model:CreateSequence(
	{
		name = "tiny_04_avalanche",
		sequences = {
			{ "@tiny_04_avalanche" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_04_toss",
		sequences = {
			{ "@tiny_04_toss" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_04_grow",
		sequences = {
			{ "@tiny_04_grow" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_GROWL", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_04_toss_tree",
		sequences = {
			{ "@tiny_04_toss_tree" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_04_grow_tree",
		sequences = {
			{ "@tiny_04_grow_tree" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_GROWL", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_04_avalanche_alt_tree",
		sequences = {
			{ "@tiny_04_avalanche_alt_tree" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)
