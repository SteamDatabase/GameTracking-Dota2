// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MModelGameData
// MFgdHelper = "game_data_list{ key = 'CDestructiblePartsSystemData_HitGroupInfoAndPartData' }"
class CDestructiblePartsSystemData_HitGroupInfoAndPartData
{
	// MPropertySuppressField
	CGlobalSymbol m_DebugName;
	// MPropertyStartGroup = "+Hitgroup"
	// MPropertyDescription = "The hitgroup this is related to."
	HitGroup_t m_nHitGroup;
	// MPropertyDescription = "Do we disable the hitgroup and physics bodies tagged with said hitgroup when all sub parts are destroyed?"
	// MPropertyFriendlyName = "Disable Hit Group & Remove Tagged Physics Bodies When Destroyed"
	bool m_bDisableHitGroupWhenDestroyed;
	// MPropertyDescription = "Other hitgroups to destroy when this one is fully destroyed.  Useful for chaining destructibles like blowing up the lower arm when the upper arm dies."
	CUtlVector< HitGroup_t > m_nOtherHitgroupsToDestroyWhenFullyDestructed;
	// MPropertyStartGroup = "+Gibbing"
	// MPropertyDescription = "Only allow this part to be destroyed when gibbing.  Useful for special case gibbing breakables like torsos."
	bool m_bOnlyDestroyWhenGibbing;
	// MPropertyStartGroup = "+Damage Levels"
	// MPropertyDescription = "The various damage levels for this hitgroup."
	// MPropertyFriendlyName = "Damage Levels"
	// MPropertyAutoExpandSelf
	CUtlVector< CDestructiblePartsSystemData_PartData > m_PartsData;
};
