class C_DOTA_Ability_Tusk_Snowball : public C_DOTABaseAbility
{
	float32 snowball_windup_radius;
	float32 snowball_radius;
	int32 snowball_grow_rate;
	int32 snowball_damage;
	int32 snowball_damage_bonus;
	float32 stun_duration;
	float32 stun_duration_bonus;
	int32 bonus_damage;
	float32 bonus_stun;
	int32 snowball_speed;
	int32 snowball_speed_bonus;
	float32 snowball_duration;
	Vector m_vProjectileLocation;
	CUtlVector< CHandle< C_BaseEntity > > m_hSnowballedUnits;
	ParticleIndex_t m_nFXIndex;
	CountdownTimer ctSnowball;
	bool m_bSpeakAlly;
	bool m_bIsExpired;
	bool m_bInWindup;
	CHandle< C_BaseEntity > m_hPrimaryTarget;
	int32 m_nContainedValidUnits;
	bool m_bEndingSnowball;
};
