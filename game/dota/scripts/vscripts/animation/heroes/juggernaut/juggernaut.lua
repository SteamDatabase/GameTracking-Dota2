--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\juggernaut\juggernaut.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_odachi_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_odachi", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_odachi", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_odachi_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_odachi", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_odachi", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_odachi_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_odachi", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_odachi", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_odachi",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_odachi_lookFrame_0", "@turns_odachi_lookFrame_1", "@turns_odachi_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_odachi_anim",
		sequences = {
			{ "@run_odachi_anim" }
		},
		addlayer = {
			"turns_odachi"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "odachi", weight = 1 }
		}
	}
)
