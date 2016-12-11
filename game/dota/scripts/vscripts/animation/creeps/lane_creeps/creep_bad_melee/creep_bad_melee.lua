--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\creeps\lane_creeps\creep_bad_melee\creep_bad_melee.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "flinch",
		framerangesequence = "@flinch",
		cmds = {
			{ cmd = "sequence", sequence = "@flinch", dst = 1 },
			{ cmd = "fetchframe", sequence = "@flinch", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_FLINCH", weight = 1 }
		}
	}
)
