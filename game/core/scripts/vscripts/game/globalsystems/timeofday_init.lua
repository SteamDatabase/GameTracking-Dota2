--========= Copyright (c) Valve Corporation. All Rights Reserved. ============

-- Create a namespace in the global scope
TimeOfDay = {}

-------------------------------------------------------------------------------
function TimeOfDay:GetEntity() 
    local envTimeOfDay = Entities:FindByClassname(nil, "env_time_of_day")
    return envTimeOfDay
end


-------------------------------------------------------------------------------
function TimeOfDay:Float(timeofday, keyName, defaultValue) 
    if timeofday then 
        return timeofday:GetFloat(keyName, defaultValue)
    end
    
    return defaultValue
end


-------------------------------------------------------------------------------
function TimeOfDay:IsNight() 
    local noonMidnightCycle = TimeOfDay:Float(TimeOfDay.GetEntity(self), "NoonMidnightCycle", 0.0)
    
    return (noonMidnightCycle > 0.5)
end


-------------------------------------------------------------------------------
function TimeOfDay:IsDay()
    return not TimeOfDay:IsNight()
end


-------------------------------------------------------------------------------
-- Returns a value between 0 and 1, representing the progression of night time
-- Returns 0 at or before nightfall
-- Returns 1 at or after sunrise
-------------------------------------------------------------------------------
function TimeOfDay:NightProgress() 
    local timeEnt = TimeOfDay:GetEntity()
    local morningEveningCycle = TimeOfDay:Float(timeEnt, "MorningEveningCycle", 0.0)
    local noonMidnightCycle = TimeOfDay:Float(timeEnt, "NoonMidnightCycle", 0.0)
    
    if noonMidnightCycle > 0.5 then 
        return 1.0 - morningEveningCycle -- Night time progresses from evening->morning
    else 
        return (morningEveningCycle > 0.5) and 0.0 or 1.0 -- Day time - clamp to endpoints
    end
end

