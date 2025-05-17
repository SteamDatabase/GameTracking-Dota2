class CDOTA_Modifier_Roshan_Grab_Self : public CDOTA_Buff
{
	CHandle< CDOTA_BaseNPC > m_hTarget;
	Vector m_vPulverizeCenter;
	Vector m_vCasterStartPos;
	float32 interval;
};
