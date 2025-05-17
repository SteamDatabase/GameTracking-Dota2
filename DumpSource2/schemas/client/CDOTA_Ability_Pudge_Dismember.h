// MNetworkVarNames = "CHandle< CBaseEntity> m_hVictim"
class CDOTA_Ability_Pudge_Dismember : public C_DOTABaseAbility
{
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hVictim;
	int32 shard_cast_range;
};
