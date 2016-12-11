--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\bane\grip.mdl
--
--=============================================================================


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "bane_grip",
		poseParamX = model:CreatePoseParameter( "grip", 0, 1, 0, false ),
		sequences = {
			{ "bane_grip_attack_grab", "bane_grip_attack" }
		},
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 }
		}
	}
)
