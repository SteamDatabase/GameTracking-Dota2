class CDOTA_Ability_AncientApparition_IceBlast : public C_DOTABaseAbility
{
	CountdownTimer m_PathTimer;
	Vector m_vTarget;
	Vector m_vStartPos;
	Vector m_vLastTempViewer;
	int32 m_iTrackerProjectile;
	float32 path_radius;
	float32 radius_min;
	float32 radius_max;
	float32 radius_grow;
	float32 frostbite_duration;
	float32 target_sight_radius;
	CUtlVector< CHandle< C_BaseEntity > > m_hFrostbittenEntities;
}
