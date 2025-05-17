class C_DOTA_Ability_Frogmen_CongregationOfTheDeep : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > hAlreadyHitList;
	float32 duration;
	int32 speed;
	float32 damage;
	float32 range;
	int32 projectile_count;
	int32 projectile_width;
	float32 neutral_shared_cooldown;
};
