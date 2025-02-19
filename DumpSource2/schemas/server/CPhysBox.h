class CPhysBox
{
	int32 m_damageType;
	int32 m_damageToEnableMotion;
	float32 m_flForceToEnableMotion;
	QAngle m_angPreferredCarryAngles;
	bool m_bNotSolidToWorld;
	bool m_bEnableUseOutput;
	float32 m_flTouchOutputPerEntityDelay;
	CEntityIOOutput m_OnDamaged;
	CEntityIOOutput m_OnAwakened;
	CEntityIOOutput m_OnMotionEnabled;
	CEntityIOOutput m_OnPlayerUse;
	CEntityIOOutput m_OnStartTouch;
	CHandle< CBasePlayerPawn > m_hCarryingPlayer;
};
