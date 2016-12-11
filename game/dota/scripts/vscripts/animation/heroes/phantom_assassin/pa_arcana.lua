--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\phantom_assassin\pa_arcana.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@arcana_agg_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_agg_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_agg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@arcana_agg_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_agg_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_agg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@arcana_agg_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_agg_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_agg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "arcana_agg_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@arcana_agg_turns_lookFrame_0", "@arcana_agg_turns_lookFrame_1", "@arcana_agg_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "arcana_agg_run",
		sequences = {
			{ "@arcana_agg_run" }
		},
		addlayer = {
			"arcana_agg_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "arcana", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "arcana_run",
		sequences = {
			{ "@arcana_run" }
		},
		addlayer = {
			"arcana_agg_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "arcana", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "arcana_run_haste",
		sequences = {
			{ "@arcana_run_haste" }
		},
		addlayer = {
			"arcana_agg_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@arcana_run_injured_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_run_injured_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@arcana_run_injured_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_run_injured_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@arcana_run_injured_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_run_injured_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "arcana_run_injured_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@arcana_run_injured_turns_lookFrame_0", "@arcana_run_injured_turns_lookFrame_1", "@arcana_run_injured_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "arcana_run_injured",
		sequences = {
			{ "@arcana_run_injured" }
		},
		addlayer = {
			"arcana_run_injured_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 },
			{ name = "arcana", weight = 1 }
		}
	}
)
