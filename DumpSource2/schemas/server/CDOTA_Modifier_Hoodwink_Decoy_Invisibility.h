class CDOTA_Modifier_Hoodwink_Decoy_Invisibility : public CDOTA_Modifier_Invisible
{
	int32 movement_speed;
	CUtlVector< CHandle< CBaseEntity > > m_hEntitiesAffected;
}
