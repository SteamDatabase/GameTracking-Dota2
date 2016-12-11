--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\tiny_02\tiny_02.mdl
--
--=============================================================================

model:CreateWeightlist(
	"topHalf",
	{
		{ "root", 1 },
		{ "spine3", 1 },
		{ "spine2", 1 },
		{ "spine1", 1 },
		{ "thigh_R", 0.5 },
		{ "knee_R", 0.25 },
		{ "ankle_R", 0 },
		{ "thigh_L", 0.5 },
		{ "knee_L", 0.25 }
	}
)


model:CreateSequence(
	{
		name = "tiny_02_avalanche",
		sequences = {
			{ "@tiny_02_avalanche" }
		},
		weightlist = "topHalf",
		activities = {
			{ name = "ACT_TINY_AVALANCHE", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_02_toss",
		sequences = {
			{ "@tiny_02_toss" }
		},
		weightlist = "topHalf",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_02_growl",
		sequences = {
			{ "@tiny_02_growl" }
		},
		weightlist = "topHalf",
		activities = {
			{ name = "ACT_TINY_GROWL", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_02_growl_tree",
		sequences = {
			{ "@tiny_02_growl_tree" }
		},
		weightlist = "topHalf",
		activities = {
			{ name = "ACT_TINY_GROWL", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_02_avalanche_alt_tree",
		sequences = {
			{ "@tiny_02_avalanche_alt_tree" }
		},
		weightlist = "topHalf",
		activities = {
			{ name = "ACT_TINY_AVALANCHE", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tiny_02_toss_tree",
		sequences = {
			{ "@tiny_02_toss_tree" }
		},
		weightlist = "topHalf",
		activities = {
			{ name = "ACT_TINY_TOSS", weight = 1 },
			{ name = "tree", weight = 1 }
		}
	}
)
