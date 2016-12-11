--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\creeps\mega_greevil\mega_greevil.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upBody",
	{
		{ "spine1", 1 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@mg_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mg_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@mg_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mg_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@mg_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mg_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mg_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "mg_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@mg_turns_lookFrame_0", "@mg_turns_lookFrame_1", "@mg_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "mg_run",
		sequences = {
			{ "@mg_run" }
		},
		addlayer = {
			"mg_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "mg_spawn",
		sequences = {
			{ "@mg_spawn" }
		},
		weightlist = "upBody",
		activities = {
			{ name = "ACT_DOTA_SPAWN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "roshan_run",
		sequences = {
			{ "@roshan_run" }
		},
		addlayer = {
			"mg_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "roshan", weight = 1 }
		}
	}
)
