class CDOTA_Modifier_Kunkka_Torrent : public CDOTA_Buff
{
	float32 torrent_damage;
	float32 damage_tick_interval;
	float32 percent_instant;
	float32 flDamagePerTick;
	float32 m_flStartZ;
	float32 m_flCurTime;
	bool m_bTorrentStorm;
};
