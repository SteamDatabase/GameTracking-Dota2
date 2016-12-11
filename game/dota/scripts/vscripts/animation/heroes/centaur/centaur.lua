--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\centaur\centaur.mdl
--
--=============================================================================

model:CreateWeightlist(
	"UpperBody",
	{
		{ "spine1", 1 },
		{ "LShield_R0C0", 0 },
		{ "RShield_R0C0", 0 },
		{ "spine1_1", 0 },
		{ "root", 1 },
		{ "wrist_A_R", 0 },
		{ "clavicle_A_R", 0 },
		{ "clavicle_A_L", 1 },
		{ "clavicle_A_L", 1 },
		{ "clavicle_A_L", 0 }
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_new_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_new_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_new_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_new",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_new_lookFrame_0", "@turns_new_lookFrame_1", "@turns_new_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_anim",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turns_new"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_new_injured_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new_injured", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new_injured", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_new_injured_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new_injured", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new_injured", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_new_injured_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_new_injured", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_new_injured", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_new_injured",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_new_injured_lookFrame_0", "@turns_new_injured_lookFrame_1", "@turns_new_injured_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "run_new_injured_anim",
		sequences = {
			{ "@run_new_injured" }
		},
		addlayer = {
			"turns_new_injured"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


-- AsTurningRun

model:CreateSequence(
	{
		name = "run_new_haste_anim",
		sequences = {
			{ "@run_new_haste" }
		},
		addlayer = {
			"turns_new"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "ulti",
		sequences = {
			{ "@ulti" }
		},
		weightlist = "UpperBody",
		activities = {
			{ name = "ACT_DOTA_CENTAUR_STAMPEDE", weight = 1 }
		}
	}
)
