class CBaseProp : public CBaseAnimatingActivity
{
	bool m_bModelOverrodeBlockLOS;
	int32 m_iShapeType;
	bool m_bConformToCollisionBounds;
	CTransform m_mPreferredCatchTransform;
};
