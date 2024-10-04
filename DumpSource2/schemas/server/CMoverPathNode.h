class CMoverPathNode : public CPointEntity
{
	Vector m_vInTangentLocal;
	Vector m_vOutTangentLocal;
	CUtlSymbolLarge m_szParentPathUniqueID;
	CEntityIOOutput m_OnPassThrough;
	CHandle< CPathMover > m_hMover;
}
