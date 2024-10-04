class CDOTA_Modifier_Jakiro_LiquidFire : public CDOTA_Buff
{
	float32 duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
	int32 radius;
	ParticleIndex_t m_nFXIndex;
	bool double_head;
	bool m_bForceProc;
};
