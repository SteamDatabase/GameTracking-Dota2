--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\alchemist\alchemist.mdl
--
--=============================================================================

model:CreateWeightlist(
	"goblin",
	{
		{ "spine1_1", 1 }
	}
)

model:CreateWeightlist(
	"putback",
	{
		{ "spine1_1", 0 },
		{ "spine1", 0 },
		{ "ogre_bottle0_0_L", 0 },
		{ "bottle_leftside13_0", 0 },
		{ "ogre_bottle3_0", 0 },
		{ "clavicle_L", 1 },
		{ "clavicle_R", 1 },
		{ "sheath5_0", 1 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "TURN", -1, 1, 0, false ),
		sequences = {
			{ "@turns_lookFrame_0", "@turns_lookFrame_1", "@turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_2_gesture",
		sequences = {
			{ "@ability_2_gesture" }
		},
		weightlist = "goblin",
		activities = {
			{ name = "ACT_DOTA_ALCHEMIST_CONCOCTION", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_4_putback",
		sequences = {
			{ "@ability_4_putback" }
		},
		weightlist = "putback",
		activities = {
			{ name = "ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_alt",
		sequences = {
			{ "@run_alt" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_haste",
		sequences = {
			{ "@run_haste" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "injured_run_anim",
		sequences = {
			{ "@injured_run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_alt2",
		sequences = {
			{ "@run_alt2" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_4_run_anim",
		sequences = {
			{ "@ability_4_run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "chemical_rage", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability4_high_run_anim",
		sequences = {
			{ "@ability4_high_run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "chemical_rage", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)
