class CreatureAbilityData_t
{
	CHandle< CBaseEntity > hAbility;
	bool bIsDamage;
	bool bIsDebuff;
	bool bIsStun;
	bool bIsAOE;
	bool bIsLinear;
	bool bUseOnCreeps;
	bool bIsHeal;
	bool bIsBuff;
	bool bUseSelfishly;
	bool bCanHelpOthersEscape;
	bool bUseOnTrees;
	bool bUseOnStrongestAlly;
	int32 nUseAtHealthPercent;
	int32 nRadius;
	int32 nMinimumTargets;
	int32 nMaximumTargets;
	int32 nMinimumHP;
	int32 nMinimumRange;
	float32 flInitialCooldownMin;
	float32 flInitialCooldownMax;
	CreatureAbilityType nAbilityType;
};
