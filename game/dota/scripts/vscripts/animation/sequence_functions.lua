--[[
LayerSequenceOverSequence
Layers a sequence on top of another seqeunce using the given weightlist
Output is a new full body sequence
]]--
function LayerSequenceOverSequence( options )
	local weightlist = options.weightlist or nil
	local model = options.model or nil
	local name = options.name or nil
	local source = options.source or nil
	local target = options.target or nil
	local framerangefromsource = options.framerangefromsource or false
		
	local worldspace = options.worldspace
	
	framerangesequence = target
	if framerangefromsource then
		framerangesequence = source
	end

	-- if worldspace is not defined make it true
	if worldspace == nil then
		bWorldSpace = true
	else
		bWorldSpace = options.worldspace
	end
	
	-- error checking
	if not model then
		Log_Error( "model not specified" )
		return
	end
	
	if not name then
		Log_Error( "sequence name not specified" )
		return
	end
	
	if not source then
		Log_Error( "source animation not specified" )
		return
	end
	
	-- sequence arguments
	local args = {}
	args["name"] = name
	args["framerangesequence"] = framerangesequence
	
	-- sequence commands
	local cmds = {}
	local cmdTarget = { cmd = "sequence", sequence = target, dst = 1 }
	local cmdSequence = { cmd = "sequence", sequence = source, dst = 2 }
	local cmdWorldspace = { cmd = "worldspace", dst = 1, src = 2 }
	local cmdSlerp = { cmd = "slerp", dst = 1, src = 2 }
	if weightlist then
		cmdWorldspace["weightlist"] = weightlist
		cmdSlerp["weightlist"] = weightlist
	end
	local cmdFinalSlerp = { cmd = "slerp", dst = 0, src = 1 }

	table.insert( cmds, cmdTarget )
	table.insert( cmds, cmdSequence )
	if bWorldSpace then 
		table.insert( cmds, cmdWorldspace )
	else 
		table.insert( cmds, cmdSlerp )
	end 
	table.insert( cmds, cmdFinalSlerp )
	
	args["cmds"] = cmds
	model:CreateSequence( args )
end


