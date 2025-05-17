// MNetworkVarNames = "float m_flDamageTaken"
// MNetworkVarNames = "float m_flLastHit"
// MNetworkVarNames = "GameTime_t m_flStartDamageTime"
// MNetworkVarNames = "GameTime_t m_flLastTargetDummyDamageTime"
class C_DOTA_Unit_TargetDummy : public C_DOTA_BaseNPC_Hero
{
	// MNetworkEnable
	float32 m_flDamageTaken;
	// MNetworkEnable
	float32 m_flLastHit;
	// MNetworkEnable
	GameTime_t m_flStartDamageTime;
	// MNetworkEnable
	GameTime_t m_flLastTargetDummyDamageTime;
};
