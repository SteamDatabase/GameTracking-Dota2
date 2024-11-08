class CDOTA_Modifier_Kez_Katana_Shard_Active : public CDOTA_Buff
{
	GameTime_t m_StunTime;
	CHandle< C_BaseEntity > m_hTarget;
	bool m_bStunned;
};
