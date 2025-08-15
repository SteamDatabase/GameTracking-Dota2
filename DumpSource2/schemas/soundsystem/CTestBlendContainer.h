// MGetKV3ClassDefaults = {
//	"_class": "CTestBlendContainer",
//	"m_vSound":
//	{
//		"m_nRate": 0,
//		"m_nFormat": "PCM16",
//		"m_nChannels": 0,
//		"m_nLoopStart": 0,
//		"m_nSampleCount": 3418174416,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 3139469312,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": 0,
//		"m_encodedHeader": "[BINARY BLOB]"
//	},
//	"m_pEnvelopeAnalyzer": null,
//	"m_firstSound": "",
//	"m_secondSound": ""
//}
// MPropertyFriendlyName = "TESTBED: Nested Voice Containers"
// MPropertyDescription = "Adds to voices to a tree span."
class CTestBlendContainer : public CVoiceContainerBase
{
	CStrongHandle< InfoForResourceTypeCVoiceContainerBase > m_firstSound;
	CStrongHandle< InfoForResourceTypeCVoiceContainerBase > m_secondSound;
};
