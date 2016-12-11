


model:CreateSequence(
	{
		name = "ability_02_roll_end_anim",
		sequences = {
			{ "@jade_reckoning_boulder_roll_end" }
		},
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END", weight = 1 },
			{ name = "jade", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ability_02_roll_start",
		sequences = {
			{ "@jade_reckoning_boulder_roll_start" }
		},
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START", weight = 1 },
			{ name = "jade", weight = 1 }
		}
	}
)
