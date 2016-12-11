--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\creeps\neutral_creeps\n_creep_thunder_lizard\n_creep_thunder_lizard_small.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@n_creep_thunder_lizard_small_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@n_creep_thunder_lizard_small_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@n_creep_thunder_lizard_small_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@n_creep_thunder_lizard_small_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@n_creep_thunder_lizard_small_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@n_creep_thunder_lizard_small_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@n_creep_thunder_lizard_small_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@n_creep_thunder_lizard_small_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@n_creep_thunder_lizard_small_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "n_creep_thunder_lizard_small_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@n_creep_thunder_lizard_small_turns_lookFrame_0", "@n_creep_thunder_lizard_small_turns_lookFrame_1", "@n_creep_thunder_lizard_small_turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "n_creep_thunder_lizard_small_run",
		sequences = {
			{ "@n_creep_thunder_lizard_small_run" }
		},
		addlayer = {
			"n_creep_thunder_lizard_small_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
