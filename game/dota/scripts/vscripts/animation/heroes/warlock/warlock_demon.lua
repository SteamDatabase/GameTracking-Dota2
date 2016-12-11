--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\warlock\warlock_demon.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@warlock_demon_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@warlock_demon_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@warlock_demon_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@warlock_demon_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@warlock_demon_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@warlock_demon_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@warlock_demon_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@warlock_demon_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@warlock_demon_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "warlock_demon_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@warlock_demon_turns_lookFrame_0", "@warlock_demon_turns_lookFrame_1", "@warlock_demon_turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "warlock_demon_run",
		sequences = {
			{ "@warlock_demon_run" }
		},
		addlayer = {
			"warlock_demon_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
