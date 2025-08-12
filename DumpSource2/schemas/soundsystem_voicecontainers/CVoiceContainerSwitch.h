// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerSwitch",
//	"m_vSound":
//	{
//		"m_nRate": 1251529684,
//		"m_nFormat": 65,
//		"m_nChannels": 0,
//		"m_nLoopStart": 0,
//		"m_nSampleCount": 13782472,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 3898223631,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": -396741800,
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
