class CDOTA_Modifier_Shredder_TimberChain : public CDOTA_Buff
{
	CUtlVector< CHandle< CBaseEntity > > m_hDamaged;
	CHandle< CBaseEntity > m_hTarget;
	Vector m_vStartPosition;
	int32 speed;
	int32 radius;
	int32 damage;
	int32 tree_splinter_count;
};
