disruptor_glimpse_nb2017 = class({})
LinkLuaModifier( "modifier_disruptor_glimpse_nb2017", "modifiers/modifier_disruptor_glimpse_nb2017", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_glimpse_thinker_nb2017", "modifiers/modifier_disruptor_glimpse_thinker_nb2017", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function disruptor_glimpse_nb2017:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function disruptor_glimpse_nb2017:GetCooldown( nLevel )
	local flCooldown = self.BaseClass.GetCooldown( self, nLevel )

	local hCaster = self:GetCaster()
	if hCaster ~= nil then
		local hTalent = hCaster:FindAbilityByName( "special_bonus_unique_disruptor_glimpse_cooldown_reduction" )
		if hTalent ~= nil and hTalent:GetLevel() > 0 then
			flCooldown = flCooldown - hTalent:GetSpecialValueFor( "value" )
		end
	end

	return flCooldown
end

--------------------------------------------------------------------------------

function disruptor_glimpse_nb2017:OnSpellStart()
	local vTargetPosition = self:GetCursorPosition()
	local nCount = 0
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vTargetPosition, self:GetCaster(), self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #enemies > 0 then
		local kv = {}
		local thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_disruptor_glimpse_thinker_nb2017", kv, vTargetPosition, self:GetCaster():GetTeamNumber(), false )	
		local thinkerBuff = thinker:FindModifierByName( "modifier_disruptor_glimpse_thinker_nb2017" )
		for _,enemy in pairs(enemies) do
			local buff = enemy:FindModifierByName( "modifier_disruptor_glimpse_nb2017" )
			if buff ~= nil and not enemy:IsMagicImmune() then
				EmitSoundOn("Hero_Disruptor.GlimpseNB2017.Target", enemy )
				thinkerBuff:AddGlimpsedUnit( enemy, buff:GetOldestPosition() )
				nCount = nCount + 1
			end
		end

		--print( "Beginning glimpse on" )
		--print( nCount )
		thinkerBuff:BeginGlimpse()
	end
	
end

--------------------------------------------------------------------------------

function disruptor_glimpse_nb2017:OnUpgrade()
	if self:GetLevel() == 1 then
		ListenToGameEvent( "npc_spawned", Dynamic_Wrap( disruptor_glimpse_nb2017, "OnNPCSpawned" ), self )
		for _,unit in pairs( Entities:FindAllByClassname( "npc_dota_creature") ) do
			if unit ~= nil and not unit:IsMagicImmune() then
				unit:AddNewModifier( self:GetCaster(), self, "modifier_disruptor_glimpse_nb2017", { duration = -1 } )
			end
		end
	end
end

--------------------------------------------------------------------------------

function disruptor_glimpse_nb2017:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	if spawnedUnit:IsCreature() and ( spawnedUnit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() ) then
		spawnedUnit:AddNewModifier( self:GetCaster(), self, "modifier_disruptor_glimpse_nb2017", { duration = -1 } )
	end
end

