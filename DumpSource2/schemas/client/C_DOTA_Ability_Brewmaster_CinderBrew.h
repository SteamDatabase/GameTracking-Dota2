class C_DOTA_Ability_Brewmaster_CinderBrew : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > m_hUnitsHit;
	float32 duration;
	float32 barrel_impact_damage;
	float32 barrel_width;
};
