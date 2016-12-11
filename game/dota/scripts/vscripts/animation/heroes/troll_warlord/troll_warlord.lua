--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\troll_warlord\troll_warlord.mdl
--
--=============================================================================

model:CreateWeightlist(
	"UpperBody",
	{
		{ "spine1", 1 }
	}
)

model:CreateWeightlist(
	"UpperBody_plus",
	{
		{ "spine1", 1 },
		{ "root", 0.35 },
		{ "hip1_0", 0 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@tw_turns_melee_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@tw_turns_melee", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@tw_turns_melee", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@tw_turns_melee_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@tw_turns_melee", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@tw_turns_melee", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@tw_turns_melee_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@tw_turns_melee", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@tw_turns_melee", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "tw_turns_melee",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@tw_turns_melee_lookFrame_0", "@tw_turns_melee_lookFrame_1", "@tw_turns_melee_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "tw_run_melee_anim",
		sequences = {
			{ "@tw_run_melee" }
		},
		addlayer = {
			"tw_turns_melee"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "melee", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "tw_run_melee_haste_anim",
		sequences = {
			{ "@tw_run_melee_haste" }
		},
		addlayer = {
			"tw_turns_melee"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "melee", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "tw_run_melee_injured_anim",
		sequences = {
			{ "@tw_run_melee_injured" }
		},
		addlayer = {
			"tw_turns_melee"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "melee", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tw_cast1_ranged_to_melee",
		sequences = {
			{ "@tw_cast1_ranged_to_melee" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 },
			{ name = "melee", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tw_cast4_battle_trance_melee",
		sequences = {
			{ "@tw_cast4_battle_trance_melee" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_4", weight = 1 },
			{ name = "melee", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@tw_turns_ranged_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@tw_turns_ranged", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@tw_turns_ranged", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@tw_turns_ranged_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@tw_turns_ranged", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@tw_turns_ranged", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@tw_turns_ranged_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@tw_turns_ranged", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@tw_turns_ranged", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "tw_turns_ranged",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@tw_turns_ranged_lookFrame_0", "@tw_turns_ranged_lookFrame_1", "@tw_turns_ranged_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "tw_run_ranged_anim",
		sequences = {
			{ "@tw_run_ranged" }
		},
		addlayer = {
			"tw_turns_ranged"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "tw_run_ranged_haste",
		sequences = {
			{ "@tw_run_ranged_haste" }
		},
		addlayer = {
			"tw_turns_ranged"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "tw_run_ranged_injured",
		sequences = {
			{ "@tw_run_ranged_injured" }
		},
		addlayer = {
			"tw_turns_ranged"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tw_cast1_melee_to_ranged",
		sequences = {
			{ "@tw_cast1_melee_to_ranged" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "tw_cast4_battle_trance_ranged",
		sequences = {
			{ "@tw_cast4_battle_trance_ranged" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_4", weight = 1 }
		}
	}
)
