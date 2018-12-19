require( "event_queue" )

creature_big_bomb_explode = class({})

--------------------------------------------------------------------------------

function creature_big_bomb_explode:OnAbilityPhaseStart()
	if IsServer() then
	end
	return true
end

--------------------------------------------------------------------------------

function creature_big_bomb_explode:OnAbilityPhaseInterrupted()
	if IsServer() then
	end
end
--------------------------------------------------------------------------------

function creature_big_bomb_explode:OnSpellStart()
	if IsServer() then

		self.EventQueue = CEventQueue()

		EmitSoundOn( "BigBomb.Explode", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/creature_big_bomb/creature_big_bomb_explode_blood.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:GetCaster():Kill(nil, self:GetCaster())

		--self.EventQueue:AddEvent( 0.25,

		--function()
			local flDamage = 999999
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 5000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					if enemy ~= nil then
						local damage = 
						{
							victim = enemy,
							attacker = self:GetCaster(), 
							damage = flDamage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
							ability = self
						}
						ApplyDamage( damage )
					end
				end
			end
		--end
		--)
			
	end
end

--------------------------------------------------------------------------------