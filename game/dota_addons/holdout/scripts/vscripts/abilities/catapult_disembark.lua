catapult_disembark = class({})

--------------------------------------------------------------------------------

function catapult_disembark:IsStealable()
	return false
end

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

			local creeps = {}
			local meepos = {}
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					if enemy ~= nil and enemy:IsAlive() then
						if enemy:GetUnitName() == "npc_dota_creature_creep_melee" then
							table.insert( creeps, enemy )
						end 
						if enemy:GetUnitName() == "npc_dota_creature_meepo" then
							table.insert( meepos, enemy )
						end
					end
				end
			end


			if #creeps < 64 then
				local number_of_creeps = self:GetSpecialValueFor( "number_of_creeps" )
				local nCreepsToSpawn = math.min( number_of_creeps, 64 - #creeps )
				print ( "We have " .. #creeps .. " creeps, spawning " .. nCreepsToSpawn )
				for i=0,nCreepsToSpawn do
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
			end


			if #meepos < 32 then
				local number_of_meepos = self:GetSpecialValueFor( "number_of_meepos" )
				local nMeeposToSpawn = math.min( number_of_meepos, 32 - #meepos )
				print ( "We have " .. #meepos .. " meepos, spawning " .. nMeeposToSpawn )
				for i=0,nMeeposToSpawn do
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
end

--------------------------------------------------------------------------------