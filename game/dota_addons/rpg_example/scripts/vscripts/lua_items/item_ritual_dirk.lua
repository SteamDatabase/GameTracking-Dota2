if item_ritual_dirk == nil then
	item_ritual_dirk = class({})
end

LinkLuaModifier( "item_ritual_dirk_modifier", "lua_items/item_ritual_dirk_modifier.lua", LUA_MODIFIER_MOTION_NONE )

function item_ritual_dirk:Spawn()
	print( "item_ritual_dirk:Spawn()" )
	if IsServer() then
		self.damage = RandomInt( ( self:GetSpecialValueFor( "bonus_damage" ) / 2 ), self:GetSpecialValueFor( "bonus_damage" ) )
		self.mana_gain_on_kill = self.damage
		CustomNetTables:SetTableValue( "custom_item_state", string.format( "%d", self:GetEntityIndex() ), { damage = self.damage } )
	else
		local netTable = CustomNetTables:GetTableValue( "custom_item_state", string.format( "%d", self:GetEntityIndex() ) )
		self.damage = netTable.damage
	end
end

function item_ritual_dirk:GetIntrinsicModifierName()
	return "item_ritual_dirk_modifier"
end