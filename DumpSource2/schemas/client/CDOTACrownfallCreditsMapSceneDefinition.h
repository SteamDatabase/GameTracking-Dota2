class CDOTACrownfallCreditsMapSceneDefinition
{
	CPanoramaImageName m_strImage;
	CPanoramaImageName m_strImageMask;
	Vector2D m_vViewStart;
	Vector2D m_vViewEnd;
	CrownfallCreditsAABB_t m_bounds;
	int32 m_nAnimOffsetX;
	int32 m_nAnimOffsetY;
	CUtlVector< CDOTACrownfallCreditsMapSceneAnimateableDefinition > m_vecAnimations;
	bool m_bScale;
};
