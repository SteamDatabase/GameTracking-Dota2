// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerSwitch",
//	"m_vSound":
//	{
//		"m_nRate": -644295724,
//		"m_nFormat": 60,
//		"m_nChannels": 0,
//		"m_nLoopStart": 0,
//		"m_nSampleCount": 3005669992,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 3611080335,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": -683885096,
//		"m_encodedHeader": "[BINARY BLOB]"
//	},
//	"m_pEnvelopeAnalyzer": null,
//	"m_soundsToPlay":
//	[
//	]
//}
// MPropertyFriendlyName = "Container Switch"
// MPropertyDescription = "An array of containers"
class CVoiceContainerSwitch : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Container List"
	CUtlVector< CSoundContainerReference > m_soundsToPlay;
};
