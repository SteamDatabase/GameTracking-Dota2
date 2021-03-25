
local SHADOWFIEND_BOT_STATE_IDLE					= 0
local SHADOWFIEND_BOT_STATE_MOVE			= 1
local SHADOWFIEND_BOT_STATE_TP					= 2
local SHADOWFIEND_BOT_STATE_INACTIVE					= 3


-----------------------------------------------------------------------------------------------------

if CEulsSetupShadowFiendBot == nil then
	CEulsSetupShadowFiendBot = class({})
end

function CEulsSetupShadowFiendBot:constructor( me )
	self.me = me


	self.tableMovementLocations = 
	{

		Entities:FindByName( nil, "enemy_waypoint_1" ),
		Entities:FindByName( nil, "enemy_waypoint_2" ),
		Entities:FindByName( nil, "enemy_waypoint_3" ),
		Entities:FindByName( nil, "enemy_waypoint_4" ),
	}

	self.hLastMoveLoc = Entities:FindByName( nil, "enemy_waypoint_1" )
	self.LastMoveCommandTime = GameRules:GetGameTime() - 0.2
	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})

	for _,hTower in ipairs( Entities:FindAllByClassname( "ent_dota_fountain" ) ) do
		if hTower:GetTeam() == me:GetTeam() then
			self.hTpLocation = hTower
			break
		end
	end

	self.hTownPortalItem = nil



	self.nBotState = SHADOWFIEND_BOT_STATE_MOVE

	self.nPlayerUsedAbilityListener = ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( CEulsSetupShadowFiendBot, "OnPlayerUsedAbility" ), self )


end



--------------------------------------------------------------------------------
function CEulsSetupShadowFiendBot:OnPlayerUsedAbility( event )
	if event.PlayerID == nil or event.PlayerID ~= 0 then
		return
	end
	
	-- Only enable dodging behavior if we've completed task 1
	local hTask1 = GameRules.DotaNPX:GetTask( "ice_path_shadow_fiend_1" )
	if hTask1 ~= nil and hTask1:IsCompleted() == false then
		return
	end

	local hTask3 = GameRules.DotaNPX:GetTask( "ice_path_shadow_fiend_3" )
	if hTask3 ~= nil and hTask3:IsCompleted() == true then
		return
	end
	
	-- Get the player's forward facing vector
	local hCaster = PlayerResource:GetSelectedHeroEntity( 0 )
	local vPlayerDir = hCaster:GetForwardVector():Normalized()

	-- the Ice path will be in the direction of the player's forward facing vector
	-- the vRetreatCrossDir is normal to that vector

	local vRetreatCrossDir = Vector(vPlayerDir.y, -1 * vPlayerDir.x, 0 )
	local vMyPos = self.me:GetAbsOrigin()

	-- Since we don't know which way our direction is pointing, select the option that will put us the furthest from the caster to ensure we're not trying to cross the ice path
	local vRetreatPos = nil
	local vRetreatOption1 = vMyPos - vRetreatCrossDir * 600
	local vRetreatOption2 = vMyPos + vRetreatCrossDir * 600

	if (vRetreatOption1 - hCaster:GetAbsOrigin()):Length2D() > (vRetreatOption2 - hCaster:GetAbsOrigin()):Length2D() then
		vRetreatPos = vRetreatOption1
	else
		vRetreatPos = vRetreatOption2
	end
	self.LastMoveCommandTime = GameRules:GetGameTime()
	self.hBlinkItem = self.me:FindItemInInventory( "item_blink" )
	if self.hBlinkItem ~= nil then
			print ('Casting Blink')
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hBlinkItem:entindex(),
				Position = vRetreatPos,
				Queue = false
			} )

	else
			ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vRetreatPos,
			Queue = false
		} )
	end


end



------------------------------------------------------------------------------------------

function CEulsSetupShadowFiendBot:BotThink()

	if not IsServer() then
		return
	end

	if not self.me:IsAlive() then
		return
	end

	if GameRules:IsGamePaused() then
		return
	end


	if self.nBotState == SHADOWFIEND_BOT_STATE_INACTIVE then
		self.me:RemoveSelf()
		return -1
	end


	if self.hTownPortalItem == nil then
		self.hTownPortalItem = self.me:FindItemInInventory( "item_tpscroll" )
		if self.hTownPortalItem then
			self.hTownPortalItem:EndCooldown()
		end
	end
	self.me:SetHealth( self.me:GetMaxHealth() )

	local hTask = GameRules.DotaNPX:GetTask( "ice_path_shadow_fiend_3" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		self.nBotState = SHADOWFIEND_BOT_STATE_TP
	end



	if 	self.hBlinkItem ~= nil and self.hBlinkItem:GetCooldownTimeRemaining() > 0 then 
		self.hBlinkItem:EndCooldown()
		local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, self.me )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.me, PATTACH_POINT_FOLLOW, "attach_hitloc", self.me:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end


	if self.nBotState == SHADOWFIEND_BOT_STATE_IDLE then
		--do nothing

	 elseif self.nBotState == SHADOWFIEND_BOT_STATE_MOVE then

	 	if  self.me:IsMoving() == false and GameRules:GetGameTime() >= self.LastMoveCommandTime + 0.5 then

	 		-- choose a random destination

	 		local vTryLoc = nil
		 	
		 	repeat
				vTryLoc = GetRandomElement(self.tableMovementLocations)
			until vTryLoc ~= self.hLastMoveLoc

	 		self.LastMoveCommandTime = GameRules:GetGameTime()

			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vTryLoc:GetAbsOrigin()
			} )
			self.hLastMoveLoc = vTryLoc
		end
	elseif self.nBotState == SHADOWFIEND_BOT_STATE_TP then
		if self.hTownPortalItem and self.hTownPortalItem:IsFullyCastable() == true then
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTownPortalItem:entindex(),
			Position = self.hTpLocation:GetAbsOrigin(),
		} )
		end
		
		if self.hTownPortalItem and not self.hTownPortalItem:IsFullyCastable() and not self.hTownPortalItem:IsChanneling() then
			self.nBotState = SHADOWFIEND_BOT_STATE_INACTIVE
			return -1
		end
		return 0.2
	end
	return 0.2
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then


	local hTask = GameRules.DotaNPX:GetTask( "root_enemy_hero" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		return -1
	end
		thisEntity:SetContextThink( "CEulsSetupShadowFiendBotThink", CEulsSetupShadowFiendBotThink, 0.1 )
		thisEntity.Bot = CEulsSetupShadowFiendBot( thisEntity )
	end
end

function CEulsSetupShadowFiendBotThink()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


