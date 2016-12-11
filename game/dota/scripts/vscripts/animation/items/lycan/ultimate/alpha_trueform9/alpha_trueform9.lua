--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\items\lycan\ultimate\alpha_trueform9\alpha_trueform9.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@lycan_wolf_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lycan_wolf_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lycan_wolf_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@lycan_wolf_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lycan_wolf_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lycan_wolf_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@lycan_wolf_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@lycan_wolf_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@lycan_wolf_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "lycan_wolf_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@lycan_wolf_turns_lookFrame_0", "@lycan_wolf_turns_lookFrame_1", "@lycan_wolf_turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "lycan_wolf_run",
		sequences = {
			{ "@lycan_wolf_run" }
		},
		addlayer = {
			"lycan_wolf_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
