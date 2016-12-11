--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\abaddon\abaddon.mdl
--
--=============================================================================

model:CreateWeightlist(
	"gesture_rider",
	{
		{ "spine2_1", 0.4 },
		{ "spine2_2", 0.6 },
		{ "spine2_3", 0.7 },
		{ "spine2_4", 1 },
		{ "neck11", 1 },
		{ "head1", 1 },
		{ "tassel_R", 1 },
		{ "tassel_L", 1 },
		{ "clavicle_R", 1 },
		{ "bicep_R", 1 },
		{ "elbow_R", 1 },
		{ "wrist_R", 1 },
		{ "Thumb_0_R1", 1 },
		{ "Thumb_1_R1", 1 },
		{ "Thumb_2_R", 1 },
		{ "Index_0_R1", 1 },
		{ "Cloth_R0C0", 1 },
		{ "Cloth_R1C0", 0 },
		{ "Cloth_R0C1", 0 },
		{ "Cloth_R0C2", 0 },
		{ "neck1", 1 },
		{ "rein_Cloth_R0C1", 0 },
		{ "rein_Cloth_R0C0", 0 },
		{ "rein_Cloth_R0C3", 0 },
		{ "rein_Cloth_R0C2", 0 }
		--{ "Cloth_R4C0", 0 },
		--{ "Cloth_R0C0", 1 },
		--{ "Cloth_R0C0", 1 },
		--{ "Cloth_R0C0", 1 },
		--{ "Cloth_R0C0", 1 },
		--{ "Cloth_R0C0", 1 },
		--{ "rein1_4", 0 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_lookFrame_0", "@turns_lookFrame_1", "@turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "aggressive_run",
		sequences = {
			{ "@aggressive_run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "aggressive_run_mace",
		sequences = {
			{ "@aggressive_run_mace" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "aggressive", weight = 1 },
			{ name = "mace", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "borrow_time_cast",
		sequences = {
			{ "@borrow_time_cast" }
		},
		weightlist = "gesture_rider",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_4", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "weapon_end_gesture",
		sequences = {
			{ "@weapon_end_gesture" }
		},
		weightlist = "gesture_rider",
		activities = {
			{ name = "ACT_DOTA_RELAX_START", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "weapon_gesture",
		sequences = {
			{ "@weapon_gesture" }
		},
		weightlist = "gesture_rider",
		activities = {
			{ name = "ACT_DOTA_RELAX_END", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_injured",
		sequences = {
			{ "@run_injured" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)
