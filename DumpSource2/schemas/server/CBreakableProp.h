// MNetworkVarNames = "CPropDataComponent::Storage_t m_CPropDataComponent"
class CBreakableProp : public CBaseProp
{
	// MNetworkEnable
	// MNetworkUserGroup = "CPropDataComponent"
	// MNetworkAlias = "CPropDataComponent"
	// MNetworkTypeAlias = "CPropDataComponent"
	CPropDataComponent m_CPropDataComponent;
	CEntityIOOutput m_OnStartDeath;
	CEntityIOOutput m_OnBreak;
	CEntityOutputTemplate< float32 > m_OnHealthChanged;
	CEntityIOOutput m_OnTakeDamage;
	float32 m_impactEnergyScale;
	int32 m_iMinHealthDmg;
	QAngle m_preferredCarryAngles;
	float32 m_flPressureDelay;
	float32 m_flDefBurstScale;
	Vector m_vDefBurstOffset;
	CHandle< CBaseEntity > m_hBreaker;
	PerformanceMode_t m_PerformanceMode;
	GameTime_t m_flPreventDamageBeforeTime;
	BreakableContentsType_t m_BreakableContentsType;
	CUtlString m_strBreakableContentsPropGroupOverride;
	CUtlString m_strBreakableContentsParticleOverride;
	bool m_bHasBreakPiecesOrCommands;
	float32 m_explodeDamage;
	float32 m_explodeRadius;
	float32 m_explosionDelay;
	CUtlSymbolLarge m_explosionBuildupSound;
	CUtlSymbolLarge m_explosionCustomEffect;
	CUtlSymbolLarge m_explosionCustomSound;
	CUtlSymbolLarge m_explosionModifier;
	int32 m_explosionDangerSound;
	CHandle< CBasePlayerPawn > m_hPhysicsAttacker;
	GameTime_t m_flLastPhysicsInfluenceTime;
	float32 m_flDefaultFadeScale;
	CHandle< CBaseEntity > m_hLastAttacker;
	CUtlSymbolLarge m_iszPuntSound;
	bool m_bUsePuntSound;
	bool m_bOriginalBlockLOS;
};
