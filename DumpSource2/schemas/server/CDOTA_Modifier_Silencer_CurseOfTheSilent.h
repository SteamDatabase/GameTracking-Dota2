class CDOTA_Modifier_Silencer_CurseOfTheSilent : public CDOTA_Buff
{
	int32 damage;
	ParticleIndex_t nFxIndex;
	int32 penalty_duration;
	float32 penalty_multiplier;
	int32 movespeed;
	int32 undispellable;
	bool from_global_silence;
};
