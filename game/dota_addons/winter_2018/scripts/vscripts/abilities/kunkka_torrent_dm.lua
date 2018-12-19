kunkka_torrent_dm = class({})

--------------------------------------------------------------------------------

function kunkka_torrent_dm:OnSpellStart()
	if IsServer() then
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_kunkka_torrent_thinker", {}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
		if hThinker ~= nil then
			local hBuff = hThinker:FindModifierByName( "modifier_kunkka_torrent_thinker" )
			if hBuff ~= nil then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf", PATTACH_ABSORIGIN, hThinker )
				hBuff:AddParticle( nFXIndex, false, false, -1, false, false )
			end

			EmitSoundOn( "Ability.pre.Torrent", self:GetCaster() )
		end
	end
end

--------------------------------------------------------------------------------