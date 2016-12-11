--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\bristleback\bristleback.mdl
--
--=============================================================================

model:CreateWeightlist(
	"quills",
	{
		{ "quill814_0", 1 },
		{ "quill915_0", 1 },
		{ "quill612_0", 1 },
		{ "quill713_0", 1 },
		{ "Spine_2", 0 },
		{ "Head_0", 0 },
		{ "clavicle_R", 0 },
		{ "clavicle_L", 0 },
		{ "Spine_3", 0 },
		{ "quill28_0", 1 },
		{ "quill10_0", 1 },
		{ "quill410_0", 1 },
		{ "quill511_0", 1 },
		{ "quill39_0", 1 }
	}
)

model:CreateWeightlist(
	"spike_quills",
	{
		{ "quill28_top_right", 1 },
		{ "quill10_piston_bot", 1 },
		{ "quill410_piston_top", 1 },
		{ "quill39_mid", 1 },
		{ "quill915_0", 1 },
		{ "quill713_0", 1 },
		{ "quill612_0", 1 },
		{ "quill814_0", 1 },
		{ "backtop5_0", 1 },
		{ "quill511_0", 0 }
	}
)


model:CreateSequence(
	{
		name = "quill_spray",
		sequences = {
			{ "@quill_spray" }
		},
		weightlist = "quills",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2", weight = 1 }
		}
	}
)



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

-- AsTurningRun

model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "spike_quill_spray",
		sequences = {
			{ "@spike_quill_spray" }
		},
		weightlist = "spike_quills",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2", weight = 1 },
			{ name = "spike", weight = 1 }
		}
	}
)
