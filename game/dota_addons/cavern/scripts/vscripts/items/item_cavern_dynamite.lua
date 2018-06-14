item_cavern_dynamite = class({})
--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_creature_armed_dynamite", "modifiers/modifier_creature_armed_dynamite", LUA_MODIFIER_MOTION_NONE )

function item_cavern_dynamite:OnSpellStart()
	if IsServer() then
		local vPos = self:GetCursorPosition()
		EmitSoundOn( "Hero_Techies.RemoteMine.Plant", self:GetCaster() );
		local hUnit = CreateUnitByName( "npc_dota_creature_armed_dynamite", vPos, true, nil, nil, self:GetCaster():GetTeam() )
		hUnit:AddNewModifier( hUnit, nil, "modifier_creature_armed_dynamite", {} )
		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
