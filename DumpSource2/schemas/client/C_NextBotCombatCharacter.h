// MNetworkVarNames = "uint8 m_nLod"
class C_NextBotCombatCharacter : public C_BaseCombatCharacter
{
	CountdownTimer m_shadowTimer;
	bool m_bInFrustum;
	int32 m_nInFrustumFrame;
	float32 m_flFrustumDistanceSqr;
	// MNetworkEnable
	uint8 m_nLod;
};
