--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\beastmaster\beastmaster_bird.mdl
--
--=============================================================================

model:CreateWeightlist(
	"no_wings",
	{
		{ "clavicle_R", 0 },
		{ "clavicle_L", 0 },
		{ "bicep_A_L", 0 },
		{ "root", 0 },
		{ "neck0_0", 1 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@bird_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bird_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bird_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@bird_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bird_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bird_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@bird_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@bird_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@bird_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "bird_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@bird_turns_lookFrame_0", "@bird_turns_lookFrame_1", "@bird_turns_lookFrame_2" }
		},
		weightlist = "no_wings"
	}
)


model:CreateSequence(
	{
		name = "bird_fly",
		sequences = {
			{ "@bird_fly" }
		},
		addlayer = {
			"bird_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
