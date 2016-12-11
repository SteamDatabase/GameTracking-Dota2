-- WeightList
model:CreateWeightlist(
	"upperBody",
	{
		{ "root", 0.3 },
		{ "spine1", 0.25 },
		{ "spine2", 1 }
	}
)
-- AsLookLayer
model:CreateSequence(
	{
		name = "@au_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@au_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@au_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@au_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@au_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@au_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@au_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@au_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@au_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@au_turns_lookFrame_0", "@au_turns_lookFrame_1", "@au_turns_lookFrame_2" }
		}
	}
)


-- AsTurningRun



model:CreateSequence(
	{
		name = "au_walk",
		sequences = {
			{ "@au_walk" }
		},
		addlayer = {
			"au_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "walk", weight = 5 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_walk_look",
		sequences = {
			{ "@au_walk_look" }
		},
		addlayer = {
			"au_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "walk", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_walk_injured",
		sequences = {
			{ "@au_walk_injured" }
		},
		addlayer = {
			"au_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "walk", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_run",
		sequences = {
			{ "@au_run" }
		},
		addlayer = {
			"au_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 3 },
			{ name = "run", weight = 5 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_run_look",
		sequences = {
			{ "@au_run_look" }
		},
		addlayer = {
			"au_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_run_injured",
		sequences = {
			{ "@au_run_injured" }
		},
		addlayer = {
			"au_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_run_haste",
		sequences = {
			{ "@au_run_haste" }
		},
		addlayer = {
			"au_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_cast04_cancel_dark_rift",
		sequences = {
			{ "@au_cast04_cancel_dark_rift" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_cast04_cancel_dark_rift_injured",
		sequences = {
			{ "@au_cast04_cancel_dark_rift_injured" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "au_cast04_cancel_dark_rift_test",
		framerangesequence = "@au_cast04_cancel_dark_rift",
		cmds = {
			{ cmd = "sequence", sequence = "@au_cast04_cancel_dark_rift", dst = 1 },
			{ cmd = "fetchframe", sequence = "@au_cast04_cancel_dark_rift", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "", weight = 1 }
		}
	}
)