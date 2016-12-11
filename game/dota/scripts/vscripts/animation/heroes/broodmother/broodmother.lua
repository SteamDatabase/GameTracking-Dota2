--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\broodmother\broodmother.mdl
--
--=============================================================================

model:CreateWeightlist(
	"torso_up",
	{
		{ "neck1", 1 },
		{ "spine1", 1 }
	}
)

model:CreateWeightlist(
	"root_only",
	{
		{ "root", 1 },
		{ "SimpleBugLeg_base_A_R", 0 },
		{ "SimpleBugLeg_base_L", 0 },
		{ "spine1", 0 },
		{ "SimpleBugLeg_base_R", 0 },
		{ "butt_start", 0 },
		{ "SimpleBugLeg_base_A_L", 0 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@broodmother_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@broodmother_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@broodmother_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@broodmother_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@broodmother_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@broodmother_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@broodmother_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@broodmother_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@broodmother_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "broodmother_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@broodmother_turns_lookFrame_0", "@broodmother_turns_lookFrame_1", "@broodmother_turns_lookFrame_2" }
		},
		weightlist = "torso_up"
	}
)


model:CreateSequence(
	{
		name = "broodmother_run",
		sequences = {
			{ "@broodmother_run" }
		},
		addlayer = {
			"broodmother_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "broodmother_run_haste",
		sequences = {
			{ "@broodmother_run_haste" }
		},
		addlayer = {
			"broodmother_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "broodmother_run_web",
		sequences = {
			{ "@broodmother_run_web" }
		},
		addlayer = {
			"broodmother_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "web", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "broodmother_run_chase",
		sequences = {
			{ "@broodmother_run_chase" }
		},
		addlayer = {
			"broodmother_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "chase", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "broodmother_run_chase_web",
		sequences = {
			{ "@broodmother_run_chase_web" }
		},
		addlayer = {
			"broodmother_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "chase", weight = 1 },
			{ name = "web", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "broodmother_run_injured",
		sequences = {
			{ "@broodmother_run_injured" }
		},
		addlayer = {
			"broodmother_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "broodmother_run_injured_web",
		sequences = {
			{ "@broodmother_run_injured_web" }
		},
		addlayer = {
			"broodmother_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 },
			{ name = "web", weight = 1 }
		}
	}
)
