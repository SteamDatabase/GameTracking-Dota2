// MNetworkVarNames = "Vector m_vStartLocation"
class C_DOTA_Ability_Rubick_Telekinesis : public C_DOTABaseAbility
{
	// MNetworkEnable
	Vector m_vStartLocation;
	Vector m_vLandLocation;
	GameTime_t m_flStartTime;
	C_DOTA_BaseNPC* m_pTarget;
};
