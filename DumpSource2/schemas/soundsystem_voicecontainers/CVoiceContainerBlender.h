// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerBlender",
//	"m_vSound":
//	{
//		"m_nRate": -1415484975,
//		"m_nFormat": 185,
//		"m_nChannels": 3611080656,
//		"m_nLoopStart": 32766,
//		"m_nSampleCount": 2879482320,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 3005887752,
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
