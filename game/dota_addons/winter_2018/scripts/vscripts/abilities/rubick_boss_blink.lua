rubick_boss_blink = class({})

-----------------------------------------------------------------------------

function rubick_boss_blink:OnSpellStart()
	if IsServer() then
		local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vDirection = vDirection:Normalized()

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 2, vDirection )
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCursorPosition() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		FindClearSpaceForUnit( self:GetCaster(), self:GetCursorPosition(), true )

		EmitSoundOn( "DOTA_Item.BlinkDagger.Activate", self:GetCaster() )
	end
end