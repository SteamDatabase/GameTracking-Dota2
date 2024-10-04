class CDOTA_Ability_AghsFort_Ravage_Potion : public CDOTA_Item
{
	CUtlVector< CHandle< CBaseEntity > > m_hEntsHit;
	int32 damage;
	float32 duration;
	float32 spend_charge_delay;
};
