--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\rubick\rubick.mdl
--
--=============================================================================

model:CreateWeightlist(
	"UpperBody",
	{
		{ "Spine_0", 1 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@rubick_steal_brfireflyb_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@rubick_steal_brfireflyb_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@rubick_steal_brfireflyb_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@rubick_steal_brfireflyb_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@rubick_steal_brfireflyb_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@rubick_steal_brfireflyb_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@rubick_steal_brfireflyb_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@rubick_steal_brfireflyb_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@rubick_steal_brfireflyb_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "rubick_steal_brfireflyb_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@rubick_steal_brfireflyb_turns_lookFrame_0", "@rubick_steal_brfireflyb_turns_lookFrame_1", "@rubick_steal_brfireflyb_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "rubick_steal_brfireflyb",
		sequences = {
			{ "@rubick_steal_brfireflyb" }
		},
		addlayer = {
			"rubick_steal_brfireflyb_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "firefly", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "rubick_steal_arctic_burn",
		sequences = {
			{ "@rubick_steal_brfireflyb" }
		},
		addlayer = {
			"rubick_steal_brfireflyb_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "flying", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "rubick_steal_swarcry",
		sequences = {
			{ "@rubick_steal_swarcry" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 },
			{ name = "strength", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "rubick_steal_bmwildaxesb",
		sequences = {
			{ "@rubick_steal_bmwildaxesb" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_WILD_AXES_END", weight = 1 },
			{ name = "axes", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "rubick_steal_swarcry_dupe1",
		sequences = {
			{ "@rubick_steal_swarcry_dupe1" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 },
			{ name = "strength", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "rubick_steal_uenrage",
		sequences = {
			{ "@rubick_steal_uenrage" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 },
			{ name = "enrage", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "rubick_steal_uoverpower",
		sequences = {
			{ "@rubick_steal_uoverpower" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 },
			{ name = "overpower", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@rubick_run_haste_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@rubick_run_haste_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@rubick_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@rubick_run_haste_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@rubick_run_haste_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@rubick_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@rubick_run_haste_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@rubick_run_haste_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@rubick_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "rubick_run_haste_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@rubick_run_haste_turns_lookFrame_0", "@rubick_run_haste_turns_lookFrame_1", "@rubick_run_haste_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "rubick_steal_wrwindrun",
		sequences = {
			{ "@rubick_steal_wrwindrun" }
		},
		addlayer = {
			"rubick_run_haste_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "windrun", weight = 1 }
		}
	}
)
