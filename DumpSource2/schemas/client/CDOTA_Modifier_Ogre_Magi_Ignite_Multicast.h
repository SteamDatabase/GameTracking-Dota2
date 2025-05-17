class CDOTA_Modifier_Ogre_Magi_Ignite_Multicast : public CDOTA_Buff
{
	CHandle< C_DOTA_BaseNPC > m_hTarget;
	float32 multicast_delay;
	int32 m_nMultiCastCount;
	int32 ignite_multicast_aoe;
};
