--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\weaver\weaver.mdl
--
--=============================================================================

model:CreateWeightlist(
	"head",
	{
		{ "Head_0", 0 },
		{ "Root_0", 0 },
		{ "thigh_A_R", 0 },
		{ "Head_1", 1 },
		{ "lant1_0", 0 },
		{ "rant2_0", 0 }
	}
)

model:CreateWeightlist(
	"head50",
	{
		{ "Head_0", 0 },
		{ "Root_0", 0 },
		{ "thigh_A_R", 0 },
		{ "Head_0", 0.5 },
		{ "mandibleL3_0", 1 },
		{ "mandibleR4_0", 1 },
		{ "lant1_0", 0 },
		{ "rant2_0", 0 }
	}
)

model:CreateWeightlist(
	"spine",
	{
		{ "ArbitraryChain0_0", 0 },
		{ "thigh_A_L", 0 },
		{ "thigh_A_R", 0 },
		{ "thigh_L", 0 },
		{ "thigh_R", 0 },
		{ "clavicle_L", 0 },
		{ "clavicle_R", 0 },
		{ "rant2_0", 0 },
		{ "Head_0", 0 },
		{ "Root_0", 0 },
		{ "Spine_0", 1 }
	}
)


model:CreateSequence(
	{
		name = "head_loop",
		sequences = {
			{ "@head_loop" }
		},
		weightlist = "head",
		activities = {
			{ name = "ACT_DOTA_CONSTANT_LAYER", weight = 1 }
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
		},
		weightlist = "spine"
	}
)


model:CreateSequence(
	{
		name = "run_anim",
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


model:CreateSequence(
	{
		name = "run_injured_anim",
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


model:CreateSequence(
	{
		name = "run_invis_anim",
		sequences = {
			{ "@run_invis" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "shukuchi", weight = 1 }
		}
	}
)
