class CDOTA_Modifier_VoidSpirit_AetherRemnant_Pull : public CDOTA_Buff
{
	ParticleIndex_t m_nFXIndex;
	PlayerID_t m_nPlayerID;
	float32 think_interval;
	float32 artifice_pct_effectiveness;
	bool bIsArtifice;
};
