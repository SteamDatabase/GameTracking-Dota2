class C_DOTA_Item_RuneSpawner_Powerup : public CBaseAnimatingActivity
{
	DOTA_RUNES m_nRuneType;
	float32 m_flLastSpawnTime;
	float32 m_flNextSpawnTime;
	bool m_bNextRuneIsWater;
	bool m_bWillSpawnNextPowerRune;
}
