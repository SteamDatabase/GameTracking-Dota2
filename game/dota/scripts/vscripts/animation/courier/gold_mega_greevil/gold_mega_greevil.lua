--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\gold_mega_greevil\gold_mega_greevil.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@gmg_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@gmg_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@gmg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@gmg_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@gmg_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@gmg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@gmg_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@gmg_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@gmg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "gmg_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@gmg_turns_lookFrame_0", "@gmg_turns_lookFrame_1", "@gmg_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "mg_run",
		sequences = {
			{ "@mg_run" }
		},
		addlayer = {
			"gmg_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
