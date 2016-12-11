--========= Copyright (c) Valve Corporation. All Rights Reserved. ============
--============================================================================

----------------------------------------------------------------------------------------------------------
DoIncludeScript("game/globalsystems/timeofday_core", getfenv(1))
DoIncludeScript("game/globalsystems/timeofday_skymodel", getfenv(1))


----------------------------------------------------------------------------------------------------------
TimeOfDay_RegisterFloat("IsNight")


----------------------------------------------------------------------------------------------------------
g_DayNightCycle = SkyModel_CreateDayNightCycle(g_TimeOfDayKeyValues)

g_StartClockTime = g_TimeOfDayKeyValues:GetNumber("time", 12.0)

g_InitTime = g_GameTime



do
    local physicalSunDirection = SkyModel_SunLightDirectionForDayNightCycle(g_DayNightCycle, g_StartClockTime)

    g_IsNight = (physicalSunDirection.z < 0.0)

end


----------------------------------------------------------------------------------------------------------
-- The time-of-day entity calls this script every so often to ask for current conditions
----------------------------------------------------------------------------------------------------------
function CalculateTimeOfDayState() 
    local physicalSkyHaze = 0.0
    local clockTime = SkyModel_CalculateClockTime(g_StartClockTime, g_GameTime - g_InitTime, g_DayNightCycle)
    local physicalSunDirection = SkyModel_SunLightDirectionForDayNightCycle(g_DayNightCycle, clockTime)
    local physicalSunColor = SkyModel_SunLightColorForLightParameters(physicalSkyHaze, physicalSunDirection.z)
    
    -- Uncomment to print information about the sun light color/angles and sky lighting
    -- SkyModel_PrintLightInfo( g_DayNightCycle, physicalSkyHaze )

    if g_TimeOfDayEntity then 
        local wasNight = g_IsNight
        g_IsNight = (physicalSunDirection.z < 0.0)
        
        if g_IsNight and not wasNight then 
            g_TimeOfDayEntity:FireOutput("OnSunset", nil, nil, nil, 0.0)
        elseif not g_IsNight and wasNight then
            g_TimeOfDayEntity:FireOutput("OnSunrise", nil, nil, nil, 0.0)
        end
    end
    
    local result = 
    {
        Global = 
        {
            SunLightDirection = physicalSunDirection,
            SunLightColor = physicalSunColor,
            PhysicalSkyHaze = physicalSkyHaze,
            PhysicalSky = 1.0,
            RayleighScattering = Rayleigh(2.0),
            MieScattering = Mie(4.0),
            MieTightness = 0.6,
            IsNight = g_IsNight and 1.0 or 0.0
        }
    }
    
    return result
end
