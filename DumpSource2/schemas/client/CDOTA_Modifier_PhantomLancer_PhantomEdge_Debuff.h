class CDOTA_Modifier_PhantomLancer_PhantomEdge_Debuff : public CDOTA_Buff
{
	float32 bonus_damage;
	float32 duration;
	PlayerID_t m_nSourcePlayer;
	CUtlVector< GameTime_t > m_vecStackRemovalTimes;
};
