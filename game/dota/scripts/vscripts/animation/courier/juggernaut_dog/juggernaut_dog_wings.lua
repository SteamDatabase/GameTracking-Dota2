--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\juggernaut_dog\juggernaut_dog_wings.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@wings_turn_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@wings_turn", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@wings_turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@wings_turn_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@wings_turn", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@wings_turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@wings_turn_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@wings_turn", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@wings_turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "wings_turn",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@wings_turn_lookFrame_0", "@wings_turn_lookFrame_1", "@wings_turn_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "wings_run",
		sequences = {
			{ "@wings_run" }
		},
		addlayer = {
			"wings_turn"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
