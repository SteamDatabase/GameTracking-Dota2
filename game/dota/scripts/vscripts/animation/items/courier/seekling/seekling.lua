-- Workshop Importer [run_anims]: Pose sequence
model:CreateSequence(
		  {
				name = "courier_turn_center",
				delta = true,
				fadeInTime = 0,
				fadeOutTime = 0,
				fps = 30,
				framerangesequence = "center_pose",
				cmds = {
					 { cmd = "sequence", sequence = "center_pose", dst = 1 },
					 { cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
					 { cmd = "subtract", dst = 1, src = 2 },
					 { cmd = "slerp", dst = 0, src = 1 }
				}
		  }
)
-- Workshop Importer [run_anims]: Pose sequence
model:CreateSequence(
		  {
				name = "courier_turn_left",
				delta = true,
				fadeInTime = 0,
				fadeOutTime = 0,
				fps = 30,
				framerangesequence = "left_pose",
				cmds = {
					 { cmd = "sequence", sequence = "left_pose", dst = 1 },
					 { cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
					 { cmd = "subtract", dst = 1, src = 2 },
					 { cmd = "slerp", dst = 0, src = 1 }
				}
		  }
)
-- Workshop Importer [run_anims]: Pose sequence
model:CreateSequence(
		  {
				name = "courier_turn_right",
				delta = true,
				fadeInTime = 0,
				fadeOutTime = 0,
				fps = 30,
				framerangesequence = "right_pose",
				cmds = {
					 { cmd = "sequence", sequence = "right_pose", dst = 1 },
					 { cmd = "fetchframe", sequence = "center_pose", frame = 0, dst = 2 },
					 { cmd = "subtract", dst = 1, src = 2 },
					 { cmd = "slerp", dst = 0, src = 1 }
				}
		  }
)
-- Workshop Importer [run_anims]: Turns sequence
model:CreateSequence(
	  {
			name = "courier_turns",
			delta = true,
		    fadeInTime = 0.2,
			fadeOutTime = 0.2,
			poseParamX = model:CreatePoseParameter( "turn", -1, 1, 0, false ),
			sequences = {
				 { "courier_turn_left", "courier_turn_center", "courier_turn_right" }
			}
	  }
)
-- Workshop Importer [run_anims]: Run sequence
model:CreateSequence(
	 {
		  name = "courier_run",
		  looping = true,
		  sequences = {
				{ "@courier_run" }
		  },
		  addlayer = { "courier_turns" },
		  activities = {
				{ name = "ACT_DOTA_RUN", weight = 1 }
		  }
	 }
)
