class CDOTA_Modifier_Ogre_Magi_Ignite_Multicast : public CDOTA_Buff
{
	CHandle< CDOTA_BaseNPC > m_hTarget;
	float32 multicast_delay;
	int32 m_nMultiCastCount;
	float32 ignite_multicast_aoe;
};
