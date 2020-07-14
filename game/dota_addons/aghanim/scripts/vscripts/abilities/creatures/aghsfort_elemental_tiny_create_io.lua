
aghsfort_elemental_tiny_create_io = class({})
LinkLuaModifier( "modifier_elemental_tiny_create_io_dummy", "modifiers/creatures/modifier_elemental_tiny_create_io_dummy", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghsfort_elemental_tiny_create_io:Precache( context )

	PrecacheUnitByNameSync( "npc_dota_creature_elemental_io", context, -1 )

end

--------------------------------------------------------------------------------

function aghsfort_elemental_tiny_create_io:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghsfort_elemental_tiny_create_io:OnSpellStart()
	if not IsServer() then
		return
	end

	if self:GetCaster() == nil or self:GetCaster():IsNull() then
		return
	end

	local nSummonCount = self:GetSpecialValueFor( "spawn_count" )
	local nMaxSummons = self:GetSpecialValueFor( "max_summons" )
	local flSpawnDistance = self:GetSpecialValueFor( "spawn_distance" )

	local flDeltaAngle = 360 / nSummonCount
	local vAngles = QAngle( 0, math.random( 0, flDeltaAngle ), 0 )

	--first time we spawn, create 2 the hIos
	if not self:GetCaster():FindModifierByName( "modifier_elemental_tiny_create_io_dummy" )  then
		nSummonCount = 2
		local kv2 = {}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_elemental_tiny_create_io_dummy", kv2 )
	end

	for i = 1,nSummonCount do

		local vSpawnPosition = nil
		for s = 1,36 do

			local vDir = AnglesToVector( vAngles )
			local vTest = self:GetCaster():GetAbsOrigin() + vDir * flSpawnDistance + math.random( -25, 25 )

			if GameRules.Aghanim:GetCurrentRoom():IsValidSpawnPoint( vTest ) then
				vSpawnPosition = vTest
				break
			end

			vAngles.y = vAngles.y + 10

		end

		vAngles.y = vAngles.y + flDeltaAngle + math.random( -20, 20 )

		if vSpawnPosition ~= nil then

			local kv =
			{
				vLocX = vSpawnPosition.x,
				vLocY = vSpawnPosition.y,
				vLocZ = vSpawnPosition.z,
			}
			local hIo = CreateUnitByName( "npc_dota_creature_elemental_io", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			if hIo ~= nil then 
				hIo:AddNewModifier( self:GetCaster(), self, "modifier_frostivus2018_broodbaby_launch", kv )
				hIo:SetOwner(self:GetCaster())
				table.insert( self:GetCaster().hIos, hIo )
			end
		end

	end

end

--------------------------------------------------------------------------------
