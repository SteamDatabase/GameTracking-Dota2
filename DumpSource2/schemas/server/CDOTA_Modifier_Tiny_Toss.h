class CDOTA_Modifier_Tiny_Toss : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	float32 m_flPredictedTotalTime;
	Vector m_vStartPosition;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bHorizontalMotionInterrupted;
	bool m_bDamageApplied;
	bool m_bTargetTeleported;
	Vector m_vHorizontalVelocity;
	Vector m_vLastKnownTargetPosition;
	float32 m_flInitialVelocityZ;
	bool m_bDone;
	float32 radius;
	int32 toss_damage;
	int32 bonus_land_damage_pct;
	float32 land_debuff_duration;
}
