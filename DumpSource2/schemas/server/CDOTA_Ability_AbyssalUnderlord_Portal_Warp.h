// MNetworkVarNames = "float m_flChannelTime"
class CDOTA_Ability_AbyssalUnderlord_Portal_Warp : public CDOTABaseAbility
{
	CHandle< CBaseEntity > m_hTarget;
	// MNetworkEnable
	float32 m_flChannelTime;
	CHandle< CBaseEntity > m_hSpawnUnderlingThinker;
	CHandle< CBaseEntity > m_hWarrior;
	CHandle< CBaseEntity > m_hArcher;
};
