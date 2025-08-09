// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerSwitch",
//	"m_vSound":
//	{
//		"m_nRate": -71773228,
//		"m_nFormat": 250,
//		"m_nChannels": 0,
//		"m_nLoopStart": 0,
//		"m_nSampleCount": 4263654904,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 1291830335,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": 1291832200,
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
