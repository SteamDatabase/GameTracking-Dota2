--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\skywrath_mage\skywrath_mage.mdl
--
--=============================================================================



-- AsLookLayer
model:CreateSequence(
	{
		name = "@skywrath_mage_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@skywrath_mage_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@skywrath_mage_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@skywrath_mage_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@skywrath_mage_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@skywrath_mage_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@skywrath_mage_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@skywrath_mage_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@skywrath_mage_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "skywrath_mage_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@skywrath_mage_turns_lookFrame_0", "@skywrath_mage_turns_lookFrame_1", "@skywrath_mage_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "skywrath_mage_run_aggressive_anim",
		sequences = {
			{ "@skywrath_mage_run_aggressive" }
		},
		addlayer = {
			"skywrath_mage_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "skywrath_mage_run_glide_anim",
		sequences = {
			{ "@skywrath_mage_run_glide" }
		},
		addlayer = {
			"skywrath_mage_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "skywrath_mage_run_injured_anim",
		sequences = {
			{ "@skywrath_mage_run_injured" }
		},
		addlayer = {
			"skywrath_mage_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)
