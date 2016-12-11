--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\lycan\summon_wolves.mdl
--
--=============================================================================

model:CreateWeightlist(
	"neck_up",
	{
		{ "neck1", 1 },
		{ "ear_R_R0C0", 0 },
		{ "ear_L_R0C0", 0 },
		{ "spine2", 0 },
		{ "spine1", 0 },
		{ "clavicle_L", 0 },
		{ "clavicle_R", 0 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@summon_wolves_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@summon_wolves_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@summon_wolves_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@summon_wolves_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@summon_wolves_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@summon_wolves_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@summon_wolves_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@summon_wolves_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@summon_wolves_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "summon_wolves_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@summon_wolves_turns_lookFrame_0", "@summon_wolves_turns_lookFrame_1", "@summon_wolves_turns_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "summon_wolves_howl",
		sequences = {
			{ "@summon_wolves_howl" }
		},
		weightlist = "neck_up",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "summon_wolves_run",
		sequences = {
			{ "@summon_wolves_run" }
		},
		addlayer = {
			"summon_wolves_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
