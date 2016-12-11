--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\phantom_assassin\phantom_assassin.mdl
--
--=============================================================================



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
		name = "phantom_assassin_run",
		sequences = {
			{ "@phantom_assassin_run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "phantom_assassin_run_loda",
		sequences = {
			{ "@phantom_assassin_run_loda" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "loda", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@phantom_assassin_run_injured_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_injured_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@phantom_assassin_run_injured_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_injured_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@phantom_assassin_run_injured_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_injured_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "phantom_assassin_run_injured_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@phantom_assassin_run_injured_turns_lookFrame_0", "@phantom_assassin_run_injured_turns_lookFrame_1", "@phantom_assassin_run_injured_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "phantom_assassin_run_injured",
		sequences = {
			{ "@phantom_assassin_run_injured" }
		},
		addlayer = {
			"phantom_assassin_run_injured_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "phantom_assassin_run_injured_loda",
		sequences = {
			{ "@phantom_assassin_run_injured_loda" }
		},
		addlayer = {
			"phantom_assassin_run_injured_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 },
			{ name = "loda", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@phantom_assassin_run_haste_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_haste_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@phantom_assassin_run_haste_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_haste_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@phantom_assassin_run_haste_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_haste_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@phantom_assassin_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "phantom_assassin_run_haste_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@phantom_assassin_run_haste_turns_lookFrame_0", "@phantom_assassin_run_haste_turns_lookFrame_1", "@phantom_assassin_run_haste_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "phantom_assassin_run_haste",
		sequences = {
			{ "@phantom_assassin_run_haste" }
		},
		addlayer = {
			"phantom_assassin_run_haste_turns"
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
		name = "phantom_assassin_run_haste_loda",
		sequences = {
			{ "@phantom_assassin_run_haste_loda" }
		},
		addlayer = {
			"phantom_assassin_run_haste_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 },
			{ name = "loda", weight = 1 }
		}
	}
)
