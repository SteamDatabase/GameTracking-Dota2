class CDOTA_Ability_Frogmen_TendrilsOfTheDeep : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
	float32 duration;
	int32 speed;
	float32 damage;
	float32 range;
	float32 yaw_offset;
	int32 projectile_width;
	float32 neutral_shared_cooldown;
};
