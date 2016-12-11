--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\octopus\octopus_flying.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@run_flying_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_flying_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_flying_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_flying_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_flying_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_flying_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_flying_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_flying_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_flying_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_flying_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@run_flying_turns_lookFrame_0", "@run_flying_turns_lookFrame_1", "@run_flying_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_flying",
		sequences = {
			{ "@run_flying" }
		},
		addlayer = {
			"run_flying_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@run_flying_haste_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_flying_haste_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_flying_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_flying_haste_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_flying_haste_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_flying_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_flying_haste_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_flying_haste_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_flying_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_flying_haste_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@run_flying_haste_turns_lookFrame_0", "@run_flying_haste_turns_lookFrame_1", "@run_flying_haste_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_flying_haste",
		sequences = {
			{ "@run_flying_haste" }
		},
		addlayer = {
			"run_flying_haste_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)
