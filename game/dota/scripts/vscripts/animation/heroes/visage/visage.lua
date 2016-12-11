--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\visage\visage.mdl
--
--=============================================================================

model:CreateWeightlist(
	"neck",
	{
		{ "spine1_2", 1 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@visage_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@visage_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@visage_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "visage_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@visage_turns_lookFrame_0", "@visage_turns_lookFrame_1", "@visage_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "visage_run_anim",
		sequences = {
			{ "@visage_run" }
		},
		addlayer = {
			"visage_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@visage_run_haste_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_run_haste_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@visage_run_haste_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_run_haste_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@visage_run_haste_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_run_haste_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_run_haste_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "visage_run_haste_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@visage_run_haste_turns_lookFrame_0", "@visage_run_haste_turns_lookFrame_1", "@visage_run_haste_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "visage_run_haste_anim",
		sequences = {
			{ "@visage_run_haste" }
		},
		addlayer = {
			"visage_run_haste_turns"
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
		name = "@visage_run_injured_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_run_injured_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@visage_run_injured_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_run_injured_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@visage_run_injured_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@visage_run_injured_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@visage_run_injured_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "visage_run_injured_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@visage_run_injured_turns_lookFrame_0", "@visage_run_injured_turns_lookFrame_1", "@visage_run_injured_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "visage_run_injured_anim",
		sequences = {
			{ "@visage_run_injured" }
		},
		addlayer = {
			"visage_run_injured_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "visage_attack",
		sequences = {
			{ "@visage_attack" }
		},
		weightlist = "neck",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "visage_attack_alt1",
		sequences = {
			{ "@visage_attack_alt1" }
		},
		weightlist = "neck",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)
