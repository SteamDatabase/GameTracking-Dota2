basic_explosion should serve as a good starting point for effects that emit instantaneously and disappear after a short time (including explosions.)

The effect hierarchy looks like this:

basic_explosion (actually just a container for the child effects)
  -basic_explosion_bits (small trails that fly away from the core and then fall from gravity)
  -basic_explosion_burst (a turbulent wave of energy)
  -basic_explosion_flash (a simple, fast flash of light to lend some extra visual punch)

Unlike basic_projectile, the components of this effect are much more freeform.  You could remove, add, or modify any component and you'd still have a functioning one-shot instant-emission effect as long as you had at least one child effect making particles.

The main basic_explosion effect is an empty container in this case because this provides complete control over the sorting of effect components; if your effect doesn't require this, you could just as easily make one of the component effects the parent (basic_explosion_bits, for example) and then make the other two into children.

Note that two of these sub-effects demonstrate the use of multiple renderers within a single effect - basic_explosion_bits (two trail renderers with two different textures) and basic_explosion_burst (a sprite renderer and a deferred light renderer.)