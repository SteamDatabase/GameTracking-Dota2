if mango_orchard_toss_mango == nil then
	mango_orchard_toss_mango = class({})
end

--------------------------------------------------------------------------------

function mango_orchard_toss_mango:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function mango_orchard_toss_mango:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function mango_orchard_toss_mango:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function mango_orchard_toss_mango:Precache( context )
	PrecacheResource( "particle", "particles/creatures/mango_orchard_mango_linear.vpcf", context )
end

--------------------------------------------------------------------------------

function mango_orchard_toss_mango:HasAnyMangoes()
	return self:GetCurrentAbilityCharges() > 0
end

--------------------------------------------------------------------------------

function mango_orchard_toss_mango:CastFilterResultTarget( hTarget )
	if self:HasAnyMangoes() == false then
		return UF_FAIL_CUSTOM
	end

	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

-----------------------------------------------------------------------------

function mango_orchard_toss_mango:OnSpellStart()
	if IsServer() then
		local vDirection = self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()
		local flDist2d = vDirection:Length2D()
		vDirection = vDirection:Normalized()
		vDirection.z = 0.0

		local info = 
		{
			EffectName = "particles/creatures/mango_orchard_mango_linear.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(), 
			fStartRadius = 100,
			fEndRadius = 100,
			vVelocity = vDirection * self:GetSpecialValueFor( "projectile_speed" ),
			fDistance = self:GetSpecialValueFor( "distance" ),
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		}

		ProjectileManager:CreateLinearProjectile( info )

		EmitSoundOnLocationWithCaster( self:GetCaster():GetAbsOrigin(), "SeasonalConsumable.TI10.HotPotato.Projectile", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function mango_orchard_toss_mango:OnProjectileHit( hTarget, vLocation )
	if hTarget == self:GetCaster() then
		return false 
	end

	if IsServer() then
		if hTarget ~= nil then 
			if hTarget:IsRealHero() then 
				local newItem = CreateItem( "item_mango_orchard_mango", nil, nil )
				hTarget:AddItemByName( "item_mango_orchard_mango" )
			end

			if hTarget:GetUnitName() == "npc_aghsfort_morty_mango_orchard" then 
				local hModifier = hTarget:FindModifierByName( "modifier_creature_mango_orchard_morty" )
				if hModifier then 
					hModifier:FeedMango( self:GetCaster() )
				end
			end

			if hTarget:GetUnitName() == "npc_dota_creature_ogre_tank_mango_farmer" then
				local hBloodlustAbility = hTarget:FindAbilityByName( "ogre_magi_channelled_bloodlust" )
				if hBloodlustAbility and hTarget:GetModifierCount() < 7 then 
					EmitSoundOn( "Hero_OgreMagi.Bloodlust.Target", hPlayerHero )
					EmitSoundOn( "Hero_OgreMagi.Bloodlust.Target.FP", hPlayerHero )
					hTarget:AddNewModifier( hTarget, hBloodlustAbility, "modifier_ogre_magi_channelled_bloodlust", { duration = 5.0 } )
					hTarget:AddNewModifier( hTarget, hBloodlustAbility, "modifier_ogre_magi_channelled_bloodlust", { duration = 5.0 } )
				end 
			end
		else
			-- local newItem = CreateItem( "item_mango_orchard_mango", nil, nil )
			-- newItem:SetPurchaseTime( 0 )
			-- newItem:SetCurrentCharges( 1 )
				
			-- local drop = CreateItemOnPositionSync( vLocation, newItem )
			-- local dropTarget = FindPathablePositionNearby( vLocation, 0, 0 )
			-- newItem:LaunchLootInitialHeight( true, 0, 128, 0.5, dropTarget )
		end
	end

	return true
end


--------------------------------------------------------------------------------