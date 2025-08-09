// MGetKV3ClassDefaults = {
//	"m_nIconID": 0,
//	"m_flSizeScale": 1.000000,
//	"m_flIntensity": 1.000000,
//	"m_bAdditive": false,
//	"m_bForceBaseIconWhite": false,
//	"m_eAnimType": "k_ePingMinimapAnimType_None",
//	"m_eDrawCondition": "k_ePingMinimapDrawCondition_Always",
//	"m_flPulseStartSizeScale": 0.000000,
//	"m_flPulseBonusIntensity": 0.000000,
//	"m_flPulseDuration": 1.000000,
//	"m_nPulseCount": 1
//}
class PingMinimapIconLayerInfo_t
{
	// MPropertyDescription = "ID of icon to show on minimap. See scripts/minimap_icons.txt and mod_textures.txt"
	int32 m_nIconID;
	float32 m_flSizeScale;
	float32 m_flIntensity;
	bool m_bAdditive;
	bool m_bForceBaseIconWhite;
	EPingMinimapAnimType m_eAnimType;
	EPingMinimapDrawCondition m_eDrawCondition;
	float32 m_flPulseStartSizeScale;
	float32 m_flPulseBonusIntensity;
	float32 m_flPulseDuration;
	int32 m_nPulseCount;
};
