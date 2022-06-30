pendulum_trap = class({})
LinkLuaModifier( "modifier_pendulum_trap_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pendulum_trap:CastFilterResultTarget( hTarget )
	--print("Cast Filter")
	if IsServer() then
		--print("Is Server")

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function pendulum_trap:GetCastRange( vLocation, hTarget )
	--print("Getting Cast Range")
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

--------------------------------------------------------------------------------

function pendulum_trap:OnSpellStart()
	--print("Starting Spell")
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		--print("Target is valid")
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			--print("Calling modifier")
			local damage_delay = self:GetSpecialValueFor( "damage_delay" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_pendulum_trap_lua", { duration = damage_delay } )
			--EmitSoundOn( "Conquest.Pendulum.Target", hTarget )
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_blood01.vpcf", PATTACH_CUSTOMORIGIN, nil );
		--ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		--EmitSoundOn( "Conquest.Pendulum.Target", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
