--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\blood_seeker\blood_seeker.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "thirst_gesture",
		framerangesequence = "@thirst_gesture",
		cmds = {
			{ cmd = "sequence", sequence = "@thirst_gesture", dst = 1 },
			{ cmd = "fetchframe", sequence = "attack2_thirst", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_BLOODSEEKER_THIRST", weight = 1 }
		}
	}
)
