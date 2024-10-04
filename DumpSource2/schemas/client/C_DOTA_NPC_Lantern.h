class C_DOTA_NPC_Lantern : public C_DOTA_BaseNPC_Building
{
	CUtlSymbolLarge m_szInteractAbilityName;
	CNewParticleEffect* m_pVisionRangeFX;
	ParticleIndex_t m_iFxIndex;
	int32 m_nPreviewViewer;
	int32 m_nTeamNumberShown;
};
