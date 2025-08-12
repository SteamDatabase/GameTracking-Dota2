// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerStaticAdditiveSynth",
//	"m_vSound":
//	{
//		"m_nRate": -674895407,
//		"m_nFormat": 162,
//		"m_nChannels": 3898223952,
//		"m_nLoopStart": 32765,
//		"m_nSampleCount": 778328436,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 13732280,
//		"m_nSeekTable":
//		[
//		],
//		"m_nLoopEnd": 0,
//		"m_encodedHeader": "[BINARY BLOB]"
//	},
//	"m_pEnvelopeAnalyzer": null,
//	"m_tones":
//	[
//	]
//}
// MPropertyFriendlyName = "Additive Synth Container"
// MPropertyDescription = "This is a static additive synth that can scale components of the synth based on how many instances are running."
class CVoiceContainerStaticAdditiveSynth : public CVoiceContainerBase
{
	CUtlVector< CVoiceContainerStaticAdditiveSynth::CTone > m_tones;
};
