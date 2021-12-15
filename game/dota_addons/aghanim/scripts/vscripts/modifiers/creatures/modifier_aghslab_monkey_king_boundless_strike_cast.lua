
modifier_aghslab_monkey_king_boundless_strike_cast = class({})

-----------------------------------------------------------------------------

function modifier_aghslab_monkey_king_boundless_strike_cast:OnCreated( kv )
	if IsServer() then
		--print( "Boundless Strike Modifier Created" )
		self.hBoundlessStrike = self:GetParent():FindAbilityByName( "monkey_king_boundless_strike" )
		self.vPos = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )

		local nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/monkey_king/boundless_strike_preview.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
		ParticleManager:SetParticleControl( nPreviewFX, 0, self.vPos )
		ParticleManager:SetParticleControl( nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:ReleaseParticleIndex( nPreviewFX )
	end
end

-----------------------------------------------------------------------------

function modifier_aghslab_monkey_king_boundless_strike_cast:OnDestroy()
	if IsServer() then
		if self:GetParent() ~= nil and self:GetParent():IsAlive() then
			--print( "Boundless Strike Cast" )
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hBoundlessStrike:entindex(),
				Position = self.vPos,
				Queue = false,
			})
		end
	end
end

-----------------------------------------------------------------------------

