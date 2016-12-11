--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\props_structures\tower_dragon_black.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "tower_dragon_black_attack",
		framerangesequence = "@tower_dragon_black_attack",
		cmds = {
			{ cmd = "sequence", sequence = "@tower_dragon_black_attack", dst = 1 },
			{ cmd = "fetchframe", sequence = "@tower_dragon_black_attack", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)
