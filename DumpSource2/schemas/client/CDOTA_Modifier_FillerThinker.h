class CDOTA_Modifier_FillerThinker : public CDOTA_Buff
{
	CUtlVector< CHandle< C_BaseEntity > > hCasterList;
	bool bStarted;
	int32 nCount;
};
