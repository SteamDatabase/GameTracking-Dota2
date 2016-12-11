--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\particle\warlock_helborn_grasp_grip.mdl
--
--=============================================================================


-- DmeMultiSequence
model:CreateSequence(
	{
		name = "hellborn_grip",
		poseParamX = model:CreatePoseParameter( "grip", 0, 1, 0, false ),
		sequences = {
			{ "hellborn_grip_attack_grab", "hellborn_grip_attack" }
		},
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 }
		}
	}
)
