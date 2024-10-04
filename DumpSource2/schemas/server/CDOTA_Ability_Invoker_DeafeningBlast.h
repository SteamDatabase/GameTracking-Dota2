class CDOTA_Ability_Invoker_DeafeningBlast : public CDOTA_Ability_Invoker_InvokedBase
{
	float32 end_vision_duration;
	float32 damage;
	float32 knockback_duration;
	float32 disarm_duration;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
	bool m_bGrantedGem;
}
