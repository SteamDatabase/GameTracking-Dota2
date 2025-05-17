// MNetworkVarNames = "float m_flLastSpawnTime"
// MNetworkVarNames = "float m_flNextSpawnTime"
// MNetworkVarNames = "bool m_bNextRuneIsWater"
// MNetworkVarNames = "bool m_bWillSpawnNextPowerRune"
class C_DOTA_Item_RuneSpawner_Powerup : public CBaseAnimatingActivity
{
	DOTA_RUNES m_nRuneType;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPowerupLastSpawnTimeChanged"
	float32 m_flLastSpawnTime;
	// MNetworkEnable
	float32 m_flNextSpawnTime;
	// MNetworkEnable
	bool m_bNextRuneIsWater;
	// MNetworkEnable
	bool m_bWillSpawnNextPowerRune;
};
