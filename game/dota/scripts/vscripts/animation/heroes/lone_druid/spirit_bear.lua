--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\lone_druid\spirit_bear.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@sb_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@sb_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@sb_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@sb_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@sb_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@sb_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@sb_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@sb_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@sb_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "sb_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@sb_turns_lookFrame_0", "@sb_turns_lookFrame_1", "@sb_turns_lookFrame_2" }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "sb_run_injured",
		sequences = {
			{ "@sb_run_injured" }
		},
		addlayer = {
			"sb_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "sb_run_haste",
		sequences = {
			{ "@sb_run_haste" }
		},
		addlayer = {
			"sb_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "sb_run_or",
		sequences = {
			{ "@sb_run_or" }
		},
		addlayer = {
			"sb_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "AttackCheck", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "sb_run",
		sequences = {
			{ "@sb_run" }
		},
		addlayer = {
			"sb_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
