enum ParticleCollisionMode_t : uint32_t
{
	COLLISION_MODE_PER_PARTICLE_TRACE = 3,
	COLLISION_MODE_USE_NEAREST_TRACE = 2,
	COLLISION_MODE_PER_FRAME_PLANESET = 1,
	COLLISION_MODE_INITIAL_TRACE_DOWN = 0,
	COLLISION_MODE_DISABLED = -1,
};
