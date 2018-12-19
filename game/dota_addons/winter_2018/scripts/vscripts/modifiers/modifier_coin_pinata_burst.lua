
modifier_coin_pinata_burst = class({})

----------------------------------------------------------------------------------

function modifier_coin_pinata_burst:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_coin_pinata_burst:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_coin_pinata_burst:OnCreated( kv )
	if IsServer() then
		self.nCoinCount = self:GetAbility():GetLevelSpecialValueFor( "coin_count", 1 )
		self.nGoldPerBag = self:GetAbility():GetLevelSpecialValueFor( "gold_per_bag", 1 )
		self.min_coin_distance = self:GetAbility():GetLevelSpecialValueFor( "min_coin_distance", 1 )
		self.max_coin_distance = self:GetAbility():GetLevelSpecialValueFor( "max_coin_distance", 1 )
		self.min_coin_spread = self:GetAbility():GetLevelSpecialValueFor( "min_coin_spread", 1 )
		self.max_coin_spread = self:GetAbility():GetLevelSpecialValueFor( "max_coin_spread", 1 )
		self.gold_bag_modelscale = self:GetAbility():GetLevelSpecialValueFor( "gold_bag_modelscale", 1 )
	end
end

----------------------------------------------------------------------------------

function modifier_coin_pinata_burst:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_coin_pinata_burst:OnDeath( params )
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

			EmitSoundOn( "SledPenguin.Burst", self:GetParent() )

			-- Start a screenshake with the following parameters: vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
			--ScreenShake( self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true )

			self:GetParent():AddEffects( EF_NODRAW )

			local vAttackerFwd = hAttacker:GetForwardVector()
			self:CreateCoins( vAttackerFwd )
		end
	end
end

-----------------------------------------------------------------------

function modifier_coin_pinata_burst:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_UNTARGETABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_ROOTED ] = true,
	}

	return state
end

-----------------------------------------------------------------------

function modifier_coin_pinata_burst:CreateCoins( vAttackerFwd )
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
