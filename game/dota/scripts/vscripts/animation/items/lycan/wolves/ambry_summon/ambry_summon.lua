--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- qc:  models/items/lycan/wolves/ambry_summon/ambry_summon.qc
-- mdl: items/lycan/wolves/ambry_summon/ambry_summon.mdl
--
--=============================================================================

model:CreateSequence(
	{
		name = "@summon_wolves_howl",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "ambry_summon_anim_ability2.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "ambry_summon_anim_ability2.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "ambry_summon_anim_ability2.dmx", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "summon_wolves_turn_center",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "ambry_summon_anim_turnposecenter.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "ambry_summon_anim_turnposecenter.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "summon_wolves_turn_left",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "ambry_summon_anim_turnposeleft.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "ambry_summon_anim_turnposeleft.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "summon_wolves_turn_right",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "ambry_summon_anim_turnposeright.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "ambry_summon_anim_turnposeright.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "summon_wolves_howl",
		delta = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		sequences = {
			{ "@summon_wolves_howl" }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "summon_wolves_turns",
		delta = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "summon_wolves_turn_left", "summon_wolves_turn_center", "summon_wolves_turn_right" }
		}
	}
)


model:CreateSequence(
	{
		name = "summon_wolves_runx",
		looping = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		sequences = {
			{ "@summon_wolves_runx" }
		},
		addlayer = { "summon_wolves_turns" },
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

