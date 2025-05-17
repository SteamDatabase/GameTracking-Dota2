// MNetworkVarNames = "float m_flLastSpawnTime"
// MNetworkVarNames = "float m_flNextSpawnTime"
class CDOTA_Item_RuneSpawner : public CBaseAnimatingActivity
{
	// MNetworkEnable
	float32 m_flLastSpawnTime;
	// MNetworkEnable
	float32 m_flNextSpawnTime;
};
