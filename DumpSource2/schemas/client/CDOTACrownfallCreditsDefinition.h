// MGetKV3ClassDefaults = {
//	"m_vecCreditsBlocks":
//	[
//	],
//	"m_nPixelScale": 4,
//	"m_nWidth": 0,
//	"m_nHeight": 0,
//	"m_nDefaultBlockMarginTop": 100,
//	"m_flFinalLogoTimeAfterStop": 3.000000,
//	"m_flDelayBeforeValveHead": 1.000000
//}
class CDOTACrownfallCreditsDefinition
{
	CUtlVector< CDOTACrownfallCreditsBlockDefinition > m_vecCreditsBlocks;
	int32 m_nPixelScale;
	int32 m_nWidth;
	int32 m_nHeight;
	int32 m_nDefaultBlockMarginTop;
	float32 m_flFinalLogoTimeAfterStop;
	float32 m_flDelayBeforeValveHead;
};
