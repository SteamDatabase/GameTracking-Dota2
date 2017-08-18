modifier_undead_skeleton = class({})

---------------------------------------------------------

function modifier_undead_skeleton:IsHidden()
	return true
end

---------------------------------------------------------

function modifier_undead_skeleton:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_undead_skeleton:IsPermanent()
	return true
end


---------------------------------------------------------

function modifier_undead_skeleton:RemoveOnDeath()
	return false
end  

---------------------------------------------------------

function modifier_undead_skeleton:CheckState()
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

function modifier_undead_skeleton:OnCreated( kv )
	self.wake_chance = self:GetAbility():GetSpecialValueFor( "wake_chance" )
	self.respawn_chance = self:GetAbility():GetSpecialValueFor( "respawn_chance" )
	self.bAwake = false
	self.bWakingUp = false
	self.bAnimSet = false
	self.bAnimFinished = false
	if IsServer() then
		self:StartIntervalThink( 2.0 )
	end
end

--------------------------------------------------------

function modifier_undead_skeleton:OnIntervalThink()
	if IsServer() then
		if self.bWakingUp == true then
			if self.bAwake == true then
				self:StartIntervalThink( -1 )
			else
				if self:GetParent():FindModifierByName( "modifier_undead_skeleton_wake" ) == nil then
					self.bAwake = true
				end
		
			end
			return
		end

		if self.bRespawning == true then
			self.bRespawning = false
			self.bHasRespawned = true
			self:WakeUp()
			self:StartIntervalThink( 0.1 )
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

function modifier_undead_skeleton:WakeUp()
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_undead_skeleton_wake", { duration = 1.4 } )
		self.bWakingUp = true
	end
end

---------------------------------------------------------

function modifier_undead_skeleton:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	--	MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

---------------------------------------------------------

function modifier_undead_skeleton:GetActivityTranslationModifiers( params )
	return "injured"
end

---------------------------------------------------------

function modifier_undead_skeleton:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if self:GetParent():UnitCanRespawn() or self.bHasRespawned then
				self:GetParent():SetUnitCanRespawn( false )
				return 0
			end

			if RollPercentage( self.respawn_chance ) then
				self:GetParent():SetUnitCanRespawn( true )
				self.bWakingUp = false
				self.bAwake = false
				self:GetParent():RespawnUnit()
				self.bRespawning = true
				self:StartIntervalThink( RandomFloat( 2.0, 4.0 ) )
				ExecuteOrderFromTable({
					UnitIndex = self:GetParent():entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = self:GetAbility():entindex(),
					Queue = false,
					})
			end
		end
	end
	return 0
end

-----------------------------------------------------------------------------------------

function modifier_undead_skeleton:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if self.bAwake == false and self.bWakingUp == false then
				self:WakeUp()
			end
		end
	end
end