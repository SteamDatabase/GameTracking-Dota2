class CDOTA_Modifier_Tusk_WalrusKick_AirTime : public CDOTA_Buff
{
	int32 hp_threshold;
	float32 m_flStartZ;
	float32 m_flCurTime;
	float32 m_flOldPitch;
	QAngle m_qRotation;
	int32 m_nRotations;
	Vector m_vDirection;
	float32 m_flEndTime;
	float32 push_length;
};
