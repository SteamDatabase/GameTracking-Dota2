--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\shadow_fiend\shadow_fiend_arcana.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_arcana_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_arcana", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_arcana_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_arcana", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_arcana_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_arcana", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_arcana",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_arcana_lookFrame_0", "@turns_arcana_lookFrame_1", "@turns_arcana_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 11 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_desolation",
		sequences = {
			{ "@run_desolation" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 3 },
			{ name = "desolation", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_alt_desolation",
		sequences = {
			{ "@run_alt_desolation" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 4 },
			{ name = "desolation", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_haste_desolation",
		sequences = {
			{ "@run_haste_desolation" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 },
			{ name = "desolation", weight = 1 },
			{ name = "fast_run", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_fast_desolation",
		sequences = {
			{ "@run_fast_desolation" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 3 },
			{ name = "fast_run", weight = 1 },
			{ name = "desolation", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_alt_fast_desolation",
		sequences = {
			{ "@run_alt_fast_desolation" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 4 },
			{ name = "desolation", weight = 1 },
			{ name = "fast_run", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_fast_desolation_base",
		sequences = {
			{ "@run_fast_desolation_base" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 3 },
			{ name = "desolation", weight = 1 },
			{ name = "fast_run", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_injured_desolation",
		sequences = {
			{ "@run_injured_desolation" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 },
			{ name = "desolation", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_haste",
		sequences = {
			{ "@run_haste" }
		},
		addlayer = {
			"turns_arcana"
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
		name = "run_injured",
		sequences = {
			{ "@run_injured" }
		},
		addlayer = {
			"turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)
