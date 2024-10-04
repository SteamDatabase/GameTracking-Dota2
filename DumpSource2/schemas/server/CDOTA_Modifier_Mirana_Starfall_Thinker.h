class CDOTA_Modifier_Mirana_Starfall_Thinker : public CDOTA_Buff
{
	int32 starfall_secondary_radius;
	CHandle< CBaseEntity > m_hTarget;
	int32 m_iDamage;
	bool m_bStarDropped;
	bool m_bSecondStar;
};
