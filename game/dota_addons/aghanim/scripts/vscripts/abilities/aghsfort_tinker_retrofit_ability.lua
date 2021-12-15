aghsfort_tinker_retrofit_ability = class({})

------------------------------------------------------------------------

function aghsfort_tinker_retrofit_ability:OnProjectileHit( hTarget, vLocation )
	if IsServer() then 
		if hTarget and hTarget.nTinkerRetrofitMode ~= nil then 
			if hTarget.nTinkerRetrofitMode == 0 then 
				EmitSoundOn( "Hero_Tinker.LaserImpact", hTarget )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex );
				EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile.Impact", hTarget )
			end

			hTarget.nTinkerRetrofitMode = nil
		end
	end

	return true 
end

------------------------------------------------------------------------