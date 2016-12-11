--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\items\terrorblade\marauders_demon\marauders_demon.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperbody",
	{
		{ "Root0_JNT", 1 },
		{ "Spine0_JNT", 1 },
		{ "LeftLeg0_JNT", 0 },
		{ "RightLeg0_JNT", 0 },
		{ "RightPelvis0_JNT", 0 },
		{ "LeftPelvis0_JNT", 0 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@demonturns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@demonturns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@demonturns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@demonturns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@demonturns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@demonturns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@demonturns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@demonturns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@demonturns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "demonturns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@demonturns_lookFrame_0", "@demonturns_lookFrame_1", "@demonturns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "demon_runcycle",
		sequences = {
			{ "@demon_runcycle" }
		},
		addlayer = {
			"demonturns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 2 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "demon_runcycle_injured",
		sequences = {
			{ "@demon_runcycle_injured" }
		},
		addlayer = {
			"demonturns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 2 },
			{ name = "injured", weight = 1 }
		}
	}
)
