--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\wraith_king\wraith_frost.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "spine1", 1 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@WK_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@WK_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@WK_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@WK_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@WK_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@WK_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@WK_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@WK_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@WK_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "WK_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@WK_turns_lookFrame_0", "@WK_turns_lookFrame_1", "@WK_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"WK_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_haste",
		sequences = {
			{ "@run_haste" }
		},
		addlayer = {
			"WK_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_injured",
		sequences = {
			{ "@run_injured" }
		},
		addlayer = {
			"WK_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@run_to_idle_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_to_idle_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_to_idle",
		delta = true,
		poseParamX = model:CreatePoseParameter( "run_to_idle", 0, 1, 0, false ),
		sequences = {
			{ "@run_to_idle_lookFrame_0", "@run_to_idle_lookFrame_1" }
		},
		weightlist = "upperBody"
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@idle_to_run_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@idle_to_run", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@idle_to_run", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@idle_to_run_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@idle_to_run", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@idle_to_run", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "idle_to_run",
		delta = true,
		poseParamX = model:CreatePoseParameter( "idle_to_run", 0, 1, 0, false ),
		sequences = {
			{ "@idle_to_run_lookFrame_0", "@idle_to_run_lookFrame_1" }
		},
		weightlist = "upperBody"
	}
)
