class CDOTA_Ability_Aghanim_Spear
{
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
	CUtlVector< int32 > m_vecProjectileHandles;
	Vector m_vTarget;
	Vector m_vSourcePosition;
	int32 damage;
};
