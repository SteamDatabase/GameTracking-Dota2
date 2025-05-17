class CDOTA_Ability_Lycan_SummonWolves : public CDOTABaseAbility
{
	char[4096] szUnitName;
	int32 wolf_index;
	float32 wolf_duration;
	CUtlVector< CHandle< CBaseEntity > > m_hExistingUnits;
};
