// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class SNewSettingsDefinition
{
	// MPropertyDescription = "unique integer ID of this new setting"
	// MVDataUniqueMonotonicInt = "_editor/next_new_setting_id"
	// MPropertyAttributeEditor = "locked_int()"
	NewSettingsID_t nID;
	CUtlString m_sTitle;
	CUtlString m_sDescription;
	CPanoramaImageName sIcon;
	CUtlString m_sCreationDate;
	ENewSettingsBadge m_eNewSettingsBadge;
};
