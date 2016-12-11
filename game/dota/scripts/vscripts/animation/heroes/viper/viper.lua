--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\viper\viper.mdl
--
--=============================================================================

model:CreateWeightlist(
	"spine",
	{
		{ "root", 0.8 },
		{ "Arm1_0_R", 0 },
		{ "Arm0_0_L", 0 },
		{ "Tail0_0", 1 },
		{ "spine1", 1 },
		{ "spine2", 1 }
	}
)

model:CreateWeightlist(
	"full",
	{
		{ "root", 1 }
	}
)


model:CreateSequence(
	{
		name = "attack",
		sequences = {
			{ "@attack" }
		},
		weightlist = "spine",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "poison_attack",
		sequences = {
			{ "@poison_attack" }
		},
		weightlist = "spine",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 }
		}
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_lookFrame_0", "@turns_lookFrame_1", "@turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
