 -------------------
-- utility functions
--------------------

-- takes a table of arguments , compares it to a table of deault values
-- and returns a table that is the default value plus new non default values
function addInArgs(self, defaultTable, argTable) 
    local newTable = {}
    
    for idx, _ in pairs(defaultTable) do
        if vlua.contains(argTable, idx) then 
            newTable[idx] = argTable[idx]
        else 
            newTable[idx] = defaultTable[idx]
        end
    end
    
    return newTable
end
