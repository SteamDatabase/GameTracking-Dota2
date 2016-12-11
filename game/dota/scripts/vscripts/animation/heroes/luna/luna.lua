--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\luna\luna.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@luna_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@luna_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@luna_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@luna_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@luna_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@luna_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@luna_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@luna_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@luna_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "luna_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@luna_turns_lookFrame_0", "@luna_turns_lookFrame_1", "@luna_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "luna_run",
		sequences = {
			{ "@luna_run" }
		},
		addlayer = {
			"luna_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "luna_run_haste",
		sequences = {
			{ "@luna_run_haste" }
		},
		addlayer = {
			"luna_turns"
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "luna_run_injured",
		sequences = {
			{ "@luna_run_injured" }
		},
		addlayer = {
			"luna_turns"
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
		name = "luna_run_alt",
		sequences = {
			{ "@luna_run_alt" }
		},
		addlayer = {
			"luna_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@lucentyr_run_haste_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lucentyr_run_haste_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lucentyr_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@lucentyr_run_haste_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lucentyr_run_haste_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lucentyr_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@lucentyr_run_haste_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lucentyr_run_haste_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lucentyr_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "lucentyr_run_haste_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@lucentyr_run_haste_turns_lookFrame_0", "@lucentyr_run_haste_turns_lookFrame_1", "@lucentyr_run_haste_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "lucentyr_run_haste",
		sequences = {
			{ "@lucentyr_run_haste" }
		},
		addlayer = {
			"lucentyr_run_haste_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 },
			{ name = "lucentyr", weight = 1 }
		}
	}
)
