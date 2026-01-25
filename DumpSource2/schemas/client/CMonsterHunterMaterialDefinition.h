// MGetKV3ClassDefaults = {
//	"m_unID": 0,
//	"m_strName": "",
//	"m_eRarity": "k_eMonsterHunterMaterialRarity_Invalid",
//	"m_bUniversal": false,
//	"m_bHidden": false,
//	"m_bDeprecated": false
//}
// MVDataRoot
class CMonsterHunterMaterialDefinition
{
	// MVDataUniqueMonotonicInt = "_editor/next_id_material"
	// MPropertyAttributeEditor = "locked_int()"
	MonsterHunterMaterialID_t m_unID;
	// MPropertyDescription = ""
	CUtlString m_strName;
	// MPropertyDescription = ""
	EMonsterHunterMaterialRarity m_eRarity;
	bool m_bUniversal;
	bool m_bHidden;
	bool m_bDeprecated;
};
