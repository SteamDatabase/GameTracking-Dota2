class CDOTA_Modifier_Hoodwink_Decoy_Invisibility : public CDOTA_Modifier_Invisible
{
	int32 movement_speed;
	CUtlVector< CHandle< C_BaseEntity > > m_hEntitiesAffected;
}
