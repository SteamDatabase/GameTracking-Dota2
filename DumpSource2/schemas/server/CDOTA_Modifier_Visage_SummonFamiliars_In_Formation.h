class CDOTA_Modifier_Visage_SummonFamiliars_In_Formation : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hOwner;
	CHandle< CBaseEntity > m_hCurrentTarget;
	int32 familiar_index;
	int32 back_distance;
	int32 side_distance;
	Vector m_vecDesiredPosition;
	int32 max_distance;
	int32 return_distance;
	int32 attack_range_buffer;
	float32 recall_duration;
	bool m_bTeleporting;
	int32 familiar_attack_range;
	int32 additional_target_search_radius;
};
