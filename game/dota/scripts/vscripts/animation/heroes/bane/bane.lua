--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\bane\bane.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@bane_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bane_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bane_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@bane_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bane_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bane_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@bane_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bane_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bane_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "bane_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@bane_turns_lookFrame_0", "@bane_turns_lookFrame_1", "@bane_turns_lookFrame_2" }
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
			"bane_turns"
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
			"bane_turns"
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
			"bane_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


--------------------------------------------------------------------------------
-- slumbering terror (immortal)
--------------------------------------------------------------------------------

-- AsLookLayer
model:CreateSequence(
	{
		name = "@terror_bane_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@terror_bane_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@terror_bane_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@terror_bane_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@terror_bane_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@terror_bane_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@terror_bane_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@terror_bane_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@terror_bane_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "terror_bane_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@terror_bane_turns_lookFrame_0", "@terror_bane_turns_lookFrame_1", "@terror_bane_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "terror_run",
		sequences = {
			{ "@terror_run" }
		},
		addlayer = {
			"terror_bane_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "terror", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "terror_run_haste",
		sequences = {
			{ "@terror_run_haste" }
		},
		addlayer = {
			"terror_bane_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "terror", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "terror_run_injured",
		sequences = {
			{ "@terror_run_injured" }
		},
		addlayer = {
			"terror_bane_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "terror", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


