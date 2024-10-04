class C_DOTA_Ability_Nyx_Assassin_Impale : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > hAlreadyHitList;
	int32 width;
	float32 duration;
	int32 length;
	int32 speed;
	Vector vOriginalCast;
};
