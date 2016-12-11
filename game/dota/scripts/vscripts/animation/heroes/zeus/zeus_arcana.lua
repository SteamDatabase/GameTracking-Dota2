-- WeightList


-- AsLookLayer
model:CreateSequence(
	{
		name = "@zeus_turns_arcana_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@zeus_turns_arcana", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@zeus_turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@zeus_turns_arcana_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@zeus_turns_arcana", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@zeus_turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@zeus_turns_arcana_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@zeus_turns_arcana", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@zeus_turns_arcana", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "zeus_turns_arcana",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@zeus_turns_arcana_lookFrame_0", "@zeus_turns_arcana_lookFrame_1", "@zeus_turns_arcana_lookFrame_2" }
		}
	}
)

model:CreateSequence(
	{
		name = "zeus_lightning_turns_arcana",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@zeus_turns_arcana_lookFrame_0", "@zeus_turns_arcana_lookFrame_1", "@zeus_turns_arcana_lookFrame_2" }
		}
	}
)

-- AsTurningRun



model:CreateSequence(
	{
		name = "zeus_run_arcana",
		sequences = {
			{ "@zeus_run_arcana" }
		},
		addlayer = {
			"zeus_turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
model:CreateSequence(
	{
		name = "zeus_run_haste_arcana",
		sequences = {
			{ "@zeus_run_haste_arcana" }
		},
		addlayer = {
			"zeus_turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)
model:CreateSequence(
	{
		name = "zeus_lightning_run_arcana",
		sequences = {
			{ "@zeus_lightning_run_arcana" }
		},
		addlayer = {
			"zeus_lightning_turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "lightning", weight = 1 }
		}
	}
)
model:CreateSequence(
	{
		name = "zeus_lightning_run_haste",
		sequences = {
			{ "@zeus_lightning_run_haste" }
		},
		addlayer = {
			"zeus_lightning_turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "lightning", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)
model:CreateSequence(
	{
		name = "zeus_lightning_run_injured_arcana",
		sequences = {
			{ "@zeus_lightning_run_injured_arcana" }
		},
		addlayer = {
			"zeus_lightning_turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "lightning", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)
model:CreateSequence(
	{
		name = "zeus_run_injured_arcana",
		sequences = {
			{ "@zeus_run_injured_arcana" }
		},
		addlayer = {
			"zeus_turns_arcana"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
			
		}
	}
)
