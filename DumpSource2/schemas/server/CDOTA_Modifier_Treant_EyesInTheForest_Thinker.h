class CDOTA_Modifier_Treant_EyesInTheForest_Thinker : public CDOTA_Buff
{
	float32 vision_aoe;
	CDOTA_Tree* m_Tree;
	CHandle< CBaseEntity > m_hTree;
	ParticleIndex_t m_nFXIndex;
	bool m_bUpgradedVision;
};
