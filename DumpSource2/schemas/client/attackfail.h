enum attackfail : uint32_t
{
	DOTA_ATTACK_RECORD_FAIL_NO = 0,
	DOTA_ATTACK_RECORD_FAIL_TERRAIN_MISS = 1,
	DOTA_ATTACK_RECORD_FAIL_SOURCE_MISS = 2,
	DOTA_ATTACK_RECORD_FAIL_TARGET_EVADED = 3,
	DOTA_ATTACK_RECORD_FAIL_TARGET_INVULNERABLE = 4,
	DOTA_ATTACK_RECORD_FAIL_TARGET_OUT_OF_RANGE = 5,
	DOTA_ATTACK_RECORD_CANNOT_FAIL = 6,
	DOTA_ATTACK_RECORD_FAIL_BLOCKED_BY_OBSTRUCTION = 7,
};
