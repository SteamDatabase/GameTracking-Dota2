class CDOTA_Modifier_Enchantress_NaturesAttendants : public CDOTA_Buff
{
	float32 heal_interval;
	float32 heal;
	float32 radius;
	float32 movespeed;
	int32 wisp_count;
	ParticleIndex_t m_nWispFXIndex;
	bool m_bAutoWisps;
};
