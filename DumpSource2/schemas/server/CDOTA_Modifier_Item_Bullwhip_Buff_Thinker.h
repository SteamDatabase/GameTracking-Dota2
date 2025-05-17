class CDOTA_Modifier_Item_Bullwhip_Buff_Thinker : public CDOTA_Buff
{
	int32 speed;
	CHandle< CBaseEntity > m_hTarget;
	ParticleIndex_t m_nFXIndex;
};
