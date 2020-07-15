boss_timbersaw_timber_chain = class({})

----------------------------------------------------------------------------------------

function boss_timbersaw_timber_chain:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timber_chain_tree.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timber_chain_trail.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timber_dmg.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_tree_dmg.vpcf", context )

end

--------------------------------------------------------------------------------
--[[
function boss_timbersaw_timber_chain:OnAbilityPhaseStart()
	if IsServer() then
		self.chain_radius = self:GetSpecialValueFor( "chain_radius" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.chain_radius, self.chain_radius, self.chain_radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 0, 0, 200 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_timbersaw_timber_chain:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end
]]--
--------------------------------------------------------------------------------

function boss_timbersaw_timber_chain:OnSpellStart()
	if IsServer() then
		--ParticleManager:DestroyParticle( self.nPreviewFX, false )
		self.chain_radius = self:GetSpecialValueFor( "chain_radius" ) 
		self.radius = self:GetSpecialValueFor( "radius" )
		self.speed = self:GetSpecialValueFor( "speed" ) 
		self.range = self:GetSpecialValueFor( "range" ) 
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" ) 
		self.bRetracting = false
		self.hHitTargets = {}

		local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local vTargetPos = self:GetCaster():GetAbsOrigin() + ( vDirection * self.range ) + Vector( 0, 0, 96 )
		self.vVelocity = vDirection * self.speed 
		local info = 
		{
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAbsOrigin(), 
			fStartRadius = self.chain_radius,
			fEndRadius = self.chain_radius,
			vVelocity = self.vVelocity,
			fDistance = self.range,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
			iUnitTargetType = DOTA_UNIT_TARGET_TREE,
		}

		ProjectileManager:CreateLinearProjectile( info )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin() + Vector( 0, 0, 96 ), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, vTargetPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( self.speed, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( 10, 0, 0 ) )

		EmitSoundOn( "Hero_Shredder.TimberChain.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function boss_timbersaw_timber_chain:OnProjectileThink( vLocation )
	if IsServer() then
		
		if self.bRetracting == false then
			local hTrees = GridNav:GetAllTreesAroundPoint( vLocation, self.chain_radius, true )
			if #hTrees > 0 then
				for _,Tree in pairs ( hTrees ) do
					if Tree and Tree:IsStanding() then
						local vTreeOrigin = Tree:GetAbsOrigin()
						if self:GetCaster().Encounter and self:GetCaster().Encounter:GetRoom() and self:GetCaster().Encounter:GetRoom():IsInRoomBounds( vTreeOrigin ) then
							self:OnProjectileHit( Tree, vTreeOrigin )
							return
						end
					end
				end
			end
		else
			if self:GetCaster():FindModifierByName( "modifier_shredder_timber_chain" ) then
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), me, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
				if #enemies > 0 then
					for _,enemy in pairs( enemies ) do
						if enemy and self:HasHitTarget( enemy ) == false then
							table.insert( self.hHitTargets, enemy )
							enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function boss_timbersaw_timber_chain:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if self.bRetracting == false then
			StopSoundOn( "Hero_Shredder.TimberChain.Cast", self:GetCaster() )

			if hTarget ~= nil then
				print( "found a tree" )
				EmitSoundOnLocationWithCaster( vLocation, "Hero_Shredder.TimberChain.Impact", self:GetCaster() )
				local nTreeFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_shredder/shredder_timber_chain_tree.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
				ParticleManager:SetParticleControl( nTreeFX, 0, vLocation + Vector( 0, 0, 96 ) )
				ParticleManager:ReleaseParticleIndex( nTreeFX )

				local flDist = ( vLocation - self:GetCaster():GetAbsOrigin() ):Length2D()
				local flDuration = flDist / self.speed
				local kv = {}
				kv[ "duration" ] = flDuration
				kv[ "tree_index" ] = hTarget:entindex()
				
				self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_shredder_timber_chain", kv )
				ParticleManager:SetParticleControl( self.nFXIndex, 1, vLocation + Vector( 0, 0, 96 ) )
				ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( flDuration * 2 - 0.1, 0, 0 ) )
			else
				ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin() + Vector( 0, 0, 96 ), true )

				local flFailChainDuration = ( self.range * 2 ) / self.speed
				ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( flFailChainDuration - 0.1, 0, 0 ) )
			end

			EmitSoundOn( "Hero_Shredder.TimberChain.Retract", self:GetCaster() )
			
			self.bRetracting = true
			ParticleManager:ReleaseParticleIndex( self.nFXIndex )

			local info = 
			{
				Ability = self,
				vSpawnOrigin = vLocation, 		
				vVelocity = self.vVelocity * -1,
				fDistance = self.range,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
				iUnitTargetType = DOTA_UNIT_TARGET_TREE,
			}

			ProjectileManager:CreateLinearProjectile( info )
		else
			self.hHitTargets = {}
		end
	end

	return true
end

--------------------------------------------------------------------------------

function boss_timbersaw_timber_chain:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end
