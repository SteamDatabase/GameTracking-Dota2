// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CDOTATrophyDefinition
{
	// MPropertyDescription = "unique integer ID of this trophy"
	// MVDataUniqueMonotonicInt = "_editor/next_trophy_id"
	// MPropertyAttributeEditor = "locked_int()"
	uint16 m_nID;
	// MPropertyDescription = "is this trophy still obtainable? This way we can have different presentations based on past and current trophies"
	bool m_bObtainable;
	// MPropertyDescription = "should we render a progrss bar of progress towards the next tier"
	bool m_bShowProgressBar;
	// MPropertyDescription = "should we show the popup when you earn the first tier of this trophy"
	bool m_bShowInitialEarn;
	// MPropertyDescription = "the date this trophy was introduced (YYYY-MM-DD or YYYY-MM-DD hh:mm:ss)"
	CUtlString m_sCreationDate;
	// MPropertyDescription = "how many badge points to grant for each increment"
	// MPropertyHideField
	uint32 m_nBadgePointsPerUnit;
	// MPropertyDescription = "how many units need to be leveled up in order to get the badge point grant"
	// MPropertyHideField
	uint32 m_nUnitsPerBadgePoint;
	// MPropertyDescription = "the cutoff for where badge points stop granting (0 is disable this limit)"
	// MPropertyHideField
	uint32 m_nMaxUnitsForBadgePoints;
	// MPropertyDescription = "higher sort tiers come first in presentation"
	// MPropertyHideField
	uint32 m_nSortTier;
	// MPropertyDescription = "localization string ID to use for the user facing category trophy belongs to"
	CUtlString m_sLocCategory;
	// MPropertyDescription = "localization string ID to use for the user facing name of this trophy"
	CUtlString m_sLocName;
	// MPropertyDescription = "localization string ID to use for the user facing descriptiontrophy"
	CUtlString m_sLocDescription;
	// MPropertyDescription = "pluralizable localization string ID to use for the user facing unit to display on the trophy tooltip (e.g. 1 Challenge Completed / 3 Challenges Completed)"
	CUtlString m_sLocUnitsPluralizable;
	// MPropertyAutoExpandSelf
	CUtlVector< TrophyLevel_t > m_vecLevels;
};
