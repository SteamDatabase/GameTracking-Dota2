class CDOTA_Modifier_Largo_FroglingBand_Self : public CDOTA_Buff
{
	int32 max_froglings;
	int32 m_nNumFroglings;
	CUtlVector< CHandle< CDOTA_BaseNPC_Largo_Frogling > > m_vecFroglings;
};
