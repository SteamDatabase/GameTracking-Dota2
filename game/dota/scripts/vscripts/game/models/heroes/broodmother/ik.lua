function CreateBroodMotherIKChainTable( bonePrefix, boneSuffix, bForwardIsXPositive )

	local endEffectorBoneName	= bonePrefix .. "3" .. boneSuffix

	local tarsusBoneName		= bonePrefix .. "2" .. boneSuffix	-- Last 'knuckle'
	local metaTarsusBoneName	= bonePrefix .. "1" .. boneSuffix	-- Second to last 'knuckle'

	local tibiaBoneName			= bonePrefix .. "0" .. boneSuffix	-- Root 'knuckle'

	return	{
				-- Basic definition
					chain_name=endEffectorBoneName,
					end_effector_bone_name=endEffectorBoneName,					-- (Required) The bone we manipulate, and use to build a bone chain.
					root_bone=tibiaBoneName,
					bones_point_along_positive_x=bForwardIsXPositive,			-- (Optional) Do bones point to their children along positive X?
					solver_info = { type="fabrik" },

				-- Smoothing parameters; velocity based.
					target_orientation_speedlimit=180.000000,					-- (Optional) How fast we can change the end effectors orientation towards a target (in modelspace), in degrees per second.
					target_position_speedlimit=1000,							-- (Optional) How fast we can change the end effectors position towards a target (in modelspace), in inches per second.

				-- Rules for this chain
					rules=
						{
							{
								type = "ground",
								height = 100.000,
								trace_diameter = 5.000,
							},
						},

				constraints = {
					{ type="hinge", joint=tarsusBoneName, min_angle=200, max_angle=359},
					{ type="hinge", joint=metaTarsusBoneName, min_angle=200, max_angle=359},
					--{ type="hinge", joint=tibiaBoneName, min_angle=200, max_angle=359}, -- I think this joint requires a spherical constraint
				},
			}
end

model:CreateIKControlRig( "bug",
	{
		rig_settings =
		{
			legs = { 
				"SimpleBugLeg_3_A_R",
				"SimpleBugLeg_3_B_R",
				"SimpleBugLeg_3_B_L",
				"SimpleBugLeg_3_A_L",
				"SimpleBugLeg_3_L",
				"SimpleBugLeg_3_R",
			},

			tilt_bone="root"
		},
		common_settings=
		{
			chains =
			{
				-- TODO: These are created in clockwise order so that we can do the Newell plane solve. Should solve this tool side.
				CreateBroodMotherIKChainTable( "SimpleBugLeg_", "_A_R", false ),	-- Middle right
				CreateBroodMotherIKChainTable( "SimpleBugLeg_", "_B_R", false ),	-- Front right
				CreateBroodMotherIKChainTable( "SimpleBugLeg_", "_B_L", true ),		-- Front left
				CreateBroodMotherIKChainTable( "SimpleBugLeg_", "_A_L", true ),		-- Middle left
				CreateBroodMotherIKChainTable( "SimpleBugLeg_", "_L", true ), 		-- Back left
				CreateBroodMotherIKChainTable( "SimpleBugLeg_", "_R", false ),		-- Back right
			},
		},
	}
)

