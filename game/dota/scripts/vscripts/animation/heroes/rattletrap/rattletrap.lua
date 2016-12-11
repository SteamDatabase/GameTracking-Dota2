--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- source1import auto-generated animation script
-- local changes will be overwritten if source1import if run again on this asset
--
-- mdl: models\heroes\rattletrap\rattletrap.mdl
--
--=============================================================================

model:CreateWeightlist(
	"upperBody",
	{
		{ "thigh_R", 0 },
		{ "thigh_L", 0 },
		{ "Spine_0", 0.5 },
		{ "Root_0", 0 },
		{ "Spine_1", 1 }
	}
)


model:CreateSequence(
	{
		name = "battery_assault",
		sequences = {
			{ "@battery_assault" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_RATTLETRAP_BATTERYASSAULT", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "power_cogs",
		sequences = {
			{ "@power_cogs" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_RATTLETRAP_POWERCOGS", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "telebolt_power_cogs",
		sequences = {
			{ "@telebolt_power_cogs" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_RATTLETRAP_POWERCOGS", weight = 1 },
			{ name = "telebolt", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "para_battery_assault",
		sequences = {
			{ "@para_battery_assault" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_RATTLETRAP_BATTERYASSAULT", weight = 1 },
			{ name = "para", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "para_power_cogs",
		sequences = {
			{ "@para_power_cogs" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_RATTLETRAP_POWERCOGS", weight = 1 },
			{ name = "para", weight = 1 }
		}
	}
)


model:CreateSequence(
	{
		name = "para_telebolt_power_cogs",
		sequences = {
			{ "@para_telebolt_power_cogs" }
		},
		weightlist = "upperBody",
		activities = {
			{ name = "ACT_DOTA_RATTLETRAP_POWERCOGS", weight = 1 },
			{ name = "telebolt", weight = 1 },
			{ name = "para", weight = 1 }
		}
	}
)
