--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\leshrac\leshrac.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "Spine_1", 1 },
		{ "Spine_0", 1 },
		{ "QuadrupedFrontLeg_0_R", 0 },
		{ "QuadrupedFrontLeg_0_L", 0 }
	}
)


model:CreateSequence(
	{
		name = "pulse_nova",
		framerangesequence = "@pulse_nova",
		cmds = {
			{ cmd = "sequence", sequence = "@pulse_nova", dst = 1 },
			{ cmd = "fetchframe", sequence = "@pulse_nova", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_4", weight = 1 }
		}
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



-- AsLookLayer
model:CreateSequence(
	{
		name = "@staff_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@staff_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@staff_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@staff_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@staff_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@staff_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@staff_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@staff_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@staff_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "staff_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@staff_turns_lookFrame_0", "@staff_turns_lookFrame_1", "@staff_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "staff_run_anim",
		sequences = {
			{ "@staff_run" }
		},
		addlayer = {
			"staff_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "torment", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "staff_run_haste",
		sequences = {
			{ "@staff_run_haste" }
		},
		addlayer = {
			"staff_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "torment", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "staff_pulse_nova",
		framerangesequence = "@staff_pulse_nova",
		cmds = {
			{ cmd = "sequence", sequence = "@staff_pulse_nova", dst = 1 },
			{ cmd = "fetchframe", sequence = "@staff_pulse_nova", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_4", weight = 1 },
			{ name = "torment", weight = 1 }
		}
	}
)


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
