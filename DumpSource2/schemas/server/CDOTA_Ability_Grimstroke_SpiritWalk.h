class CDOTA_Ability_Grimstroke_SpiritWalk : public CDOTABaseAbility
{
	float32 buff_duration;
	CHandle< CBaseEntity > m_hTarget;
	int32 can_end_early;
};
