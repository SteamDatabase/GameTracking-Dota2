class CDOTA_Ability_Windrunner_Shackleshot : public CDOTABaseAbility
{
	int32 shackle_count;
	Vector m_vArrowAvgPos;
	Vector m_vArrowStartPos;
	Vector m_vArrowStartPos2;
	Vector m_vArrowStartPos3;
	CHandle< CBaseEntity > m_hTarget;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_vecShackledUnits;
};
