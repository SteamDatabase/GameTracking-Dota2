enum RenderPrimitiveType_t : uint32_t
{
	RENDER_PRIM_POINTS = 0,
	RENDER_PRIM_LINES = 1,
	RENDER_PRIM_LINES_WITH_ADJACENCY = 2,
	RENDER_PRIM_LINE_STRIP = 3,
	RENDER_PRIM_LINE_STRIP_WITH_ADJACENCY = 4,
	RENDER_PRIM_TRIANGLES = 5,
	RENDER_PRIM_TRIANGLES_WITH_ADJACENCY = 6,
	RENDER_PRIM_TRIANGLE_STRIP = 7,
	RENDER_PRIM_TRIANGLE_STRIP_WITH_ADJACENCY = 8,
	RENDER_PRIM_INSTANCED_QUADS = 9,
	RENDER_PRIM_HETEROGENOUS = 10,
	RENDER_PRIM_COMPUTE_SHADER = 11,
	RENDER_PRIM_MESH_SHADER = 12,
	RENDER_PRIM_TYPE_COUNT = 13,
};
