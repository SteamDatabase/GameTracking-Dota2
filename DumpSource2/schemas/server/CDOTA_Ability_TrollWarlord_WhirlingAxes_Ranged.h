class CDOTA_Ability_TrollWarlord_WhirlingAxes_Ranged : public CDOTABaseAbility
{
	Vector m_vStartPos;
	int32 m_iArrowProjectile;
	float32 axe_width;
	float32 axe_speed;
	float32 axe_range;
	float32 axe_spread;
	int32 axe_count;
	CUtlVector< CHandle< CBaseEntity > > m_hHitUnits;
};
