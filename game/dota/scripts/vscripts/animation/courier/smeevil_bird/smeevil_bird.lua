--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\smeevil_bird\smeevil_bird.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@smeevil_bird_ground_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@smeevil_bird_ground_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@smeevil_bird_ground_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@smeevil_bird_ground_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@smeevil_bird_ground_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@smeevil_bird_ground_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@smeevil_bird_ground_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@smeevil_bird_ground_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@smeevil_bird_ground_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "smeevil_bird_ground_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@smeevil_bird_ground_turns_lookFrame_0", "@smeevil_bird_ground_turns_lookFrame_1", "@smeevil_bird_ground_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "smeevil_bird_run",
		sequences = {
			{ "@smeevil_bird_run" }
		},
		addlayer = {
			"smeevil_bird_ground_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 2 }
		}
	}
)

model:CreateSequence(
	{
		name = "smeevil_bird_run_look_back",
		sequences = {
			{ "@smeevil_bird_run_look_back" }
		},
		addlayer = {
			"smeevil_bird_ground_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)