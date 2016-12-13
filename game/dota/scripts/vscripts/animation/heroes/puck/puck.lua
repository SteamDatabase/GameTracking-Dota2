--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\puck\puck.mdl
--
--=============================================================================

model:CreateWeightlist(
	"body_no_wings",
	{
		{ "wing_r2a", 0 },
		{ "wing_l2a", 0 },
		{ "wing_r0a", 0 },
		{ "wing_r1a", 0 },
		{ "wing_l1a", 0 },
		{ "wing_l0a", 0 },
		{ "root", 1 }
	}
)

model:CreateWeightlist(
	"wings",
	{
		{ "root", 0 },
		{ "wing_r2a", 1 },
		{ "wing_l0a", 1 },
		{ "wing_r0a", 1 },
		{ "wing_l2a", 1 },
		{ "wing_l1a", 1 },
		{ "wing_r1a", 1 }
	}
)


model:CreateSequence(
	{
		name = "attack_no_wings",
		sequences = {
			{ "@attack_no_wings" }
		},
		weightlist = "body_no_wings"
	}
)


model:CreateSequence(
	{
		name = "wings",
		sequences = {
			{ "@wings" }
		},
		weightlist = "wings",
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
		}
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turns_no_wings_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_no_wings", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_no_wings", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_no_wings_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_no_wings", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_no_wings", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turns_no_wings_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turns_no_wings", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turns_no_wings", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turns_no_wings",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turns_no_wings_lookFrame_0", "@turns_no_wings_lookFrame_1", "@turns_no_wings_lookFrame_2" }
		},
		weightlist = "body_no_wings"
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


model:CreateSequence(
	{
		name = "run_no_wings",
		sequences = {
			{ "@run_no_wings" }
		},
		addlayer = {
			"turns_no_wings"
		},
		weightlist = "body_no_wings"
	}
)


model:CreateSequence(
	{
		name = "versus_dive",
		sequences = {
			{ "@victory" }
		},
		addlayer = {
			"wings"
		},
		activities = {
			{ name = "ACT_DOTA_VERSUS", weight = 1 }
		}
	}
)

