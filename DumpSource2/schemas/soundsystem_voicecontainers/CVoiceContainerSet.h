// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerSet",
//	"m_vSound":
//	{
//		"m_nRate": 1251529684,
//		"m_nFormat": 65,
//		"m_nChannels": 3898223536,
//		"m_nLoopStart": 32765,
//		"m_nSampleCount": 13876824,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 0,
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
// MPropertyFriendlyName = "Container Set"
// MPropertyDescription = "An array of containers that are played all at once."
class CVoiceContainerSet : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Container List"
	CUtlVector< CVoiceContainerSetElement > m_soundsToPlay;
};
