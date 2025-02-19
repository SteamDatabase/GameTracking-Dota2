class CVoiceContainerParameterBlender
{
	CSoundContainerReference m_firstSound;
	CSoundContainerReference m_secondSound;
	bool m_bEnableOcclusionBlend;
	CPiecewiseCurve m_curve1;
	CPiecewiseCurve m_curve2;
	bool m_bEnableDistanceBlend;
	CPiecewiseCurve m_curve3;
	CPiecewiseCurve m_curve4;
};
