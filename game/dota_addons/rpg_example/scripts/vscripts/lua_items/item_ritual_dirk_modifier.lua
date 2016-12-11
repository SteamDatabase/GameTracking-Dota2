require( "utility_functions" )

if item_ritual_dirk_modifier == nil then
	item_ritual_dirk_modifier = class({})
end

function item_ritual_dirk_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
	return funcs
end

function item_ritual_dirk_modifier:OnCreated( kv )
	print( "item_ritual_dirk_modifier:OnCreated( kv )" )
	print( "  PrintTable kv:" )
	PrintTable( kv, " " )
	self.BaseClass.OnCreated( self, kv )
	local hAbility = self:GetAbility()
	self.damageBonus = 0
	if hAbility ~= nil then
		self.damageBonus = hAbility.damage
	end

	ListenToGameEvent( "entity_killed", Dynamic_Wrap( item_ritual_dirk_modifier, "OnEntityKilled" ), self )
end

function item_ritual_dirk_modifier:OnAbilityExecuted( params )
	print( "OnAbilityFullyCast" )
	print( "  params:" )
	for k, v in pairs( params ) do
		print( string.format( "%s == %s", k, v ) )
	end

	local hAbility = self:GetAbility()
	
	local hCaster = params.unit
	if hCaster ~= nil then
		print( "  hCaster:GetUnitName() == " .. hCaster:GetUnitName() )
	end

	local hTarget = params.target
	if hTarget ~= nil then
		print( "  hTarget:GetUnitName() == " .. hTarget:GetUnitName() )
	end
end

function item_ritual_dirk_modifier:OnEntityKilled( event )
	if not IsServer() then
		return
	end
	local hAbility = self:GetAbility()
	local hDeadUnit = EntIndexToHScript( event.entindex_killed )
	local hAttackerUnit = EntIndexToHScript( event.entindex_attacker )
	if hAttackerUnit == self:GetParent() and hAbility ~= nil then
		hAttackerUnit:GiveMana( hAbility.mana_gain_on_kill )
	end

	return
end

function item_ritual_dirk_modifier:IsHidden()
	return true
end

function item_ritual_dirk_modifier:GetModifierPreAttack_BonusDamage( params )
	return self.damageBonus
end