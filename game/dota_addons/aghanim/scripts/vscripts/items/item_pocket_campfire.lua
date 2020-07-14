
item_pocket_campfire = class({})

--------------------------------------------------------------------------------

function item_pocket_campfire:OnSpellStart()
	if IsServer() then
		local vPos = self:GetCursorPosition()
		local hPocketCampfire = CreateUnitByName( "npc_dota_pocket_campfire", vPos, true, nil, nil, DOTA_TEAM_GOODGUYS )
		if hPocketCampfire ~= nil then
			EmitSoundOn( "PocketCampfire.Create", hCampfire )
		end
		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------

