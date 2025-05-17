class CDOTA_Modifier_DeathProphet_SpiritSiphon : public CDOTA_Buff
{
	float32 flSmoothness;
	float32 damage;
	float32 damage_pct;
	int32 drain_range;
	float32 haunt_duration;
	int32 siphon_buffer;
	int32 movement_steal;
	CHandle< C_BaseEntity > m_hTarget;
	ParticleIndex_t m_iLinkIndex;
	int32 m_nSelfBuffSerialNumber;
	int32 m_nTargetDebuffSerialNumber;
	bool m_bAppliedFear;
	float32 shard_fear_duration;
	float32 shard_consecutive_siphon_duration;
};
