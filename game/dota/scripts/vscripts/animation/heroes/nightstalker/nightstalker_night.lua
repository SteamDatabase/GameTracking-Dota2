--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\nightstalker\nightstalker_night.mdl
--
--=============================================================================

model:CreateWeightlist(
	"night_daytonightulti",
	{
		{ "root", 0 },
		{ "spine1", 1 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@night_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@night_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@night_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@night_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@night_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@night_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@night_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@night_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@night_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "night_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@night_turns_lookFrame_0", "@night_turns_lookFrame_1", "@night_turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "night_daytonightulti",
		sequences = {
			{ "@night_daytonightulti" }
		},
		weightlist = "night_daytonightulti",
		activities = {
			{ name = "ACT_DOTA_NIGHTSTALKER_TRANSITION", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "night_run_injured",
		sequences = {
			{ "@night_run_injured" }
		},
		addlayer = {
			"night_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "night_run",
		sequences = {
			{ "@night_run" }
		},
		addlayer = {
			"night_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "night_run_withalt",
		sequences = {
			{ "@night_run_withalt" }
		},
		addlayer = {
			"night_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
