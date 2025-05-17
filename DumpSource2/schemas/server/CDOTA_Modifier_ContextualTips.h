class CDOTA_Modifier_ContextualTips : public CDOTA_Buff
{
	bool m_bAllEnemiesBots;
	GameTime_t m_flGloblLastTipSendTime;
	GameTime_t m_flLastEnemyHeroDamageTime;
	GameTime_t m_flLastEnemyHeroVisibleTime;
};
