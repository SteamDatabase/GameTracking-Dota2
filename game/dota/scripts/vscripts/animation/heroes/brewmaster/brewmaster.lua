--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\brewmaster\brewmaster.mdl
--
--=============================================================================

model:CreateWeightlist(
	"primalSplit",
	{
		{ "spine1", 1 },
		{ "mug4_0", 0 }
	}
)

model:CreateWeightlist(
	"drunkenBrawler",
	{
		{ "root", 1 },
		{ "thigh_R", 0 },
		{ "hipCloth2_0_A_L", 0 },
		{ "thigh_L", 0 },
		{ "hipCloth3_0_A_R", 0 },
		{ "frontCloth5_0", 0 },
		{ "ear1_0_R", 0 },
		{ "ear0_0_L", 0 },
		{ "jaw0_0", 0 },
		{ "clavicle_L", 0 },
		{ "bicep_R", 0.5 },
		{ "wrist_R", 1 },
		{ "mug4_0", 0 }
	}
)

model:CreateWeightlist(
	"upperBody",
	{
		{ "spine1", 1 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "TURN", -1, 1, 0, false ),
		sequences = {
			{ "@turns_lookFrame_0", "@turns_lookFrame_1", "@turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "drunkenBrawler",
		framerangesequence = "@drunkenBrawler",
		cmds = {
			{ cmd = "sequence", sequence = "@drunkenBrawler", dst = 1 },
			{ cmd = "fetchframe", sequence = "@drunkenBrawler", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 }
		}
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@idle_to_run_pose_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@idle_to_run_pose", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@idle_to_run_pose", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@idle_to_run_pose_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@idle_to_run_pose", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@idle_to_run_pose", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "idle_to_run_pose",
		delta = true,
		poseParamX = model:CreatePoseParameter( "idle_to_run", 0, 1, 0, false ),
		sequences = {
			{ "@idle_to_run_pose_lookFrame_0", "@idle_to_run_pose_lookFrame_1" }
		},
		weightlist = "upperBody"
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@idle_aggr_to_run_aggr_pose_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@idle_aggr_to_run_aggr_pose", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@idle_aggr_to_run_aggr_pose", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@idle_aggr_to_run_aggr_pose_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@idle_aggr_to_run_aggr_pose", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@idle_aggr_to_run_aggr_pose", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "idle_aggr_to_run_aggr_pose",
		delta = true,
		poseParamX = model:CreatePoseParameter( "idle_aggr_to_run_aggr", 0, 1, 0, false ),
		sequences = {
			{ "@idle_aggr_to_run_aggr_pose_lookFrame_0", "@idle_aggr_to_run_aggr_pose_lookFrame_1" }
		},
		weightlist = "upperBody"
	}
)


model:CreateSequence(
	{
		name = "run_aggressive_anim",
		sequences = {
			{ "@run_aggressive_anim" }
		},
		addlayer = {
			"turns",
			"idle_aggr_to_run_aggr_pose"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "Run_anim",
		sequences = {
			{ "@Run_anim" }
		},
		addlayer = {
			"turns",
			"idle_to_run_pose"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

