--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- qc:  models/courier/courier_mech/courier_mech.qc
-- mdl: courier/courier_mech/courier_mech.mdl
--
--=============================================================================

model:CreateSequence(
	{
		name = "courier_mech_turns_lookFrame_0",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "courier_mech_turns_lookframe_0.smd",
		cmds = {
			{ cmd = "sequence", sequence = "courier_mech_turns_lookframe_0.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "delta.smd", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "courier_mech_turns_lookFrame_1",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "courier_mech_turns_lookframe_1.smd",
		cmds = {
			{ cmd = "sequence", sequence = "courier_mech_turns_lookframe_1.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "delta.smd", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "courier_mech_turns_lookFrame_2",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "courier_mech_turns_lookframe_2.smd",
		cmds = {
			{ cmd = "sequence", sequence = "courier_mech_turns_lookframe_2.smd", dst = 1 },
			{ cmd = "fetchframe", sequence = "delta.smd", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "courier_mech_turns",
		delta = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		poseParamX = model:CreatePoseParameter( "TURN", -1, 1, 0, false ),
		sequences = {
			{ "courier_mech_turns_lookFrame_0", "courier_mech_turns_lookFrame_1", "courier_mech_turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "courier_mech_run",
		looping = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		sequences = {
			{ "@courier_mech_run" }
		},
		addlayer = { "courier_mech_turns" },
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

