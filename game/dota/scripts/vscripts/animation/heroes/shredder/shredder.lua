--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\shredder\shredder.mdl
--
--=============================================================================

model:CreateWeightlist(
	"Blade",
	{
		{ "WaistBlades", 1 }
	}
)

model:CreateWeightlist(
	"noBlade",
	{
		{ "root", 1 },
		{ "WaistBlades", 1 },
		{ "WaistBlades", 0 }
	}
)


model:CreateSequence(
	{
		name = "spawn",
		sequences = {
			{ "@spawn" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_SPAWN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "idle",
		sequences = {
			{ "@idle" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "idle_rare1",
		sequences = {
			{ "@idle_rare1" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_IDLE_RARE", weight = 1 }
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
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "Attack_1",
		sequences = {
			{ "@Attack_1" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "Attack_2",
		sequences = {
			{ "@Attack_2" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "Attack_3",
		sequences = {
			{ "@Attack_3" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "Attack_4",
		sequences = {
			{ "@Attack_4" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "injured",
		sequences = {
			{ "@injured" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "injured_attack",
		sequences = {
			{ "@injured_attack" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_ATTACK", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "injured_idle",
		sequences = {
			{ "@injured_idle" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "stun",
		sequences = {
			{ "@stun" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_DISABLED", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "flail",
		sequences = {
			{ "@flail" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_FLAIL", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "whirlingDeath",
		sequences = {
			{ "@whirlingDeath" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_1", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "timberChain",
		sequences = {
			{ "@timberChain" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "chakram",
		sequences = {
			{ "@chakram" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_4", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "chakram_aghs",
		sequences = {
			{ "@chakram_aghs" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_6", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "teleport_end",
		sequences = {
			{ "@teleport_end" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_TELEPORT_END", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "idle_chakram",
		sequences = {
			{ "@idle_chakram" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_IDLE", weight = 1 },
			{ name = "chakram", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_chakram",
		sequences = {
			{ "@run_chakram" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "chakram", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "portrait",
		sequences = {
			{ "@portrait" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_CAPTURE", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "bladesSpin",
		sequences = {
			{ "@bladesSpin" }
		},
		weightlist = "Blade",
		activities = {
			{ name = "ACT_DOTA_CONSTANT_LAYER", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "teleport",
		sequences = {
			{ "@teleport" }
		},
		weightlist = "noBlade",
		activities = {
			{ name = "ACT_DOTA_TELEPORT", weight = 1 }
		}
	}
)
