// MNetworkVarNames = "bool m_bFirstSongPlayed"
// MNetworkVarNames = "float m_flSongStartTime"
// MNetworkVarNames = "int m_nBurstEffect"
// MNetworkVarNames = "int m_nFailEffect"
class CDOTA_Ability_Largo_AmphibianRhapsody : public CDOTABaseAbility
{
	float32 duration;
	float32 rhythm_grace_period;
	float32 movement_burst_duration;
	float32 slow_resistance_burst_duration;
	float32 radius;
	float32 heal_burst;
	int32 max_stacks;
	float32 burst_damage;
	float32 damage_per_stack;
	// MNetworkEnable
	bool m_bFirstSongPlayed;
	// MNetworkEnable
	float32 m_flSongStartTime;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBurstEffectChanged"
	int32 m_nBurstEffect;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnFailEffectChanged"
	int32 m_nFailEffect;
};
