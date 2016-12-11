if item_broadsword_epic == nil then
	item_broadsword_epic = class({})
end

LinkLuaModifier( "item_broadsword_epic_modifier", "lua_items/item_broadsword_epic_modifier.lua", LUA_MODIFIER_MOTION_NONE )

function item_broadsword_epic:Spawn()
	if IsServer() then
		self.damage = RandomInt( 1, self:GetSpecialValueFor( "bonus_damage" ) )
		CustomNetTables:SetTableValue( "custom_item_state", string.format( "%d", self:GetEntityIndex() ), { damage = self.damage } )
	else
		local netTable = CustomNetTables:GetTableValue( "custom_item_state", string.format( "%d", self:GetEntityIndex() ) )
		self.damage = netTable.damage
	end
end

function item_broadsword_epic:GetIntrinsicModifierName()
	return "item_broadsword_epic_modifier"
end
