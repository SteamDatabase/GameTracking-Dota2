--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\creeps\lane_creeps\creep_bad_siege\creep_bad_siege.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "creep_bad_siege_bw_striaght",
		framerangesequence = "@creep_bad_siege_bw_striaght",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_bw_striaght", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_bw_L",
		framerangesequence = "@creep_bad_siege_bw_L",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_bw_L", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_bw_R",
		framerangesequence = "@creep_bad_siege_bw_R",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_bw_R", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_rw_left",
		framerangesequence = "@creep_bad_siege_rw_left",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_rw_left", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_rw_straight",
		framerangesequence = "@creep_bad_siege_rw_straight",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_rw_straight", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_rw_right",
		framerangesequence = "@creep_bad_siege_rw_right",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_rw_right", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_lw_left",
		framerangesequence = "@creep_bad_siege_lw_left",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_lw_left", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_lw_right",
		framerangesequence = "@creep_bad_siege_lw_right",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_lw_right", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_lw_straight",
		framerangesequence = "@creep_bad_siege_lw_straight",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_bad_siege_lw_straight", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_bad_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "creep_bad_siege_left_wheel",
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "creep_bad_siege_lw_left", "creep_bad_siege_lw_straight", "creep_bad_siege_lw_right" }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "creep_bad_siege_right_wheel",
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "creep_bad_siege_rw_left", "creep_bad_siege_rw_straight", "creep_bad_siege_rw_right" }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "creep_bad_siege_back_wheel",
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "creep_bad_siege_bw_L", "creep_bad_siege_bw_striaght", "creep_bad_siege_bw_R" }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_bad_siege_wheel_layer",
		numframes = 48,
		fps = 30,
		addlayer = {
			"creep_bad_siege_back_wheel",
			"creep_bad_siege_right_wheel",
			"creep_bad_siege_left_wheel"
		},
		activities = {
			{ name = "ACT_DOTA_WHEEL_LAYER", weight = 1 }
		}
	}
)
