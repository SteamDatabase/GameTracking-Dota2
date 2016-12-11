--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\tiny_03\tiny_03_head.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "spine2", 1 },
		{ "spine3", 1 },
		{ "spine1", 0.85 },
		{ "root", 0.76 },
		{ "knee_L", 0.25 },
		{ "knee_R", 0.25 },
		{ "ankle_R", 0 }
	}
)


model:CreateSequence(
	{
		name = "tiny_03_avalanche_alt",
		sequences = {
			{ "@tiny_03_avalanche_alt" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_AVALANCHE", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_03_toss",
		sequences = {
			{ "@tiny_03_toss" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_03_growl",
		sequences = {
			{ "@tiny_03_growl" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_GROWL", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_03_avalanche_alt_tree",
		sequences = {
			{ "@tiny_03_avalanche_alt_tree" }
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
		name = "tiny_03_growl_tree",
		sequences = {
			{ "@tiny_03_growl_tree" }
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
		name = "tiny_03_toss_tree",
		sequences = {
			{ "@tiny_03_toss_tree" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)
