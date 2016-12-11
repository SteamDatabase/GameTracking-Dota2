--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\razor\razor.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "razor_plasma_field",
		framerangesequence = "@razor_plasma_field",
		cmds = {
			{ cmd = "sequence", sequence = "@razor_plasma_field", dst = 1 },
			{ cmd = "fetchframe", sequence = "@razor_plasma_field", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_1", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "razor_ti6_plasma_field",
		framerangesequence = "@razor_ti6_plasma_field",
		cmds = {
			{ cmd = "sequence", sequence = "@razor_ti6_plasma_field", dst = 1 },
			{ cmd = "fetchframe", sequence = "@razor_ti6_plasma_field", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_1", weight = 1 },
			{ name = "ti6", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "razor_static_link",
		framerangesequence = "@razor_static_link",
		cmds = {
			{ cmd = "sequence", sequence = "@razor_static_link", dst = 1 },
			{ cmd = "fetchframe", sequence = "razor_idle", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_2", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "razor_eye",
		framerangesequence = "@razor_eye",
		cmds = {
			{ cmd = "sequence", sequence = "@razor_eye", dst = 1 },
			{ cmd = "fetchframe", sequence = "@razor_eye", frame = 0, dst = 2 },
			{ cmd = "subtract", dst = 1, src = 2 },
			{ cmd = "add", dst = 0, src = 1 }
		},
		activities = {
			{ name = "ACT_DOTA_OVERRIDE_ABILITY_4", weight = 1 }
		}
	}
)



-- AsLookLayer
model:CreateSequence(
	{
		name = "@razor_turns_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@razor_turns", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@razor_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@razor_turns_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@razor_turns", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@razor_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@razor_turns_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@razor_turns", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@razor_turns", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "razor_turns",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@razor_turns_lookFrame_0", "@razor_turns_lookFrame_1", "@razor_turns_lookFrame_2" }
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
			"razor_turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)
