class CDOTA_Modifier_Brewmaster_Void_Astral_Pull_Movement : public CDOTA_Buff
{
	Vector m_vDirection;
	float32 m_flEndTime;
	float32 m_flCurTime;
	int32 pull_distance;
	int32 damage;
	float32 pull_duration;
};
