class CDOTA_Modifier_VoidSpirit_AetherRemnantThinker : public CDOTA_Buff
{
	float32 radius;
	Vector m_vFacingDir;
	CHandle< C_BaseEntity > m_hRemnant;
	bool m_bTriggered;
	float32 m_flCurThink;
	bool bIsArtifice;
};
