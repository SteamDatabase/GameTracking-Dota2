basic_ambient is a barebones starting point for effects that emit continuously over time and never stop playing on their own.  The example featured here is a small column of ambient environmental smoke or steam.

This is a very simple effect with just one component and no children.

It does have a number of influences on its motion, though:
  *A small initial velocity via its Position Within Sphere Random
  *Drag in its Movement Basic
  *A random force Force Generator which applies the broad motion necessary to get the column
  *A turbulent force Force Generator which adds hand-tunable noise to the particles' motion

At times it may be necessary to stack up motion influences like this in order to achieve naturalistic results, but don't automatically make that assumption - sometimes simply adding positive or negative gravity (by modifying the third or "Z" field of the Movement Basic Operator) introduces enough movement to look good.