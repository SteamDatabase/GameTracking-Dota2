--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- Script called for each vagrp which doesn't have an associated script
--
--=============================================================================


-- get a list of all the animations
local sAnimNameList = model:GetAnimationList()


-- build a sequence for everything
for _, sAnimName in pairs( sAnimNameList ) do
	-- Calling this will add a reference to the lua table created in C++ so make local
--	if sAnimName == "@Idle_Falling" then
		local sequence = SSingleAnimationSequence( model, "script_" .. sAnimName, sAnimName )
		return
--	end
end

-- print( "\nDone making default sequences\n" );
