require( "event_queue" )

modifier_creature_wraith_king_reincarnation = class({})

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:IsHidden()
	return false
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:IsPermanent()
	return true
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:RemoveOnDeath()
	return false
end 

function modifier_creature_wraith_king_reincarnation:GetTexture()
	return "skeleton_king_reincarnation"
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:CheckState()
	state = {}
	local bAwake = self:GetParent().bAwake and not (self.bWakingUp or self.bRespawning)
	state[MODIFIER_STATE_NO_HEALTH_BAR] = not bAwake
	state[MODIFIER_STATE_ATTACK_IMMUNE] = not bAwake
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = not bAwake
	state[MODIFIER_STATE_UNSELECTABLE] = not bAwake
	state[MODIFIER_STATE_DISARMED] = not bAwake
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = not bAwake
	state[MODIFIER_STATE_OUT_OF_GAME] = not bAwake
	state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = not bAwake
	return state
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:OnCreated( kv )
	if IsServer() then
		self:GetParent().bAwake = true
		self.bWakingUp = false
		self.bAnimSet = false
		self.bAnimFinished = false	
		self.bRespawning = false
		self.flRespawnDelay = 1.5
		self.flReincarnateTime = 3
		self.flWakeTime = nil

		self.EventQueue = CEventQueue()
		self:GetParent():SetUnitCanRespawn( true )
		self:StartIntervalThink( 1.0 )
	end
end

--------------------------------------------------------

 function modifier_creature_wraith_king_reincarnation:OnIntervalThink()
 	if IsServer() then
 		if self.bRespawning == true then
 			self:WakeUp()
 			self:StartIntervalThink( 0.1 )
 			self.bRespawning = false
 			return
 		end

 		if self.bWakingUp then
 			local flT = (GameRules:GetGameTime() - self.flWakeTime)/self.flReincarnateTime
 			local flHP = flT*self:GetParent():GetMaxHealth()*math.pow(0.5,self:GetParent().nDeaths)
 			self:GetParent():SetHealth(flHP)
 		end

 	end
 end


function modifier_creature_wraith_king_reincarnation:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:WakeUp()
	if IsServer() then
		self:GetParent():RespawnUnit()
		self:GetParent():InterruptChannel()
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_creature_wraith_king_wake", {} )
		self.bWakingUp = true
		self.flWakeTime = GameRules:GetGameTime()	

		self.EventQueue:AddEvent( self.flReincarnateTime, 
			function(self)
				if not self:IsNull() and not self:GetParent():IsNull() then
					self.bWakingUp = false
					self:GetParent().bAwake = true
					self:GetParent():RemoveModifierByName("modifier_creature_wraith_king_wake")
				end
		end, self )

	end
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:GetActivityTranslationModifiers( params )
	--if self.bWakingUp == true then
	--	return "reincarnate"
	--end
	return nil
end

---------------------------------------------------------

function modifier_creature_wraith_king_reincarnation:OnDeath( params )

	if IsServer() then
		if params.unit == self:GetParent() then

			EmitSoundOn( "Cavern.Reincarnate", self:GetParent() )

			if self:GetParent().nDeaths == nil then
				self:GetParent().nDeaths = 0
			end

			self:GetParent().nDeaths = self:GetParent().nDeaths + 1

			self:GetParent().bAwake = false	
			self.EventQueue:AddEvent( self.flRespawnDelay, 
			function(self)
				if not self:IsNull() and not self:GetParent():IsNull() then
					self.bRespawning = true
				end
			end, self ) 

		end
	end
	return 0
end
