--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\courier\greevil\greevil.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_flying_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_flying", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_flying", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_flying_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_flying", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_flying", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_flying_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_flying", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_flying", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_flying",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_flying_lookFrame_0", "@turns_flying_lookFrame_1", "@turns_flying_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "naked_run",
		sequences = {
			{ "@naked_run" }
		},
		addlayer = {
			"turns_flying"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "level1_run",
		sequences = {
			{ "@level1_run" }
		},
		addlayer = {
			"turns_flying"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "level_1", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "level2_run",
		sequences = {
			{ "@level2_run" }
		},
		addlayer = {
			"turns_flying"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "level_2", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "level3_run",
		sequences = {
			{ "@level3_run" }
		},
		addlayer = {
			"turns_flying"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "level_3", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "black_run",
		sequences = {
			{ "@black_run" }
		},
		addlayer = {
			"turns_flying"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "black", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "white_run",
		sequences = {
			{ "@white_run" }
		},
		addlayer = {
			"turns_flying"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "white", weight = 1 }
		}
	}
)
