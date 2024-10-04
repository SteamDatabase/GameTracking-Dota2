class CDOTA_Modifier_Enchantress_NaturesAttendants : public CDOTA_Buff
{
	float32 heal_interval;
	float32 heal;
	int32 radius;
	int32 movespeed;
	int32 wisp_count;
	ParticleIndex_t m_nWispFXIndex;
	bool m_bAutoWisps;
}
