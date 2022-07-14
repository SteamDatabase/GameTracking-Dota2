modifier_dark_seer_wall_of_replica_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_dark_seer_wall_of_replica_nb2017:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_dark_seer_wall_of_replica_nb2017:IsPurgable()
	return true;
end

--------------------------------------------------------------------------------

function modifier_dark_seer_wall_of_replica_nb2017:OnCreated( kv )
	self.width = self:GetAbility():GetSpecialValueFor( "width" )
	self.replica_damage_incoming = self:GetAbility():GetSpecialValueFor( "replica_damage_incoming" )
	self.replica_damage_outgoing = self:GetAbility():GetSpecialValueFor( "replica_damage_outgoing" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )

	if IsServer() then
		self.vWallDirection = Vector( kv["dir_x"], kv["dir_y"], kv["dir_z"] )
		self:GetParent():SetForwardVector( self.vWallDirection )
		self.vWallRight = self:GetParent():GetRightVector() * self.width / 2
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlForward( nFXIndex, 0, self.vWallDirection );
		ParticleManager:SetParticleControl( nFXIndex, 0, ( self:GetParent():GetOrigin() + self.vWallRight ) );
		ParticleManager:SetParticleControl( nFXIndex, 1, ( self:GetParent():GetOrigin() - self.vWallRight ) );
		ParticleManager:SetParticleControl( nFXIndex, 2, self.vWallDirection );
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		self:StartIntervalThink( 0.0 )
		EmitSoundOn( "Hero_Dark_Seer.Wall_of_Replica_Start", self:GetParent() )	
		self:GetParent():EmitSoundParams( "Hero_Dark_Seer.Wall_of_Replica_lp", 100, 0.0, self:GetDuration() )

		self.hReplicatedUnits = {}
	end
end

--------------------------------------------------------------------------------

function modifier_dark_seer_wall_of_replica_nb2017:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Dark_Seer.Wall_of_Replica_lp", self:GetParent() )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_dark_seer_wall_of_replica_nb2017:OnIntervalThink()
	if IsServer() then
		local vLineA = self:GetParent():GetOrigin() + self.vWallRight * ( self.width * 0.5 )
		local vLineB = self:GetParent():GetOrigin() - self.vWallRight * ( self.width * 0.5 )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				local bTryCreate = true
				for _, replicated in pairs( self.hReplicatedUnits ) do
					if enemy == replicated then
				    	bTryCreate = false
				    end
				end

			    if bTryCreate == true then 
			    	local flDistOffLine = CalcDistanceToLineSegment2D( enemy:GetOrigin(), vLineA, vLineB )
			    	if flDistOffLine <= ( enemy:GetPaddedCollisionRadius() + 50.0 ) then
			    		table.insert( self.hReplicatedUnits, enemy )
			    		local flDuration = self:GetDieTime() - GameRules:GetGameTime()
			    		local kv =
			    		{
			    			duration = flDuration,
			    			outgoing_damage = self.replica_damage_outgoing,
			    			replica_damage_incoming = self.replica_damage_incoming,
			    		}

			    		local replica = CreateUnitByName( enemy:GetUnitName(), enemy:GetOrigin() + RandomVector( enemy:GetPaddedCollisionRadius() + 50.0 ), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			    		
			    		if replica ~= nil then
			    			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica_replicate.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy );
							ParticleManager:SetParticleControlEnt( nFXIndex, 1, replica, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true );
							ParticleManager:ReleaseParticleIndex( nFXIndex );

			    			replica:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_illusion", kv )
			    			replica:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_darkseer_wallofreplica_illusion", { duration = flDuration } )
			    			replica:SetControllableByPlayer( self:GetCaster():GetPlayerID(), true )
			    			replica:SetIdleAcquire( true )
			    			FindClearSpaceForUnit( replica, replica:GetOrigin(), true )

			    			local hAbility = replica:FindAbilityByName( "zombie_torso" )
			    			if hAbility ~= nil then
			    				replica:RemoveModifierByName( "modifier_zombie_torso" )
			    				replica:RemoveAbility( "zombie_torso" )
			    			end

			    			for i = 0, DOTA_ITEM_MAX - 1 do
								local item = replica:GetItemInSlot( i )
								if item ~= nil then
									item:SetSellable( false )
									item:SetDroppable( false )
				    			end
				    		end
				    	end

			    		local kv2 =
			    		{
			    			duration = self.slow_duration
			    		}
			    		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_dark_seer_wall_slow", kv2 )
			    	end
			    end
			end
			
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dark_seer_wall_of_replica_nb2017:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_dark_seer_wall_of_replica_nb2017:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		for i = 1,#self.hReplicatedUnits do
			local unit = self.hReplicatedUnits[i]
			if unit == hUnit then
				table.remove( self.hReplicatedUnits, i )
				return 0
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------
