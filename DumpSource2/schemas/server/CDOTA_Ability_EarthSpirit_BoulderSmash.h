class CDOTA_Ability_EarthSpirit_BoulderSmash : public CDOTABaseAbility
{
	float32 speed;
	float32 rock_damage;
	float32 creep_multiplier;
	float32 radius;
	float32 rock_search_aoe;
	float32 unit_distance;
	float32 rock_distance;
	int32 m_nProjectileID;
	CHandle< CBaseEntity > m_hCursorTarget;
	bool m_bUsedStone;
	CHandle< CBaseEntity > m_hTarget;
	bool m_bTargetStone;
};
