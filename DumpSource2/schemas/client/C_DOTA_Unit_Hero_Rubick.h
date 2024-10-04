class C_DOTA_Unit_Hero_Rubick : public C_DOTA_BaseNPC_Hero
{
	Vector m_stolenAbilityColorHSV1;
	Vector m_stolenAbilityColorHSV2;
	Vector m_stolenAbilityFXColorHSV;
	bool m_bHasInitializedAbilityColors;
	Vector m_startAbilityColorHSV1;
	Vector m_startAbilityColorHSV2;
	Vector m_startAbilityFXColorHSV;
	Vector m_currAbilityColorHSV1;
	Vector m_currAbilityColorHSV2;
	Vector m_currAbilityFXColorHSV;
	GameTime_t m_flStartTime;
}
