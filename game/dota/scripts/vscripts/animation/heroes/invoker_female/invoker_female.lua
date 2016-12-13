--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\invoker\invoker.mdl
--
--=============================================================================

model:CreateWeightlist(
	"orb_spawn_lf",
	{
		{ "clavicle_R", 0 },
		{ "clavicle_L", 1 },
		{ "arm_upper_L", 1 }
	}
)

model:CreateWeightlist(
	"orb_spawn_rt",
	{
		{ "clavicle_R", 1 },
		{ "arm_upper_R", 1 }
	}
)

model:CreateWeightlist(
	"orbs_loop_mask",
	{
		{ "orb3", 1 },
		{ "orb1", 1 },
		{ "orb2", 1 }
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
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_lookFrame_0", "@turns_lookFrame_1", "@turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_anim",
		sequences = {
			{ "@run" }
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
		name = "orbs",
		sequences = {
			{ "@orbs" }
		},
		weightlist = "orbs_loop_mask",
		activities = {
			{ name = "ACT_DOTA_CONSTANT_LAYER", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "orb_spawn_lf",
		sequences = {
			{ "@orb_spawn_lf" }
		},
		weightlist = "orb_spawn_lf",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "orb_spawn_rt",
		sequences = {
			{ "@orb_spawn_rt" }
		},
		weightlist = "orb_spawn_rt",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_2", weight = 1 }
		}
	}
)

