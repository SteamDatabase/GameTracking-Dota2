item_potion_of_cowardice = class({})
--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_potion_of_cowardice_buff", 	"modifiers/modifier_potion_of_cowardice_buff", LUA_MODIFIER_MOTION_NONE )

function item_potion_of_cowardice:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_potion_of_cowardice_buff", { duration = 15 } )

		local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/smoke_of_deceit.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 1, 150 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "EscapePotion.Activate", self:GetCaster() )

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
