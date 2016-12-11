--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\phoenix\phoenix_bird.mdl
--
--=============================================================================

model:CreateWeightlist(
	"Wings_Only",
	{
		{ "clavicle_R", 1 },
		{ "clavicle_L", 1 },
		{ "Tail_base", 1 },
		{ "Tail_base", 0 },
		{ "TailR_R0C0", 0 },
		{ "Tail_R0C0", 0 }
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
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"bird_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 8 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_haste",
		sequences = {
			{ "@run_haste" }
		},
		addlayer = {
			"bird_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)
