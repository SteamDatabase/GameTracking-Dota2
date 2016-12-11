--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\sand_king\sand_king.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "epicenter",
		framerangesequence = "@epicenter",
		cmds = {
			{ cmd = "sequence", sequence = "@epicenter", dst = 1 },
			{ cmd = "fetchframe", sequence = "@epicenter", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 }
		}
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turn_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turn",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turn_lookFrame_0", "@turn_lookFrame_1", "@turn_lookFrame_2" }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "sand_king_run",
		sequences = {
			{ "@sand_king_run" }
		},
		addlayer = {
			"turn",
			"turn"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
