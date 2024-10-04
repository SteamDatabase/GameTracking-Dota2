class CDOTA_Ability_Centaur_Stampede : public C_DOTABaseAbility
{
	float32 duration;
	int32 base_damage;
	float32 strength_damage;
	float32 slow_duration;
	float32 scepter_bonus_duration;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
}
