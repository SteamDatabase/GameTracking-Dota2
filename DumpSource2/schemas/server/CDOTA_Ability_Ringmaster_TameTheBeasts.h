// MNetworkVarNames = "GameTime_t m_flStartTime"
// MNetworkVarNames = "Vector m_vStartLocation"
class CDOTA_Ability_Ringmaster_TameTheBeasts : public CDOTABaseAbility
{
	Vector m_vCrackLocation;
	CDOTA_BaseNPC* m_pTarget;
	CHandle< CBaseEntity > m_hThinker;
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
