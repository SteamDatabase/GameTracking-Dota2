--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\particle\cracked_boulder.mdl
--
--=============================================================================


model:CreateSequence(
	{
		name = "cracked_boulder_build",
		framerangesequence = "@cracked_boulder_build",
		cmds = {
			{ cmd = "reversesequence", sequence = "@cracked_boulder_build", dst = 0 }
		}
	}
)
