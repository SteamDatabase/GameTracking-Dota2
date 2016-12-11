--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\morphling\morphling.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_new_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_new_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_new_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_new",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_new_lookFrame_0", "@turns_new_lookFrame_1", "@turns_new_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "run_new",
		sequences = {
			{ "@run_new" }
		},
		addlayer = {
			"turns_new"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "tears_run",
		sequences = {
			{ "@tears_run" }
		},
		addlayer = {
			"turns_new"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "tears", weight = 1 }
		}
	}
)
