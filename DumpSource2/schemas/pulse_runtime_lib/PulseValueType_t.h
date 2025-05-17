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
	// MPropertyFriendlyName = "World Vector"
	PVAL_VEC3_WORLDSPACE = 5,
	// MPropertyFriendlyName = "Transform"
	PVAL_TRANSFORM = 6,
	// MPropertyFriendlyName = "World Transform"
	PVAL_TRANSFORM_WORLDSPACE = 7,
	// MPropertyFriendlyName = "Color"
	PVAL_COLOR_RGB = 8,
	// MPropertyFriendlyName = "Game Time"
	PVAL_GAMETIME = 9,
	// MPropertyFriendlyName = "Entity Handle"
	PVAL_EHANDLE = 10,
	// MPropertyFriendlyName = "Resource"
	PVAL_RESOURCE = 11,
	// MPropertyFriendlyName = "SoundEvent Instance Handle"
	PVAL_SNDEVT_GUID = 12,
	// MPropertyFriendlyName = "SoundEvent"
	PVAL_SNDEVT_NAME = 13,
	// MPropertyFriendlyName = "Entity Name"
	PVAL_ENTITY_NAME = 14,
	// MPropertyFriendlyName = "Opaque Handle"
	PVAL_OPAQUE_HANDLE = 15,
	// MPropertyFriendlyName = "Typesafe Int"
	PVAL_TYPESAFE_INT = 16,
	// MPropertySuppressEnumerator
	PVAL_CURSOR_FLOW = 17,
	// MPropertyFriendlyName = "Any"
	PVAL_ANY = 18,
	// MPropertyFriendlyName = "Schema Enum"
	PVAL_SCHEMA_ENUM = 19,
	// MPropertyFriendlyName = "Panorama Panel Handle"
	PVAL_PANORAMA_PANEL_HANDLE = 20,
	// MPropertyFriendlyName = "Test Handle"
	PVAL_TEST_HANDLE = 21,
	// MPropertyFriendlyName = "Array"
	PVAL_ARRAY = 22,
	// MPropertySuppressEnumerator
	PVAL_COUNT = 23,
};
