// MGetKV3ClassDefaults = {
//	"m_nIconID": 0,
//	"m_flSize": 800.000000,
//	"m_bAlignBottom": false,
//	"m_bForceBaseIconWhite": false,
//	"m_flAnimStartSize": 10000.000000,
//	"m_flAnimThrobSize": 300.000000,
//	"m_flAnimThrobRate": 6.000000,
//	"m_flAnimIntroDuration": 0.300000,
//	"m_flAnimOutroDuration": 0.500000,
//	"m_eDrawCondition": "k_ePingMinimapDrawCondition_Always"
//}
class PingMinimapIconInfo_t
{
	// MPropertyDescription = "ID of icon to show on minimap. See scripts/minimap_icons.txt and mod_textures.txt"
	int32 m_nIconID;
	// MPropertyDescription = "Size in world units of the minimap icon."
	float32 m_flSize;
	bool m_bAlignBottom;
	bool m_bForceBaseIconWhite;
	float32 m_flAnimStartSize;
	float32 m_flAnimThrobSize;
	float32 m_flAnimThrobRate;
	// MPropertyDescription = "Duration of time that the intro takes."
	float32 m_flAnimIntroDuration;
	// MPropertyDescription = "Duration of time the outro takes."
	float32 m_flAnimOutroDuration;
	EPingMinimapDrawCondition m_eDrawCondition;
};
