--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\beastmaster\beastmaster_beast.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@beast_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@beast_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@beast_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@beast_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@beast_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@beast_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@beast_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@beast_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@beast_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "beast_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@beast_turns_lookFrame_0", "@beast_turns_lookFrame_1", "@beast_turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "beast_run",
		sequences = {
			{ "@beast_run" }
		},
		addlayer = {
			"beast_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
