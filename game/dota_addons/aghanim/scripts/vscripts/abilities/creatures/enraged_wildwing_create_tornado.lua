
enraged_wildwing_create_tornado = class({})
LinkLuaModifier( "modifier_enraged_wildkin_tornado_passive", "modifiers/creatures/modifier_enraged_wildkin_tornado_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enraged_wildkin_tornado_passive_debuff", "modifiers/creatures/modifier_enraged_wildkin_tornado_passive_debuff", LUA_MODIFIER_MOTION_NONE )

require( "aghanim_utility_functions" )
--------------------------------------------------------------------

function enraged_wildwing_create_tornado:Precache( context )

	PrecacheResource( "particle", "particles/neutral_fx/tornado_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/enraged_wildkin/enraged_wildkin_tornado.vpcf", context )
	PrecacheUnitByNameSync( "npc_aghsfort_creature_enraged_wildwing_tornado", context, -1 )
end

--------------------------------------------------------------------------------

function enraged_wildwing_create_tornado:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 175, 175, 175 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 140, 0 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function enraged_wildwing_create_tornado:OnAbilityPhaseInterrupted()
	if IsServer() then
		--ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

--function enraged_wildwing_create_tornado:GetChannelAnimation()
--	return ACT_DOTA_CHANNEL_ABILITY_1
--end

--------------------------------------------------------------------------------

function enraged_wildwing_create_tornado:OnSpellStart()
	if IsServer() then
		

		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		local vPos = self:GetCaster():GetAbsOrigin()
		for i=1,32 do
			local vLoc = FindPathablePositionNearby(self:GetCaster():GetAbsOrigin(), 400, 800 )

				if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then
					vPos = vLoc
					break
				end
		end

		local hTornado = CreateUnitByName( "npc_aghsfort_creature_enraged_wildwing_tornado", vPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		hTornado:EmitSound( "n_creep_Wildkin.Tornado" )

		local szAbilityName = "enraged_wildkin_tornado_passive"
		local hAbility = hTornado:FindAbilityByName(szAbilityName)
		if hAbility == nil then
			hAbility = hTornado:AddAbility(szAbilityName)
		 end
		 hAbility:UpgradeAbility( true )



		--local kv = {
		--	movespeed_pct = self:GetSpecialValueFor( "movespeed_pct" ),
		--	damage = self:GetSpecialValueFor( "damage" ),
		--}
		--hTornado:AddNewModifier( self:GetCaster(), self, "modifier_enraged_wildkin_tornado_passive", kv )	

		--self.m_hTornado = hTornado
	end
end


--------------------------------------------------------------------------------
--
--function enraged_wildwing_create_tornado:OnChannelFinish( bInterrupted )
--	if IsServer() then
--		if self.m_hTornado ~= nil then
--			self.m_hTornado:StopSound( "n_creep_Wildkin.Tornado" )
--			self.m_hTornado:RemoveModifierByName("modifier_enraged_wildkin_tornado_passive")
--			self.m_hTornado:ForceKill( false )
--		end
--		ParticleManager:DestroyParticle( self.nPreviewFX, false )
--	end
--end
