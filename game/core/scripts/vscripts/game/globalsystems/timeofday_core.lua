--========= Copyright (c) Valve Corporation. All Rights Reserved. ============
--============================================================================

----------------------------------------------------------------------------------------------------------
-- The time-of-day entity has a fixed number of data fields in which to store weather state.
-- These functions identify the names of those fields (i.e. what they mean to various systems).
-- Content in other systems (e.g. particle system) can query time-of-day with the names assigned.
----------------------------------------------------------------------------------------------------------

TimeOfDaySlotNames = {}
TimeOfDay_FloatSlotCounter = 0
TimeOfDay_VectorSlotCounter = 0


function TimeOfDay_RegisterFloat(slotName) 
    local key = "float" .. TimeOfDay_FloatSlotCounter
    TimeOfDaySlotNames[key] = slotName
    TimeOfDay_FloatSlotCounter = TimeOfDay_FloatSlotCounter + 1
end


function TimeOfDay_RegisterVector(slotName) 
    local key = "vector" .. TimeOfDay_VectorSlotCounter
    TimeOfDaySlotNames[key] = slotName
    TimeOfDay_VectorSlotCounter = TimeOfDay_VectorSlotCounter + 1
end


----------------------------------------------------------------------------------------------------------
-- These are the named data fields intrinsically supported by the system.
----------------------------------------------------------------------------------------------------------

-- Sunlight
TimeOfDay_RegisterVector("SunLightDirection")
TimeOfDay_RegisterVector("SunLightColor")


-- Skybox
TimeOfDay_RegisterFloat("PhysicalSky")
TimeOfDay_RegisterFloat("PhysicalSkyHaze")
TimeOfDay_RegisterVector("SkyHorizonColor")
TimeOfDay_RegisterVector("SkyZenithColor")
TimeOfDay_RegisterFloat("SkyGradient")


-- Aerial Perspective
TimeOfDay_RegisterVector("RayleighScattering")
TimeOfDay_RegisterVector("MieScattering")
TimeOfDay_RegisterFloat("MieTightness")


-- Fog
TimeOfDay_RegisterVector("FogColorPrimary")
TimeOfDay_RegisterVector("FogColorSecondary")
TimeOfDay_RegisterVector("FogDirection")
TimeOfDay_RegisterFloat("FogStart")
TimeOfDay_RegisterFloat("FogEnd")
TimeOfDay_RegisterFloat("FogMaxDensity")
TimeOfDay_RegisterFloat("FogExponent")


----------------------------------------------------------------------------------------------------------
function AzimuthAltitude(azimuth, altitude) 
    local azimuthRadians = azimuth * math.pi / 180.0
    local altitudeRadians = altitude * math.pi / 180.0
    local x = -math.sin(0.5 * math.pi - altitudeRadians) * math.sin(azimuthRadians)
    local y = -math.sin(0.5 * math.pi - altitudeRadians) * math.cos(azimuthRadians)
    local z = math.cos(0.5 * math.pi - altitudeRadians)
    
    return Vector(x, y, z)
end
