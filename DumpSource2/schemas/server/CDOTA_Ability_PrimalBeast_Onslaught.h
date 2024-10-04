class CDOTA_Ability_PrimalBeast_Onslaught : public CDOTABaseAbility
{
	float32 max_charge_time;
	float32 knockback_distance;
	int32 knockback_damage;
	int32 collision_radius;
	int32 max_distance;
	Vector m_vStartPos;
	ParticleIndex_t m_nFXIndex;
	int32 m_nProjectileID;
}
