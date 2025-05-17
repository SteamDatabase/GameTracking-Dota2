// MNetworkVarNames = "CHandle< CBaseEntity> m_hVictim"
class CDOTA_Ability_Pudge_Dismember : public CDOTABaseAbility
{
	// MNetworkEnable
	CHandle< CBaseEntity > m_hVictim;
	int32 shard_cast_range;
};
