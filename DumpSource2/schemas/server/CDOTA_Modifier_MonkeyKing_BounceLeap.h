class CDOTA_Modifier_MonkeyKing_BounceLeap : public CDOTA_Buff
{
	float32 give_up_distance;
	float32 ground_jump_distance;
	float32 m_flZDelta;
	float32 perched_day_vision;
	float32 perched_night_vision;
	Vector m_vStart;
	CHandle< CBaseEntity > m_hTarget;
	Vector m_vTargetPos;
	float32 m_flSpeed;
	bool m_bTargetingEntity;
	bool m_bGroundToTree;
	bool m_bTreeToGround;
	bool m_bTreeToTree;
	bool m_bIsSpringJump;
	float32 m_fSpringChanneledPercent;
	int32 m_nLeapSpeed;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndex2;
	float32 m_flFlightDuration;
	float32 m_flCurrentTimeVert;
};
