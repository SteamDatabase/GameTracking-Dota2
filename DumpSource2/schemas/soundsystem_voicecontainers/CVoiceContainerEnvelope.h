// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerEnvelope",
//	"m_vSound":
//	{
//		"m_nRate": -992422956,
//		"m_nFormat": 36,
//		"m_nChannels": 7,
//		"m_nLoopStart": 0,
//		"m_nSampleCount": 3492001128,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 4294967295,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": -1310128760,
//		"m_encodedHeader": "[BINARY BLOB]"
//	},
//	"m_pEnvelopeAnalyzer": null,
//	"m_sound": "",
//	"m_analysisContainer": null
//}
// MPropertyFriendlyName = "Envelope VSND"
// MPropertyDescription = "Plays sound with envelope."
class CVoiceContainerEnvelope : public CVoiceContainerBase
{
	// MPropertyFriendlyName = "Vsnd File"
	CStrongHandle< InfoForResourceTypeCVoiceContainerBase > m_sound;
	// MPropertyFriendlyName = "Container Analyzers"
	CVoiceContainerAnalysisBase* m_analysisContainer;
};
