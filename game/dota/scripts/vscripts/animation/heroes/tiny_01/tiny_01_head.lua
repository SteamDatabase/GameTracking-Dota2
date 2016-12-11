--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\tiny_01\tiny_01_head.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "thigh_R", 0.25 },
		{ "thigh_L", 0.25 },
		{ "root", 0.76 },
		{ "spine1", 0.86 },
		{ "spine2", 1 },
		{ "knee_R", 0 },
		{ "knee_L", 0 }
	}
)


model:CreateSequence(
	{
		name = "tiny_1_toss",
		sequences = {
			{ "@tiny_1_toss" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_1_avalanche_long",
		sequences = {
			{ "@tiny_1_avalanche_long" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_AVALANCHE", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_1_avalanche_alt_tree",
		sequences = {
			{ "@tiny_1_avalanche_alt_tree" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_AVALANCHE", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_1_toss_tree",
		sequences = {
			{ "@tiny_1_toss_tree" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)
