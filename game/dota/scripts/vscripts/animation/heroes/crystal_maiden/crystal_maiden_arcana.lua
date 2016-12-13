--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\crystal_maiden\crystal_maiden_arcana.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@arcana_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@arcana_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@arcana_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@arcana_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@arcana_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "arcana_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@arcana_turns_lookFrame_0", "@arcana_turns_lookFrame_1", "@arcana_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_arcana_anim",
		sequences = {
			{ "@run_arcana_anim" }
		},
		addlayer = {
			"arcana_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "arcana_agg_run_anim",
		sequences = {
			{ "@arcana_agg_run_anim" }
		},
		addlayer = {
			"arcana_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@wardstaff_arcana_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@wardstaff_arcana_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@wardstaff_arcana_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@wardstaff_arcana_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@wardstaff_arcana_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@wardstaff_arcana_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@wardstaff_arcana_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@wardstaff_arcana_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@wardstaff_arcana_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "wardstaff_arcana_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@wardstaff_arcana_turns_lookFrame_0", "@wardstaff_arcana_turns_lookFrame_1", "@wardstaff_arcana_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "wardstaff_run_arcana_anim",
		sequences = {
			{ "@wardstaff_run_arcana_anim" }
		},
		addlayer = {
			"wardstaff_arcana_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "wardstaff", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "wardstaff_arcana_agg_run_anim",
		sequences = {
			{ "@wardstaff_arcana_agg_run_anim" }
		},
		addlayer = {
			"wardstaff_arcana_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 },
			{ name = "wardstaff", weight = 1 }
		}
	}
)
