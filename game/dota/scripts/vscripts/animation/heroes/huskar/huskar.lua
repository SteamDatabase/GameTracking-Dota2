--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\huskar\huskar.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@sd_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@sd_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@sd_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@sd_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@sd_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@sd_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@sd_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@sd_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@sd_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "sd_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@sd_turns_lookFrame_0", "@sd_turns_lookFrame_1", "@sd_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "sd_run_anim",
		sequences = {
			{ "@sd_run" }
		},
		addlayer = {
			"sd_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "dominator", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "sd_run_aggressive_anim",
		sequences = {
			{ "@sd_run_aggressive" }
		},
		addlayer = {
			"sd_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 },
			{ name = "dominator", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "sd_run_aggressive_injured",
		sequences = {
			{ "@sd_run_aggressive_injured" }
		},
		addlayer = {
			"sd_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured_aggressive", weight = 1 },
			{ name = "dominator", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "sd_run_haste",
		sequences = {
			{ "@sd_run_haste" }
		},
		addlayer = {
			"sd_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 },
			{ name = "dominator", weight = 1 }
		}
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turn_layer_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn_layer", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn_layer_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn_layer", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn_layer_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn_layer", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn_layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turn_layer",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turn_layer_lookFrame_0", "@turn_layer_lookFrame_1", "@turn_layer_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "run_anim",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turn_layer"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_aggressive_anim",
		sequences = {
			{ "@run_aggressive" }
		},
		addlayer = {
			"turn_layer"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_aggressive_injured",
		sequences = {
			{ "@run_aggressive_injured" }
		},
		addlayer = {
			"turn_layer"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured_aggressive", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_haste",
		sequences = {
			{ "@run_haste" }
		},
		addlayer = {
			"turn_layer"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)
