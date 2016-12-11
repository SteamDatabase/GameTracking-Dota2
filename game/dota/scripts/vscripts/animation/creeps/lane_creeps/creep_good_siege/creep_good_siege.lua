--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\creeps\lane_creeps\creep_good_siege\creep_good_siege.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "creep_good_siege_lw_left",
		framerangesequence = "@creep_good_siege_lw_left",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_lw_left", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_lw_straight",
		framerangesequence = "@creep_good_siege_lw_straight",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_lw_straight", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_lw_right",
		framerangesequence = "@creep_good_siege_lw_right",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_lw_right", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_rw_left",
		framerangesequence = "@creep_good_siege_rw_left",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_rw_left", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_rw_straight",
		framerangesequence = "@creep_good_siege_rw_straight",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_rw_straight", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_rw_right",
		framerangesequence = "@creep_good_siege_rw_right",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_rw_right", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_bw_straight",
		framerangesequence = "@creep_good_siege_bw_straight",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_bw_straight", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_bw_left",
		framerangesequence = "@creep_good_siege_bw_left",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_bw_left", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_bw_right",
		framerangesequence = "@creep_good_siege_bw_right",
		delta = true,
		cmds = {
			{ cmd = "sequence", sequence = "@creep_good_siege_bw_right", dst = 0 },
			{ cmd = "fetchframe", sequence = "creep_good_siege_idle", frame = 0, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "creep_good_siege_left_wheel",
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "creep_good_siege_lw_left", "creep_good_siege_lw_straight", "creep_good_siege_lw_right" }
		},
		activities = {
			{ name = "ACT_DOTA_", weight = 1 }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "creep_good_siege_right_wheel",
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "creep_good_siege_rw_left", "creep_good_siege_rw_straight", "creep_good_siege_rw_right" }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "creep_good_siege_back_wheel",
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "creep_good_siege_bw_left", "creep_good_siege_bw_straight", "creep_good_siege_bw_right" }
		}
	}
)


model:CreateSequence(
	{
		name = "creep_good_siege_wheel_layer",
		numframes = 40,
		fps = 30,
		addlayer = {
			"creep_good_siege_back_wheel",
			"creep_good_siege_right_wheel",
			"creep_good_siege_left_wheel"
		},
		activities = {
			{ name = "ACT_DOTA_WHEEL_LAYER", weight = 1 }
		}
	}
)
