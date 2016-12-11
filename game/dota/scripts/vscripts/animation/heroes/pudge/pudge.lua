--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\pudge\pudge.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "apron_tie_0", 0 },
		{ "apron_R0C1", 0 },
		{ "apron_R0C0", 0 },
		{ "thigh_R", 0 },
		{ "root", 0 },
		{ "spine1", 1 }
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
		name = "pudge_walkN_anim",
		sequences = {
			{ "@pudge_walkN" }
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
		name = "pudge_rot",
		sequences = {
			{ "@pudge_rot" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_ROT", weight = 1 }
		}
	}
)

-- Harpoon Immortal

model:CreateSequence(
	{
		name = "hh_rot",
		sequences = {
			{ "@hh_rot" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_ROT", weight = 1 },
			{ name = "harpoon", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "hh_pudge_walkN",
		sequences = {
			{ "@hh_pudge_walkN" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "harpoon", weight = 1 }
		}
	}
)