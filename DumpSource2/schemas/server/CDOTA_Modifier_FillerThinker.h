class CDOTA_Modifier_FillerThinker : public CDOTA_Buff
{
	CUtlVector< CHandle< CBaseEntity > > hCasterList;
	bool bStarted;
	int32 nCount;
};
