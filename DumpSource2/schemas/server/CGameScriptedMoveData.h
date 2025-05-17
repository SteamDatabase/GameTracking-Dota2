// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class CGameScriptedMoveData
{
	Vector m_vAccumulatedRootMotion;
	float32 m_flAccumulatedRootMotionRotation;
	Vector m_vSrc;
	QAngle m_angSrc;
	QAngle m_angDst;
	QAngle m_angCurrent;
	float32 m_flLockedSpeed;
	float32 m_flAngRate;
	float32 m_flDuration;
	GameTime_t m_flStartTime;
	bool m_bActive;
	bool m_bTeleportOnEnd;
	bool m_bIgnoreRotation;
	ScriptedMoveType_t m_nType;
	bool m_bSuccess;
	ForcedCrouchState_t m_nForcedCrouchState;
	bool m_bIgnoreCollisions;
	Vector m_vDest;
	CHandle< CBaseEntity > m_hDestEntity;
};
