basic_rope demonstrates a single non-decaying static rope effect whose texture scrolls rapidly to suggest turbulent energy.  It has no child effects.

The only operator is "Set Single Control Point Position", which sets CP1 512 units above CP0.  We do this because the Position initializer we're using, "Position Along Path Sequential", requires two control points in order to define its path.

In "Position Along Path Sequential", we set up the path and assign it 16 particles from start to end, which matches the spawn count in our emitter.

The Rope Renderer's "texture V Scroll Rate" is set pretty high - 800 - to get simple visual turbulence by scrolling a texture with painted-in noise.

There are a few non-basic initializers - a cluster of three "Remap Particle Count to Scalar" inits.  Because it's an instant effect, and the particles are sequential along a line, we know exactly which particle will be where along the line.  That means we can very efficiently initialize groups of particles with specific attributes.

In this case, I wanted to soften the beginning and end of the rope, so I'm remapping the particle count to the alpha.  The key to making this work is the "only active within specified input range" Property of the "Remap Particle Count to Scalar" init.  Normally the minimum and maximum values would clamp beyond their range, but with this Property switched on, we're telling the initializer to ignore input values outside the locally-specified range.

That means that with our three Remap inits, we're telling:

1. Particles 0-3 to interpolate from alpha 0 to alpha 1.0.
2. Particles 4-11 to interpolate from alpha 1.0 to alpha 1.0 (that is, to be full alpha within this range.)
3. Particles 12-15 to interpolate from alpha 1.0 back down to 0.

If we wanted this effect to decay after 4 seconds, and alpha-fade in and out, we could retain our soft ends by switching the particle count remappers to "Alpha Alternate" instead of "Alpha".

