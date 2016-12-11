--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\badger\courier_badger_flying.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@courier_badger_flying_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@courier_badger_flying_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@courier_badger_flying_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@courier_badger_flying_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@courier_badger_flying_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@courier_badger_flying_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@courier_badger_flying_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@courier_badger_flying_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@courier_badger_flying_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "courier_badger_flying_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@courier_badger_flying_turns_lookFrame_0", "@courier_badger_flying_turns_lookFrame_1", "@courier_badger_flying_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "courier_badger_flying_run",
		sequences = {
			{ "@courier_badger_flying_run" }
		},
		addlayer = {
			"courier_badger_flying_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
