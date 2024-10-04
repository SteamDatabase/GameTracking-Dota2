class C_DOTA_Ability_Lycan_SummonWolves : public C_DOTABaseAbility
{
	char[4096] szUnitName;
	int32 wolf_index;
	float32 wolf_duration;
	CUtlVector< CHandle< C_BaseEntity > > m_hExistingUnits;
}
