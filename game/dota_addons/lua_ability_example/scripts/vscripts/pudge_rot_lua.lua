pudge_rot_lua = class({})
LinkLuaModifier( "modifier_pudge_rot_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function pudge_rot_lua:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function pudge_rot_lua:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_rot_lua", nil )

		if not self:GetCaster():IsChanneling() then
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
		end
	else
		local hRotBuff = self:GetCaster():FindModifierByName( "modifier_pudge_rot_lua" )
		if hRotBuff ~= nil then
			hRotBuff:Destroy()
		end
	end
end

--------------------------------------------------------------------------------