// MNetworkVarNames = "Vector m_vStartLocation"
class CDOTA_Ability_Rubick_Telekinesis : public CDOTABaseAbility
{
	// MNetworkEnable
	Vector m_vStartLocation;
	Vector m_vLandLocation;
	GameTime_t m_flStartTime;
	CDOTA_BaseNPC* m_pTarget;
};
