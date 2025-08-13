// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerEnvelope",
//	"m_vSound":
//	{
//		"m_nRate": -644295724,
//		"m_nFormat": 60,
//		"m_nChannels": 7,
//		"m_nLoopStart": 0,
//		"m_nSampleCount": 3005600040,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 4294967295,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": -683885096,
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
