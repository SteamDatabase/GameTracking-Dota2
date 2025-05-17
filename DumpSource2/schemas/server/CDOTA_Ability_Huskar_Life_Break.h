class CDOTA_Ability_Huskar_Life_Break : public CDOTABaseAbility
{
	Vector m_vProjectileLocation;
	CHandle< CBaseEntity > m_hTarget;
	bool m_bInterrupted;
};
