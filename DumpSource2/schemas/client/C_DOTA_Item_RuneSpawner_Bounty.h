// MNetworkVarNames = "float m_flLastSpawnTime"
// MNetworkVarNames = "float m_flNextSpawnTime"
class C_DOTA_Item_RuneSpawner_Bounty : public CBaseAnimatingActivity
{
	DOTA_RUNES m_nRuneType;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBountyLastSpawnTimeChanged"
	float32 m_flLastSpawnTime;
	// MNetworkEnable
	float32 m_flNextSpawnTime;
};
