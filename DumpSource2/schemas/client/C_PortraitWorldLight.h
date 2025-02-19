class C_PortraitWorldLight
{
	float32 m_flLatitude;
	float32 m_flLongitude;
	float32 m_flAdditionalRadius;
	float32 m_flBoundsRadiusMultiplier;
	CHandle< C_PortraitWorldUnit > m_hTarget;
	bool m_bShowGizmos;
	CUtlStringToken m_hitboxSetName;
	Vector m_vPreviousCenter;
	Vector m_vCenterVelocity;
	float32 m_flPreviousBoundingSphereRadius;
	float32 m_flBoundingSphereRadiusChangeSpeed;
	bool m_bPreviousValuesInitialized;
};
