class CDOTA_GameMechanic_AutoRecovery : public CServerOnlyEntity
{
	float32 m_flRecoveryDelay;
	float32 m_flHealthRegenPerSecond;
	float32 m_flManaRegenPerSecond;
	float32 m_flTickInterval;
};
