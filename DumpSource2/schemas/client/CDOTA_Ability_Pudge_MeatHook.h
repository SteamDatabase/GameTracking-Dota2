class CDOTA_Ability_Pudge_MeatHook
{
	Vector m_vEndpoint;
	int32 m_nConsecutiveHits;
	bool m_bIsVectorTargeted;
	Vector m_vTurnLocation;
	Vector m_vDirectionAfterTurn;
	bool m_bHasTurned;
	float32 m_flDistanceAfterTurn;
	Vector m_vFinalPosition;
	float32 reveal_duration;
	int32 curve_hook;
	float32 curve_hook_turn_rate;
	int32 curve_hook_debug;
	float32 m_fTimeRemaining;
	float32 m_flFacingTarget;
};
