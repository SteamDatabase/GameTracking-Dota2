--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\axe\axe.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "thigh_L", 0 },
		{ "thigh_R", 0 },
		{ "root", 0.25 },
		{ "spine1", 1 }
	}
)


model:CreateSequence(
	{
		name = "berserkers_call",
		sequences = {
			{ "@berserkers_call" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "rampant_berserkers_call",
		sequences = {
			{ "@rampant_berserkers_call" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_1", weight = 1 },
			{ name = "rampant", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "battle_hunger",
		sequences = {
			{ "@battle_hunger" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "counter_helix",
		framerangesequence = "@counter_helix",
		cmds = {
			{ cmd = "sequence", sequence = "@counter_helix", dst = 1 },
			{ cmd = "fetchframe", sequence = "@counter_helix", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_3", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "counter_helix_blood_chaser",
		framerangesequence = "@counter_helix_blood_chaser",
		cmds = {
			{ cmd = "sequence", sequence = "@counter_helix_blood_chaser", dst = 1 },
			{ cmd = "fetchframe", sequence = "@counter_helix_blood_chaser", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_3", weight = 1 },
			{ name = "blood_chaser", weight = 1 }
		}
	}
)
