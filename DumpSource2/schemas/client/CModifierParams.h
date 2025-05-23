class CModifierParams
{
	CHandle< C_DOTABaseAbility > ability;
	float32 fDamage;
	float32 fOriginalDamage;
	int32 nActivity;
	bool bTooltip;
	int32 nTooltipParam;
	bool bIgnoreInvis;
	bool bNoCooldown;
	bool bIgnoreBaseArmor;
	bool bIgnoreBaseMagicArmor;
	bool bReincarnate;
	bool bDoNotConsume;
	bool bReportMax;
	float32 fDistance;
	float32 fGain;
	float32 fAttackTimeRemaining;
	PlayerID_t m_nIssuerPlayerIndex;
	PlayerID_t m_nVictimPlayerID;
	int32 nDamageType;
	int32 nDamageflags;
	int32 nDamageCategory;
	int32 iFailType;
	int16 iRecord;
	int32 nCost;
	int32 nHealthCost;
	int32 nOrdertype;
	Vector vOldLoc;
	Vector vNewLoc;
	Vector vCastLocation;
	bool bCraniumBasherTested;
	bool bMKBTested;
	bool bOctarineTested;
	bool bHeartRegenApplied;
	bool bSangeAmpApplied;
	bool bLocketAmpApplied;
	bool bPaladinAmpApplied;
	bool bBlademailApplied;
	bool bForceFieldApplied;
	bool bKayaApplied;
	bool bYashaAndKayaApplied;
	bool bStoutConsidered;
	bool bAegisUsed;
	bool bRaindropUsed;
	bool bInterrupted;
	bool bDiffusalApplied;
	bool bChainLightningConsidered;
	bool bSuppressDamage;
	bool bRangedAttack;
	bool bProcessProcs;
	bool bProjectileIsFromIllusion;
	bool bHasMagicComponent;
	bool bIsSpellLifesteal;
	bool bBloodstoneRegenApplied;
	bool bShroudManaRestoreApplied;
	bool bPhylacteryApplied;
	bool bAllowZeroDamageFromPostReductionBlock;
	bool bForceMagicStickProc;
	bool bIgnoreNegativeValuesIfDebuffImmune;
	bool bIgnorePositiveValuesIfDebuffImmune;
	bool bIgnoreAllIfDebuffImmune;
	bool bAlsoIgnoreBuffsIfDebuffImmune;
	bool bIgnoreLowerIfDebuffImmune;
	float32 flIgnoreLowerIfDebuffImmune;
	bool bIgnoreHigherIfDebuffImmune;
	float32 flIgnoreHigherIfDebuffImmune;
	bool bIgnoreTemporaryAttackSpeedModifiers;
	char* pszAbilitySpecialName;
	int32 nAbilitySpecialLevel;
	CHandle< C_BaseEntity > hattacker;
	CHandle< C_BaseEntity > htarget;
	CHandle< C_BaseEntity > hunit;
	CHandle< C_DOTABaseAbility > inflictor;
	CDOTA_Buff* pAddedBuff;
};
