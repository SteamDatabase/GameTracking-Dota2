class CDOTA_Modifier_Seasonal_TI9_Shovel_Ghost_Haunt : public CDOTA_Buff
{
	int32 nDamageInstances;
	GameTime_t m_flLastAttackTime;
	GameTime_t m_flLastMoveTime;
	CHandle< CBaseEntity > m_hGhost;
}
