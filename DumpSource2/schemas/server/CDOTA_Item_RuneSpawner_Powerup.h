class CDOTA_Item_RuneSpawner_Powerup : public CBaseAnimatingActivity
{
	CUtlSymbolLarge m_szPosition;
	float32 m_flLastSpawnTime;
	float32 m_flNextSpawnTime;
	bool m_bNextRuneIsWater;
	bool m_bWillSpawnNextPowerRune;
}
