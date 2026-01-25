// MGetKV3ClassDefaults = {
//	"m_strLocHeroName": "",
//	"m_strLocFieldNotes": "",
//	"m_strLocNonHeroName": "",
//	"m_strLocPersonaFieldNotes": "",
//	"m_strNonHeroStickerName": "",
//	"m_strNonHeroStickerDisplayName": "",
//	"m_bAlwaysUnlocked": false,
//	"m_bIsHero": true,
//	"m_bIsForeword": false,
//	"m_nUnlocksAtCodexCompletionCount": -1,
//	"m_eAuthor": "k_eInvalid",
//	"m_ePersonaAuthor": "k_eInvalid"
//}
class CMonsterHunterHeroCodexDefinition
{
	CVDataLocalizedToken m_strLocHeroName;
	CVDataLocalizedToken m_strLocFieldNotes;
	CVDataLocalizedToken m_strLocNonHeroName;
	CVDataLocalizedToken m_strLocPersonaFieldNotes;
	CUtlString m_strNonHeroStickerName;
	CUtlString m_strNonHeroStickerDisplayName;
	bool m_bAlwaysUnlocked;
	bool m_bIsHero;
	bool m_bIsForeword;
	int32 m_nUnlocksAtCodexCompletionCount;
	EMonsterHunterCodexAuthor m_eAuthor;
	EMonsterHunterCodexAuthor m_ePersonaAuthor;
};
