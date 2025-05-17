class C_DOTA_Ability_Windrunner_Shackleshot : public C_DOTABaseAbility
{
	int32 shackle_count;
	Vector m_vArrowAvgPos;
	Vector m_vArrowStartPos;
	Vector m_vArrowStartPos2;
	Vector m_vArrowStartPos3;
	CHandle< C_BaseEntity > m_hTarget;
};
