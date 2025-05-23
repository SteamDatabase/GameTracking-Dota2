class sAcquireHistory
{
	AbilityID_t m_nAbilityID;
	int32 m_nLevel;
	int32 m_nGold;
	int32 m_nNetWorth;
	int32 m_bCombinedItem;
	float32 m_fGameTime;
	CUtlVector< AbilityID_t > m_vecItemList;
	CUtlVector< AbilityID_t > m_vecTalentSkilledList;
	CUtlVector< AbilityID_t > m_vecAvailableNeutralItemList;
	bool m_bSold;
};
