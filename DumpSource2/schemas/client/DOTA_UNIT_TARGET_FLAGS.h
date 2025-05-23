// MEnumFlagsWithOverlappingBits
enum DOTA_UNIT_TARGET_FLAGS : uint32_t
{
	DOTA_UNIT_TARGET_FLAG_NONE = 0,
	DOTA_UNIT_TARGET_FLAG_RANGED_ONLY = 2,
	DOTA_UNIT_TARGET_FLAG_MELEE_ONLY = 4,
	DOTA_UNIT_TARGET_FLAG_DEAD = 8,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES = 16,
	DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES = 32,
	DOTA_UNIT_TARGET_FLAG_INVULNERABLE = 64,
	DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE = 128,
	DOTA_UNIT_TARGET_FLAG_NO_INVIS = 256,
	DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS = 512,
	DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED = 1024,
	DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED = 2048,
	DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED = 4096,
	DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS = 8192,
	DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE = 16384,
	DOTA_UNIT_TARGET_FLAG_MANA_ONLY = 32768,
	DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP = 65536,
	DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO = 131072,
	DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD = 262144,
	DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED = 524288,
	DOTA_UNIT_TARGET_FLAG_PREFER_ENEMIES = 1048576,
	DOTA_UNIT_TARGET_FLAG_RESPECT_OBSTRUCTIONS = 2097152,
	DOTA_UNIT_TARGET_FLAG_CAN_BE_SEEN = 384,
};
