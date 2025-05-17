// MNetworkVarNames = "EHANDLE m_hTowerAttackTarget"
// MNetworkVarNames = "EHANDLE m_hTowerHighFiveTarget"
class C_DOTA_BaseNPC_Tower : public C_DOTA_BaseNPC_Building
{
	ParticleIndex_t m_nAltHeldRangeFX;
	bool m_bWasInRange;
	ParticleIndex_t m_iRangeFX;
	ParticleIndex_t m_iPulseFX;
	uint8 m_unTowerTier;
	float32 m_fTowerAggroDangerAmount;
	float32 m_flControlledUnitInRangeAmount;
	float32 m_flControlledUnitTargettedAmount;
	ParticleIndex_t m_iAnticipationFX;
	CUtlSymbolLarge m_szAnticipationFXName;
	CHandle< C_BaseEntity > m_hPrevTowerAttackTarget;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hTowerAttackTarget;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hTowerHighFiveTarget;
	int32 m_iPoseParameterAim;
	QAngle m_angDefaultCustomTowerAngle;
	float32 m_flLastAimYaw;
	bool m_bClientSideCustomTower;
	CountdownTimer m_IdleRareAnimationTime;
};
