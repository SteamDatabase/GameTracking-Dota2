// MGetKV3ClassDefaults = {
//	"_class": "CVoiceContainerStaticAdditiveSynth",
//	"m_vSound":
//	{
//		"m_nRate": -1415484975,
//		"m_nFormat": 185,
//		"m_nChannels": 3611080656,
//		"m_nLoopStart": 32766,
//		"m_nSampleCount": 3181664628,
//		"m_flDuration": 0.000000,
//		"m_Sentences":
//		[
//		],
//		"m_nStreamingSize": 3005619512,
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
