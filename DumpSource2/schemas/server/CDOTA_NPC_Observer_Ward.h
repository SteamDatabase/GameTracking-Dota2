// MNetworkVarNames = "FowCustomTeams_t m_nFoWTeam"
class CDOTA_NPC_Observer_Ward : public CDOTA_BaseNPC_Additive
{
	int32 m_iDuration;
	bool m_bPlacedInSpawnBox;
	GameTime_t m_flSpawnTime;
	// MNetworkEnable
	FowCustomTeams_t m_nFoWTeam;
};
