class C_NextBotCombatCharacter : public C_BaseCombatCharacter
{
	CountdownTimer m_shadowTimer;
	bool m_bInFrustum;
	int32 m_nInFrustumFrame;
	float32 m_flFrustumDistanceSqr;
	uint8 m_nLod;
};
