amoeba_fuse = class({})

-----------------------------------------------------------------------------------------

function amoeba_fuse:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget()
		if hTarget ~= nil and hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() and hTarget:IsAlive() then
			local hTargetBuff = hTarget:FindModifierByName( "modifier_amoeba_boss_passive" )
			local hMyBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_boss_passive" )
			if hTargetBuff ~= nil and hMyBuff ~= nil then
				

				hTarget:Heal( self:GetCaster():GetHealth() / 10, self )
				EmitSoundOn( "Hero_Undying.Decay.Transfer.PaleAugur", hTarget )
				ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget ) )
				SendOverheadEventMessage( nil, 10, hTarget, self:GetCaster():GetHealth() / 10, nil )
				self:GetCaster():RemoveAllItemDrops()
				self:GetCaster():AddEffects( EF_NODRAW )
				self:GetCaster():ForceKill( false )
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function amoeba_fuse:GetCastRange( vLocation, hTarget )
	if IsServer() then
		return self:GetCaster():GetAttackRange()
	end
	   
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 
 