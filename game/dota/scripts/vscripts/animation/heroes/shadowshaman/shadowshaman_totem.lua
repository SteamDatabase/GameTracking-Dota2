--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\shadowshaman\shadowshaman_totem.mdl
--
--=============================================================================


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "ss_totem_attack_multi",
		poseParamX = model:CreatePoseParameter( "aim", -1, 1, 0, false ),
		sequences = {
			{ "ss_totem_attack_minus179", "ss_totem_attack_minus90", "ss_totem_attack", "ss_totem_attack_90", "ss_totem_attack_180" }
		},
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "ss_totem_idle_multi",
		poseParamX = model:CreatePoseParameter( "aim", -1, 1, 0, false ),
		sequences = {
			{ "ss_totem_idle_minus179", "ss_totem_idle_minus90", "ss_totem_idle", "ss_totem_idle90", "ss_totem_idle180" }
		},
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 }
		}
	}
)

