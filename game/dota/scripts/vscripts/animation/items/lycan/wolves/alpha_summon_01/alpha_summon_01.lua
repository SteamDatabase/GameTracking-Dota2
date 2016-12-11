--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- qc:  models/items/lycan/wolves/alpha_summon_01/alpha_summon_01.qc
-- mdl: items/lycan/wolves/alpha_summon_01/alpha_summon_01.mdl
--
--=============================================================================

model:CreateSequence(
	{
		name = "@summon_wolves_howl",
		delta = true,
		fadeInTime = 0,
		fadeOutTime = 0,
		fps = 30,
		framerangesequence = "alpha_summon_01_anim_ability2.dmx",
		cmds = {
			{ cmd = "sequence", sequence = "alpha_summon_01_anim_ability2.dmx", dst = 1 },
			{ cmd = "fetchframe", sequence = "alpha_summon_01_anim_ability2.dmx", frame = 0, dst = 2 },
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

