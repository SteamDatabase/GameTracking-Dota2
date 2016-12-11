--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\props_gameplay\roquelaire\roquelaire.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_lookFrame_0", "@turns_lookFrame_1", "@turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "fly",
		sequences = {
			{ "@fly" }
		},
		blendlayer = {
			{ sequence = "turns", startframe = "0", peakframe = "3", tailframe = "23", endframe = "26" },
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 2 }
		}
	}
)


model:CreateSequence(
	{
		name = "fly_glide",
		sequences = {
			{ "@fly_glide" }
		},
		blendlayer = {
			{ sequence = "turns", startframe = "0", peakframe = "3", tailframe = "23", endframe = "26" },
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 3 }
		}
	}
)
