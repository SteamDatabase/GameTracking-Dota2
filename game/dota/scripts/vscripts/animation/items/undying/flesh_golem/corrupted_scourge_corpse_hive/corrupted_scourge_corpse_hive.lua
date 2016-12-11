--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\undying\undying_flesh_golem.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBod",
	{
		{ "spine1", 1 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@flesh_golem_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@flesh_golem_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@flesh_golem_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@flesh_golem_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@flesh_golem_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@flesh_golem_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "flesh_golem_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@flesh_golem_turns_lookFrame_0", "@flesh_golem_turns_lookFrame_1", "@flesh_golem_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "flesh_golem_run",
		sequences = {
			{ "@flesh_golem_run" }
		},
		addlayer = {
			"flesh_golem_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "flesh_golem_run_injured",
		sequences = {
			{ "@flesh_golem_run_injured" }
		},
		addlayer = {
			"flesh_golem_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "flesh_golem_run_haste",
		sequences = {
			{ "@flesh_golem_run_haste" }
		},
		addlayer = {
			"flesh_golem_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_cast1_decay",
		framerangesequence = "@decay",
		cmds = {
			{ cmd = "sequence", sequence = "@decay", dst = 1 },
			{ cmd = "fetchframe", sequence = "@decay", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_UNDYING_DECAY", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_cast1_decay_injured",
		framerangesequence = "@flesh_golem_cast1_decay_injured",
		cmds = {
			{ cmd = "sequence", sequence = "@flesh_golem_cast1_decay_injured", dst = 1 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_cast1_decay_injured", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_UNDYING_DECAY", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_cast_2_soul_rip",
		framerangesequence = "@flesh_golem_cast_2_soul_rip",
		cmds = {
			{ cmd = "sequence", sequence = "@flesh_golem_cast_2_soul_rip", dst = 1 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_cast_2_soul_rip", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_UNDYING_SOUL_RIP", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_cast_2_soul_rip_injured",
		framerangesequence = "@flesh_golem_cast_2_soul_rip_injured",
		cmds = {
			{ cmd = "sequence", sequence = "@flesh_golem_cast_2_soul_rip_injured", dst = 1 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_cast_2_soul_rip_injured", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_UNDYING_SOUL_RIP", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_cast_3_tombstone",
		framerangesequence = "@flesh_golem_cast_3_tombstone",
		cmds = {
			{ cmd = "sequence", sequence = "@flesh_golem_cast_3_tombstone", dst = 1 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_cast_3_tombstone", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_UNDYING_TOMBSTONE", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_cast_3_tombstone_injured",
		framerangesequence = "@flesh_golem_cast_3_tombstone_injured",
		cmds = {
			{ cmd = "sequence", sequence = "@flesh_golem_cast_3_tombstone_injured", dst = 1 },
			{ cmd = "fetchframe", sequence = "@flesh_golem_cast_3_tombstone_injured", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_UNDYING_TOMBSTONE", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_spawn",
		sequences = {
			{ "@flesh_golem_spawn" }
		},
		weightlist = "upperBod",
		activities = {
			{ name = "ACT_DOTA_SPAWN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flesh_golem_spawn_injured",
		sequences = {
			{ "@flesh_golem_spawn_injured" }
		},
		weightlist = "upperBod",
		activities = {
			{ name = "ACT_DOTA_SPAWN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)
