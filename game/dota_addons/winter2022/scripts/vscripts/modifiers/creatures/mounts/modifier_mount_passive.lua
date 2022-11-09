modifier_mount_passive = class({})

----------------------------------------------------------------------------------
function modifier_mount_passive:IsHidden()
	return true
end

----------------------------------------------------------------------------------
function modifier_mount_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------
function modifier_mount_passive:OnCreated( kv )
	if IsServer() then
		self.hPlayer = self:GetParent():GetOwnerEntity()

		self.bSentSummonEvent = false
		self.mount_cast_point = math.max(0.01, self:GetAbility():GetSpecialValueFor("mount_cast_point"))
		local summon_cast_point = math.max(0.01, self:GetAbility():GetSpecialValueFor("summon_cast_point"))

		self.hPlayer:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mounted", { } )
		self.hPlayer:Interrupt()

		self:StartIntervalThink( summon_cast_point )
	end
end

----------------------------------------------------------------------------------
function modifier_mount_passive:OnDestroy()
	if not IsServer() then return end
	
	if self:GetAbility().OnDespawn ~= nil then
		self:GetAbility():OnDespawn()
	end
end

----------------------------------------------------------------------------------

function modifier_mount_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

----------------------------------------------------------------------------------

function modifier_mount_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end


-----------------------------------------------------------------------

function modifier_mount_passive:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type

		if self:GetParent():GetOwnerEntity() ~= hOrderedUnit then
			-- not an order to our hero
			return
		end

		if params.ability ~= nil and params.ability:GetName() == "summon_penguin" then
			-- let the summon ability handle this order
			return
		end

		local dismountOrders = {
			[DOTA_UNIT_ORDER_CAST_POSITION] = true,
			[DOTA_UNIT_ORDER_CAST_TARGET] = true,
			[DOTA_UNIT_ORDER_CAST_TARGET_TREE] = true,
			[DOTA_UNIT_ORDER_CAST_NO_TARGET] = true,
			[DOTA_UNIT_ORDER_HOLD_POSITION] = true,
			[DOTA_UNIT_ORDER_STOP] = true,
			[DOTA_UNIT_ORDER_TAUNT] = true,
			[DOTA_UNIT_ORDER_PATROL] = true,
		}

		if dismountOrders[nOrderType] then
			if not self:GetParent():HasModifier("modifier_mount_movement") and not self:GetParent():HasModifier("modifier_mount_hop_movement") then
				if not self:GetParent():HasModifier("modifier_kill") then
					self:GetParent():AddNewModifier(nil, nil, "modifier_kill", { duration = 2 })
				end
			end

			if self.hPlayer ~= nil and self.hPlayer:IsNull() == false then
				self.hPlayer:RemoveModifierByName( "modifier_mounted" )
			end
			
			self:StartIntervalThink( -1 )
			self.bSentSummonEvent = false
		end
	end
end

-----------------------------------------------------------------------

function modifier_mount_passive:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------

function modifier_mount_passive:OnIntervalThink()
	if IsServer() then
		if not self.bSentSummonEvent then
			if self:GetAbility().GetAnimation_Summon and self:GetAbility():GetAnimation_Summon() ~= nil then
				self:GetParent():StartGesture( self:GetAbility():GetAnimation_Summon() )
			end

			if self:GetAbility().OnSummon ~= nil then
				self:GetAbility():OnSummon()
			end
			
			self:StartIntervalThink( self.mount_cast_point )
			self.bSentSummonEvent = true
		else
			self:TryMount()
			self:StartIntervalThink( -1 )
			self.bSentSummonEvent = false
		end
	end
end

---------------------------------------------------------------------------

function modifier_mount_passive:TryMount()
	if IsServer() then
		if self.hPlayer ~= nil then
			local bMounted = false
			local flMaxDistance = 250.0
			if ( self.hPlayer:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() <= flMaxDistance then
				self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), self:GetAbility():GetMovementModifierName(), {} )
				bMounted = true
			end

			if not bMounted then
				self.hPlayer:RemoveModifierByName( "modifier_mounted" )
			end
		end
	end
end