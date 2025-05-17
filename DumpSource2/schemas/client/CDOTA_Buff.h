class CDOTA_Buff : public C_HorizontalMotionController
{
	CUtlSymbolLarge m_name;
	CUtlSymbolLarge m_iszModifierAura;
	int32 m_iSerialNumber;
	// MFieldVerificationName = "m_iStringIndex"
	int32 m_iPaddingToMakeSchemaHappy;
	int32 m_iIndex;
	GameTime_t m_flCreationTime;
	int32 m_iCreationFrame;
	GameTime_t m_flLastAppliedTime;
	float32 m_flDuration;
	GameTime_t m_flDieTime;
	CHandle< C_BaseEntity > m_hCaster;
	CHandle< C_BaseEntity > m_hAbility;
	CHandle< C_BaseEntity > m_hParent;
	CHandle< C_BaseEntity > m_hAuraOwner;
	int32 m_iStackCount;
	int16 m_iAuraSearchTeam;
	int16 m_iAuraSearchType;
	int32 m_iAuraSearchFlags;
	float32 m_flAuraRadius;
	int32 m_iTeam;
	int32 m_iAttributes;
	// MFieldVerificationName = "m_iTooltipParity"
	int16 m_iTooltipParity;
	bitfield:1 m_bIsAura;
	bitfield:1 m_bIsAuraActiveOnDeath;
	bitfield:1 m_bMarkedForDeletion;
	bitfield:1 m_bAuraIsHeal;
	bitfield:1 m_bProvidedByAura;
	bitfield:1 m_bCurrentlyInAuraRange;
	bool m_bPurgedDestroy;
	GameTime_t m_flPreviousTick;
	float32 m_flThinkInterval;
	float32 m_flThinkTimeAccumulator;
	CUtlVector< CDOTA_BuffParticle > m_iParticles;
	CUtlVector< CHandle< C_BaseEntity > > m_hAuraUnits;
	HSCRIPT m_hScriptScope;
};
