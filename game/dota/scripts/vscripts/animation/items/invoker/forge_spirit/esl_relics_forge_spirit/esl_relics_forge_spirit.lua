--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- qc:  models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.qc
-- mdl: items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.mdl
--
--=============================================================================

model:CreateSequence(
	{
		name = "forge_spirit_turn_center",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "esl_relics_forge_spirit_anim_turnposecenter.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "esl_relics_forge_spirit_anim_turnposecenter.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "forge_spirit_turn_left",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "esl_relics_forge_spirit_anim_turnposeleft.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "esl_relics_forge_spirit_anim_turnposeleft.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "forge_spirit_turn_right",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "esl_relics_forge_spirit_anim_turnposeright.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "esl_relics_forge_spirit_anim_turnposeright.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "slerp", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "forge_spirit_turns",
		delta = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "forge_spirit_turn_left", "forge_spirit_turn_center", "forge_spirit_turn_right" }
		}
	}
)


model:CreateSequence(
	{
		name = "forge_spirit_runx",
		looping = true,
		fadeInTime = 0.2,
		fadeOutTime = 0.2,
		sequences = {
			{ "@forge_spirit_runx" }
		},
		addlayer = { "forge_spirit_turns" },
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

