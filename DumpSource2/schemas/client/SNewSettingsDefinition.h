// MGetKV3ClassDefaults = {
//	"nID": 0,
//	"m_sTitle": "",
//	"m_sDescription": "",
//	"sIcon": "",
//	"m_sCreationDate": "",
//	"m_eNewSettingsBadge": "eNewSettingsBadge_New"
//}
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
