--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\smeevil_crab\smeevil_crab.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@smeevil_crab_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@smeevil_crab_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@smeevil_crab_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@smeevil_crab_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@smeevil_crab_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@smeevil_crab_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@smeevil_crab_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@smeevil_crab_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@smeevil_crab_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "smeevil_crab_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@smeevil_crab_turns_lookFrame_0", "@smeevil_crab_turns_lookFrame_1", "@smeevil_crab_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "smeevil_crab_run",
		sequences = {
			{ "@smeevil_crab_run" }
		},
		addlayer = {
			"smeevil_crab_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
