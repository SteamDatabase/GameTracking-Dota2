require( "modifiers/modifier_blessing_base" )

modifier_blessing_extra_life = class( modifier_blessing_base )

function modifier_blessing_extra_life:OnBlessingCreated( kv )
	hHero = self:GetParent()
	if hHero ~= nil then
		hHero.nRespawnsMax = hHero.nRespawnsMax + 1
		CustomNetTables:SetTableValue( "respawns_max", string.format( "%d", hHero:entindex() ), { respawns = hHero.nRespawnsMax } )
	end
end