
aghsfort_elemental_tiny_toss = class({})
LinkLuaModifier( "modifier_elemental_tiny_grab", "modifiers/creatures/modifier_elemental_tiny_grab", LUA_MODIFIER_MOTION_HORIZONTAL )
----------------------------------------------------------------------------------------

function aghsfort_elemental_tiny_toss:Precache( context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_attack_telegraph.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_wisp/wisp_tether.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_wisp/wisp_tether_hit.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/target_telegraph_attack.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/elemental_tiny_ping.vpcf", context )
	
end

--------------------------------------------------------------------------------

function aghsfort_elemental_tiny_toss:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghsfort_elemental_tiny_toss:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 50, 50, 50 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 0 ) )

		self.hProjectile = nil 
		-- We want to find an Io to toss
		self:FindProjectile()
		if self.hProjectile ~= nil then 
			return true
		end

	end
	return false

end
--------------------------------------------------------------------------------

function aghsfort_elemental_tiny_toss:OnAbilityPhaseInterrupted()
		
	if IsServer() then
		-- We were interrupted. Drop our Io and stop our warnings
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		self.hProjectile:RemoveModifierByName( "modifier_elemental_tiny_grab" )
		self.hProjectile = nil
	end 
end

--------------------------------------------------------------------------------

function aghsfort_elemental_tiny_toss:FindProjectile()
	
	if IsServer() then
		self.grab_radius = self:GetSpecialValueFor( "grab_radius" )
	
		local entities = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.grab_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,  DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false )
		
		for _, hAlly in pairs( entities ) do
			if hAlly ~= nil and not hAlly:IsNull() and hAlly:IsAlive() == true and hAlly:GetUnitName() == "npc_dota_creature_elemental_io"  then
				if not hAlly:FindModifierByName("modifier_tiny_toss")  and not hAlly:FindModifierByName("modifier_elemental_tiny_grab")  then
					-- We found an Io, it's going to be our projectile
					self.hProjectile = hAlly
				end
			end
		end

		if self.hProjectile ~= nil then
			-- Position Io into our hand
			self.hProjectile:AddNewModifier( self:GetCaster(), self, "modifier_elemental_tiny_grab", nil )

					local nDestinationPreviewFX = ParticleManager:CreateParticle( "particles/creatures/elemental_tiny_ping.vpcf", PATTACH_CUSTOMORIGIN, nil )
					--local nDestinationPreviewFX = ParticleManager:CreateParticle( "particles/ui_mouseactions/ping_retreat.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl( nDestinationPreviewFX, 0, self:GetCaster():GetCursorPosition() )
					--ParticleManager:SetParticleControl( nDestinationPreviewFX, 1, Vector( 275, 1.8, 1.8 ) )
					ParticleManager:SetParticleControl( nDestinationPreviewFX, 7, Vector( 255, 10, 10 ) )
					--ParticleManager:SetParticleControl( nDestinationPreviewFX, 16, Vector( 1, 0, 0 ) )
					ParticleManager:ReleaseParticleIndex( nDestinationPreviewFX )
					EmitSoundOnLocationWithCaster( self:GetCaster():GetCursorPosition(), "General.PingWarning", self:GetCaster() )

					AddFOWViewer( DOTA_TEAM_GOODGUYS, self:GetCaster():GetCursorPosition(), self:GetSpecialValueFor( "radius" ), self:GetSpecialValueFor( "duration" ) + 0.5, false )


		else
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
			self:StartCooldown(2)
		end
	end 
end

--------------------------------------------------------------------------------

function aghsfort_elemental_tiny_toss:OnSpellStart()

	if IsServer() then

		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
	end

		local kv = {
			x = vPos.x,
			y = vPos.y,
			z = vPos.z
		}
		if self.hProjectile ~= nil and self.hProjectile:IsAlive() then 
			-- Leave our hand, Io
			self.hProjectile:RemoveModifierByName( "modifier_elemental_tiny_grab" )
			--	And fly like the wind!
			self.hProjectile:AddNewModifier( self:GetCaster(), self, "modifier_tiny_toss", kv )
			self:GetCaster():StartGesture( ACT_TINY_TOSS )


		
			EmitSoundOn( "Ability.TossThrow", self:GetCaster() )

		end		
	end
end