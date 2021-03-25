
local SHAMAN_BOT_STATE_IDLE						= 0
local SHAMAN_BOT_STATE_CAST_SPELLS				= 1
local SHAMAN_BOT_STATE_INACTIVE					= 2 

-----------------------------------------------------------------------------------------------------

if CStatusEffectsShadowShamanBot == nil then
	CStatusEffectsShadowShamanBot = class({})
end

function CStatusEffectsShadowShamanBot:constructor( me )
	self.me = me

	self.hAbilityVoodoo = self.me:FindAbilityByName( "shadow_shaman_voodoo" )
	ScriptAssert( self.hAbilityVoodoo ~= nil, "self.hAbilityVoodoo is nil!" )
	self.hAbilityShackles = self.me:FindAbilityByName( "shadow_shaman_shackles" )
	ScriptAssert( self.hAbilityShackles ~= nil, "self.hAbilityShackles is nil!" )

	self.nBotState = SHAMAN_BOT_STATE_IDLE
	self.hAttackTarget = nil
	self.me:AddNewModifier(nil, nil, "modifier_fountain_aura_buff", {})
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsShadowShamanBot:StartAI()
	if self.nBotState ~= SHAMAN_BOT_STATE_IDLE then
		return
	end
		printf("StartAI")
	self:ChangeBotState( SHAMAN_BOT_STATE_CAST_SPELLS )
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsShadowShamanBot:ChangeBotState( nNewState )
	self.nBotState = nNewState
end

-----------------------------------------------------------------------------------------------------

function CStatusEffectsShadowShamanBot:FindBestTarget()
	local Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #Heroes > 0 then
		-- prioritize ursa
		for _,hHero in pairs( Heroes ) do
			if hHero:GetUnitName() == "npc_dota_hero_lina" then
				self.hAttackTarget = hHero
				self:ChangeBotState( SHAMAN_BOT_STATE_CAST_SPELLS )
				return
			end
		end
	end
	return nil
end

function CStatusEffectsShadowShamanBot:BotThink()

	if self.me:FindModifierByName("modifier_bashed") ~= nil then
		self.me:RemoveModifierByName("modifier_fountain_aura_buff")
		self:ChangeBotState( SHAMAN_BOT_STATE_INACTIVE )
		return -1
	end

	if self.nBotState == SHAMAN_BOT_STATE_INACTIVE then

		return -1
	end


	if self.nBotState == SHAMAN_BOT_STATE_IDLE then
		
		if self:FindBestTarget() then return end

	elseif self.nBotState == SHAMAN_BOT_STATE_CAST_SPELLS then

		if self.hAttackTarget ~= nil and not self.hAttackTarget:IsAlive() then
			return
		end

		if not self.me:IsAlive() then
			self:ChangeBotState( SHAMAN_BOT_STATE_INACTIVE )
			return
		end

		local hHex = self.hAttackTarget:FindModifierByName( "modifier_shadow_shaman_voodoo" )
		local hShackles = self.hAttackTarget:FindModifierByName( "modifier_shadow_shaman_shackles" )

		if hHex ~= nil and hHex:GetRemainingTime() > 0.3 then 
			return hHex:GetRemainingTime()
		elseif hShackles ~= nil then
			return hShackles:GetRemainingTime()
		elseif self.hAbilityShackles and self.hAbilityShackles:IsFullyCastable() then
			self:CastAbilityAtTarget( self.hAbilityShackles, self.hAttackTarget )
			return 1
		elseif self.hAbilityVoodoo and self.hAbilityVoodoo:IsFullyCastable() then
			self:CastAbilityAtTarget( self.hAbilityVoodoo, self.hAttackTarget )
			return 1
		else 
			RefreshHero(self.me)
			self.me:RemoveModifierByName("modifier_invulnerable")
			return
		end
	end
end

function CStatusEffectsShadowShamanBot:MoveToLocation( vPos )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = false,
	} )
end

function CStatusEffectsShadowShamanBot:CastAbilityAtTarget( hAbility, hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hAbility:entindex(),
		TargetIndex = hTarget:entindex(),
		Queue = false,
	} )
end

function CStatusEffectsShadowShamanBot:AttackTarget( hTarget )
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
		Queue = false,
	} )
end

function FindItemByName( hUnit, strItemName )
	for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
		local hItem = hUnit:GetItemInSlot( iSlot )
		if hItem and hItem:GetAbilityName() == strItemName then
			return hItem
		end
	end
end

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then


	local hTask = GameRules.DotaNPX:GetTask( "stun_enemy_hero" )
	if hTask ~= nil and hTask:IsCompleted() == true then
		return -1
	end

		thisEntity:SetContextThink( "StatusEffectsShadowShamanBot", StatusEffectsShadowShamanBot, 0.25 )
		thisEntity.Bot = CStatusEffectsShadowShamanBot( thisEntity )
	end
end

function StatusEffectsShadowShamanBot()
	if IsServer() == false then
		return -1
	end

	thisEntity.Bot:BotThink()

	return 0.1
end


