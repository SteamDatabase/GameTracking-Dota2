--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\items\dragon_knight\dragon_immortal_1\dragon_immortal_1.mdl
--
--=============================================================================

model:CreateWeightlist(
	"spine",
	{
		{ "root", 1 },
		{ "spine1", 1 },
		{ "bicep_A_L", 0 },
		{ "clavicle_L", 0 },
		{ "bicep_A_R", 0 },
		{ "clavicle_R", 0 },
		{ "thigh_L", 0 },
		{ "tail0_0", 0 },
		{ "thigh_R", 0 }
	}
)

model:CreateWeightlist(
	"wings_only",
	{
		{ "neck1", 0 },
		{ "spine2", 0 },
		{ "bicep_A_L", 1 },
		{ "bicep_A_R", 1 },
		{ "clavicle_R", 0 },
		{ "clavicle_L", 0 },
		{ "spine1", 0 },
		{ "root", 0 },
		{ "tail0_0", 0 },
		{ "thigh_L", 0 },
		{ "thigh_R", 0 }
	}
)

model:CreateWeightlist(
	"turns",
	{
		{ "root", 1 },
		{ "bicep_A_L", 0 },
		{ "bicep_A_R", 0 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@dragon_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@dragon_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@dragon_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@dragon_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@dragon_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@dragon_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@dragon_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@dragon_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@dragon_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "dragon_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@dragon_turns_lookFrame_0", "@dragon_turns_lookFrame_1", "@dragon_turns_lookFrame_2" }
		},
		weightlist = "turns"
	}
)


model:CreateSequence(
	{
		name = "dragon_attack",
		sequences = {
			{ "@dragon_attack" }
		},
		weightlist = "spine",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "dragon_bash",
		sequences = {
			{ "@dragon_bash" }
		},
		weightlist = "spine",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "dragon_breath",
		sequences = {
			{ "@dragon_breath" }
		},
		weightlist = "spine",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "dragon_run",
		sequences = {
			{ "@dragon_run" }
		},
		addlayer = {
			"dragon_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "wings_loop",
		sequences = {
			{ "@dragon_idle" }
		},
		weightlist = "wings_only",
		activities = {
			{ name = "ACT_DOTA_CONSTANT_LAYER", weight = 1 }
		}
	}
)
