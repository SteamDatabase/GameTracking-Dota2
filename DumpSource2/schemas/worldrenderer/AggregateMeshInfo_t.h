class AggregateMeshInfo_t
{
	uint32 m_nVisClusterMemberOffset;
	uint8 m_nVisClusterMemberCount;
	bool m_bHasTransform;
	uint8 m_nLODGroupMask;
	int16 m_nDrawCallIndex;
	int16 m_nLODSetupIndex;
	Color m_vTintColor;
	ObjectTypeFlags_t m_objectFlags;
	int32 m_nLightProbeVolumePrecomputedHandshake;
	uint32 m_nInstanceStreamOffset;
	AggregateInstanceStream_t m_instanceStreams;
};
