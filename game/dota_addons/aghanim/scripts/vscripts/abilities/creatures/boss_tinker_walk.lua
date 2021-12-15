
--------------------------------------------------------------------------------

boss_tinker_walk = class({})

--------------------------------------------------------------------------------

function boss_tinker_walk:OnSpellStart()
	if IsServer() then
		ExecuteOrderFromTable({
			UnitIndex = self:GetCaster():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self:GetCursorPosition()
		})
	end
end

--------------------------------------------------------------------------------
