class CDOTA_Ability_Tinker_Keen_Teleport : public CDOTABaseAbility
{
	int32 creep_teleport_level;
	int32 hero_teleport_level;
	float32 outpost_channel_time;
	float32 jungle_outpost_channel_time;
	CHandle< CBaseEntity > m_hTeleportTarget;
	ParticleIndex_t m_nFXOrigin;
	ParticleIndex_t m_nFXDestination;
	VectorWS m_vDestination;
	int32 m_iMinDistance;
	float32 m_flBaseTeleportTime;
};
