
require( "winter2022_utility_functions" )

modifier_greevil_filling = class({})

--------------------------------------------------------------------------------

function modifier_greevil_filling:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:OnCreated( kv )
	self.nBagsDropped = 0

	if IsServer() == false then
		return
	end

	self:SetHasCustomTransmitterData( true )

	self.filling_type = WINTER2022_GREEVIL_FILLING_TYPE_INVALID

	self.health_potions_to_drop = self:GetAbility():GetSpecialValueFor( "health_potions_to_drop" )

	self.mana_potions_to_drop = self:GetAbility():GetSpecialValueFor( "mana_potions_to_drop" )

	self.candy_to_drop_default = self:GetAbility():GetSpecialValueFor( "candy_to_drop_default" )
	self.candy_to_drop_bonus = self:GetAbility():GetSpecialValueFor( "candy_to_drop_bonus" )

	self.gold_bags_to_drop = self:GetAbility():GetSpecialValueFor( "gold_bags_to_drop" )
	self.gold_ticks_per_bag = self:GetAbility():GetSpecialValueFor( "gold_ticks_per_bag" )
	
	self.xp_tomes_to_drop = self:GetAbility():GetSpecialValueFor( "xp_tomes_to_drop" )

	self.neutral_items_to_drop = self:GetAbility():GetSpecialValueFor( "neutral_items_to_drop" )

	self.lava_blobs_to_spit = self:GetAbility():GetSpecialValueFor( "lava_blobs_to_spit" )

	self.bFillingEjected = false
end

--------------------------------------------------------------------------------

--[[
function modifier_greevil_filling:AddCustomTransmitterData( )
	return
	{
		move_speed_per_drop = self.move_speed_per_drop,
		nBagsDropped = self.nBagsDropped,
	}
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:HandleCustomTransmitterData( data )
	self.move_speed_per_drop = data.move_speed_per_drop
	self.nBagsDropped = data.nBagsDropped
end
]]--

--------------------------------------------------------------------------------

function modifier_greevil_filling:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

----------------------------------------------------------------------------------------

function modifier_greevil_filling:OnDeath( params )
	if IsServer() == false then
		return
	end

	if params.unit == self:GetParent() and self.bFillingEjected == false then
		self:EjectFilling( false, params.attacker )

		local vBloodDir = -self:GetParent():GetForwardVector()
		local hAttacker = params.attacker
		if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker ~= self:GetParent() then
			vBloodDir = hAttacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
			vBloodDir = vBloodDir:Normalized()
		end

		local vColor = WINTER2022_GREEVIL_FILLING_COLORS[ self:GetFillingType() ]
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/greevils/greevil_blood_death.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControlTransformForward( nFXIndex, 1, self:GetParent():GetAbsOrigin(), vBloodDir )
		ParticleManager:SetParticleControl( nFXIndex, 10, vColor )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Roshan.Greevil.Splatter", self:GetParent() )
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:SetFillingEjected( bEjected )
	self.bFillingEjected = bEjected
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:SetFillingType( nFillingType )
	if IsServer() == false then
		return false
	end

	self.filling_type = nFillingType
end


--------------------------------------------------------------------------------

function modifier_greevil_filling:GetFillingType()
	return self.filling_type
end


--------------------------------------------------------------------------------

function modifier_greevil_filling:EjectFilling( bRoshanKill, hAttacker )
	if IsServer() == false then
		return
	end

	if self.bFillingEjected == true then
		return
	end
	self.bFillingEjected = true

	local flTime = GameRules:GetDOTATime( false, true )

	if self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_INVALID then
		print( 'ERROR: GREEVIL ATTEMPTED TO EJECT ITS FILLING BUT HAS AN INVALID FILLING TYPE!' )
		return
	end

	local nCandyToDrop = self.candy_to_drop_default

	if self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_RED then
		-- SPIDERS!
		self:SpawnSpiders( bRoshanKill )
	elseif self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_ORANGE then
		local hCaster = self:GetParent()
		if bRoshanKill then
			hCaster = GameRules.Winter2022.hRoshan
		end

		local hAbility = hCaster:AddAbility( "roshan_launch_lava_blob" )
		if hAbility ~= nil then
			hAbility:UpgradeAbility(true)
			local nMinRangeFromCenter = 150
			local bDoPathingCheck = false
			print( 'ORANGE GREEVIL KILLED - CREATING LAVA BLOBS' )

			for i=1,self.lava_blobs_to_spit do
				local vTargetPos = self:GetLootPosition( bRoshanKill, nMinRangeFromCenter, bDoPathingCheck )
				--print( 'LAVA TARGET POS ' .. vTargetPos.x .. ', ' .. vTargetPos.y .. ', ' .. vTargetPos.z )
				ExecuteOrderFromTable({
					UnitIndex = hCaster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position = vTargetPos,
					AbilityIndex = hAbility:entindex(),
					Queue = false,
				})
			end
		end

	elseif self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_BLUE then
		print( 'BLUE GREEVIL KILLED - dropping mana potion' )
		for i=1, self.mana_potions_to_drop do
			local newItem = CreateItem( "item_mana_potion", nil, nil )
			newItem:SetPurchaseTime( flTime )
			
			local vSpawnPos = self:GetParent():GetAbsOrigin()
			if bRoshanKill == true then
				vSpawnPos = self:GetRoshanMouthPosition()
			end

			local drop = CreateItemOnPositionForLaunch( vSpawnPos, newItem )
			drop.bIsLootDrop = true

			local vPos = self:GetLootPosition( bRoshanKill )

			if bRoshanKill then
				newItem:LaunchLootInitialHeight( true, 0, 100, 0.75, vPos )
			else
				newItem:LaunchLoot( true, 400, 1.5, vPos )
			end
		end
		EmitSoundOn( "Dungeon.TreasureItemDrop", self:GetParent() )

	elseif self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_GREEN then
		print( 'GREEN GREEVIL KILLED - dropping health potion' )
		for i=1, self.health_potions_to_drop do
			local newItem = CreateItem( "item_health_potion", nil, nil )
			newItem:SetPurchaseTime( flTime )
			
			local vSpawnPos = self:GetParent():GetAbsOrigin()
			if bRoshanKill == true then
				vSpawnPos = self:GetRoshanMouthPosition()
			end

			local drop = CreateItemOnPositionForLaunch( vSpawnPos, newItem )
			drop.bIsLootDrop = true

			local vPos = self:GetLootPosition( bRoshanKill )

			if bRoshanKill then
				newItem:LaunchLootInitialHeight( true, 0, 100, 0.75, vPos )
			else
				newItem:LaunchLoot( true, 400, 1.5, vPos )
			end
		end
		EmitSoundOn( "Dungeon.TreasureItemDrop", self:GetParent() )

	elseif self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_YELLOW then
		local nGold = math.ceil( GameRules.Winter2022.nGoldPerWave * self.gold_ticks_per_bag )
		for i=1, self.gold_bags_to_drop do
			local nRandomizedGold = math.ceil( RandomFloat( nGold * 0.9, nGold * 1.1 ) )
			print( 'YELLOW GREEVIL KILLED - dropping gold worth ' .. nRandomizedGold )

			local newItem = CreateItem( "item_bag_of_gold", nil, nil )
			newItem:SetPurchaseTime( flTime )
			newItem:SetCurrentCharges( nRandomizedGold )

			local vSpawnPos = self:GetParent():GetAbsOrigin()
			if bRoshanKill == true then
				vSpawnPos = self:GetRoshanMouthPosition()
			end

			local drop = CreateItemOnPositionForLaunch( vSpawnPos, newItem )
			drop:SetModelScale( 1.5 )
			drop.bIsLootDrop = true

			local vPos = self:GetLootPosition( bRoshanKill )

			--DebugDrawSphere( vSpawnPos, Vector(255,255,255), 0.8, 100, false, 0.75 )
			--DebugDrawSphere( vPos, Vector(255,0,0), 0.8, 100, false, 0.75 )

			local fPercent = RandomFloat( 0.9, 1.1 )
			local fHeight = 400 * fPercent
			local fTime = 1.5 * fPercent
			if bRoshanKill then
				newItem:LaunchLootInitialHeight( true, 0, 100, 0.75 * fPercent, vPos )
			else
				newItem:LaunchLoot( true, fHeight, fTime, vPos )
			end
		end
		EmitSoundOn( "Dungeon.TreasureItemDrop", self:GetParent() )

	elseif self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_WHITE then
		print( 'WHITE GREEVIL KILLED - dropping tomes' )
		for i=1, self.xp_tomes_to_drop do
			local newItem = CreateItem( "item_tome_winter2022", nil, nil )
			newItem:SetPurchaseTime( flTime )
			
			local vSpawnPos = self:GetParent():GetAbsOrigin()
			if bRoshanKill == true then
				vSpawnPos = self:GetRoshanMouthPosition()
			end

			local drop = CreateItemOnPositionForLaunch( vSpawnPos, newItem )
			drop.bIsLootDrop = true

			local vPos = self:GetLootPosition( bRoshanKill )

			--DebugDrawSphere( vSpawnPos, Vector(255,255,255), 0.8, 100, false, 0.75 )
			--DebugDrawSphere( vPos, Vector(255,0,0), 0.8, 100, false, 0.75 )

			if bRoshanKill then
				newItem:LaunchLootInitialHeight( true, 0, 100, 0.75, vPos )
			else
				newItem:LaunchLoot( true, 400, 1.5, vPos )
			end
		end
		EmitSoundOn( "Dungeon.TreasureItemDrop", self:GetParent() )

	elseif self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_PURPLE then
		-- EXTRA CANDY!
		nCandyToDrop = nCandyToDrop + self.candy_to_drop_bonus
		local vSpawnPos = self:GetParent():GetAbsOrigin()
		if bRoshanKill == true then
			vSpawnPos = self:GetRoshanMouthPosition()
		end
		for i = 1, nCandyToDrop do
			vDropTargetOffset = nil
			if bRoshanKill == true then
				vDropTargetOffset = GameRules.Winter2022.hRoshan:GetForwardVector() * 800
			end
			GameRules.Winter2022:DropCandyAtPosition( vSpawnPos, nil, nil, false, 2.0, vDropTargetOffset )
		end
		
		if hAttacker ~= nil and not hAttacker:IsNull() and hAttacker:IsOwnedByAnyPlayer() then
			GameRules.Winter2022:GrantEventAction( hAttacker:GetPlayerOwnerID(), "winter2022_hit_greevils_for_candy", nCandyToDrop )
		end
			
	elseif self.filling_type == WINTER2022_GREEVIL_FILLING_TYPE_BLACK then
		-- NEUTRAL ITEM!
		print( 'BLACK GREEVIL KILLED - dropping neutral items' )
		for i=1, self.neutral_items_to_drop do
			local newItem = CreateItem( "item_neutral_item_treasure", nil, nil )
			newItem:SetPurchaseTime( flTime )
			
			local vSpawnPos = self:GetParent():GetAbsOrigin()
			if bRoshanKill == true then
				vSpawnPos = self:GetRoshanMouthPosition()
			end
	
			local drop = CreateItemOnPositionForLaunch( vSpawnPos, newItem )
			drop.bIsLootDrop = true

			local vPos = self:GetLootPosition( bRoshanKill )

			if bRoshanKill then
				newItem:LaunchLootInitialHeight( true, 0, 100, 0.75, vPos )
			else
				newItem:LaunchLoot( true, 400, 1.5, vPos )
			end
		end	
		EmitSoundOn( "NeutralTreasure.Drop", self:GetCaster() )
	end	
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:GetRandomPositionInFrontOfRoshan( nMinRangeFromCenter )
	local nMin = 0
	if nMinRangeFromCenter ~= nil then
		nMin = nMinRangeFromCenter
	end

	local vPos = GameRules.Winter2022.hRoshan:GetAbsOrigin() + ( GameRules.Winter2022.hRoshan:GetForwardVector() * 800 )
	--DebugDrawSphere( vPos, Vector(255,255,0), 0.8, 400, false, 0.75 )
	vPos = vPos + RandomVector( RandomFloat( nMin, 400 ) )
	return vPos
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:GetLootPosition( bRoshanKill, nMinRangeFromCenter, bDoPathingCheck )
	local vPos = nil
	if bRoshanKill == true then
		vPos = self:GetRandomPositionInFrontOfRoshan( nMinRangeFromCenter )
	else
		vPos = self:GetParent():GetAbsOrigin() + RandomVector( RandomFloat( nMinRangeFromCenter or 0, 300 ) )
	end

	if bDoPathingCheck ~= nil and bDoPathingCheck == false then
		return vPos
	end

	local hPathingEnt = self:GetParent()
	if bRoshanKill then
		hPathingEnt = GameRules.Winter2022.hRoshan
	end

	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( hPathingEnt:GetOrigin(), vPos ) ) and ( nAttempts < 5 ) ) do

		if bRoshanKill == true then
			vPos = self:GetRandomPositionInFrontOfRoshan( nMinRangeFromCenter )
		else
			vPos = self:GetParent():GetAbsOrigin() + RandomVector( RandomFloat( nMinRangeFromCenter or 0, 300 ) )
		end

		nAttempts = nAttempts + 1

		if nAttempts >= 5 then
			print( 'CANNOT FIND A GOOD LOOT LOCATION AFTER 5 ATTEMPTS - DEFAULTING TO ORIGINAL POS' )
			vPos = hPathingEnt:GetOrigin()
		end
	end

	return vPos
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:GetRoshanMouthPosition()
	local vMouthPos = nil
	if GameRules.Winter2022.hRoshan ~= nil then
		--vMouthPos = GameRules.Winter2022.hRoshan:GetAttachmentOrigin( GameRules.Winter2022.hRoshan:ScriptLookupAttachment( "attach_hitloc" ) )
		vMouthPos = GameRules.Winter2022.hRoshan:GetAbsOrigin()
		vMouthPos = vMouthPos + Vector(0,0,400)
		vMouthPos = vMouthPos + ( GameRules.Winter2022.hRoshan:GetForwardVector() * 200 )
		--printf( "ROSH MOUTH POS MODIFIED TO %f %f %f", vMouthPos.x, vMouthPos.y, vMouthPos.z )
		--DebugDrawSphere( vMouthPos, Vector(0,255,0), 0.8, 75, false, 0.75 )
	else
		print( 'ERROR - NO ROSHAN FOUND! USING ORIGIN FOR ROSH MOUTH POSITION!' )
		vMouthPos = self:GetParent():GetAbsOrigin()
	end

	return vMouthPos
end

--------------------------------------------------------------------------------

function modifier_greevil_filling:SpawnSpiders( bRoshanKill )
	local spiders_to_spawn = self:GetAbility():GetSpecialValueFor( "spiders_to_spawn" )
	local spider_explosion_radius = self:GetAbility():GetSpecialValueFor( "spider_explosion_radius" )
	local spider_knockback_duration = self:GetAbility():GetSpecialValueFor( "spider_knockback_duration" )
	local spider_knockback_distance = self:GetAbility():GetSpecialValueFor( "spider_knockback_distance" )
	local spider_knockback_height = self:GetAbility():GetSpecialValueFor( "spider_knockback_height" )
	local spider_duration = self:GetAbility():GetSpecialValueFor( "spider_duration" )

	local spider_damage_pct_per_min = self:GetAbility():GetSpecialValueFor( "spider_damage_pct_per_min" )
	local spider_health_pct_per_min = self:GetAbility():GetSpecialValueFor( "spider_health_pct_per_min" )
	local spider_model_scale_per_min = self:GetAbility():GetSpecialValueFor( "spider_model_scale_per_min" )
	local spider_armor_per_min = self:GetAbility():GetSpecialValueFor( "spider_armor_per_min" )

	EmitSoundOn( "Greevil.SpawnSpiderlings", self:GetParent() )

	--local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
	--ParticleManager:ReleaseParticleIndex( nFXIndex )

	for i=1, spiders_to_spawn do
		local hSpider = nil
		if bRoshanKill == true then
			vSpawnPos = self:GetRoshanMouthPosition()
			vecPosition = self:GetLootPosition( bRoshanKill )

			--DebugDrawSphere( vSpawnPos, Vector(255,255,255), 0.8, 100, false, 0.75 )
			--DebugDrawSphere( vecPosition, Vector(255,0,0), 0.8, 100, false, 0.75 )

			hSpider = CreateUnitByName( "npc_dota_creature_newborn_spider", vSpawnPos, false, nil, nil, DOTA_TEAM_CUSTOM_1 )
			if hSpider ~= nil then
				hSpider:SetInitialGoalEntity( nil )
				hSpider:SetAbsOrigin( vSpawnPos )

				local vFacing = vecPosition - vSpawnPos
				vFacing.z = 0
				vFacing = vFacing:Normalized()
				local angles = VectorAngles( vFacing )
				hSpider:SetAngles( angles.x, angles.y, angles.z )
			
				local kv =
				{
					vLocX = vecPosition.x,
					vLocY = vecPosition.y,
					vLocZ = vecPosition.z
				}
				hSpider:AddNewModifier( nil, nil, "modifier_spider_spit_out", kv )
			end
		else
			local vSpawnPos = self:GetParent():GetAbsOrigin()
			local vecPosition = vSpawnPos + RandomVector( RandomFloat( 25, 50 ) )

			hSpider = CreateUnitByName( "npc_dota_creature_newborn_spider", vecPosition, false, nil, nil, DOTA_TEAM_CUSTOM_1 )				
			if hSpider ~= nil then
				hSpider:SetInitialGoalEntity( nil )
				local fSpiderKnockbackDuration = spider_knockback_duration * RandomFloat( 0.8, 1.2 )
				local fSpiderKnockbackHeight = spider_knockback_height * RandomFloat( 0.8, 1.2 )
				if bRoshanKill then
					fSpiderKnockbackHeight = 100
				end

				local kv =
				{
					center_x = vSpawnPos.x,
					center_y = vSpawnPos.y,
					center_z = vSpawnPos.z,
					should_stun = true,
					duration = fSpiderKnockbackDuration,
					knockback_duration = fSpiderKnockbackDuration,
					knockback_distance = spider_knockback_distance,
					knockback_height = fSpiderKnockbackHeight,
				}

				hSpider:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv )
			end
		end

		if hSpider ~= nil then
			local fDuration = RandomFloat( spider_duration * 0.9, spider_duration * 1.1 )
			hSpider:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_kill", { duration = fDuration } )

			local kv2 =
			{
				damage_buff_pct = math.floor( (GameRules:GetGameTime() / 60) * spider_damage_pct_per_min ),
				hp_buff_pct = math.floor( (GameRules:GetGameTime() / 60) * spider_health_pct_per_min ),
				model_scale = math.floor( (GameRules:GetGameTime() / 60) * spider_model_scale_per_min ),
				armor_buff = math.floor( (GameRules:GetGameTime() / 60) * spider_armor_per_min ),
			}
			--print( 'SPIDER BUFF STATS:' )
			--PrintTable( kv2 )
			hSpider:AddNewModifier( nil, nil, "modifier_creature_buff", kv2 )
		end
	end
end