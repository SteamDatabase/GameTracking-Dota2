--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\visage\visage_familiar.mdl
--
--=============================================================================

model:CreateWeightlist(
	"chainHead",
	{
		{ "head", 1 },
		{ "chainBase1_0", 1 },
		{ "neck1", 1 }
	}
)


model:CreateSequence(
	{
		name = "familiar_attack",
		sequences = {
			{ "@familiar_attack" }
		},
		weightlist = "chainHead",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@familiar_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@familiar_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@familiar_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@familiar_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@familiar_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@familiar_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@familiar_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@familiar_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@familiar_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "familiar_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@familiar_turns_lookFrame_0", "@familiar_turns_lookFrame_1", "@familiar_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "familiar_run",
		sequences = {
			{ "@familiar_run" }
		},
		addlayer = {
			"familiar_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
