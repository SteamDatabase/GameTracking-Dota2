class CDOTA_Modifier_Visage_SummonFamiliars_In_Formation : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hOwner;
	CHandle< C_BaseEntity > m_hCurrentTarget;
	int32 familiar_index;
	int32 back_distance;
	int32 side_distance;
	Vector m_vecDesiredPosition;
	float32 max_distance;
	float32 return_distance;
	float32 attack_range_buffer;
	float32 recall_duration;
	bool m_bTeleporting;
	int32 familiar_attack_range;
	float32 additional_target_search_radius;
};
