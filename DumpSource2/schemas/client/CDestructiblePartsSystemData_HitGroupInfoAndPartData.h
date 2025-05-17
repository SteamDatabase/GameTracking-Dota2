// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MModelGameData
// MFgdHelper (UNKNOWN FOR PARSER)
class CDestructiblePartsSystemData_HitGroupInfoAndPartData
{
	// MPropertyDescription = "Data for this destructible part."
	// MPropertyAutoExpandSelf
	CUtlVector< CDestructiblePartsSystemData_PartData > m_PartsData;
	// MPropertyStartGroup = "+Hitgroup"
	// MPropertyDescription = "The hitgroup this is related to."
	HitGroup_t m_nHitGroup;
	// MPropertyDescription = "Do we disable the hitgroup and physics bodies tagged with said hitgroup when all sub parts are destroyed?"
	// MPropertyFriendlyName = "Disable Hit Group & Remove Tagged Physics Bodies When Destroyed"
	bool m_bDisableHitGroupWhenDestroyed;
};
