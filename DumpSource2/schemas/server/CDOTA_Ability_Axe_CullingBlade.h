class CDOTA_Ability_Axe_CullingBlade : public CDOTABaseAbility, public CHorizontalMotionController
{
	bool m_bInterrupted;
	Vector m_vProjectileLocation;
	CHandle< CBaseEntity > m_hTarget;
};
