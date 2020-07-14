
modifier_drow_ranger_skeleton_archer = class({})

--------------------------------------------------------------------------------

function modifier_drow_ranger_skeleton_archer:OnCreated( kv )
	if IsServer() then
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_clinkz/clinkz_burning_army_start.vpcf", PATTACH_ABSORIGIN, self:GetParent() ) )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_clinkz/clinkz_burning_army.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_drow_ranger_skeleton_archer:OnDestroy()
	if IsServer() then
		if self.nFXIndex ~= nil then
			--print( 'modifier_drow_ranger_skeleton_archer:OnDestroy() removing particle' )
			ParticleManager:DestroyParticle( self.nFXIndex, false )
		end

		self:GetParent():ForceKill( false )
	end
end
