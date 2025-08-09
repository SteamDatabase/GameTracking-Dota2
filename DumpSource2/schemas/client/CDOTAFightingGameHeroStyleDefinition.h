// MGetKV3ClassDefaults = {
//	"m_bUseDefault": false,
//	"m_bUseEquipped": false,
//	"m_unStyleIndex": 255,
//	"m_strLocName": "",
//	"m_vecItems":
//	[
//	]
//}
// MVDataRoot
class CDOTAFightingGameHeroStyleDefinition
{
	bool m_bUseDefault;
	bool m_bUseEquipped;
	style_index_t m_unStyleIndex;
	CUtlString m_strLocName;
	CUtlVector< item_definition_index_t > m_vecItems;
};
