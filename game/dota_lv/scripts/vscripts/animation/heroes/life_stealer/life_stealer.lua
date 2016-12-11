--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\life_stealer\life_stealer.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "Root_0", 1 },
		{ "Spine_0", 1 },
		{ "thigh_R", 0.25 },
		{ "thigh_L", 0.25 },
		{ "knee_L", 0 },
		{ "ankle_L", 0 },
		{ "knee_R", 0 },
		{ "ankle_R", 0 }
	}
)

model:CreateWeightlist(
	"torso_only",
	{
		{ "thigh_R", 0 },
		{ "thigh_L", 0 },
		{ "clavicle_L", 0 },
		{ "clavicle_R", 0 },
		{ "knee_R", 0 },
		{ "knee_L", 0 },
		{ "Spine_0", 1 },
		{ "Root_0", 0.9 }
	}
)

model:CreateWeightlist(
	"cast3_bone_mask",
	{
		{ "thigh_R", 0.5 },
		{ "knee_R", 0.25 },
		{ "ankle_R", 0 },
		{ "thigh_L", 0.5 },
		{ "knee_L", 0.25 },
		{ "ankle_L", 0 },
		{ "clavicle_R", 0.9 },
		{ "clavicle_L", 0.9 },
		{ "bicep_R", 0.7 },
		{ "bicep_L", 0.7 }
	}
)


model:CreateSequence(
	{
		name = "cast1_rage",
		sequences = {
			{ "@cast1_rage" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_LIFESTEALER_RAGE", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@lifestealer_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lifestealer_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lifestealer_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@lifestealer_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lifestealer_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lifestealer_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@lifestealer_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lifestealer_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lifestealer_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "lifestealer_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@lifestealer_turns_lookFrame_0", "@lifestealer_turns_lookFrame_1", "@lifestealer_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_hop",
		sequences = {
			{ "@run_hop" }
		},
		addlayer = {
			"lifestealer_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"lifestealer_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 4 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_murder_lust",
		sequences = {
			{ "@run_murder_lust" }
		},
		addlayer = {
			"lifestealer_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "chase", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_aggressive",
		sequences = {
			{ "@run_aggressive" }
		},
		addlayer = {
			"lifestealer_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_injured",
		sequences = {
			{ "@run_injured" }
		},
		addlayer = {
			"lifestealer_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_haste_rune",
		sequences = {
			{ "@run_haste_rune" }
		},
		addlayer = {
			"lifestealer_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)
