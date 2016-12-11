-- animation functions
SqAnimation = class({}, {}, s_animation_t)

function SqAnimation:constructor(animationName, addAnim) 
    addAnim = addAnim or false
    if not animationName then 
        print("!!!ERROR!!! Animation does not have a name")
        return
    end
    print("Creating Animation: " .. animationName)
    getbase(self):constructor()
    SetName(animationName)
    if addAnim then 
        AddAnimation(self)
    end
end



-- copies specified animation to current animation, and resets name back to it's original name
-- since Copy() overwrites the name with the copied anims name
function SqAnimation:SqCopyAnim(animation) 
    local name = GetName(self)
    Copy(animation)
    SetName(name)
end


-- helper function to print out all the animations on a model
function SqPrintAnimations(self) 
    for _, animation in pairs(GetAnimationList()) do
        print(" * Animation: " .. animation)
    end
end
