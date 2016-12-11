--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\earth_spirit\earth_spirit.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upper_body",
	{
		{ "Spine0_JNT", 1 },
		{ "UprWeapon0_JNT", 1 },
		{ "LwrWeapon0_JNT", 1 },
		{ "Spine1_JNT", 1 },
		{ "Spine2_JNT", 1 }
	}
)

model:CreateWeightlist(
	"full_body",
	{
		{ "Root0_JNT", 1 }
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
		name = "run_anim",
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


model:CreateSequence(
	{
		name = "ability_01_staff_smash_anim",
		sequences = {
			{ "@ability_01_staff_smash" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_02_roll_end_anim",
		sequences = {
			{ "@ability_02_roll_end" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_02_roll_start",
		sequences = {
			{ "@ability_02_roll_start" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_03_geogrip",
		sequences = {
			{ "@ability_03_geogrip" }
		},
		weightlist = "upper_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_3", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_04_stone_caller_anim",
		sequences = {
			{ "@ability_04_stone_caller" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_ES_STONE_CALLER", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_aggro_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_aggro", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_aggro", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_aggro_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_aggro", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_aggro", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_aggro_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_aggro", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_aggro", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_aggro",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_aggro_lookFrame_0", "@turns_aggro_lookFrame_1", "@turns_aggro_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_aggro_anim",
		sequences = {
			{ "@run_aggro" }
		},
		addlayer = {
			"turns_aggro"
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
		name = "@turns_injured_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_injured", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_injured", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_injured_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_injured", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_injured", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_injured_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_injured", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_injured", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_injured",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_injured_lookFrame_0", "@turns_injured_lookFrame_1", "@turns_injured_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_injured_anim",
		sequences = {
			{ "@run_injured" }
		},
		addlayer = {
			"turns_injured"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_02_roll_end_injured",
		sequences = {
			{ "@ability_02_roll_end_injured" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_02_roll_start_injured",
		sequences = {
			{ "@ability_02_roll_start_injured" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_02_roll_end_aggro",
		sequences = {
			{ "@ability_02_roll_end_aggro" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_02_roll_start_aggro",
		sequences = {
			{ "@ability_02_roll_start_aggro" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_05_magnetize_ult_vibrate_anim",
		sequences = {
			{ "@ability_05_magnetize_ult_vibrate" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_6", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "ti6_ability_02_roll_end_anim",
		sequences = {
			{ "@ti6_ability_02_roll_end" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END", weight = 1 },
			{ name = "jade", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ti6_ability_02_roll_start",
		sequences = {
			{ "@ti6_ability_02_roll_start" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START", weight = 1 },
			{ name = "jade", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "ti6_ability_02_roll_endability_02_roll_end_aggro",
		sequences = {
			{ "@ti6_ability_02_roll_end_aggro" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END", weight = 1 },
			{ name = "aggressive", weight = 1 },
			{ name = "jade", weight = 1 },
		}
	}
)

model:CreateSequence(
	{
		name = "ti6_ability_02_roll_end_injured",
		sequences = {
			{ "@ti6_ability_02_roll_end_injured" }
		},
		weightlist = "full_body",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END", weight = 1 },
			{ name = "injured", weight = 1 },
			{ name = "jade", weight = 1 },
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "ti6_run_aggro_anim",
		sequences = {
			{ "@ti6_run_aggro" }
		},
		addlayer = {
			"turns_aggro"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 },
			{ name = "jade", weight = 1 },
		}
	}
)


