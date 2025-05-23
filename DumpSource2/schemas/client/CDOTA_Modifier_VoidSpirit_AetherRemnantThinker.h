class CDOTA_Modifier_VoidSpirit_AetherRemnantThinker : public CDOTA_Buff
{
	float32 radius;
	Vector m_vFacingDir;
	int32 pierces_creeps;
	CHandle< C_BaseEntity > m_hRemnant;
	CHandle< C_BaseEntity > m_hPartnerRemnant;
	bool m_bTriggered;
	float32 m_flCurThink;
	bool bIsArtifice;
};
