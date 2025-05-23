class CDOTA_Ability_SandKing_BurrowStrike : public CDOTABaseAbility
{
	float32 burrow_width;
	int32 burrow_speed;
	float32 burrow_anim_time;
	bool m_bIsVectorTargeted;
	Vector m_vEndpoint;
};
