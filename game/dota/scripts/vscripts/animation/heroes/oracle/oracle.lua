--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\oracle\oracle.mdl
--
--=============================================================================

model:CreateWeightlist(
	"ball",
	{
		{ "ball", 0 },
		{ "ball_in", 1 }
	}
)

model:CreateWeightlist(
	"no_ball",
	{
		{ "root", 1 },
		{ "ball", 1 },
		{ "ball_in", 0 }
	}
)


model:CreateSequence(
	{
		name = "attack",
		sequences = {
			{ "@attack" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack_fast",
		sequences = {
			{ "@attack_fast" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 },
			{ name = "fast", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack_faster",
		sequences = {
			{ "@attack_faster" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 },
			{ name = "faster", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack_fastest",
		sequences = {
			{ "@attack_fastest" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 },
			{ name = "fastest", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack2",
		sequences = {
			{ "@attack2" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack2_fast",
		sequences = {
			{ "@attack2_fast" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK2", weight = 1 },
			{ name = "fast", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack2_faster",
		sequences = {
			{ "@attack2_faster" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK2", weight = 1 },
			{ name = "faster", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack2_fastest",
		sequences = {
			{ "@attack2_fastest" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK2", weight = 1 },
			{ name = "fastest", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack2_injured",
		sequences = {
			{ "@attack2_injured" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack2_injured_duplicate",
		sequences = {
			{ "@attack2_injured_duplicate" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_ATTACK2", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "idle",
		sequences = {
			{ "@idle" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 }
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

-- AsTurningRun

model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turns"
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "stun",
		sequences = {
			{ "@stun" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_DISABLED", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flail",
		sequences = {
			{ "@flail" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_FLAIL", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "cast1_FortunesEnd",
		sequences = {
			{ "@cast1_FortunesEnd" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_STATUE_SEQUENCE", weight = 1 }
		}
	}
)
model:CreateSequence(
	{
		name = "cast1_FortunesEnd_anim",
		sequences = {
			{ "@cast1_FortunesEnd_anim" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "cast1_FortunesEnd_Resolve",
		sequences = {
			{ "@cast1_FortunesEnd_Resolve" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1_END", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "cast2_Fates_Edict",
		sequences = {
			{ "@cast2_Fates_Edict" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "cast3_Purifying_Flames",
		sequences = {
			{ "@cast3_Purifying_Flames" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_3", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "cast4_False_Promise",
		sequences = {
			{ "@cast4_False_Promise" }
		},
		weightlist = "no_ball",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_4", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ball_layer",
		sequences = {
			{ "@ball_layer" }
		},
		weightlist = "ball",
		activities = {
			{ name = "ACT_DOTA_CONSTANT_LAYER", weight = 1 }
		}
	}
)
