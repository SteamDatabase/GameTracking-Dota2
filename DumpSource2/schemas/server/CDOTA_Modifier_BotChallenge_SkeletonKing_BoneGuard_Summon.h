class CDOTA_Modifier_BotChallenge_SkeletonKing_BoneGuard_Summon : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	int32 talent_skeleton_damage;
	bool m_bRespawnReady;
	bool m_bRespawnConsumed;
	bool m_bKillParentOnDestroy;
	GameTime_t m_flRespawnTime;
	int32 vampiric_aura;
	int32 gold_bounty;
	int32 xp_bounty;
	int32 skeleton_building_damage_reduction;
	int32 skeleton_bonus_hero_damage;
};
