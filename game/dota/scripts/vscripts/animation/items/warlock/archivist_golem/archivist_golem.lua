--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- qc:  models/items/warlock/archivist_golem/archivist_golem.qc
-- mdl: items/warlock/archivist_golem/archivist_golem.mdl
--
--=============================================================================

model:CreateSequence(
	{
		name = "turn_left",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		cmds = {
			{ cmd = "fetchframe", sequence = "warlock_demon_turns.dmx", frame = 0, dst = 1 },
			{ cmd = "fetchframe", sequence = "turn_centerpose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turn_center",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		cmds = {
			{ cmd = "fetchframe", sequence = "warlock_demon_turns.dmx", frame = 1, dst = 1 },
			{ cmd = "fetchframe", sequence = "turn_centerpose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turn_right",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		cmds = {
			{ cmd = "fetchframe", sequence = "warlock_demon_turns.dmx", frame = 2, dst = 1 },
			{ cmd = "fetchframe", sequence = "turn_centerpose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns",
		delta = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "turn_left", "turn_center", "turn_right" }
		}
	}
)


model:CreateSequence(
	{
		name = "run",
		looping = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		sequences = {
			{ "@run" }
		},
		addlayer = { "turns" },
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

