--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\creeps\lane_creeps\creep_bad_melee_diretide\creep_bad_melee_diretide.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@bad_melee_diretide_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bad_melee_diretide_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bad_melee_diretide_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@bad_melee_diretide_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bad_melee_diretide_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bad_melee_diretide_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@bad_melee_diretide_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bad_melee_diretide_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bad_melee_diretide_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "bad_melee_diretide_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@bad_melee_diretide_turns_lookFrame_0", "@bad_melee_diretide_turns_lookFrame_1", "@bad_melee_diretide_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "bad_melee_diretide_run",
		sequences = {
			{ "@bad_melee_diretide_run" }
		},
		addlayer = {
			"bad_melee_diretide_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "bad_melee_diretide_run_alt",
		sequences = {
			{ "@bad_melee_diretide_run_alt" }
		},
		addlayer = {
			"bad_melee_diretide_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
