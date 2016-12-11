--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\clinkz\clinkz.mdl
--
--=============================================================================

model:CreateWeightlist(
	"first_blood",
	{
		{ "spine1", 1 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@run_turn_layer_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_turn_layer", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_turn_layer_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_turn_layer", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_turn_layer_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_turn_layer", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_turn_layer",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@run_turn_layer_lookFrame_0", "@run_turn_layer_lookFrame_1", "@run_turn_layer_lookFrame_2" }
		}
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@windwalk_turn_layer_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@windwalk_turn_layer", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@windwalk_turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@windwalk_turn_layer_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@windwalk_turn_layer", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@windwalk_turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@windwalk_turn_layer_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@windwalk_turn_layer", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@windwalk_turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "windwalk_turn_layer",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@windwalk_turn_layer_lookFrame_0", "@windwalk_turn_layer_lookFrame_1", "@windwalk_turn_layer_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "first_blood",
		framerangesequence = "@first_blood",
		cmds = {
			{ cmd = "sequence", sequence = "@first_blood", dst = 1 },
			{ cmd = "fetchframe", sequence = "@first_blood", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_FIRST_BLOOD", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"run_turn_layer"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "windwalk",
		sequences = {
			{ "@windwalk" }
		},
		addlayer = {
			"windwalk_turn_layer"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "windwalk", weight = 1 }
		}
	}
)
