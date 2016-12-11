--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- Script that is run when the modelprocessing vscript system starts
--
--=============================================================================

-- Msg( "ModelProcessing - Initializing script VM...\n" )

-------------------------------------------------------------------------------


-- returns a string like "foo.nut:53"
-- with the source file and line number of its caller.
-- returns the empty string if it couldn't get the source file and line number of its caller.
function _sourceline(self) 
    local v
    -- FIXUP: Please fixup this call - Lua counterpart incompatible, manual fixup required - getstackinfos
    v = getstackinfos(2)
    if v then 
        return v.src .. ":" .. v.line .. " "
    else 
        return ""
    end
end

-- Msg( "ModelProcessing - ...done\n" )


-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
require "modelprocessing.utilities"
require "modelprocessing.sequences"
require "modelprocessing.animations"
