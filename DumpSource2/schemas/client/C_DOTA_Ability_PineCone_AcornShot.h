// MNetworkVarNames = "DotaTreeId_t m_nAcornTree"
class C_DOTA_Ability_PineCone_AcornShot : public C_DOTABaseAbility
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPineConeAcornTreePlanted"
	uint32 m_nAcornTree;
	float32 projectile_speed;
	float32 bounce_delay;
	int32 bounce_range;
	int32 bounce_count;
};
