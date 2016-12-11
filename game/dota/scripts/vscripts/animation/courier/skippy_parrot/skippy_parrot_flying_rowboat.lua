--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\skippy_parrot\skippy_parrot_flying_rowboat.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@flying_rowboat_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@flying_rowboat_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@flying_rowboat_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@flying_rowboat_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@flying_rowboat_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@flying_rowboat_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@flying_rowboat_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@flying_rowboat_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@flying_rowboat_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "flying_rowboat_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@flying_rowboat_turns_lookFrame_0", "@flying_rowboat_turns_lookFrame_1", "@flying_rowboat_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "flying_rowboat_run",
		sequences = {
			{ "@flying_rowboat_run" }
		},
		addlayer = {
			"flying_rowboat_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flying_rowboat_run_haste",
		sequences = {
			{ "@flying_rowboat_run_haste" }
		},
		addlayer = {
			"flying_rowboat_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)