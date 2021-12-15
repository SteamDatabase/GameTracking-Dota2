modifier_creature_bonus_balloon_mine = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:IsHidden()
	return true;
end


function modifier_creature_bonus_balloon_mine:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:OnCreated( kv )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.bInitialized = false

	if IsServer() then

		self.flExpireTime = GameRules:GetGameTime() + self.time_limit
		--self:OnIntervalThink()
		self:StartIntervalThink( 3.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		--MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:OnIntervalThink()
	if not IsServer() then
		return
	end

	if self.bInitialized == false then 
		self.vFirstPatrolPoint = self:GetParent():GetOrigin()
		self.vSecondPatrolPoint = FindPathablePositionNearby( self.vFirstPatrolPoint, 900, 900 )
		self.CurrentDestination = self.vFirstPatrolPoint
		self.bInitialized = true
	end

	if GameRules:GetGameTime() > self.flExpireTime then
		self:GetParent():ForceKill(false)
		return
	end

	if self.CurrentDestination == self.vFirstPatrolPoint then
		self.CurrentDestination = self.vSecondPatrolPoint
	else
		self.CurrentDestination = self.vFirstPatrolPoint
	end
	--[[
	ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.CurrentDestination
		})
	]]
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
	--	if hAttacker == hUnit then
	--		return 0
	--	end

		if hUnit == self:GetParent() then		
			if  hAttacker ~= hUnit then
				hAttacker:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
				EmitSoundOn( "Hero_Techies.LandMine.Detonate", self:GetParent() )
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.0, 1.0, 50 ) )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, 1.0, 50 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			hUnit:AddEffects( EF_NODRAW )

		end



	end
	return 0
end



--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:CheckState()
	local state = {}
	if IsServer()  then
		if GameRules:GetGameTime() > self.flExpireTime then
	--		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	--		state[MODIFIER_STATE_INVULNERABLE] = true
	--		state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon_mine:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

--function modifier_creature_bonus_balloon_mine:GetVisualZDelta( params )
--	return 50
--end

