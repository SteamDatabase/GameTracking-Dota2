class C_DOTA_Ability_TrollWarlord_WhirlingAxes_Ranged : public C_DOTABaseAbility
{
	Vector m_vStartPos;
	int32 m_iArrowProjectile;
	int32 axe_width;
	float32 axe_speed;
	float32 axe_range;
	int32 axe_spread;
	int32 axe_count;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitUnits;
}
