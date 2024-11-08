class C_BasePropDoor : public C_DynamicProp
{
	DoorState_t m_eDoorState;
	bool m_modelChanged;
	bool m_bLocked;
	bool m_bNoNPCs;
	Vector m_closedPosition;
	QAngle m_closedAngles;
	CHandle< C_BasePropDoor > m_hMaster;
	Vector m_vWhereToSetLightingOrigin;
};
