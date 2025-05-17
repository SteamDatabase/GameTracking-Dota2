class CDOTA_Modifier_MonkeyKing_ArcToGround : public CDOTA_Buff
{
	float32 leap_speed;
	float32 give_up_distance;
	float32 attackspeed_duration;
	float32 m_flOriginalZDelta;
	float32 m_flZDelta;
	Vector m_vStart;
	Vector m_vTargetPos;
	float32 m_flSpeed;
	bool m_bDroppedFromTree;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndex2;
	float32 m_flOriginalHeight;
	bool m_bRightClickHop;
};
