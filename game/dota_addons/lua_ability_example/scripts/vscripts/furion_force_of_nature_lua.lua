furion_force_of_nature_lua = class({})
LinkLuaModifier( "modifier_furion_force_of_nature_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function furion_force_of_nature_lua:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

--------------------------------------------------------------------------------

function furion_force_of_nature_lua:IsHiddenWhenStolen()
	return true
end

--------------------------------------------------------------------------------

function furion_force_of_nature_lua:OnSpellStart()
	self.area_of_effect = self:GetSpecialValueFor( "area_of_effect" )
	self.max_treants = self:GetSpecialValueFor( "max_treants" )
	self.duration = self:GetSpecialValueFor( "duration" )

	local vTargetPosition = self:GetCursorPosition()
	local trees = GridNav:GetAllTreesAroundPoint( vTargetPosition, self.area_of_effect, true )
	local nTreeCount = #trees

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff_base", self:GetCaster():GetOrigin(), true )

	ParticleManager:SetParticleControl( nFXIndex, 1, vTargetPosition )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.area_of_effect, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	GridNav:DestroyTreesAroundPoint( vTargetPosition, self.area_of_effect, true )

	if nTreeCount == 0 then
		return
	end

	local nTreantsToSpawn = math.min( self.max_treants, nTreeCount )
	while nTreantsToSpawn > 0 do
		local hTreant = CreateUnitByName( "npc_dota_furion_treant", vTargetPosition, true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber() )
		if hTreant ~= nil then
			hTreant:SetControllableByPlayer( self:GetCaster():GetPlayerID(), false )
			hTreant:SetOwner( self:GetCaster() )

			local kv = {
				duration = self.duration
			}

			hTreant:AddNewModifier( self:GetCaster(), self, "modifier_furion_force_of_nature_lua", kv )
		end

		nTreantsToSpawn = nTreantsToSpawn - 1
	end

	EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.ForceOfNature", self:GetCaster() )
end

--------------------------------------------------------------------------------