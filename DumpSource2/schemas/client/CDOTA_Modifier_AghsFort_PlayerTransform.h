class CDOTA_Modifier_AghsFort_PlayerTransform : public CDOTA_Buff
{
	itemid_t m_nCourierItemId;
	CUtlString m_ModelNameOfDisguise;
	int32 m_nMoveSpeed;
	int32 m_nDisguisedSpeed;
	ParticleIndex_t m_nDisguiseEffectIndex;
	CHandle< C_BaseEntity > m_hCourier;
	bool m_bIsFlyingCourier;
	char* s_pszDonkeyDisguise;
	float32 invul_duration;
	bool m_bParticlesSpawned;
};
