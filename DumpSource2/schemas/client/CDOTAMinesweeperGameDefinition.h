// MGetKV3ClassDefaults = {
//	"m_player":
//	{
//		"m_nInitialHealth": 1,
//		"m_nInitialMana": 0
//	},
//	"m_vecStages":
//	[
//	],
//	"m_flTimeLimit": -0.617683,
//	"m_nIllusionManaCost": 32766,
//	"m_nStageProgressionTimerIncrease": 940547877,
//	"m_dustEffect": "",
//	"m_grassEffect": "",
//	"m_explosionEffect": "",
//	"m_manaPotEffect": "",
//	"m_timerIncreaseEffect": "",
//	"m_illusionEffect": "",
//	"m_lostManaPotEffect": "",
//	"m_lostTimerIncreaseEffect": "",
//	"m_nManaPotRestoration": 0,
//	"m_nMaxConcurrentManaPots": 0,
//	"m_nManaPotExpireClicks": 0,
//	"m_nManaPotChance": 0,
//	"m_flTimeExtension": 0.000000,
//	"m_nMaxConcurrentTimerIncreases": 0,
//	"m_nTimerIncreaseExpireClicks": 142137600,
//	"m_nTimerIncreaseChance": -220279147,
//	"m_nScorePerCellRevealed": 0,
//	"m_nScorePerStageCleared": 0,
//	"m_nScorePerSecondsRemaining": -232,
//	"m_nFailedChordClickTimes": -1,
//	"m_flFailedChordClickCooldown": 2
//}
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
