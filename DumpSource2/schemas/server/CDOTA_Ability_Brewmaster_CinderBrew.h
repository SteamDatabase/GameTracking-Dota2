class CDOTA_Ability_Brewmaster_CinderBrew : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > m_hUnitsHit;
	float32 duration;
	float32 barrel_impact_damage;
	float32 barrel_width;
};
