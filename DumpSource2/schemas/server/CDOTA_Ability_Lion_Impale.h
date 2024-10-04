class CDOTA_Ability_Lion_Impale : public CDOTABaseAbility
{
	float32 width;
	float32 duration;
	int32 speed;
	float32 length_buffer;
	float32 range;
	int32 m_iDefaultCastRange;
	int32 pierces_immunity;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};
