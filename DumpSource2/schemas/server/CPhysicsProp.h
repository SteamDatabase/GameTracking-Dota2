class CPhysicsProp
{
	CEntityIOOutput m_MotionEnabled;
	CEntityIOOutput m_OnAwakened;
	CEntityIOOutput m_OnAwake;
	CEntityIOOutput m_OnAsleep;
	CEntityIOOutput m_OnPlayerUse;
	CEntityIOOutput m_OnOutOfWorld;
	CEntityIOOutput m_OnPlayerPickup;
	bool m_bForceNavIgnore;
	bool m_bNoNavmeshBlocker;
	bool m_bForceNpcExclude;
	float32 m_massScale;
	float32 m_buoyancyScale;
	int32 m_damageType;
	int32 m_damageToEnableMotion;
	float32 m_flForceToEnableMotion;
	bool m_bThrownByPlayer;
	bool m_bDroppedByPlayer;
	bool m_bTouchedByPlayer;
	bool m_bFirstCollisionAfterLaunch;
	bool m_bHasBeenAwakened;
	bool m_bIsOverrideProp;
	DynamicContinuousContactBehavior_t m_nDynamicContinuousContactBehavior;
	GameTime_t m_fNextCheckDisableMotionContactsTime;
	int32 m_iInitialGlowState;
	int32 m_nGlowRange;
	int32 m_nGlowRangeMin;
	Color m_glowColor;
	bool m_bShouldAutoConvertBackFromDebris;
	bool m_bMuteImpactEffects;
	bool m_bAcceptDamageFromHeldObjects;
	bool m_bEnableUseOutput;
	CPhysicsProp::CrateType_t m_CrateType;
	CUtlSymbolLarge[4] m_strItemClass;
	int32[4] m_nItemCount;
	bool m_bRemovableForAmmoBalancing;
	bool m_bAwake;
};
