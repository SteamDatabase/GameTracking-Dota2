class CDOTA_Ability_Grimstroke_SpiritWalk : public C_DOTABaseAbility
{
	float32 buff_duration;
	CHandle< C_BaseEntity > m_hTarget;
	int32 can_end_early;
};
