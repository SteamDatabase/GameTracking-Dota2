class CDOTA_Modifier_Attached_Unit : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hAttachTarget;
	bool m_bPhysicalImmune;
	bool m_bMagicImmune;
};
