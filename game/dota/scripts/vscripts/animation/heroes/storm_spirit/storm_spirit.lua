--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\storm_spirit\storm_spirit.mdl
--
--=============================================================================


-- AsLookLayer
model:CreateSequence(
	{
		name = "@turn_lookFrame_0",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn", frame = 0, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn_lookFrame_1",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "@turn_lookFrame_2",
		snap = true,
		delta = true,
		hidden = true,
		cmds = {
			{ cmd = "fetchframe", sequence = "@turn", frame = 2, dst = 0 },
			{ cmd = "fetchframe", sequence = "@turn", frame = 1, dst = 1 },
			{ cmd = "subtract", dst = 0, src = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "turn",
		delta = true,
		poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
		sequences = {
			{ "@turn_lookFrame_0", "@turn_lookFrame_1", "@turn_lookFrame_2" }
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
			"turn"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_injured",
		sequences = {
			{ "@run_injured" }
		},
		addlayer = {
			"turn"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_injured_overload",
		sequences = {
			{ "@run_injured_overload" }
		},
		addlayer = {
			"turn"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 },
			{ name = "overload", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "run_overload",
		sequences = {
			{ "@run_overload" }
		},
		addlayer = {
			"turn"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "overload", weight = 1 }
		}
	}
)
