--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\witchdoctor\witchdoctor.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "thigh_L", 0 },
		{ "thigh_R", 0 },
		{ "root", 1 }
	}
)


model:CreateSequence(
	{
		name = "voodoo_restoration",
		sequences = {
			{ "@voodoo_restoration" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_VOODOO_REST", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "bonkers_voodoo_restoration",
		sequences = {
			{ "@bonkers_voodoo_restoration" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_VOODOO_REST", weight = 1 },
			{ name = "bonkers_the_mad", weight = 1 }
		}
	}
)
