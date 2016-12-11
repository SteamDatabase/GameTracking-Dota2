-- Mouth Pose Parameter

model:CreatePoseParameter( "mouth", 0, 1, 0, false )

-- WeightList

model:CreateWeightlist(
	"upperBody",
	{
		{ "hips_1", 0 },
		{ "root", 0 },
		{ "spine1", 1 },
	}
)

-- AsLookLayer
model:CreateSequence(
	{
		name = "@aw_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@aw_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@aw_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@aw_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@aw_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@aw_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@aw_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@aw_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@aw_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "aw_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@aw_turns_lookFrame_0", "@aw_turns_lookFrame_1", "@aw_turns_lookFrame_2" }
		}
	}
)


-- AsTurningRun



model:CreateSequence(
	{
		name = "aw_walk",
		sequences = {
			{ "@aw_walk" }
		},
		addlayer = {
			"aw_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "walk", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "aw_walk_injured",
		sequences = {
			{ "@aw_walk_injured" }
		},
		addlayer = {
			"aw_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "walk", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "aw_run",
		sequences = {
			{ "@aw_run" }
		},
		addlayer = {
			"aw_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "aw_run_injured",
		sequences = {
			{ "@aw_walk_injured" }
		},
		addlayer = {
			"aw_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "aw_run_haste",
		sequences = {
			{ "@aw_run_haste" }
		},
		addlayer = {
			"aw_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)

-- 

model:CreateSequence(
	{
		name = "aw_cast4_tempest_double",
		sequences = {
			{ "@aw_cast4_tempest_double" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 }
		}
	}
)
