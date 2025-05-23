enum PulseValueType_t : uint32_t
{
	// MPropertyFriendlyName = "Void"
	PVAL_INVALID = -1,
	// MPropertyFriendlyName = "Boolean"
	PVAL_BOOL = 0,
	// MPropertyFriendlyName = "Integer"
	PVAL_INT = 1,
	// MPropertyFriendlyName = "Float"
	PVAL_FLOAT = 2,
	// MPropertyFriendlyName = "String"
	PVAL_STRING = 3,
	// MPropertyFriendlyName = "Vector"
	PVAL_VEC3 = 4,
	// MPropertyFriendlyName = "Angle"
	PVAL_QANGLE = 5,
	// MPropertyFriendlyName = "World Vector"
	PVAL_VEC3_WORLDSPACE = 6,
	// MPropertyFriendlyName = "Transform"
	PVAL_TRANSFORM = 7,
	// MPropertyFriendlyName = "World Transform"
	PVAL_TRANSFORM_WORLDSPACE = 8,
	// MPropertyFriendlyName = "Color"
	PVAL_COLOR_RGB = 9,
	// MPropertyFriendlyName = "Game Time"
	PVAL_GAMETIME = 10,
	// MPropertyFriendlyName = "Entity Handle"
	PVAL_EHANDLE = 11,
	// MPropertyFriendlyName = "Resource"
	PVAL_RESOURCE = 12,
	// MPropertyFriendlyName = "SoundEvent Instance Handle"
	PVAL_SNDEVT_GUID = 13,
	// MPropertyFriendlyName = "SoundEvent"
	PVAL_SNDEVT_NAME = 14,
	// MPropertyFriendlyName = "Entity Name"
	PVAL_ENTITY_NAME = 15,
	// MPropertyFriendlyName = "Opaque Handle"
	PVAL_OPAQUE_HANDLE = 16,
	// MPropertyFriendlyName = "Typesafe Int"
	PVAL_TYPESAFE_INT = 17,
	// MPropertySuppressEnumerator
	PVAL_CURSOR_FLOW = 18,
	// MPropertyFriendlyName = "Any"
	PVAL_ANY = 19,
	// MPropertyFriendlyName = "Schema Enum"
	PVAL_SCHEMA_ENUM = 20,
	// MPropertyFriendlyName = "Panorama Panel Handle"
	PVAL_PANORAMA_PANEL_HANDLE = 21,
	// MPropertyFriendlyName = "Test Handle"
	PVAL_TEST_HANDLE = 22,
	// MPropertyFriendlyName = "Array"
	PVAL_ARRAY = 23,
	// MPropertySuppressEnumerator
	PVAL_COUNT = 24,
};
