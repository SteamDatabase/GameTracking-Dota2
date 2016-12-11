--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- qc:  models/courier/venoling/venoling.qc
-- mdl: courier/venoling/venoling.mdl
--
--=============================================================================

model:CreateSequence(
	{
		name = "turns_center",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "venoling_turns_center.smd",
		cmds = {
			{ cmd = "sequence", sequence = "venoling_turns_center.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "centerpose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_left",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "venoling_turns_left.smd",
		cmds = {
			{ cmd = "sequence", sequence = "venoling_turns_left.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "centerpose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_right",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "venoling_turns_right.smd",
		cmds = {
			{ cmd = "sequence", sequence = "venoling_turns_right.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "centerpose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns",
		delta = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "turns_left", "turns_center", "turns_right" }
		}
	}
)


model:CreateSequence(
	{
		name = "run",
		looping = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		sequences = {
			{ "@run" }
		},
		addlayer = { "turns" },
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

