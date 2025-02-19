class CDOTA_Modifier_Corpselord_Revive
{
	int32 radius;
	int32 ticks_to_revive;
	float32 tick_interval;
	CHandle< C_DOTA_BaseNPC > m_pReviveTarget;
	int32 m_nCurrentTicks;
};
