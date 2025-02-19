class C_Team
{
	C_NetworkUtlVectorBase< CHandle< CBasePlayerController > > m_aPlayerControllers;
	C_NetworkUtlVectorBase< CHandle< C_BasePlayerPawn > > m_aPlayers;
	int32 m_iScore;
	char[129] m_szTeamname;
};
