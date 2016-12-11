if item_saprophytic_blade == nil then
	item_saprophytic_blade = class({})
end

LinkLuaModifier( "item_saprophytic_blade_modifier", "lua_items/item_saprophytic_blade_modifier.lua", LUA_MODIFIER_MOTION_NONE )

function item_saprophytic_blade:Spawn()
	print( "item_saprophytic_blade:Spawn()" )
	if IsServer() then
		self.damage = RandomInt( ( self:GetSpecialValueFor( "bonus_damage" ) / 2 ), self:GetSpecialValueFor( "bonus_damage" ) )
		self.lifesteal_on_kill = self.damage
		CustomNetTables:SetTableValue( "custom_item_state", string.format( "%d", self:GetEntityIndex() ), { damage = self.damage } )
	else
		local netTable = CustomNetTables:GetTableValue( "custom_item_state", string.format( "%d", self:GetEntityIndex() ) )
		self.damage = netTable.damage
	end
end

function item_saprophytic_blade:GetIntrinsicModifierName()
	return "item_saprophytic_blade_modifier"
end
