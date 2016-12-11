--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\vengeful\vengeful.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "command_aura",
		framerangesequence = "@command_aura",
		cmds = {
			{ cmd = "sequence", sequence = "@command_aura", dst = 1 },
			{ cmd = "fetchframe", sequence = "@command_aura", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 }
		}
	}
)
