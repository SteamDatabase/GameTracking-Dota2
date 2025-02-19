class CDOTA_Modifier_Dawnbreaker_Fire_Wreath_Caster
{
	int32 movement_speed;
	int32 shard_movement_penalty;
	int32 swipe_radius;
	int32 swipe_damage;
	int32 smash_radius;
	int32 smash_damage;
	int32 m_nCurrentSpeed;
	float32 flSwipeInterval;
	GameTime_t m_flNextHit;
	int32 iCurrentAttack;
	int32 total_attacks;
	float32 smash_stun_duration;
	float32 sweep_stun_duration;
	bool m_bHasCompletedMove;
	float32 duration;
	Vector m_vTargetHorizontalDirection;
	int32 smash_distance_from_hero;
	float32 animation_rate;
	float32 turn_rate;
	float32 m_flFacingTarget;
	int32 movespeed_bonus_self_max;
	int32 movespeed_bonus_ally_max;
	int32 movespeed_bonus_radius;
	float32 movespeed_bonus_duration;
	int32 m_iSuccessfulSwipesHittingHeroes;
};
