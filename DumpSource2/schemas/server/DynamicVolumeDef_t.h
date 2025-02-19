class DynamicVolumeDef_t
{
	Vector m_vAttachAnchorPos;
	CHandle< CBaseEntity > m_target;
	int32 m_nHullIdx;
	float32 m_flSrcDistToCenter;
	float32 m_flDstDistToCenter;
	bool m_bAttached;
};
