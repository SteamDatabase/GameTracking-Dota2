--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\twin_headed_dragon\twin_headed_dragon.mdl
--
--=============================================================================

model:CreateWeightlist(
	"icehead",
	{
		{ "neck11", 1 }
	}
)

model:CreateWeightlist(
	"firehead",
	{
		{ "neck1", 1 }
	}
)


model:CreateSequence(
	{
		name = "attack",
		sequences = {
			{ "@attack" }
		},
		weightlist = "icehead",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "attack_alt1",
		sequences = {
			{ "@attack_alt1" }
		},
		weightlist = "icehead",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "liquidfire_attack",
		sequences = {
			{ "@liquidfire_attack" }
		},
		weightlist = "firehead",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 },
			{ name = "liquid_fire", weight = 1 }
		}
	}
)
