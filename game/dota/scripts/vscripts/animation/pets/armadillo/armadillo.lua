--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\pets\armadillo\armadillo.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@trot_sidetoside_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@trot_sidetoside_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@trot_sidetoside_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@trot_sidetoside_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@trot_sidetoside_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@trot_sidetoside_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@trot_sidetoside_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@trot_sidetoside_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@trot_sidetoside_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "trot_sidetoside_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@trot_sidetoside_turns_lookFrame_0", "@trot_sidetoside_turns_lookFrame_1", "@trot_sidetoside_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "trot_sidetoside",
		sequences = {
			{ "@trot_sidetoside" }
		},
		addlayer = {
			"trot_sidetoside_turns"
		},
		activities = {
			{ name = "ACT_DOTA_TROT", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "trot_hindlegs",
		sequences = {
			{ "@trot_hindlegs" }
		},
		addlayer = {
			"trot_sidetoside_turns"
		},
		activities = {
			{ name = "ACT_DOTA_TROT", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@run_roll_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_roll_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_roll_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_roll_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_roll_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_roll_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_roll_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_roll_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_roll_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_roll_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@run_roll_turns_lookFrame_0", "@run_roll_turns_lookFrame_1", "@run_roll_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_roll",
		sequences = {
			{ "@run_roll" }
		},
		addlayer = {
			"run_roll_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_sidetoside",
		sequences = {
			{ "@run_sidetoside" }
		},
		addlayer = {
			"trot_sidetoside_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 2 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@run_gallop_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_gallop_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_gallop_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_gallop_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_gallop_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_gallop_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@run_gallop_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@run_gallop_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@run_gallop_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_gallop_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@run_gallop_turns_lookFrame_0", "@run_gallop_turns_lookFrame_1", "@run_gallop_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_gallop",
		sequences = {
			{ "@run_gallop" }
		},
		addlayer = {
			"run_gallop_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 3 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@swim_paddle_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@swim_paddle_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@swim_paddle_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@swim_paddle_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@swim_paddle_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@swim_paddle_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@swim_paddle_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@swim_paddle_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@swim_paddle_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "swim_paddle_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@swim_paddle_turns_lookFrame_0", "@swim_paddle_turns_lookFrame_1", "@swim_paddle_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "swim_paddle",
		sequences = {
			{ "@swim_paddle" }
		},
		addlayer = {
			"swim_paddle_turns"
		},
		activities = {
			{ name = "ACT_DOTA_SWIM", weight = 1 }
		}
	}
)
