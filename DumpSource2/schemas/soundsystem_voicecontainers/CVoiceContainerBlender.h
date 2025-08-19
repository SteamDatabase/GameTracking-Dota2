// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerBlender",
//	"m_vSound":
//	{
//		"m_nRate": -1653528015,
//		"m_nFormat": 9,
//		"m_nChannels": 2984836992,
//		"m_nLoopStart": 32767,
//		"m_nSampleCount": 2641439280,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 3492288360,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": 0,
//		"m_encodedHeader": "[BINARY BLOB]"
//	},
//	"m_pEnvelopeAnalyzer": null,
//	"m_firstSound":
//	{
//		"m_bUseReference": true,
//		"m_sound": "",
//		"m_pSound": null
//	},
//	"m_secondSound":
//	{
//		"m_bUseReference": true,
//		"m_sound": "",
//		"m_pSound": null
//	},
//	"m_flBlendFactor": 0.000000
//}
// MPropertyFriendlyName = "Blender"
// MPropertyDescription = "Blends two containers."
class CVoiceContainerBlender : public CVoiceContainerBase
{
	CSoundContainerReference m_firstSound;
	CSoundContainerReference m_secondSound;
	float32 m_flBlendFactor;
};
