class CDOTACrownfallCreditsBlockDefinition
{
	CUtlVector< CDOTACrownfallCreditsCharacterDefinition > m_vecCharacters;
	CDOTACrownfallCreditsMapSceneDefinition m_scene;
	CUtlString m_strCustomPanoramaClass;
	int32 m_nMarginBottom;
	int32 m_nMarginTop;
	bool m_bSpecialThanksBlock;
	CUtlString m_strLocText;
	bool m_bJustText;
	int32 m_nStopOffset;
};
