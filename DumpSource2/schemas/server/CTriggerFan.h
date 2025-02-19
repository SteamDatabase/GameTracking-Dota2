class CTriggerFan
{
	Vector m_vFanOrigin;
	Vector m_vFanOriginOffset;
	Vector m_vFanEnd;
	Vector m_vNoiseDirectionTarget;
	Vector m_vDirection;
	bool m_bPushTowardsEntity;
	Quaternion m_qNoiseDelta;
	CHandle< CInfoFan > m_hInfoFan;
	float32 m_flForce;
	bool m_bFalloff;
	CountdownTimer m_RampTimer;
	CUtlSymbolLarge m_iszInfoFan;
	float32 m_flRopeForceScale;
	float32 m_flParticleForceScale;
	float32 m_flPlayerForce;
	bool m_bPlayerWindblock;
	float32 m_flNPCForce;
	float32 m_flRampTime;
	float32 m_fNoiseDegrees;
	float32 m_fNoiseSpeed;
	bool m_bPushPlayer;
	bool m_bRampDown;
	int32 m_nManagerFanIdx;
};
