
modifier_battle_point_pinata = class({})

----------------------------------------------------------------------------------

function modifier_battle_point_pinata:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_battle_point_pinata:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_battle_point_pinata:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
-------------------------------------------------------------------------------

function modifier_battle_point_pinata:GetAbsoluteNoDamagePhysical( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:GetAbsoluteNoDamageMagical( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:GetAbsoluteNoDamagePure( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:GetModifierIncomingPhysicalDamage_Percentage()
	return -100
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:OnCreated( kv )
	if IsServer() then
		local hParent = self:GetParent()

		self.hMyVisionRevealer = GameRules.JungleSpirits.hVisionRevealer -- this requires an uncomfortable amount of trust but should be ok

		self.nAttacksNeeded = self:GetAbility():GetLevelSpecialValueFor( "attacks_needed", 1 )
		self.nPingInterval = self:GetAbility():GetLevelSpecialValueFor( "ping_interval", 1 )
		self.nGemsPerHit = GameRules.JungleSpirits:ScaleGemAmountWithGameTime( GEM_MEGA_PINATA_GEM_DROP_MODIFIER_STACK / self.nAttacksNeeded )
		self.nAccumAttacks = 0
		self.nDmgPerHit = hParent:GetHealth() / self.nAttacksNeeded

		hParent:StartGesture( ACT_DOTA_IDLE )

		hParent:SetForwardVector( RandomVector( 1 ) )
		hParent:SetSkin( 1 )

		hParent:AddNewModifier( hParent, nil, "modifier_kill", { duration = TIME_PER_GEM_SPAWN } )

		local nFXIndex = ParticleManager:CreateParticle( "particles/items/essence_treasure_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nOverheadFXIndex = ParticleManager:CreateParticle( "particles/addons_gameplay/morokai_orb_overhead_large.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent )
		self:AddParticle( nOverheadFXIndex, false, false, -1, false, true )

		local nAmbientFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/treasure_chest_ambient_fog_large.vpcf", PATTACH_ABSORIGIN, hParent )
		self:AddParticle( nAmbientFXIndex, false, false, -1, false, false )

		self:StartIntervalThink( self.nPingInterval )
	end
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:OnIntervalThink()
	if IsServer() then
		EmitSoundOnLocationWithCaster ( self:GetParent():GetAbsOrigin(), "BattlePointDrop.Ping", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:OnAttacked( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end

		if not hAttacker:IsRealHero() then
			return 0
		end

		if hTarget == self:GetParent() then
			self.nAccumAttacks = self.nAccumAttacks + 1
			CJungleSpirits:DropGemStackFromUnit( hTarget, self.nGemsPerHit, hAttacker )

			-- Find out if this will kill us before it actually kills us, so we can set bool before ending up in OnDeath
			if self:GetParent():GetHealth() - self.nDmgPerHit <= 0 then
				self.bKilledWithAttacks = true
			end

			self:GetParent():ModifyHealth( self:GetParent():GetHealth() - self.nDmgPerHit, self:GetAbility(), true, 0 )

			EmitSoundOn( "Pinata.Damage", self:GetParent() )
			self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_1 )
		end

		if self.nAccumAttacks >= self.nAttacksNeeded then
			local gameEvent = {}
			gameEvent[ "player_id" ] = hAttacker:GetPlayerID()
			gameEvent[ "teamnumber" ] = hAttacker:GetTeamNumber()
			gameEvent[ "message" ] = "#GameEvent_PlayerOpenedLargeCarePackage"
			FireGameEvent( "dota_combat_event_message", gameEvent )

			self:Destroy()

			return 0
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		if hUnit == self:GetParent() then
			if self.bKilledWithAttacks then
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/rare_treasure/rare_treasure_death.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				self:CreateBattlePointsItemDrop()
			else
				-- We died to modifier_kill expiration, so no reward or cool death particle
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/treasure_death.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end

			EmitSoundOn( "BigPinata.Burst", self:GetParent() )

			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:CheckState()
	local state =
	{
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_ROOTED ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:OnDestroy()
	if IsServer() then
		self:GetParent():AddEffects( EF_NODRAW )

		if self.hMyVisionRevealer ~= nil and self.hMyVisionRevealer:IsNull() == false then
			self.hMyVisionRevealer:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_battle_point_pinata:CreateBattlePointsItemDrop()
	for i = 1, BP_ITEMS_PER_CARE_PACKAGE do
		local nTierAwarded = GameRules.JungleSpirits:GetRandomBattlePointsRewardTier()
		local szItemName = BATTLE_POINT_REWARD_TIERS[ nTierAwarded ][ 1 ]

		local newItem = CreateItem( szItemName, nil, nil )
		newItem:SetPurchaseTime( 0 )

		local nTeamBattlePoints = BATTLE_POINT_REWARD_TIERS[ nTierAwarded ][ 2 ] / BP_ITEMS_PER_CARE_PACKAGE
		--printf( "  nTeamBattlePoints: %d", nTeamBattlePoints )
		newItem:SetCurrentCharges( nTeamBattlePoints )

		local vPos = self:GetParent():GetAbsOrigin()
		local hPhysicalItem = CreateItemOnPositionSync( vPos, newItem )

		local fModelScale = BATTLE_POINT_REWARD_TIERS[ nTierAwarded ][ 3 ]
		--printf( "  fModelScale: %.2f", fModelScale )
		hPhysicalItem:SetModelScale( fModelScale )
		hPhysicalItem:SetSkin( 2 )

		local dropTarget = vPos + RandomVector( RandomFloat( 75, 150 ) )
		newItem:LaunchLoot( true, 200, 0.5, dropTarget )
	end
end
