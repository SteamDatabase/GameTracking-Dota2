// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CDOTAMinesweeperGameDefinition
{
	CDOTAMinesweeperPlayerDefinition m_player;
	CUtlVector< CDOTAMinesweeperStageDefinition > m_vecStages;
	float32 m_flTimeLimit;
	int32 m_nIllusionManaCost;
	int32 m_nStageProgressionTimerIncrease;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_dustEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_grassEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_explosionEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_manaPotEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_timerIncreaseEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_illusionEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_lostManaPotEffect;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_lostTimerIncreaseEffect;
	int32 m_nManaPotRestoration;
	int32 m_nMaxConcurrentManaPots;
	int32 m_nManaPotExpireClicks;
	int32 m_nManaPotChance;
	float32 m_flTimeExtension;
	int32 m_nMaxConcurrentTimerIncreases;
	int32 m_nTimerIncreaseExpireClicks;
	int32 m_nTimerIncreaseChance;
	int32 m_nScorePerCellRevealed;
	int32 m_nScorePerStageCleared;
	int32 m_nScorePerSecondsRemaining;
	int32 m_nFailedChordClickTimes;
	int32 m_flFailedChordClickCooldown;
};
