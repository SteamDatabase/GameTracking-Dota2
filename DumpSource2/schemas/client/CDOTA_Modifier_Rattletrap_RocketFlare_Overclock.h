class CDOTA_Modifier_Rattletrap_RocketFlare_Overclock : public CDOTA_Buff
{
	float32 rocket_flare_interval;
	int32 rocket_flare_offset_pct;
	int32 rocket_flare_rockets;
	int32 m_nRocketsFired;
	float32 radius;
	Vector m_vOriginalTarget;
};
