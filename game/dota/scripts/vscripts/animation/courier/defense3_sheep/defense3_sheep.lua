--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- qc:  models/courier/defense3_sheep/defense3_sheep.qc
-- mdl: courier/defense3_sheep/defense3_sheep.mdl
--
--=============================================================================

model:CreateSequence(
	{
		name = "courier_turn_center",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "sheep_turn_center.smd",
		cmds = {
			{ cmd = "sequence", sequence = "sheep_turn_center.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "courier_turn_subtract", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "courier_turn_left",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "sheep_turn_left.smd",
		cmds = {
			{ cmd = "sequence", sequence = "sheep_turn_left.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "courier_turn_subtract", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "courier_turn_right",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "sheep_turn_right.smd",
		cmds = {
			{ cmd = "sequence", sequence = "sheep_turn_right.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "courier_turn_subtract", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "courier_turns",
		delta = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "courier_turn_left", "courier_turn_center", "courier_turn_right" }
		}
	}
)


model:CreateSequence(
	{
		name = "courier_run",
		looping = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		sequences = {
			{ "@courier_run" }
		},
		addlayer = { "courier_turns" },
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

