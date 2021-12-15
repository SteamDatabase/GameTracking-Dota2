
modifier_aghslab_monkey_king_primal_spring_cast = class({})

-----------------------------------------------------------------------------

function modifier_aghslab_monkey_king_primal_spring_cast:OnCreated( kv )
	if IsServer() then
		--print( "Primal Spring Modifier Created" )
		self.hPrimalSpring = self:GetParent():FindAbilityByName( "monkey_king_primal_spring" )
		self.vPos = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )

		local nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/monkey_king/primal_spring_ground_preview.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
		ParticleManager:SetParticleControl( nPreviewFX, 0, self.vPos )
		ParticleManager:SetParticleControl( nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:ReleaseParticleIndex( nPreviewFX )
	end
end

-----------------------------------------------------------------------------

function modifier_aghslab_monkey_king_primal_spring_cast:OnDestroy()
	if IsServer() then
		if self:GetParent() ~= nil and self:GetParent():IsAlive() then
			--print( "Primal Spring Cast" )
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.hPrimalSpring:entindex(),
				Position = self.vPos,
				Queue = false,
			})
		end
	end
end

-----------------------------------------------------------------------------

