
require( "ai/ai_shared" )
require( "utility_functions" )

modifier_large_coin_pinata = class({})

----------------------------------------------------------------------------------

function modifier_large_coin_pinata:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_large_coin_pinata:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_large_coin_pinata:OnCreated( kv )
	if IsServer() then
		self.nCoinCount = self:GetAbility():GetLevelSpecialValueFor( "coin_count", 1 )
		self.nGoldPerBag = self:GetAbility():GetLevelSpecialValueFor( "gold_per_bag", 1 )
		self.min_coin_distance = self:GetAbility():GetLevelSpecialValueFor( "min_coin_distance", 1 )
		self.max_coin_distance = self:GetAbility():GetLevelSpecialValueFor( "max_coin_distance", 1 )
		self.min_coin_spread = self:GetAbility():GetLevelSpecialValueFor( "min_coin_spread", 1 )
		self.max_coin_spread = self:GetAbility():GetLevelSpecialValueFor( "max_coin_spread", 1 )
		self.gold_bag_modelscale = self:GetAbility():GetLevelSpecialValueFor( "gold_bag_modelscale", 1 )
		self.think_interval = self:GetAbility():GetLevelSpecialValueFor( "think_interval", 1 )
		self.max_dist_from_spawn = self:GetAbility():GetLevelSpecialValueFor( "max_dist_from_spawn", 1 )

		self:StartIntervalThink( self.think_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_large_coin_pinata:OnIntervalThink()
	if IsServer() then
		-- Issue move command to pathfindable position within a short distance
		local vRandomPosNearby = GetRandomPathablePositionWithin( self:GetParent():GetAbsOrigin(), self.max_dist_from_spawn )

		if vRandomPosNearby then
			MoveOrder( self:GetParent(), vRandomPosNearby )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_large_coin_pinata:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_large_coin_pinata:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local hAttacker = params.attacker
			if hAttacker == nil or hAttacker:IsBuilding() then
				return
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/coin_pinata_destroy.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 4, hAttacker:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "SledPenguin.Burst.Big", self:GetParent() )
			EmitSoundOn( "BabyRoshan.Death", self:GetParent() )

			-- Start a screenshake with the following parameters: vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
			ScreenShake( self:GetParent():GetOrigin(), 7.0, 100.0, 0.3, 800.0, 0, true )

			self:GetParent():AddEffects( EF_NODRAW )

			local vAttackerFwd = hAttacker:GetForwardVector()
			self:CreateCoins( vAttackerFwd )

			self:Destroy()
		end
	end
end

-----------------------------------------------------------------------

function modifier_large_coin_pinata:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_UNTARGETABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
	}

	return state
end

-----------------------------------------------------------------------

function modifier_large_coin_pinata:CreateCoins( vAttackerFwd )
	if IsServer() then
		local nDistance = RandomInt( self.min_coin_distance, self.min_coin_distance )
		local vPos = self:GetParent():GetAbsOrigin() + ( vAttackerFwd * nDistance )

		for i = 0, ( self.nCoinCount - 1 ) do
			local vSpawnPos = vPos + RandomVector( RandomFloat( self.min_coin_spread, self.max_coin_spread ) )
			local newItem = CreateItem( "item_bag_of_gold", nil, nil )
			newItem:SetPurchaseTime( 0 )
			newItem:SetCurrentCharges( self.nGoldPerBag )
			local hPhysicalItem = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
			hPhysicalItem:SetModelScale( self.gold_bag_modelscale )
			local vDropTarget = vSpawnPos
			newItem:LaunchLoot( true, 100, 0.4, vDropTarget ) -- an item is made auto-pickup-able by LaunchLoot
		end
	end
end

--------------------------------------------------------------------------------
