// MNetworkVarNames = "FowCustomTeams_t m_nFoWTeam"
class CDOTA_NPC_Observer_Ward : public C_DOTA_BaseNPC_Additive
{
	int32 m_iDuration;
	CNewParticleEffect* m_pVisionRangeFX;
	int32 m_nPreviewViewer;
	// MNetworkEnable
	FowCustomTeams_t m_nFoWTeam;
};
