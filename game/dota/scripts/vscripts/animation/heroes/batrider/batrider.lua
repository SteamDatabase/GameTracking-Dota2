--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\batrider\batrider.mdl
--
--=============================================================================

model:CreateWeightlist(
	"spine",
	{
		{ "head", 1 },
		{ "thigh_A_L", 1 },
		{ "tail0_0", 1 },
		{ "thigh_A_R", 1 },
		{ "root", 0 }
	}
)

model:CreateWeightlist(
	"full",
	{
		{ "root", 1 }
	}
)

model:CreateWeightlist(
	"lasso",
	{
		{ "spine1_3", 1 },
		{ "clavicle_A_L", 1 },
		{ "cape4_0", 1 },
		{ "head1", 1 },
		{ "clavicle_A_R", 1 }
	}
)


model:CreateSequence(
	{
		name = "attack",
		sequences = {
			{ "@attack" }
		},
		weightlist = "spine",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "firefly_start",
		sequences = {
			{ "@firefly_start" }
		},
		weightlist = "full",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_3", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "lasso_loop",
		sequences = {
			{ "@lasso_loop" }
		},
		weightlist = "lasso",
		activities = {
			{ name = "ACT_DOTA_LASSO_LOOP", weight = 1 }
		}
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
