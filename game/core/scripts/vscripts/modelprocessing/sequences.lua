---------------------
-- Sequences
---------------------
SqSequence = class({}, {}, s_sequence_t)

-- creates a sequence based off of a single animation
function SqSequence:constructor(seqName, animationName) 
    if not seqName then 
        error("!!!ERROR!!!: You need to give the sequence a name" .. "\n")
    end
    local animation = nil
    if animationName then 
        local animCheck = FindAnimation(animationName)
        if not animCheck then 
            error("!!!ERROR!!!: Cannot find animation named: " .. animationName .. "\n")
            return
        else 
            animation = animCheck
        end
    else 
        local seqCheck = FindAnimation(seqName)
        if not seqCheck then 
            error("!!!ERROR!!!: Cannot find animation named: " .. seqName .. "\n")
            return
        else 
            animation = seqCheck
        end
    end
    getbase(self):constructor()
    SetName(seqName)
    print("Creating Sequence: " .. self:GetName())
    SetGroupSize(1, 1)
    SetAnimArray(0, 0, animation)
    AddSequence(self)
end


function SqSequence:SqHelp() 
    SqSequenceHelp(self)
end


function SqSequenceHelp(self) 
    print("\n----------------------")
    print("SqSequence Help")
    print("----------------------")
    print("local seq = SqSequence( \"sequence_name\", \"animation_name\" )")
    print("Creates a Sequence named \"name\", from the animation \"animation_name\"")
    print("If you don't specify an animation name, it will assume the name of the sequence and the name of the animation are the same")
    print("ex. local seq = SqSequence( \"idle_run\" ) is the same as typing local seq = Sequence ( \"idle_run\", \"idle_run\" ) ")
    print("Once you have a sequence you can: ")
    print(".Layer( \"name\", options )")
    print(".Activity( \"name\", weight ) : sets an activity with a name and weight")
    print("\nOnly create sequences if you need to add activities, or perform layering/blending")
    print("If you just need to play something back, an animation is fine")
    print("----------------------\n")
end


function SqSequence:SqActivity(name, weight) 
    weight = weight or 1
    self:SetActivityName(name)
    self:SetActivityWeight(weight)
end


function SqSequence:SqLayer(layerName, args) 
    args = args or {}
    local defaultValues = 
    {
        splineBlend = false,
        multipleCrossFades = false,
        overrideCrossFades = false,
        localSpaceBlend = true,
        startFrame = 0,
        endFrame = 0,
        peakFrame = 0,
        tailFrame = 0
    }
    
    local values = addInArgs(self, defaultValues, args)
    AddLayer(layerName, values.splineBlend, values.multipleCrossFades, values.overrideCrossFades, values.localSpaceBlend, values.startFrame, values.peakFrame, values.tailFrame, values.endFrame)
end


SqNineWayMotion = class(
{
    
    defaultArguments = 
    {
        addClavicle = true,
        verticalPoseName = "move_left",
        verticalMin = -1.0,
        verticalMax = 1.0,
        horizontalPoseName = "move_forward",
        horizontalMin = -1.0,
        horizontalMax = 1.0
    },
    groupSizeX = 3,
    groupSizeY = 3
}, {}, s_sequence_t)

-- this is a l4d2 style run that takes the clavicle motion and adds it as a layer
-- addClavicle = false to turn this behavior off
function SqNineWayMotion:constructor(seqName, animations, arguments) 
    arguments = arguments or {}
    if not seqName then 
        error("You need to specify a name\n")
        return
    end
    if not animations then 
        error("You need to give NineWayMotion: " .. seqName .. ", some animations\n")
        return
    end
    getbase(self):constructor()
    SetName(seqName)
    SqCreate(seqName, animations, arguments)
end


function SqNineWayMotion:SqCreate(seqName, anims, arguments) 
    anims = anims or {}
    arguments = arguments or {}
    print("Creating Nine Way Motion Sequence: " .. self:GetName())
    local args = addInArgs(self, self.defaultArguments, arguments)
    SetGroupSize(self.groupSizeX, self.groupSizeY)
    self:SetVerticalPoseParam(args.verticalPoseName, args.verticalMin, args.verticalMax)
    self:SetHorizontalPoseParam(args.horizontalPoseName, args.horizontalMin, args.horizontalMax)
    
    local animations = 
    {
        
        {
            anims.sw,
            anims.w,
            anims.nw
        },
        
        {
            anims.s,
            anims.c,
            anims.n
        },
        
        {
            anims.se,
            anims.e,
            anims.ne
        }
    }
    
    for nRow = 1, #animations, 1 do
        for nColumn = 1, #animations[nRow], 1 do
            local anim = FindAnimation(animations[nRow][nColumn])
            if anim then 
                SetAnimArray(nRow, nColumn, anim)
            else 
                error("ERROR: Cannot Find Animation: " .. animations[nRow][nColumn] .. "\n")
            end
        end
    end
    AddSequence(self)
    if args.addClavicle then 
        local clavicleSeq = SqSequence(seqName .. "_clavicles", anims.n)
        ApplyBoneMask(clavicleSeq, "clavicles_only")
        SqLayer(seqName .. "_clavicles")
    end
end


function SqNineWayMotion:SqActivity(name, weight) 
    weight = weight or 1
    self:SetActivityName(name)
    self:SetActivityWeight(weight)
end


function SqNineWayMotion:SqLayer(layerName, args) 
    args = args or {}
    local defaultValues = 
    {
        splineBlend = false,
        multipleCrossFades = false,
        overrideCrossFades = false,
        localSpaceBlend = false,
        startFrame = 0,
        endFrame = 0,
        peakFrame = 0,
        tailFrame = 0
    }
    local values = addInArgs(self, defaultValues, args)
    AddLayer(layerName, values.splineBlend, values.multipleCrossFades, values.overrideCrossFades, values.localSpaceBlend, values.startFrame, values.peakFrame, values.tailFrame, values.endFrame)
end


function SqNineWayMotion:SqHelp() 
    SqNineWayMotionHelp(self)
end


function SqNineWayMotionHelp(self) 
    print("\nSqNineWayMotion Help")
    print("----------------------")
    print("Creates a 3x3 blended run  ( l4d2 style ), ex:")
    print("local myRun = SqNineWayMotion( \"name\", \"animationTable\" , \"arguments\" )")
    print("Arguments:")
    for key, value in pairs(defaultValues) do
        print("\t" .. key .. " = " .. value)
    end
    print("AddClavicle arg adds the clavicle motion of the run_n animation to the sequence")
    print("To override the default names, do something like this:")
    print("animationTable.run_n = \"injured_run_n\" ")
    print("animationTable.run_c = \"injured_idle\" ")
    print("animationTable.run_s = \"injured_run_s\" ")
    print("local myRun = SqNineWayMotion( \"name\", \"animationTable\" )")
    print("----------------------\n")
end


-------------------
-- aim matrix
-------------------
SqAimMatrix = class(
{
    defaultValues = 
    {
        verticalPoseName = "body_yaw",
        verticalMin = -90,
        verticalMax = 90,
        horizontalPoseName = "body_pitch",
        horizontalMin = -90.0,
        horizontalMax = 45.0,
        boneMask = "upper_body"
    },
    groupSizeX = 3,
    groupSizeY = 4
}, {}, s_sequence_t)

function SqAimMatrix:constructor(seqName, animationName, args) 
    args = args or {}
    if not seqName then 
        error("!!!ERROR!!!: You need to give the aim matrix a name" .. "\n")
        return
    end
    local animation = nil
    if animationName then 
        local animCheck = FindAnimation(animationName)
        if not animCheck then 
            error("!!!ERROR!!!: Cannot find animation named: " .. animationName .. "\n")
            return
        else 
            animation = animCheck
        end
    else 
        local seqCheck = FindAnimation(seqName)
        if not seqCheck then 
            error("!!!ERROR!!!: Cannot find animation named: " .. seqName .. "\n")
            return
        else 
            animation = seqCheck
        end
    end
    getbase(self):constructor()
    SqCreate(seqName, animation, args)
end


function SqAimMatrix:SqCreate(seqName, animation, args) 
    SetName(seqName)
    local values = addInArgs(self, self.defaultValues, args)
    print("Creating 3x4 Aim Sequence: " .. self:GetName())
    SetGroupSize(self.groupSizeX, self.groupSizeY)
    self:SetVerticalPoseParam(values.verticalPoseName, values.verticalMin, values.verticalMax)
    self:SetHorizontalPoseParam(values.horizontalPoseName, values.horizontalMin, values.horizontalMax)
    
    local neutral = SqAnimation(seqName .. "_neutral", false)
    neutral:SqCopyAnim(animation)
    neutral:SetFrameRange(4, 4)
    
    local aims = 
    {
        "down_right",
        "down_center",
        "down_left",
        "mid_right",
        "mid_center",
        "mid_left",
        "up_right",
        "up_center",
        "up_left",
        "straight_up"
    }
    for i, aim in pairs(aims) do
        local aimAnim = SqAnimation(seqName .. "_" .. aim)
        aimAnim:SqCopyAnim(animation)
        aimAnim:SetFrameRange(i, i)
        aimAnim:Subtract(neutral, 0)
        AddAnimation(aimAnim)
    end
    
    local animations = 
    {
        
        {
            "down_left",
            "mid_left",
            "up_left",
            "straight_up"
        },
        
        {
            "down_center",
            "mid_center",
            "up_center",
            "straight_up"
        },
        
        {
            "down_right",
            "mid_right",
            "up_right",
            "straight_up"
        }
    }
    
    for nRow = 1, #animations, 1 do
        for nColumn = 1, #animations[nRow], 1 do
            local anim = FindAnimation(seqName .. "_" .. animations[nRow][nColumn])
            SetAnimArray(nRow, nColumn, anim)
        end
    end
    AddSequence(self)
    ApplyBoneMask(self, values.boneMask)
end


function SqAimMatrix:SqHelp() 
    SqAimMatrixHelp(self)
end


function SqAimMatrixHelp(self) 
    print("\nSqAimMatrix Help")
    print("----------------------")
    print("Creates a 3x4 aim matrix, ex:")
    print("local myAim = SqAimMatrix( \"name\" , \"animation_name\", \"arguments\")")
    print("Arguments:")
    for key, value in pairs(defaultValues) do
        print("\t" .. key .. " = " .. value)
    end
    print("local myAim = SqAimMatrix( \"name\" , \"animation_name\", { boneMask = \"lower_body\" } )")
    print("will over-ride the default value and add in the specifed one")
    print("----------------------\n")
end

-- print all the bone masks
function SqPrintBoneMasks(self) 
    for _, boneMask in pairs(GetBoneMaskList()) do
        print(" * BoneMask: " .. boneMask)
    end
end


-- helper function to print out all the animations on a model
function SqPrintSequences(self) 
    for _, seq in pairs(GetSequenceList()) do
        print(" * Sequence: " .. seq)
    end
end
