

model:CreateSequence(
	{
		name = "radiant_tower002",
		framerangesequence = "@radiant_tower002_attack",
		cmds = {
			{ cmd = "sequence", sequence = "@radiant_tower002_attack", dst = 1 },
			{ cmd = "fetchframe", sequence = "@radiant_tower002_attack", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)
