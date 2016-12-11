--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\items\venomancer\centipede_ward\centipede_ward.mdl
--
--=============================================================================


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "ward_attack_multi",
		poseParamX = model:CreatePoseParameter( "aim", -1, 1, 0, false ),
		sequences = {
			{ "ward_attack_minus179", "ward_attack_minus90", "ward_attackN", "ward_attack90", "ward_attack180" }
		},
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "ward_idle_multi",
		poseParamX = model:CreatePoseParameter( "aim", -1, 1, 0, false ),
		sequences = {
			{ "ward_idle_minus179", "ward_idle_minus90", "ward_idleN", "ward_idle90", "ward_idle180" }
		},
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 }
		}
	}
)

-- DmeMultiSequence
model:CreateSequence(
	{
		name = "ward_die_multi",
		poseParamX = model:CreatePoseParameter( "aim", -1, 1, 0, false ),
		sequences = {
			{ "ward_die_minus179", "ward_die_minus90", "ward_die", "ward_die90", "ward_die180" }
		},
		activities = {
			{ name = "ACT_DOTA_DIE", weight = 1 }
		}
	}
)