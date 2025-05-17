// MNetworkVarNames = "GameTime_t m_flStartTime"
// MNetworkVarNames = "Vector m_vStartLocation"
class C_DOTA_Ability_Ringmaster_TameTheBeasts : public C_DOTABaseAbility
{
	Vector m_vCrackLocation;
	C_DOTA_BaseNPC* m_pTarget;
	CHandle< C_BaseEntity > m_hThinker;
	ParticleIndex_t m_nAvailableAOEFXIndex;
	ParticleIndex_t m_nFinalAOEFXIndex;
	ParticleIndex_t m_nWhipAOEFXIndex;
	bool m_bWhiped;
	// MNetworkEnable
	GameTime_t m_flStartTime;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnSetStartLocation"
	Vector m_vStartLocation;
};
