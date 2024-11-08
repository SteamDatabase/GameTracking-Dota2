class CBaseAnimGraphAnimGraphController : public CAnimGraphControllerBase
{
	CAnimGraph1ParamOptionalRef< char* > m_sDestructiblePartDestroyedHitGroup;
	CAnimGraph1ParamOptionalRef< int32 > m_nDestructiblePartDestroyedPartIndex;
};
