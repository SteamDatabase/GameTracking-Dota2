// MNetworkVarNames = "string_t m_szInteractAbilityName"
class C_DOTA_NPC_Lantern : public C_DOTA_BaseNPC_Building
{
	// MNetworkEnable
	CUtlSymbolLarge m_szInteractAbilityName;
	CNewParticleEffect* m_pVisionRangeFX;
	int32 m_nPreviewViewer;
	ParticleIndex_t m_iFxIndex;
	int32 m_nCurrentOwningTeam;
	int32 m_nCurrentActivity;
	bool m_bCanBeCaptured;
};
