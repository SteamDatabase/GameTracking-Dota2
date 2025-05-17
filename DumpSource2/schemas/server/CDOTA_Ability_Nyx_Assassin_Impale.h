class CDOTA_Ability_Nyx_Assassin_Impale : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
	float32 width;
	float32 duration;
	float32 length;
	float32 speed;
	Vector vOriginalCast;
};
