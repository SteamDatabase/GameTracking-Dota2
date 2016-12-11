--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\sven\sven.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "thigh_R", 0 },
		{ "thigh_L", 0 },
		{ "root", 0.35 },
		{ "spine1", 0.65 },
		{ "spine2", 1 }
	}
)


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turn layer_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn layer", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn layer_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn layer", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn layer_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn layer", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn layer", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turn layer",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turn layer_lookFrame_0", "@turn layer_lookFrame_1", "@turn layer_lookFrame_2" }
		}
	}
)


model:CreateSequence(
	{
		name = "warcry",
		sequences = {
			{ "@warcry" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "gods_strength",
		sequences = {
			{ "@gods_strength" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@shield_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@shield_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@shield_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@shield_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@shield_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@shield_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@shield_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@shield_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@shield_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "shield_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@shield_turns_lookFrame_0", "@shield_turns_lookFrame_1", "@shield_turns_lookFrame_2" }
		}
	}
)

-- AsTurningRun

model:CreateSequence(
	{
		name = "shield_runN_anim",
		sequences = {
			{ "@shield_runN" }
		},
		addlayer = {
			"shield_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "sven_shield", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "shield_runN_free_to_play_anim",
		sequences = {
			{ "@shield_runN_free_to_play" }
		},
		addlayer = {
			"shield_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "sven_shield", weight = 1 },
			{ name = "fear", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "shield_warcry_runN",
		sequences = {
			{ "@shield_warcry_runN" }
		},
		addlayer = {
			"shield_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "sven_shield", weight = 1 },
			{ name = "sven_warcry", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "shield_warcry",
		sequences = {
			{ "@shield_warcry" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_3", weight = 1 },
			{ name = "sven_shield", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "shield_warcry_gods_strength",
		sequences = {
			{ "@shield_warcry_gods_strength" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 },
			{ name = "sven_warcry", weight = 1 },
			{ name = "sven_shield", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "runN_anim",
		sequences = {
			{ "@runN" }
		},
		addlayer = {
			"turn layer"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
