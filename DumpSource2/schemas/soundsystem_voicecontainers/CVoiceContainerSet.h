// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerSet",
//	"m_vSound":
//	{
//		"m_nRate": -992422956,
//		"m_nFormat": 36,
//		"m_nChannels": 2984836576,
//		"m_nLoopStart": 32767,
//		"m_nSampleCount": 3492162776,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 0,
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
// MPropertyFriendlyName = "Container Set"
// MPropertyDescription = "An array of containers that are played all at once."
class CVoiceContainerSet : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Container List"
	CUtlVector< CVoiceContainerSetElement > m_soundsToPlay;
};
