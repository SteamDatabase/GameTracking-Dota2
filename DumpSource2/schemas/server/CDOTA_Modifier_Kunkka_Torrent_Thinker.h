class CDOTA_Modifier_Kunkka_Torrent_Thinker : public CDOTA_Buff
{
	bool m_bShowEnemies;
	bool m_bTorrentStorm;
	bool m_bTorrentStarted;
	GameTime_t m_fTorrentStartTime;
	float32 flDamagePerTick;
	float32 flFirstDamage;
	float32 damage_tick_interval;
	float32 percent_instant;
}
