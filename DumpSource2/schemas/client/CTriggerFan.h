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
};
