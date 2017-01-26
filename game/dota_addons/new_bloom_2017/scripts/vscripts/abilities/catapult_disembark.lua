catapult_disembark = class({})

--------------------------------------------------------------------------------

function catapult_disembark:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 252, 118, 46 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function catapult_disembark:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function catapult_disembark:OnChannelFinish( bInterrupted )
	if IsServer() then
		if bInterrupted == false then
			ParticleManager:DestroyParticle( self.nPreviewFX, true )

			local creeps = Entities:FindAllByName( "npc_dota_creature_creep_melee" )
			if #creeps >= 64 then
				return
			end

			local number_of_creeps = self:GetSpecialValueFor( "number_of_creeps" )
			for i=0,number_of_creeps do
				local hCreep = CreateUnitByName( "npc_dota_creature_creep_melee", self:GetCaster():GetOrigin() + RandomVector( 175 ), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hCreep ~= nil then
					hCreep:SetOwner( self:GetCaster() )
					hCreep:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
					hCreep:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
					hCreep:SetDeathXP( 0 )
					hCreep:SetMinimumGoldBounty( 0 )
					hCreep:SetMaximumGoldBounty( 0 )
				end
			end

			local meepos = Entities:FindAllByName( "npc_dota_creature_creep_melee" )
			if #meepos >= 32 then
				return
			end
			local number_of_meepos = self:GetSpecialValueFor( "number_of_meepos" )
			for i=0,number_of_meepos do
				local hMeepo = CreateUnitByName( "npc_dota_creature_meepo", self:GetCaster():GetOrigin() + RandomVector( 175 ), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hMeepo ~= nil then
					hMeepo:SetOwner( self:GetCaster() )
					hMeepo:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
					hMeepo:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
					hMeepo:SetDeathXP( 0 )
					hMeepo:SetMinimumGoldBounty( 0 )
					hMeepo:SetMaximumGoldBounty( 0 )

					local hNet = hMeepo:FindAbilityByName( "creature_earthbind" )
					if hNet ~= nil then
						hNet:UpgradeAbility( true )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------