This basic_projectile effect is a good starting point for any custom effects that are treated as "projectiles" in the engine.  This includes many hero abilities and virtually all physical ranged attacks.

The effect hierarchy looks like this:

basic_projectile (master projectile)
  -basic_projectile_launch (burst that plays when the projectile is first shot)
  -basic_projectile_trail (visuals for the projectile while in flight)
  -basic_projectile_explosion (burst that plays on the target when the projectile hits)
    -basic_projectile_explosion_flash (a little extra flourish for the explosion)

This means that the game logic only calls one named effect (basic_projectile), and all of the other effects are called by their parent effect.  Basic_projectile doesn't actually contain any visuals on its own, but is instead used as an envelope to set up the logic for the child effects.

Projectile effects have a specific setup in which they get a lot of important data from the engine via control points (CPs).  CP0 is only used as an emission point by basic_projectile itself; its child effects all emit from CP3, which is set by the top-level effect in the Operator "Set child control points from particle positions".

CP1 is the projectile's target, and the effect gets its speed from CP2.

This is all important because it means that for projectiles, there are certain operators that SHOULD NOT BE MODIFIED when creating custom projectile effects.  Modifying or removing these runs the risk of completely breaking your effect's behavior.

The ops that shouldn't be changed are all in the base_projectile file:

*Movement Max Velocity: Recieves the projectile's speed from the game engine and sets it.  (So even though it has a listed max velocity of 600, that value is being overridden by the projectile speed the effect is getting from the engine.
*Set child control points from particle positions: Creates control points from which the child effects will emit.
*emit_instantaneously: Emits a single master particle.
*Pull towards control point: Responsible for the effect's movement toward its target.  The force is set extraordinarily high, but is limited by the Movement Max Velocity operator.

The remaining ops (Movement Basic, Lifespan Decay, and Position Within Sphere Random) are less subject to the special setup used for projectiles, but there shouldn't generally be any reason to modify them unless you know exactly what you're doing.

In most situations, the only things you'll want to change when using basic_projectile as a projectile effect template are the child effects.

That said, keep in mind that each child effect (except basic_projectile_explosion_flash) is doing an important job here - removing any of them (rather than simply modifying them) risks, at a minimum, making your projectile look weird and incomplete.