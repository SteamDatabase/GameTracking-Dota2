modifier_creature_mango_orchard_morty = class({})

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:OnCreated( kv )
	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	self.gold_bag_duration = self:GetAbility():GetSpecialValueFor( "gold_bag_duration" )
	if IsServer() then
		self.nBagsDropped = 0
		self.bTeleporting = false
		self.vCenter = Vector( -3600, 13582, 640 )
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vCenter
			})

		self.flExpireTime = GameRules:GetGameTime() + 99999999
		self:StartIntervalThink( 2.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:OnIntervalThink()
	if not IsServer() then
		return
	end

	if self.bTeleporting == true then
		return
	end

	if GameRules:GetGameTime() > self.flExpireTime then
		--self:TeleportOut()
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = FindPathablePositionNearby( self.vCenter, 0, 3500 )
		})	

end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return 250 + ( self.nBagsDropped * 2 )
	end
	return 250
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
		}
		if GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:GetActivityTranslationModifiers( params )
	return "run"
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_creature_mango_orchard_morty:FeedMango( hCaster )
	local vDropPos = Vector( -4080, 13640, 640 )
	if RandomInt( 0, 1 ) == 1 then 
		vDropPos = Vector( -3175, 13725, 640 )
	end

	
	local newItem = CreateItem( "item_bag_of_gold2", nil, nil )
	local nGoldAmount = 20
	local nAdjustedAmount = math.ceil( nGoldAmount * GameRules.Aghanim:GetGoldModifier() / 100 )
	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( nAdjustedAmount )
		
	local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )

	local dropTarget = vDropPos + RandomVector( 50 )
	newItem:LaunchLoot( true, 300, 0.75, dropTarget )
	newItem:SetLifeTime( self.gold_bag_duration )

	self.nBagsDropped = self.nBagsDropped + 1
	self.total_gold = self.total_gold - nGoldAmount
	

	
	 
	newItem = CreateItem( "item_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( nAdjustedAmount )
		
	drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )

	dropTarget = hCaster:GetAbsOrigin()
	newItem:LaunchLoot( true, 300, 0.50, dropTarget )
	newItem:SetLifeTime( self.gold_bag_duration )

	self.nBagsDropped = self.nBagsDropped + 1
	self.total_gold = self.total_gold - nGoldAmount
	
	
	EmitSoundOn( "Hero_Snapfire.FeedCookie.Consume", self:GetParent() )
	ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
	self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_2 )
	self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_rooted", { duration = 0.5 } )
end