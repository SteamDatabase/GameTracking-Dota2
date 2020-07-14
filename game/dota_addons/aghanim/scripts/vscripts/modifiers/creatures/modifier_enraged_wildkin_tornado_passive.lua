
modifier_enraged_wildkin_tornado_passive = class({})

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "tornado_radius" )
	self.harpy_spawn_interval = self:GetAbility():GetSpecialValueFor( "harpy_spawn_interval" )
	self.harpy_spawn_amount = self:GetAbility():GetSpecialValueFor( "harpy_spawn_amount" )
	self.max_total_harpies = self:GetAbility():GetSpecialValueFor( "max_total_harpies" )

	self.szHarpyUnit = "npc_aghsfort_creature_tornado_harpy"
	self.flLastHarpyTime = GameRules:GetGameTime()

	self:StartIntervalThink( 0.5 )
end


--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:GetModifierAura()
	return "modifier_enraged_wildkin_tornado_passive_debuff"
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:GetAuraRadius()
	return self.radius
end


--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "tornado_radius" )
end

--------------------------------------------------------------------------------
function modifier_enraged_wildkin_tornado_passive:DeclareFunctions()
	local funcs = {
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

function modifier_enraged_wildkin_tornado_passive:OnIntervalThink()
	if IsServer() then
		
		--if self:GetCaster() == nil or self:GetCaster():IsAlive() ~= true then
		--	self:GetParent():ForceKill(false)
		--	return
		--end	
			
		--local vDirection = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		--self:GetCaster():SetForwardVector(vDirection)
		

		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end


		if self:GetParent():IsMoving() == false then
			self:DoMove()
		end
		if GameRules:GetGameTime() - self.flLastHarpyTime > self.harpy_spawn_interval then
			-- for some reason can't find the harpies by names, so finding them by model
			local hHarpies = Entities:FindAllByModel( "models/creeps/neutral_creeps/n_creep_harpy_b/n_creep_harpy_b.vmdl" )
			if #hHarpies < self.max_total_harpies then
				--print ("we're at", #hHarpies, "now, max is", self.max_total_harpies)
				self:SpawnHarpy()
			end
		end	


	end
end

function modifier_enraged_wildkin_tornado_passive:DoMove()
	if IsServer() then

		local heroes = FindRealLivingEnemyHeroesInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), FIND_UNITS_EVERYWHERE )
		if #heroes > 0 then
			local hero = heroes[RandomInt(1, #heroes)]

			for i=1,4 do

				local vLoc = FindPathablePositionNearby(hero:GetAbsOrigin(), 200, 200 )
				if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then

					ExecuteOrderFromTable({
					UnitIndex = self:GetParent():entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = vLoc,
					Queue = false,
					})

					break
				end
			end
		end
	end
	return
end	

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:GetModifierMoveSpeed_Absolute( params )
	return 320
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:SpawnHarpy()
	if IsServer() then
 		local hUnit = self:GetParent()
 		if hUnit == nil then
 			return
 		end
 		if not hUnit:IsAlive() then
 			return
 		end

		for i = 1, self.harpy_spawn_amount do
	 		local hHarpy = CreateUnitByName( self.szHarpyUnit, self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
	 		local nMaxDistance = 200
	 		local vLoc = FindPathablePositionNearby(self:GetParent():GetAbsOrigin(), 150, nMaxDistance )

			hHarpy:SetInitialGoalEntity( self:GetParent().hInitialGoalEntity )
			hHarpy:SetDeathXP( 0 )
			hHarpy:SetMinimumGoldBounty( 0 )
			hHarpy:SetMaximumGoldBounty( 0 )

			local kv =
			{
				vLocX = vLoc.x,
				vLocY = vLoc.y,
				vLocZ = vLoc.z,
			}
			hHarpy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_frostivus2018_broodbaby_launch", kv )

		end
		
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 29, 55, 184 ) )


		self.flLastHarpyTime = GameRules:GetGameTime()
		EmitSoundOn( "Creature_Bomb_Squad.LandMine.Plant", hHarpy )

	end

	return
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_FLYING] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
		}
	end
	
	return state
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:GetEffectName( )
	return "particles/creatures/enraged_wildkin/enraged_wildkin_tornado.vpcf"
end

--------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive:OnDestroy( )
	if IsServer() then
		if self:GetCaster() and self:GetCaster():IsAlive() then
			self:GetCaster():Interrupt()
		end
	end
end
