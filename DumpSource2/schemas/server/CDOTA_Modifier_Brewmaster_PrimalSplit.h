class CDOTA_Modifier_Brewmaster_PrimalSplit : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	CHandle< CBaseEntity > m_hSecondaryTarget;
	CHandle< CBaseEntity > m_hTertiaryTarget;
	CHandle< CBaseEntity > m_hFourthTarget;
	CHandle< CBaseEntity > m_hReturnBrewling;
	int32 m_nFXIndex;
};
