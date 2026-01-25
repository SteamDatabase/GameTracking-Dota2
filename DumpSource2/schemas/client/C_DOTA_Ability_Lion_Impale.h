class C_DOTA_Ability_Lion_Impale : public C_DOTABaseAbility
{
	float32 width;
	float32 duration;
	int32 speed;
	float32 length_buffer;
	float32 range;
	int32 pierces_immunity;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
};
