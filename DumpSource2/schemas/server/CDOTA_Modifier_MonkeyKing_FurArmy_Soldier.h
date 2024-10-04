class CDOTA_Modifier_MonkeyKing_FurArmy_Soldier : public CDOTA_Buff
{
	Vector m_vTargetPos;
	Vector m_vDirection;
	int32 move_speed;
	CHandle< CBaseEntity > m_hThinker;
	bool m_bIsInPosition;
	ParticleIndex_t m_nFXIndex;
	bool m_bAutoSpawn;
}
