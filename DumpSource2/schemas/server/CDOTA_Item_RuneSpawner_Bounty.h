// MNetworkVarNames = "float m_flLastSpawnTime"
// MNetworkVarNames = "float m_flNextSpawnTime"
class CDOTA_Item_RuneSpawner_Bounty : public CBaseAnimatingActivity
{
	CUtlSymbolLarge m_szPosition;
	int32 m_nDotaTeam;
	// MNetworkEnable
	float32 m_flLastSpawnTime;
	// MNetworkEnable
	float32 m_flNextSpawnTime;
};
