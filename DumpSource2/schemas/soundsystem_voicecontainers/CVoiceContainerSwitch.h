// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerSwitch",
//	"m_vSound":
//	{
//		"m_nRate": -992422956,
//		"m_nFormat": 36,
//		"m_nChannels": 0,
//		"m_nLoopStart": 0,
//		"m_nSampleCount": 3492069544,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 2984836671,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": -1310128760,
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
