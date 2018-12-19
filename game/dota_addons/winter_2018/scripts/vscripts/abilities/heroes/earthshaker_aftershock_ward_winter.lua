
earthshaker_aftershock_ward_winter = class({})
LinkLuaModifier( "modifier_earthshaker_aftershock_ward_winter", "modifiers/heroes/modifier_earthshaker_aftershock_ward_winter", LUA_MODIFIER_MOTION_NONE )


-----------------------------------------------------------------------------------------

function earthshaker_aftershock_ward_winter:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function earthshaker_aftershock_ward_winter:OnSpellStart()
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local hWard = CreateUnitByName( "npc_dota_earthshaker_aftershock_ward_winter", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hWard ~= nil then
			local flDuration = self:GetSpecialValueFor( "ward_duration" )



			local kv =
			{
				duration = flDuration,
			}

			self:GetCaster().hWard = hWard
			hWard:AddNewModifier( self:GetCaster(), self, "modifier_earthshaker_aftershock_ward_winter", kv )
--			print (kv["duration"])
--			print (kv["mana_multiplier"])
			hWard:AddNewModifier( self:GetCaster(), self, "modifier_kill", {duration = flDuration} )

--			local nWardFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_pugna/pugna_ward_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil )
--			ParticleManager:SetParticleControl( nWardFX, 0, self:GetCursorPosition() )	
--			ParticleManager:SetParticleControlEnt( nWardFX, 1, self:GetCaster(), flDuration, "attach_attack1", self:GetCaster():GetOrigin(), true )
--			ParticleManager:SetParticleControl( nWardFX, 2, Vector( flDuration, flDuration, duration ) )
--			ParticleManager:ReleaseParticleIndex( nWardFX )

			EmitSoundOn( "Hero_EarthShaker.Totem.TI6.Layer", hWard )
		end
	end
end