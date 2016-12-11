--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
-- Script that is run when the animationsystem vscript system starts
--
--=============================================================================


-------------------------------------------------------------------------------
-- returns a string like "foo.nut:53"
-- with the source file and line number of its caller.
-- returns the empty string if it couldn't get the source file and line number of its caller.
-------------------------------------------------------------------------------
function _sourceline() 
    local v = debug.getinfo( 2 )
    if v then 
        return tostring( v.source ) .. ":" .. tostring( v.currentline ) .. " "
    else 
        return ""
    end
end



-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
AnimClasses = {}
AnimFramework = {}


-------------------------------------------------------------------------------
-- Function to tie script base class to a CPP class
-- NOTE: This is a copy and paste from EntityFramework:CreateScriptProxyClass
--       Perhaps the two should be unified
-------------------------------------------------------------------------------
function AnimFramework:CreateScriptProxyClass( className )
    local result = class(
    {

        constructor = function (self) end
,
        describe_R = function (self, depth, idx, val) 
            local rv = ""
            
            -- ignore class members that are functions since these do not show up in the class instance
            if "function" == type(val) then 
                return rv
            end
            
            local prefix = "\t"
            for i = 2, depth, 1 do
                prefix = prefix .. "\t"
            end
            
            if type(val) == "table" then
                rv = rv .. prefix .. idx .. " = " .. " is "
                local arraylen = #val
                -- If table is not empty but # length operator returns 0 then must be a table
                local istable = next(val) and tablelen == 0
                if not istable then
                    -- Might be an array, lets be sure by iterating and seeing if #entries returned by next
                    -- matches arraylen
                    local n = 0
                    for _, tval in pairs(val) do
                        n = n + 1
                        if n > arraylen then
                            istable = true
                            break
                        end
                    end
                end
                if istable then
                    rv = rv .. " table\n"
                    for i, val2 in pairs(val) do
                        rv = rv .. describe_R(depth + 1, i, val2)
                    end
                else
                    rv = rv .. " array, length " .. #val .. ")\n"
                    for i, val2 in ipairs(val) do
                        rv = rv .. describe_R(depth + 1, i, val2)
                    end
                end
            else 
                rv = rv .. (prefix .. idx .. " = " .. tostring(val) .. " (" .. type(val) .. ")\n")
            end
            
            return rv
        end
,
        inspect = function (self, detailLevel) 
            if detailLevel == kINSPECTION_FULL then 
                local rv = "inspecting " .. getclass(self) .. tostring(self) .. "\n"
                for idx, val in pairs(getclass(self) --[[ iterate through each entry in Foo's class table ]] ) do
                    rv = rv + self:describe_R(1, idx, val)
                end
                return rv
            end
            return ""
        end
    }, 
    {
        Specification = { scriptclassname = className }
    }, nil)
    
    -- Fallback to the function table for the C++ bindings
    getmetatable( result ).__index = _G[className]
    
    return result
end


-------------------------------------------------------------------------------
-- Scripted Sequence Base class, derive all scripted sequence classes from this
-------------------------------------------------------------------------------
function AnimFramework:CreateCppClassProxy( sClassName )
	if not vlua.contains( AnimClasses, sClassName ) then 
		AnimClasses[sClassName] = self:CreateScriptProxyClass( sClassName )
    end
end


-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
--print( "animationsystem - Initializing script VM..." .. _sourceline() )

require "utils.class"
require "utils.library"
require "animationsystem.utilities"
require "animationsystem.sequences"

--print( "animationsystem ...done" )