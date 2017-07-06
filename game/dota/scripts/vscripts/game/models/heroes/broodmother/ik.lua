function CreateBroodMotherIKChain( bonePrefix, boneSuffix, bForwardIsXPositive )

	local endEffectorBoneName = bonePrefix .. "3" .. boneSuffix

	local metatarsusBoneName = bonePrefix .. "2" .. boneSuffix	-- Last 'knuckle'
	local tibiaName = bonePrefix .. "1" .. boneSuffix			-- Second to last 'knuckle'

	return model:CreateIKChain( 
				endEffectorBoneName,
				endEffectorBoneName,
				{
					bones_point_along_positive_x = bForwardIsXPositive,

					target_orientation_speedlimit=360,	-- Degrees per second we'll adjust to match the target: -1 means don't limit speed, but will result in pops
					target_position_speedlimit=100000,	-- Distance units per second we'll adjust to match the target: -1 means don't limit speed, but will result in pops

					rules = {
						{ type="ground", height=200, trace_diameter=5 },
					},

					lockInfo = {
						boneInfluenceDriver="__no_bone_yet__",
						reverseFootLockBone="__no_bone_yet__",
						hyperExtensionReleaseThreshold=0.99,	-- Percentage of maximum 'straightness' before we release the lock: unused if boneInfluenceDriver isn't set.
						maxLockDistanceToTarget=10 				-- unit discrepancy from target before we release: unused if boneInfluenceDriver isn't set.
					},

					solverInfo = {
						type="perlin"
					},

					constraints = {
						{ type="hinge", joint=metatarsusBoneName, min_angle=30, max_angle=140 }
						--{ type="hinge", joint=tibiaName, min_angle=0, max_angle=90 } -- need more than a two bone solver for this
					},
				}
		)
end

local bEnableIK = true

if bEnableIK then

	-- Back legs
	CreateBroodMotherIKChain( "SimpleBugLeg_", "_R", false )
	CreateBroodMotherIKChain( "SimpleBugLeg_", "_L", true )

	-- Middle legs
	CreateBroodMotherIKChain( "SimpleBugLeg_", "_A_R", false )
	CreateBroodMotherIKChain( "SimpleBugLeg_", "_A_L", true )

	-- Front legs
	CreateBroodMotherIKChain( "SimpleBugLeg_", "_B_R", false )
	CreateBroodMotherIKChain( "SimpleBugLeg_", "_B_L", true )

	-- Hook up the control rig 
	model:CreateIKControlRig("bug", {
		legs = {
			"SimpleBugLeg_3_R",
			"SimpleBugLeg_3_A_R",
			"SimpleBugLeg_3_B_R",
			"SimpleBugLeg_3_L",
			"SimpleBugLeg_3_A_L",
			"SimpleBugLeg_3_B_L",
		},

		pivot_bone="root", -- This is probably incorrect
		pivot_influence=1.0,
	})
end
