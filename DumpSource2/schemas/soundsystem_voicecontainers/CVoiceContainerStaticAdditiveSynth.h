// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerStaticAdditiveSynth",
//	"m_vSound":
//	{
//		"m_nRate": -192558639,
//		"m_nFormat": 193,
//		"m_nChannels": 1291830656,
//		"m_nLoopStart": 32767,
//		"m_nSampleCount": 3762575732,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 4263606808,
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
