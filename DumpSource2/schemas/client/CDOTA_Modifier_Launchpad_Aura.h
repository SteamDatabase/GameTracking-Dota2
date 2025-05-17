class CDOTA_Modifier_Launchpad_Aura : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hNextNode;
	Vector m_vDirection;
	float32 m_flDistance;
	float32 radius;
	float32 vision_cone;
};
