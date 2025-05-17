class CDOTA_Modifier_AbyssalUnderlord_Underling_Autoattack : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hBestTarget;
	float32 underling_search_radius;
	bool m_bRunningToFountain;
	int32 underling_building_damage_reduction;
};
