--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\Ursa\ursa.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "Head_1", 1 },
		{ "Spine_3", 1 },
		{ "Spine_2", 1 },
		{ "clavicle_R", 0 },
		{ "Head_0", 0 },
		{ "clavicle_L", 0 },
		{ "backHair6_0", 0 },
		{ "ear1_0_R", 0 },
		{ "ear0_0_L", 0 },
		{ "backHair7_0", 0 },
		{ "Spine_1", 0.4 },
		{ "Spine_0", 0.2 },
		{ "bicep_L", 0.5 },
		{ "bicep_R", 0.5 },
		{ "elbow_R", 0 },
		{ "elbow_L", 0 }
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


model:CreateSequence(
	{
		name = "enrage_gesture",
		sequences = {
			{ "@enrage_gesture" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "overpower_gesture",
		sequences = {
			{ "@overpower_gesture" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 }
		}
	}
)


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
