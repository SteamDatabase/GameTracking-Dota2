-- WeightList
model:CreateWeightlist(
	"upperBody",
	{
		{ "root", 0.3 },
		{ "spine1", 0.25 },
		{ "spine2", 1 }
	}
)
-- AsLookLayer
model:CreateSequence(
	{
		name = "@dragonspawn_b_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@dragonspawn_b_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@dragonspawn_b_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@dragonspawn_b_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@dragonspawn_b_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@dragonspawn_b_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@dragonspawn_b_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@dragonspawn_b_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@dragonspawn_b_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "dragonspawn_b_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@dragonspawn_b_turns_lookFrame_0", "@dragonspawn_b_turns_lookFrame_1", "@dragonspawn_b_turns_lookFrame_2" }
		}
	}
)


-- AsTurningRun


model:CreateSequence(
	{
		name = "dragonspawn_b_run",
		sequences = {
			{ "@dragonspawn_b_run" }
		},
		addlayer = {
			"dragonspawn_b_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
