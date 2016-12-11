--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\ember_spirit\ember_spirit.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperbody",
	{
		{ "Spine0_JNT", 1 },
		{ "Spine1_JNT", 1 },
		{ "Root_JNT", 0 },
		{ "LfRearSkirt0_JNT", 0 },
		{ "LfLeg0_JNT", 0 },
		{ "FrontSkirt0_JNT", 0 },
		{ "RtFrontSkirt0_JNT", 0 },
		{ "RtRearSkirt0_JNT", 0 },
		{ "Bola0_JNT", 0 },
		{ "RtLeg0_JNT", 0 },
		{ "LfFrontSkirt0_JNT", 0 }
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
		weightlist = "upperbody"
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@run_to_idle_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_to_idle_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_to_idle", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_to_idle",
		delta = true,
		poseParamX = model:CreatePoseParameter( "run_to_idle", 0, 1, 0, false ),
		sequences = {
			{ "@run_to_idle_lookFrame_0", "@run_to_idle_lookFrame_1" }
		},
		weightlist = "upperbody"
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@agg_idle_to_agg_run_pose_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@agg_idle_to_agg_run_pose", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@agg_idle_to_agg_run_pose", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@agg_idle_to_agg_run_pose_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@agg_idle_to_agg_run_pose", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@agg_idle_to_agg_run_pose", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "agg_idle_to_agg_run_pose",
		delta = true,
		poseParamX = model:CreatePoseParameter( "agg_idle_to_agg_run", 1, 0, 0, false ),
		sequences = {
			{ "@agg_idle_to_agg_run_pose_lookFrame_0", "@agg_idle_to_agg_run_pose_lookFrame_1" }
		},
		weightlist = "upperbody"
	}
)


model:CreateSequence(
	{
		name = "idle_anim",
		sequences = {
			{ "@idle" }
		},
		addlayer = {
			"run_to_idle"
		},
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 }
		}
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
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_lookFrame_0", "@turns_lookFrame_1", "@turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
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


-- AsTurningRun

model:CreateSequence(
	{
		name = "aggressive_run",
		sequences = {
			{ "@aggressive_run" }
		},
		addlayer = {
			"turns",
			"agg_idle_to_agg_run_pose"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "haste_run_anim",
		sequences = {
			{ "@haste_run_anim" }
		},
		addlayer = {
			"turns",
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)