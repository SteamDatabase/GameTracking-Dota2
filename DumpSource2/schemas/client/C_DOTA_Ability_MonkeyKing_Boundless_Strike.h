class C_DOTA_Ability_MonkeyKing_Boundless_Strike : public C_DOTABaseAbility
{
	int32 strike_cast_range;
	int32 strike_radius;
	int32 spring_channel_pct;
	ParticleIndex_t m_nFXIndex;
	bool m_bIsAltCastState;
	CUtlVector< C_DOTA_BaseNPC* > struckEntities;
}
