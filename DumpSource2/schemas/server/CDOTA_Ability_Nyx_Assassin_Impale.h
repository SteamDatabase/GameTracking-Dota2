class CDOTA_Ability_Nyx_Assassin_Impale : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
	int32 width;
	float32 duration;
	int32 length;
	int32 speed;
	Vector vOriginalCast;
}
