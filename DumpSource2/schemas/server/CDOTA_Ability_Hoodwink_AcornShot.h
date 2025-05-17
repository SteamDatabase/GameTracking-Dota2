// MNetworkVarNames = "DotaTreeId_t m_nAcornTree"
class CDOTA_Ability_Hoodwink_AcornShot : public CDOTABaseAbility
{
	// MNetworkEnable
	uint32 m_nAcornTree;
	float32 projectile_speed;
	float32 bounce_delay;
	float32 bounce_range;
	int32 bounce_count;
	bool m_bIsAltCastState;
	int32 can_bounce_off_of_trees;
	int32 bounces_after_tree_bounce;
	bool bBouncedOffTree;
};
