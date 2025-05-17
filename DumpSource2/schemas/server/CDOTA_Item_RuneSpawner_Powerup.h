// MNetworkVarNames = "float m_flLastSpawnTime"
// MNetworkVarNames = "float m_flNextSpawnTime"
// MNetworkVarNames = "bool m_bNextRuneIsWater"
// MNetworkVarNames = "bool m_bWillSpawnNextPowerRune"
class CDOTA_Item_RuneSpawner_Powerup : public CBaseAnimatingActivity
{
	CUtlSymbolLarge m_szPosition;
	// MNetworkEnable
	float32 m_flLastSpawnTime;
	// MNetworkEnable
	float32 m_flNextSpawnTime;
	// MNetworkEnable
	bool m_bNextRuneIsWater;
	// MNetworkEnable
	bool m_bWillSpawnNextPowerRune;
};
