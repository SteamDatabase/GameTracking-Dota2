class CDOTA_Modifier_Weaver_Swarm : public CDOTA_Buff
{
	int32 m_iMaxDist;
	int32 m_iAttackCount;
	int32 destroy_attacks;
	Vector m_vDirection;
	Vector m_vStartLoc;
	CHandle< CBaseEntity > m_hAttachTarget;
}
