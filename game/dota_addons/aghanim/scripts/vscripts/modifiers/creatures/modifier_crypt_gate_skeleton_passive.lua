modifier_crypt_gate_skeleton_passive = class({})

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:IsHidden()
	return true
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:IsPermanent()
	return true
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:RemoveOnDeath()
	return false
end  

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	if IsServer() then
		state[MODIFIER_STATE_NO_HEALTH_BAR] = not self.bAwake 
		state[MODIFIER_STATE_ATTACK_IMMUNE] = not self.bAwake
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = not self.bAwake
		state[MODIFIER_STATE_UNSELECTABLE] = not self.bAwake
		state[MODIFIER_STATE_DISARMED] = not self.bAwake
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = not self.bAwake
	end

	return state
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:OnCreated( kv )
	self.wake_chance = 0
	self.respawn_chance = 0
	self.respawn_ms = 0
	self.respawn_as = 0
	

	if IsServer() then
		self.bAwake = false
		self.bWakingUp = false
		self.bAnimSet = false
		self.bAnimFinished = false
		self.bHasRespawned = false 
		self.wake_chance = self:GetAbility():GetSpecialValueFor( "wake_chance" )
		self.respawn_chance = self:GetAbility():GetSpecialValueFor( "respawn_chance" )
		self.respawn_ms = self:GetAbility():GetSpecialValueFor( "respawn_ms" )
		self.respawn_as = self:GetAbility():GetSpecialValueFor( "respawn_as" )

		self:GetParent():SetUnitCanRespawn( true )
		self:WakeUp()
		self:StartIntervalThink( 2.0 )
	end
end

--------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:OnIntervalThink()
	if IsServer() then
		if self.bWakingUp == true then
			if self.bAwake == true then
				self:StartIntervalThink( -1 )
			else
				if self:GetParent():FindModifierByName( "modifier_crypt_gate_skeleton_passive_wake" ) == nil then
					self.bAwake = true
				end
		
			end
			return
		end

		if self.bRespawning == true then
			self.bRespawning = false
			self.bHasRespawned = true
			self:GetParent():RespawnUnit()
			self:WakeUp()
			self:StartIntervalThink( 0.1 )
			local iIndex = ParticleManager:CreateParticle( "particles/items_fx/armlet.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			self:AddParticle( iIndex, false, false, -1, false, false );

			local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self:GetParent():GetOrigin(), 2500.0 )
			if #heroes > 0 then 
				local hero = heroes[RandomInt(1, #heroes)]
				if hero ~= nil then
					printf( "Set initial goal entity for unit \"%s\" to \"%s\"", self:GetParent():GetUnitName(), hero:GetUnitName() )
					self:GetParent():SetInitialGoalEntity( hero )
				end
			end
			
		

			return
		end

		if self:GetParent().bAttacker == true then
			self:WakeUp()
			self:StartIntervalThink( 0.1 )
			return
		end


		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies ~= 0 and RollPercentage( self.wake_chance ) then
			self:WakeUp()
			self:StartIntervalThink( 0.1 )
		end
	end
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:WakeUp()
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_crypt_gate_skeleton_passive_wake", { duration = 1.4 } )
		self.bWakingUp = true
	end
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:GetActivityTranslationModifiers( params )
	return "injured"
end

---------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if self.bHasRespawned then
				self:GetParent():SetUnitCanRespawn( false )
				return 0
			end

			if RollPercentage( self.respawn_chance ) then
				print( "respawning!" )
				self:GetParent():SetUnitCanRespawn( true )
				self.bWakingUp = false
				self.bAwake = false
				
				self.bRespawning = true
				self:StartIntervalThink( RandomFloat( 2.0, 4.0 ) )
			end
		end
	end
	return 0
end

-----------------------------------------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if self.bAwake == false and self.bWakingUp == false then
				self:WakeUp()
			end
		end
	end
end

------------------------------------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:GetModifierMoveSpeedBonus_Percentage( params )
	if self.bHasRespawned then 
		return self.respawn_ms
	end
	return 0
end


------------------------------------------------------------------------------------

function modifier_crypt_gate_skeleton_passive:GetModifierAttackSpeedBonus_Constant( params )
	if self.bHasRespawned then 
		return self.respawn_as
	end
	return 0
end