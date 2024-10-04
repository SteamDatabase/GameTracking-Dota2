class CDOTA_Ability_MonkeyKing_Boundless_Strike : public CDOTABaseAbility
{
	int32 strike_cast_range;
	int32 strike_radius;
	int32 spring_channel_pct;
	ParticleIndex_t m_nFXIndex;
	bool m_bIsAltCastState;
	CUtlVector< CDOTA_BaseNPC* > struckEntities;
}
