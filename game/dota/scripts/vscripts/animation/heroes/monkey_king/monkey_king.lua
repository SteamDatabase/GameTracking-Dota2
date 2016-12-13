-- WeightList
model:CreateWeightlist(
	"upperBody",
	{
		{ "root", 1.0 },
		{ "spine1", 1.0 },
		{ "spine2", 1.0 },
		{ "weapon", 1.0 }
	}
)
-- AsLookLayer
model:CreateSequence(
	{
		name = "@mk_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mk_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mk_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@mk_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mk_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mk_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@mk_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mk_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mk_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "mk_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@mk_turns_lookFrame_0", "@mk_turns_lookFrame_1", "@mk_turns_lookFrame_2" }
		}
	}
)

-- AsLookLayer
model:CreateSequence(
	{
		name = "@mk_turns_arcana_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mk_turns_arcana", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mk_turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@mk_turns_arcana_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mk_turns_arcana", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mk_turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@mk_turns_arcana_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@mk_turns_arcana", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@mk_turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "mk_turns_arcana",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@mk_turns_arcana_lookFrame_0", "@mk_turns_arcana_lookFrame_1", "@mk_turns_arcana_lookFrame_2" }
		}
	}
)
-- AsTurningRun

model:CreateSequence(
	{
		name = "mk_jog",
		sequences = {
			{ "@mk_jog" }
		},
		addlayer = {
			"mk_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "walk", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "mk_run",
		sequences = {
			{ "@mk_run" }
		},
		addlayer = {
			"mk_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "mk_run_fast",
		sequences = {
			{ "@mk_run_fast" }
		},
		addlayer = {
			"mk_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run_fast", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "mk_jog_injured",
		sequences = {
			{ "@mk_jog_injured" }
		},
		addlayer = {
			"mk_turns"
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
		name = "mk_run_injured",
		sequences = {
			{ "@mk_run_injured" }
		},
		addlayer = {
			"mk_turns"
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
		name = "mk_run_fast_injured",
		sequences = {
			{ "@mk_run_fast_injured" }
		},
		addlayer = {
			"mk_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "run_fast", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "cloudrun_arcana",
		sequences = {
			{ "@cloudrun" }
		},
		addlayer = {
			"mk_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "arcana", weight = 1 },
			{ name = "cloudrun", weight = 1 },
			{ name = "run", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "cloudrunfast_arcana",
		sequences = {
			{ "@cloudrun" }
		},
		addlayer = {
			"mk_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "arcana", weight = 1 },
			{ name = "cloudrun", weight = 1 },
			{ name = "run_fast", weight = 1 }
		}
	}
)